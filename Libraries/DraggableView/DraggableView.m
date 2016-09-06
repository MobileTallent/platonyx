//
//  DraggableView.m
//  testing swiping
//
//  Created by Richard Kim on 5/21/14.
//  Copyright (c) 2014 Richard Kim. All rights reserved.
//
//  @cwRichardKim for updates and requests

#define ACTION_MARGIN 120 //%%% distance from center where the action applies. Higher = swipe further in order for the action to be called
#define SCALE_STRENGTH 4 //%%% how quickly the card shrinks. Higher = slower shrinking
#define SCALE_MAX .93 //%%% upper bar for how much the card shrinks. Higher = shrinks less
#define ROTATION_MAX 1 //%%% the maximum rotation allowed in radians.  Higher = card can keep rotating longer
#define ROTATION_STRENGTH 320 //%%% strength of rotation. Higher = weaker rotation
#define ROTATION_ANGLE M_PI/8 //%%% Higher = stronger rotation angle


#import "DraggableView.h"

@implementation DraggableView {
    CGFloat xFromCenter;
    CGFloat yFromCenter;
}

//delegate is instance of ViewController
@synthesize delegate;

@synthesize panGestureRecognizer;
@synthesize information;
@synthesize image, isVideo, videoContainerView, videoPlayer, videoPlayerLayer, videoPlayButton, isVideoPlaying;
@synthesize overlayView;

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        [self setupView];
        
        // Default Data
        isVideo = NO;
        isVideoPlaying = NO;


        
        // Video Thumb Image or Static Image
        image = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        image.contentMode = UIViewContentModeScaleAspectFill;
        image.clipsToBounds = YES;
        [self addSubview:image];
        
        
        
        // Video Player
        //[videoPlayerLayer setFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        //[videoPlayerLayer setBackgroundColor:[UIColor grayColor].CGColor];
        //[videoPlayerLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
        //[videoPlayerLayer setZPosition:1501];
        
        videoContainerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        [videoContainerView setBackgroundColor:[UIColor clearColor]];
        //[videoContainerView.layer addSublayer:videoPlayerLayer];
        
        [self addSubview:videoContainerView];
        
        
        
        // Video Play Button
        //float buttonWidth = 98.0f, buttonHeight = 98.0f;
        videoPlayButton = [[UIButton alloc] initWithFrame:frame];
        videoPlayButton.center = image.center;
        [videoPlayButton setTitle:@"" forState:UIControlStateNormal];
        [videoPlayButton setBackgroundColor:[UIColor clearColor]];
        [videoPlayButton setBackgroundImage:nil forState:UIControlStateNormal];
        [videoPlayButton setImage:[UIImage imageNamed:@"camerainterface_playback"] forState:UIControlStateNormal];
        [videoPlayButton addTarget:self action:@selector(onClickVideoPlayButton:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:videoPlayButton];
        
        
        
        // Overlay
        float overlayViewWidth = 100.0f, overlayViewTopMargin = 5.0f;
        overlayView = [[OverlayView alloc] initWithFrame:CGRectMake(self.frame.size.width/2-overlayViewWidth, overlayViewTopMargin, overlayViewWidth, overlayViewWidth)];
        overlayView.alpha = 0;
        [self addSubview:overlayView];
        
        //[self updateVideoViewState];
        
        // Pan Gesture
        panGestureRecognizer = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(beingDragged:)];
        [self addGestureRecognizer:panGestureRecognizer];
        
        
    }
    return self;
}

#pragma mark - video play
- (IBAction)onClickVideoPlayButton:(id)sender {
    
    isVideoPlaying = !isVideoPlaying;
    [self updateVideoViewState];
    
}

- (void) updateVideoViewState {
    
    NSLog(@"clicked play button : %@", isVideoPlaying?@"YES":@"NO");
    if(!isVideo) {
        [videoPlayButton setHidden:YES];
        [videoContainerView setHidden:YES];
    } else {
        if(isVideoPlaying) {
            [videoPlayButton setImage:nil forState:UIControlStateNormal];
            [videoContainerView setHidden:NO];
            [videoPlayer play];
        } else {
            [videoPlayButton setImage:[UIImage imageNamed:@"camerainterface_playback"] forState:UIControlStateNormal];
            [videoPlayer pause];
        }
    }
}

- (void) setVideoContainer {
    
    NSURL *videoUrl = [NSURL URLWithString:self.videoUrlStr];
    videoPlayer = [AVPlayer playerWithURL:videoUrl];
    videoPlayer.actionAtItemEnd = AVPlayerActionAtItemEndNone;
    
    CGRect frame = self.frame;
    videoPlayerLayer = [AVPlayerLayer layer];
    [videoPlayerLayer setPlayer:videoPlayer];
    [videoPlayerLayer setFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
    [videoPlayerLayer setBackgroundColor:[UIColor grayColor].CGColor];
    [videoPlayerLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    [videoPlayerLayer setZPosition:1501];
    
    
    [videoContainerView.layer addSublayer:videoPlayerLayer];
    [videoContainerView setHidden:YES];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(playerItemDidReachEnd:)
                                                 name:AVPlayerItemDidPlayToEndTimeNotification
                                               object:[videoPlayer currentItem]];
}

#pragma mark - AVPlayer Events
- (void)playerItemDidReachEnd:(NSNotification *)notification {
    AVPlayerItem *p = [notification object];
    [p seekToTime:kCMTimeZero];
}


#pragma mark - draggable view setting
- (void)setupView {
    self.layer.cornerRadius = 0;
    self.layer.shadowRadius = 0;
    self.layer.shadowOpacity = 0;
    //self.layer.shadowOffset = CGSizeMake(1, 1);
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

//%%% called when you move your finger across the screen.
// called many times a second
-(void)beingDragged:(UIPanGestureRecognizer *)gestureRecognizer {
    
    //%%% this extracts the coordinate data from your swipe movement. (i.e. How much did you move?)
    xFromCenter = [gestureRecognizer translationInView:self].x; //%%% positive for right swipe, negative for left
    yFromCenter = [gestureRecognizer translationInView:self].y; //%%% positive for up, negative for down
    
    //%%% checks what state the gesture is in. (are you just starting, letting go, or in the middle of a swipe?)
    switch (gestureRecognizer.state) {
            //%%% just started swiping
        case UIGestureRecognizerStateBegan:{
            self.originalPoint = self.center;
            break;
        };
            //%%% in the middle of a swipe
        case UIGestureRecognizerStateChanged:{
            //%%% dictates rotation (see ROTATION_MAX and ROTATION_STRENGTH for details)
            CGFloat rotationStrength = MIN(xFromCenter / ROTATION_STRENGTH, ROTATION_MAX);
            
            //%%% degree change in radians
            CGFloat rotationAngel = (CGFloat) (ROTATION_ANGLE * rotationStrength);
            
            //%%% amount the height changes when you move the card up to a certain point
            CGFloat scale = MAX(1 - fabsf(rotationStrength) / SCALE_STRENGTH, SCALE_MAX);
            
            //%%% move the object's center by center + gesture coordinate
            self.center = CGPointMake(self.originalPoint.x + xFromCenter, self.originalPoint.y + yFromCenter);
            
            //%%% rotate by certain amount
            CGAffineTransform transform = CGAffineTransformMakeRotation(rotationAngel);
            
            //%%% scale by certain amount
            CGAffineTransform scaleTransform = CGAffineTransformScale(transform, scale, scale);
            
            //%%% apply transformations
            self.transform = scaleTransform;
            [self updateOverlay:xFromCenter];
            
            break;
        };
            //%%% let go of the card
        case UIGestureRecognizerStateEnded: {
            [self afterSwipeAction];
            break;
        };
        case UIGestureRecognizerStatePossible:break;
        case UIGestureRecognizerStateCancelled:break;
        case UIGestureRecognizerStateFailed:break;
    }
}

//%%% checks to see if you are moving right or left and applies the correct overlay image
-(void)updateOverlay:(CGFloat)distance
{
    if (distance > 0) {
        overlayView.mode = GGOverlayViewModeRight;
    } else {
        overlayView.mode = GGOverlayViewModeLeft;
    }
    
    overlayView.alpha = MIN(fabsf(distance)/100, 0.6);
}

//%%% called when the card is let go
- (void)afterSwipeAction
{
    
    if (xFromCenter > ACTION_MARGIN) {
        [self rightAction];
    } else if (xFromCenter < -ACTION_MARGIN) {
        [self leftAction];
    } else { //%%% resets the card
        [UIView animateWithDuration:0.3
                         animations:^{
                             self.center = self.originalPoint;
                             self.transform = CGAffineTransformMakeRotation(0);
                             overlayView.alpha = 0;
                         }];
    }
}

- (void)finalAction {
    if(isVideo) {
        [videoPlayer pause];
        videoPlayer = nil;
        [commonUtils removeAllSubViews: videoContainerView];
    }
    [self removeFromSuperview];
}
//%%% called when a swipe exceeds the ACTION_MARGIN to the right
-(void)rightAction
{
    CGPoint finishPoint = CGPointMake(500, 2*yFromCenter +self.originalPoint.y);
    [UIView animateWithDuration:0.5
                     animations:^{
                         self.center = finishPoint;
                     }completion:^(BOOL complete){
                         [self finalAction];
                     }];
    
    [delegate cardSwipedRight:self];
    
    NSLog(@"YES");
}

//%%% called when a swip exceeds the ACTION_MARGIN to the left
-(void)leftAction
{
    CGPoint finishPoint = CGPointMake(-500, 2*yFromCenter +self.originalPoint.y);
    [UIView animateWithDuration:0.5
                     animations:^{
                         self.center = finishPoint;
                     }completion:^(BOOL complete){
                         [self finalAction];
                     }];
    
    [delegate cardSwipedLeft:self];
    
    NSLog(@"NO");
}

-(void)rightClickAction
{
    CGPoint finishPoint = CGPointMake(600, self.center.y);
    [UIView animateWithDuration:0.5
                     animations:^{
                         self.center = finishPoint;
                         self.transform = CGAffineTransformMakeRotation(1);
                     }completion:^(BOOL complete){
                         [self finalAction];
                     }];
    
    [delegate cardSwipedRight:self];
    
    NSLog(@"YES");
}

-(void)leftClickAction
{
    CGPoint finishPoint = CGPointMake(-600, self.center.y);
    [UIView animateWithDuration:0.5
                     animations:^{
                         self.center = finishPoint;
                         self.transform = CGAffineTransformMakeRotation(-1);
                     }completion:^(BOOL complete){
                         [self finalAction];
                     }];
    
    [delegate cardSwipedLeft:self];
    
    NSLog(@"NO");
}

// Custom Actions
- (void) cardBringToTop {
    
    [UIView animateWithDuration:0.4
                     animations:^{
                         float widthDecrease = 6.0f, heightDecrease = 8.0f;
                         CGRect frame = self.frame;
                         frame.origin.x -= widthDecrease;
                         frame.origin.y += heightDecrease;
                         frame.size.width += (widthDecrease * 2);
                         frame.size.height = frame.size.width;
                         self.layer.frame = frame;
                         [image setFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
                         float overlayViewWidth = 100.0f, overlayViewTopMargin = 60.0f;
                         [overlayView setFrame:CGRectMake(self.frame.size.width/2-overlayViewWidth, overlayViewTopMargin, overlayViewWidth, overlayViewWidth)];
                         
                     } completion:^(BOOL complete){
                         
                     }];
}

@end
