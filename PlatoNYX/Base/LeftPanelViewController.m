//
//  LeftPanelViewController.m
//  DomumLink
//
//  Created by AnMac on 1/15/15.
//  Copyright (c) 2015 Petr. All rights reserved.
//

#import "LeftPanelViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "SideMenuTableViewCell.h"
#import "MySidePanelController.h"
#import "ProfileDetailViewController.h"

@interface LeftPanelViewController ()

@property (nonatomic, strong) IBOutlet UITableView *menuTableView;
@property (nonatomic, strong) NSMutableArray *menuPages;

@property (nonatomic, strong) IBOutlet UIView *containerView, *topView;

@end

@implementation LeftPanelViewController
@synthesize menuPages;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    menuPages = appController.menuPages;
    self.sidePanelController.slideDelegate = self;
    
    [self initView];
}

- (void)initView {

}

- (void)viewDidLayoutSubviews {
    CGRect containerFrame = self.containerView.frame;
    containerFrame.size.width = self.sidePanelController.leftVisibleWidth;
    [self.containerView setFrame:containerFrame];
    
    CGRect topFrame = self.topView.frame;
    [self.topView setFrame:CGRectMake(0, 0, containerFrame.size.width, topFrame.size.height)];
    
    [self.menuTableView setFrame: CGRectMake(0, self.topView.frame.size.height, containerFrame.size.width, containerFrame.size.height - topFrame.size.height + (float)[menuPages count])];
    
}


#pragma mark - UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger count = [menuPages count];
    return count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;//tableView.frame.size.height / (float)[menuPages count] - 1.0f;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(SideMenuTableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    // Remove seperator inset
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    // Prevent the cell from inheriting the Table View's margin settings
    if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
        [cell setPreservesSuperviewLayoutMargins:NO];
    }
    // Explictly set your cell's layout margins
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (SideMenuTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SideMenuTableViewCell *cell = (SideMenuTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"sideMenuCell"];
    
    NSMutableDictionary *dic = [menuPages objectAtIndex:indexPath.row];
    
    [cell setTag:[[dic objectForKey:@"tag"] intValue]];
    [cell.titleLabel setText: [dic objectForKey:@"title"]];
    
//    NSString *icon = [dic objectForKey:@"icon"];
//    if([appController.currentMenuTag isEqualToString:[dic objectForKey:@"tag"]]) {
//        icon = [icon stringByAppendingString:@"_over"];
//        [cell.bgLabel setBackgroundColor:RGBA(41, 43, 47, 1)];
//    } else {
//        [cell.bgLabel setBackgroundColor:RGBA(44, 48, 52, 1)];
//    }
//    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

#pragma mark - Page Transition

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SideMenuTableViewCell *cell = (SideMenuTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    appController.currentMenuTag = [[menuPages objectAtIndex:indexPath.row] objectForKey:@"tag"];
    [tableView reloadData];
    
    ProfileDetailViewController *mainViewController;
    
    UINavigationController *navController;
    
    switch (cell.tag) {
        case 1:
            mainViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"mainPage"];
            navController = [[UINavigationController alloc] initWithRootViewController: mainViewController];
            self.sidePanelController.centerPanel = navController;
            break;
        case 2:
            mainViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"myActPage"];
            navController = [[UINavigationController alloc] initWithRootViewController: mainViewController];
            self.sidePanelController.centerPanel = navController;
            break;
        case 3:
            mainViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"faqPage"];
            navController = [[UINavigationController alloc] initWithRootViewController: mainViewController];
            self.sidePanelController.centerPanel = navController;
            break;
        case 4:
            mainViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"contactPage"];
            navController = [[UINavigationController alloc] initWithRootViewController: mainViewController];
            self.sidePanelController.centerPanel = navController;
            break;
        case 5:
            mainViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"invitePage"];
            navController = [[UINavigationController alloc] initWithRootViewController: mainViewController];
            self.sidePanelController.centerPanel = navController;
            break;
        case 6:
            [self logout];
            break;
        default:
            break;
    }
}

- (void)logout {
    [commonUtils removeUserDefaultDic:@"current_user"];
    [commonUtils removeUserDefaultDic:@"currentUserSettings"];
    appController.currentUser = [[NSMutableDictionary alloc] init];
    appController.currentUserSettings = [[NSMutableDictionary alloc] init];
    [commonUtils setUserDefault:@"logged_out" withFormat:@"1"];
    
//    UINavigationController * myController = [self.storyboard instantiateViewControllerWithIdentifier:@"initNav"];
//    [self presentViewController:myController animated:YES completion:nil];
    
//    [self dismissViewControllerAnimated:YES completion:nil];
    [self.navigationController popToRootViewControllerAnimated:YES];
    
}

#pragma mark - App Share Function
- (void)defaultShare {
    NSString *texttoshare = @"I'm using WOOF SOCIAL! I share and discover photos/videos from people around me and watch that content spread. It's free on Apple app store!";
    UIImage *imagetoshare = [UIImage imageNamed:@"user_default_avatar"];
    
    
    NSArray *activityItems = @[texttoshare, imagetoshare];
    UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:nil];
    activityVC.excludedActivityTypes = @[UIActivityTypePostToTencentWeibo, UIActivityTypePostToWeibo];
    
    //activityVC.excludedActivityTypes = @[UIActivityTypeMessage, UIActivityTypeMail, UIActivityTypePostToFacebook, UIActivityTypePostToTwitter, UIActivityTypePostToFlickr, UIActivityTypePostToVimeo, UIActivityTypePostToTencentWeibo, UIActivityTypePostToWeibo, UIActivityTypeAssignToContact, UIActivityTypePrint, UIActivityTypeCopyToPasteboard, UIActivityTypeSaveToCameraRoll, UIActivityTypeAddToReadingList, UIActivityTypeAirDrop];
    [self presentViewController:activityVC animated:TRUE completion:nil];
}

#pragma mark -  Left Side Menu Show

- (void)onMenuShow {
    if([commonUtils getUserDefault:@"is_my_profile_changed"]) {
        [commonUtils removeUserDefault:@"is_my_profile_changed"];
        [self initView];
    }
}
- (void)onMenuHide {

}

@end

