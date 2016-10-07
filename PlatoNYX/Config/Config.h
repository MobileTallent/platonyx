//
//  Config.m


//#define SERVER_URL @"http://172.16.1.249/platonyx_api"
#define SERVER_URL @"http://platonyx.com/platonyx_api"

#define API_KEY @"f1e3c46751ecd6e4cff88ffd948794cc"

#define API_URL (SERVER_URL @"/api")

// User info

#define API_URL_USER_SIGNUP (SERVER_URL @"/api/user_signup")
#define API_URL_USER_LOGIN (SERVER_URL @"/api/user_login")
#define API_URL_USER_RETRIEVE_PASSWORD (SERVER_URL @"/api/user_retrieve_password")
#define API_URL_USER_LOGOUT (SERVER_URL @"/api/user_logout")

// Photo

#define API_URL_PHOTO_UPDATE (SERVER_URL @"/api/user_photo_update")
#define API_URL_PHOTO_ORDER (SERVER_URL @"/api/user_photo_order")
#define API_URL_PHOTO_DEL (SERVER_URL @"/api/user_photo_delete")

// Activity

#define API_URL_REC_POST (SERVER_URL @"/api/get_post")
#define API_URL_POST_ATTEND (SERVER_URL @"/api/get_attendants")
#define API_URL_JOIN_POST (SERVER_URL @"/api/join_post")
#define API_URL_MY_POST (SERVER_URL @"/api/get_myPost")
#define API_URL_LIKE (SERVER_URL @"/api/like_post")

// Settings Config

#define API_URL_UDATE_SETTING (SERVER_URL @"/api/update_settings")

// Notification List

#define API_URL_GET_NOTI_LIST (SERVER_URL @"/api/get_noti_list")
#define API_URL_READ_NOTI_LIST (SERVER_URL @"/api/read_noti_list")

// Contact

#define API_URL_CONTACT (SERVER_URL @"/api/contactus_fromuser")

// Invitation

#define API_URL_INVITE (SERVER_URL @"/api/invite_fromuser")

// Explore Barks Default Config
#define EXPLORE_STYLISTS_COUNT_DEFAULT @"100"


// Utility Values
#define RGBA(a, b, c, d) [UIColor colorWithRed:(a / 255.0f) green:(b / 255.0f) blue:(c / 255.0f) alpha:d]
#define M_PI        3.14159265358979323846264338327950288

#define FONT_HELVETICA_NEUE(s) [UIFont fontWithName:@"Helvetica Neue" size:s]
#define FONT_HELVETICA_NEUE_LIGHT(s) [UIFont fontWithName:@"Helvetica Neue Light" size:s]

#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define IS_RETINA ([[UIScreen mainScreen] scale] >= 2.0)

#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)
#define SCREEN_MAX_LENGTH (MAX(SCREEN_WIDTH, SCREEN_HEIGHT))
#define SCREEN_MIN_LENGTH (MIN(SCREEN_WIDTH, SCREEN_HEIGHT))

#define IS_IPHONE_4_OR_LESS (IS_IPHONE && SCREEN_MAX_LENGTH < 568.0)
#define IS_IPHONE_5 (IS_IPHONE && SCREEN_MAX_LENGTH == 568.0)
#define IS_IPHONE_6 (IS_IPHONE && SCREEN_MAX_LENGTH == 667.0)
#define IS_IPHONE_6P (IS_IPHONE && SCREEN_MAX_LENGTH == 736.0)
#define IS_IPHONE_6_OR_ABOVE (IS_IPHONE && SCREEN_MAX_LENGTH >= 667.0)
