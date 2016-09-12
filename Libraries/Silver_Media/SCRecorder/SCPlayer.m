//
//  SCVideoPlayer.m
//  SCAudioVideoRecorder
//
//  Created by Simon CORSIN on 8/30/13.
//  Copyright (c) 2013 rFlex. All rights reserved.
//

#import "SCPlayer.h"

////////////////////////////////////////////////////////////
// PRIVATE DEFINITION
/////////////////////

@interface SCPlayer() <AVPlayerItemOutputPullDelegate, AVPlayerItemOutputPushDelegate> {
    BOOL _shouldLoop;
    CADisplayLink *_displayLink;
    AVPlayerItemVideoOutput *_videoOutput;
    AVPlayerLayer *_playerLayer;
    SCImageView *_imageView;
}

@property (strong, nonatomic, readwrite) AVPlayerItem * oldItem;
@property (assign, nonatomic) Float64 itemsLoopLength;
@property (strong, nonatomic, readwrite) id timeObserver;

@end

__weak SCPlayer * currentSCVideoPlayer = nil;

////////////////////////////////////////////////////////////
// IMPLEMENTATION
/////////////////////

@implementation SCPlayer

@synthesize oldItem;

- (id)init {
	self = [super init];
	
	if (self) {
        self.shouldLoop = NO;

		[self addObserver:self forKeyPath:@"currentItem" options:NSKeyValueObservingOptionNew context:nil];
		
        _autoCreateSCImageView = YES;
		
		self.minimumBufferedTimeBeforePlaying = CMTimeMake(2, 1);
	}
	
	return self;
}

- (void)dealloc {
    [self endSendingPlayMessages];

    self.outputView = nil;
    [self unsetupVideoOutput:self.currentItem];
    [self removeObserver:self forKeyPath:@"currentItem"];
    [self removeOldObservers];
    [self endSendingPlayMessages];
}

- (void)beginSendingPlayMessages {
    [self endSendingPlayMessages];
    __weak SCPlayer *myWeakSelf = self;
    
    self.timeObserver = [self addPeriodicTimeObserverForInterval:CMTimeMake(1, 24) queue:nil usingBlock:^(CMTime time) {
        SCPlayer *mySelf = myWeakSelf;
        id<SCPlayerDelegate> delegate = mySelf.delegate;
        if ([delegate respondsToSelector:@selector(videoPlayer:didPlay:loopsCount:)]) {
            Float64 ratio = 1.0 / mySelf.itemsLoopLength;
            Float64 seconds = CMTimeGetSeconds(CMTimeMultiplyByFloat64(time, ratio));
            
            NSInteger loopCount = CMTimeGetSeconds(time) / (CMTimeGetSeconds(mySelf.currentItem.duration) / (Float64)mySelf.itemsLoopLength);
            
            [delegate videoPlayer:mySelf didPlay:seconds loopsCount:loopCount];
        }
    }];
}

- (void)endSendingPlayMessages {
    if (self.timeObserver != nil) {
        [self removeTimeObserver:self.timeObserver];
        self.timeObserver = nil;
    }
}

- (void) playReachedEnd:(NSNotification*)notification {
	if (notification.object == self.currentItem) {
		if (self.shouldLoop) {
			[self seekToTime:kCMTimeZero];
			if ([self isPlaying]) {
				[self play];
			}
		}
        id<SCPlayerDelegate> delegate = self.delegate;
        if ([delegate respondsToSelector:@selector(player:didReachEndForItem:)]) {
            [delegate player:self didReachEndForItem:self.currentItem];
        }
	}
}

- (void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
	if ([keyPath isEqualToString:@"currentItem"]) {
		[self initObserver];
	} else {
		
	}
}

- (void)removeOldObservers {
    if (self.oldItem != nil) {
		[[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:self.oldItem];
        
        [self unsetupVideoOutput:self.oldItem];
        
        self.oldItem = nil;
	}
}

- (void)unsetupVideoOutput:(AVPlayerItem *)playerItem {
    if (_videoOutput != nil) {
        if ([playerItem.outputs containsObject:_videoOutput]) {
            [playerItem removeOutput:_videoOutput];
        }
    }
}

- (void)outputMediaDataWillChange:(AVPlayerItemOutput *)sender {
	_displayLink.paused = NO;
}

- (void)renderVideo:(CFTimeInterval)hostFrameTime {
    CMTime outputItemTime = [_videoOutput itemTimeForHostTime:hostFrameTime];
    
	if ([_videoOutput hasNewPixelBufferForItemTime:outputItemTime]) {
        CMTime time;
		CVPixelBufferRef pixelBuffer = [_videoOutput copyPixelBufferForItemTime:outputItemTime itemTimeForDisplay:&time];
        
        if (pixelBuffer) {
            CIImage *inputImage = [CIImage imageWithCVPixelBuffer:pixelBuffer];
            
            CIImage *image = inputImage;
            
            if (_filterGroup != nil) {
                image = [_filterGroup imageByProcessingImage:inputImage];
            }
            
            CGRect extent = [inputImage extent];
            
            _imageView.imageSize = extent;
            _imageView.image = image;
//            _imageView.hidden = NO;
            
            CFRelease(pixelBuffer);
        }
    }
    
    if (_imageView.dirty) {
        [_imageView setNeedsDisplay];
    }
}

- (void)replaceCurrentItemWithPlayerItem:(AVPlayerItem *)item {
    [super replaceCurrentItemWithPlayerItem:item];
    [self suspendDisplay];
}

- (void)willRenderFrame:(CADisplayLink *)sender {
	CFTimeInterval nextFrameTime = sender.timestamp + sender.duration;
    
    [self renderVideo:nextFrameTime];
}

- (void)setupImageView {
    UIView *outputView = _outputView;
    if (outputView != nil) {
        [outputView addSubview:_imageView];
        [self resizePlayerLayerToFitOutputView];
    }
}

- (void)glkView:(SCImageView *)view drawInRect:(CGRect)rect {
    CIImage *image = view.image;
    if (image != nil) {
        [view.ciContext drawImage:image inRect:[view processRect:rect withImageSize:view.imageSize.size] fromRect:view.imageSize];
    }
}

- (void)suspendDisplay {
    _displayLink.paused = YES;
    [_videoOutput requestNotificationOfMediaDataChangeWithAdvanceInterval:0.1];
}

- (void)setupCoreImageView {
    if (_displayLink == nil) {
        _displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(willRenderFrame:)];
        _displayLink.frameInterval = 1;
        [_displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
        
        NSDictionary *pixBuffAttributes = @{(id)kCVPixelBufferPixelFormatTypeKey: @(kCVPixelFormatType_420YpCbCr8BiPlanarFullRange)};
        _videoOutput = [[AVPlayerItemVideoOutput alloc] initWithPixelBufferAttributes:pixBuffAttributes];
        [_videoOutput setDelegate:self queue:dispatch_get_main_queue()];
        _videoOutput.suppressesPlayerRendering = YES;
        
        [self suspendDisplay];
        
        if (_imageView == nil && _autoCreateSCImageView) {
            self.SCImageView = [[SCImageView alloc] init];
            _imageView.delegate = self;
        }
        
        [self setupVideoOutput];
        [self setupImageView];
    }
    
    AVPlayerItem *item = self.currentItem;
    if (_imageView != nil && item != nil) {
        NSArray *videoTracks = [item.asset tracksWithMediaType:AVMediaTypeVideo];
        
        if (videoTracks.count > 0) {
            AVAssetTrack *track = videoTracks.firstObject;
            
            CGAffineTransform transform = track.preferredTransform;
            if (self.autoRotate) {
                CGSize videoSize = track.naturalSize;
                CGSize viewSize = _imageView.frame.size;
                CGRect outRect = CGRectApplyAffineTransform(CGRectMake(0, 0, videoSize.width, videoSize.height), transform);
                
                BOOL viewIsWide = viewSize.width / viewSize.height > 1;
                BOOL videoIsWide = outRect.size.width / outRect.size.height > 1;
                
                if (viewIsWide != videoIsWide) {
                    transform = CGAffineTransformRotate(transform, M_PI_2);
                }
            }
            
            _imageView.transform = transform;
        }
    }
}

- (void)unsetupCoreImageView {
    if (_displayLink != nil) {
        [_displayLink invalidate];
        _videoOutput = nil;
        if (_imageView.delegate == self) {
            _imageView = nil;
        }
        _displayLink = nil;
        
        [self unsetupVideoOutput:self.currentItem];
    }
}

- (void)setupVideoOutput {
    if (_videoOutput != nil) {
        if (![self.currentItem.outputs containsObject:_videoOutput]) {
            [self.currentItem addOutput:_videoOutput];
//            _imageView.hidden = YES;
        }
    }
}

- (void)resizePlayerLayerToFitOutputView {
    UIView *outputView = _outputView;
    if (outputView != nil) {
        [self resizePlayerLayer:outputView.frame.size];
    }
}

- (void)resizePlayerLayer:(CGSize)size {
    
    AVAssetImageGenerator *imageGenerator = [[AVAssetImageGenerator alloc]initWithAsset:self.currentItem.asset];
    imageGenerator.appliesPreferredTrackTransform = YES;
//    CMTime time = CMTimeMake(1, 1);
//    CGImageRef imageRef = [imageGenerator copyCGImageAtTime:time actualTime:NULL error:NULL];
//    UIImage *thumbnail = [UIImage imageWithCGImage:imageRef scale:1.0 orientation:UIImageOrientationUp];

    _playerLayer.frame = CGRectMake(0, 0, size.width, size.height);
    _imageView.frame = CGRectMake(0, 0, size.width, size.height);
}

- (void)initObserver {
	[self removeOldObservers];
	
	if (self.currentItem != nil) {
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playReachedEnd:) name:AVPlayerItemDidPlayToEndTimeNotification object:self.currentItem];
        self.oldItem = self.currentItem;
        
        [self setupVideoOutput];
	}

    id<SCPlayerDelegate> delegate = self.delegate;
	if ([delegate respondsToSelector:@selector(videoPlayer:didChangeItem:)]) {
		[delegate videoPlayer:self didChangeItem:self.currentItem];
	}
}

- (void)play {
    SCPlayer *currentPlayer = currentSCVideoPlayer;
	if (currentPlayer != self && currentPlayer.shouldPlayConcurrently == NO) {
        [currentPlayer pause];
	}
	
	[super play];
	
	currentSCVideoPlayer = self;
}

- (void)pause {
	[super pause];
	
	if (currentSCVideoPlayer == self) {
		currentSCVideoPlayer = nil;
	}
}

- (CMTime) playableDuration {
	AVPlayerItem * item = self.currentItem;
	CMTime playableDuration = kCMTimeZero;
	
	if (item.status != AVPlayerItemStatusFailed) {
		
		if (item.loadedTimeRanges.count > 0) {
			NSValue * value = [item.loadedTimeRanges objectAtIndex:0];
			CMTimeRange timeRange = [value CMTimeRangeValue];
			
			playableDuration = timeRange.duration;
		}
	}
	
	return playableDuration;
}

- (void)setItemByStringPath:(NSString *)stringPath {
	[self setItemByUrl:[NSURL fileURLWithPath:stringPath]];
}

- (void)setItemByUrl:(NSURL *)url {
	[self setItemByAsset:[AVURLAsset URLAssetWithURL:url options:nil]];
}

- (void)setItemByAsset:(AVAsset *)asset {
	[self setItem:[AVPlayerItem playerItemWithAsset:asset]];
}

- (void)setItem:(AVPlayerItem *)item {
	self.itemsLoopLength = 1;
	[self replaceCurrentItemWithPlayerItem:item];
}

- (void)setSmoothLoopItemByStringPath:(NSString *)stringPath smoothLoopCount:(NSUInteger)loopCount {
	[self setSmoothLoopItemByUrl:[NSURL URLWithString:stringPath] smoothLoopCount:loopCount];
}

- (void)setSmoothLoopItemByUrl:(NSURL *)url smoothLoopCount:(NSUInteger)loopCount {
	[self setSmoothLoopItemByAsset:[AVURLAsset URLAssetWithURL:url options:nil] smoothLoopCount:loopCount];
}

- (void)setSmoothLoopItemByAsset:(AVAsset *)asset smoothLoopCount:(NSUInteger)loopCount {
	
	AVMutableComposition * composition = [AVMutableComposition composition];
	
	CMTimeRange timeRange = CMTimeRangeMake(kCMTimeZero, asset.duration);
	
	for (NSUInteger i = 0; i < loopCount; i++) {
		[composition insertTimeRange:timeRange ofAsset:asset atTime:composition.duration error:nil];
	}
	
	[self setItemByAsset:composition];
	
	self.itemsLoopLength = loopCount;
}

- (BOOL)isPlaying {
    return self.rate > 0;
}

- (BOOL)shouldLoop {
    return _shouldLoop;
}

- (void)setShouldLoop:(BOOL)shouldLoop {
    _shouldLoop = shouldLoop;
    
    self.actionAtItemEnd = shouldLoop ? AVPlayerActionAtItemEndNone : AVPlayerActionAtItemEndPause;
}

- (CMTime)itemDuration {
    Float64 ratio = 1.0 / self.itemsLoopLength;

    return CMTimeMultiply(self.currentItem.duration, ratio);
}

- (BOOL)isSendingPlayMessages {
    return self.timeObserver != nil;
}

- (void)setFilterGroup:(SCFilterGroup *)filterGroup {
    _filterGroup = filterGroup;
}

- (void)setUseCoreImageView:(BOOL)useCoreImageView {
    if (useCoreImageView != _useCoreImageView) {
        _useCoreImageView = useCoreImageView;
        
        if (useCoreImageView) {
            [self setupCoreImageView];
        } else {
            [self unsetupCoreImageView];
        }
    }
}

- (void)setOutputView:(UIView *)outputView {
    _outputView = outputView;
    
    if (outputView == nil) {
        if (_playerLayer != nil) {
            _playerLayer.player = nil;
            [_playerLayer removeFromSuperlayer];
            _playerLayer = nil;
        }
    } else {
        if (_playerLayer == nil) {
            _playerLayer = [AVPlayerLayer playerLayerWithPlayer:self];
            _playerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
        }
        [_playerLayer removeFromSuperlayer];
        [outputView.layer addSublayer:_playerLayer];
        [self setupImageView];
    }
}

- (SCImageView *)SCImageView {
    return _imageView;
}

- (void)setSCImageView:(SCImageView *)SCImageView {
    _imageView = SCImageView;
    [self setupCoreImageView];
}

- (void)setAutoRotate:(BOOL)autoRotate {
    _autoRotate = autoRotate;
}

+ (SCPlayer*)player {
	return [[SCPlayer alloc] init];
}

+ (void)pauseCurrentPlayer {
    SCPlayer *currentPlayer = currentSCVideoPlayer;
    [currentPlayer pause];
}

+ (SCPlayer*)currentPlayer {
	return currentSCVideoPlayer;
}

@end
