//
//  AppDelegate.h
//  PlatoNYX
//
//  Created by mobilestar on 8/4/16.
//  Copyright © 2016 marc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate, CLLocationManagerDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, retain) CLLocationManager *locationManager;

- (void)updateLocationManager;

@end

