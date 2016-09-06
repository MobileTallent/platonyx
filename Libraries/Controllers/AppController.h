//  AppController.h
//  Created by BE

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface AppController : NSObject

@property (nonatomic, strong) NSMutableArray *introSliderImages, *rePostArray, *upPostArray, *pastPostArray;
@property (nonatomic, strong) NSMutableDictionary *currentUser, *apnsMessage;
@property (nonatomic, strong) NSMutableArray *barks, *myBarks, *likedBarks, *menuPages, *avatars, *favoriteUsers, *statsPeriods;
@property (nonatomic, strong) UIImage *postBarkImage, *editProfileImage;

// Temporary Variables
@property (nonatomic, strong) NSString *currentMenuTag;
@property (nonatomic, assign) BOOL isMyProfileChanged;
@property (nonatomic, assign) NSUInteger myBookingsPageStatus;

// Utility Variables
@property (nonatomic, strong) NSString *authSignInAlertMessage;
@property (nonatomic, strong) UIColor *appMainColor, *appTextColor, *appThirdColor;
@property (nonatomic, strong) DoAlertView *vAlert;
@property (nonatomic, strong) UIImage *userImage;
+ (AppController *)sharedInstance;

@end
