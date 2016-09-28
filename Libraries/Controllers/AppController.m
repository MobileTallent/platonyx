//
//  AppController.m


#import "AppController.h"

static AppController *_appController;

@implementation AppController

+ (AppController *)sharedInstance {
    static dispatch_once_t predicate;
    if (_appController == nil) {
        dispatch_once(&predicate, ^{
            _appController = [[AppController alloc] init];
        });
    }
    return _appController;
}

- (id)init {
    self = [super init];
    if (self) {
        
        // Utility Data
        _appMainColor = RGBA(239, 34, 86, 1.0f);
        _appTextColor = RGBA(141, 141, 141, 1.0f);
        _appThirdColor = RGBA(220, 220, 220, 1.0f);
        
        _authSignInAlertMessage = @"Please sign in first";
        
        _vAlert = [[DoAlertView alloc] init];
        _vAlert.nAnimationType = 2;  // there are 5 type of animation
        _vAlert.dRound = 7.0;
        _vAlert.bDestructive = NO;  // for destructive mode
        //        _vAlert.iImage = [UIImage imageNamed:@"logo_top"];
        //        _vAlert.nContentMode = DoContentImage;
        
        _msgs = [[NSMutableArray alloc] init];
        
        // Intro Images
        _introSliderImages = (NSMutableArray *) @[
                                                  @"intro1",
                                                  @"intro2",
                                                  @"intro3"
                                                  ];
        
        // Side Menu Bar Pages
        _menuPages = [[NSMutableArray alloc] init];
        _menuPages = [@[
                        [@{@"tag" : @"1", @"title" : @"Profilim"} mutableCopy],
                        [@{@"tag" : @"2", @"title" : @"Etkinliklerim"} mutableCopy],
                        [@{@"tag" : @"3", @"title" : @"İletişim"} mutableCopy],
                        [@{@"tag" : @"4", @"title" : @"Davet Et"} mutableCopy],
                        [@{@"tag" : @"5", @"title" : @"Çıkış"} mutableCopy]
                        ] mutableCopy];
        
        
        // Nav Temporary Data
        _postBarkImage = nil;
        _editProfileImage = nil;
        _currentMenuTag = @"1";

        _isMyProfileChanged = NO;
        _myBookingsPageStatus = 0;
        
        // Data
        _currentUser = [[NSMutableDictionary alloc] init];
        _currentUserSettings = [[NSMutableDictionary alloc] init];
        _rePostArray = [[NSMutableArray alloc] init];
        
        _upPostArray = [[NSMutableArray alloc] init];
        _pastPostArray = [[NSMutableArray alloc] init];

    }
    return self;
}


+ (NSDictionary*) requestApi:(NSMutableDictionary *)params withFormat:(NSString *)url {
    return [AppController jsonHttpRequest:url jsonParam:params];
}

+ (id) jsonHttpRequest:(NSString*) urlStr jsonParam:(NSMutableDictionary *)params {
    NSString *paramStr = [commonUtils getParamStr:params];
    //NSLog(@"\n\nparameter string : \n\n%@", paramStr);
    NSData *requestData = [paramStr dataUsingEncoding:NSUTF8StringEncoding];

    NSData *data = nil;
    NSURL *url = [NSURL URLWithString:urlStr];
    
    NSHTTPURLResponse *response = nil;
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:10];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"content-type"];
    [request setHTTPBody: requestData];
    data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];
    
    NSString *responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    responseString = [responseString stringByReplacingOccurrencesOfString:@"\n" withString:@" "];
//    NSLog(@"\n\nresponse string : \n\n%@", responseString);
    return [[SBJsonParser new] objectWithString:responseString];
}

@end
