//
//  AppDelegate.m
//  Bestaurant
//
//  Created by Ishaan Gulrajani on 11/10/12.
//
//

#import "AppDelegate.h"
#import "ListViewController.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

    self.tabBarController = [[UITabBarController alloc] init];
    self.tabBarController.viewControllers = @[
        [[UINavigationController alloc] initWithRootViewController:[[ListViewController alloc] initWithType:ListViewControllerTypeNearby]],
        [[UINavigationController alloc] initWithRootViewController:[[ListViewController alloc] initWithType:ListViewControllerTypeRecommended]]
    ];

    [self customizeGlobalTheme];
    [self iPhoneInit];
    
    self.window.rootViewController = self.tabBarController;
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)customizeGlobalTheme {
    [[UIApplication sharedApplication]
     setStatusBarStyle:UIStatusBarStyleBlackOpaque animated:NO];
    
    UIImage *navBarImage = [UIImage imageNamed:@"navbar.png"];
    
    [[UINavigationBar appearance] setBackgroundImage:navBarImage
                                       forBarMetrics:UIBarMetricsDefault];
    
    
    UIImage *barButton = [[UIImage imageNamed:@"navbar-icon.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 4, 0, 4)];
    
    [[UIBarButtonItem appearance] setBackgroundImage:barButton forState:UIControlStateNormal
                                          barMetrics:UIBarMetricsDefault];
    
    UIImage *backButton = [[UIImage imageNamed:@"back-button.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 14, 0, 4)];
    
    [[UIBarButtonItem appearance] setBackButtonBackgroundImage:backButton forState:UIControlStateNormal
                                                    barMetrics:UIBarMetricsDefault];
    
    UIImage* tabBarBackground = [UIImage imageNamed:@"tabbar.png"];
    [[UITabBar appearance] setBackgroundImage:tabBarBackground];
    
    
    UIImage *minImage = [[UIImage imageNamed:@"slider-track-fill.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 4, 0, 4)];
    UIImage *maxImage = [UIImage imageNamed:@"slider-track.png"];
    UIImage *thumbImage = [UIImage imageNamed:@"slider-cap.png"];
    
    [[UISlider appearance] setMaximumTrackImage:maxImage
                                       forState:UIControlStateNormal];
    [[UISlider appearance] setMinimumTrackImage:minImage
                                       forState:UIControlStateNormal];
    [[UISlider appearance] setThumbImage:thumbImage
                                forState:UIControlStateNormal];
    [[UISlider appearance] setThumbImage:thumbImage
                                forState:UIControlStateHighlighted];
    
    [[UIProgressView appearance] setProgressTintColor:[UIColor colorWithPatternImage:minImage]];
    [[UIProgressView appearance] setTrackTintColor:[UIColor colorWithPatternImage:maxImage]];
    
    
    [[UITabBar appearance] setSelectionIndicatorImage:[UIImage imageNamed:@"tabbar-item.png"]];
    
}


-(void)iPhoneInit {
    UITabBarController *tabBarController = (UITabBarController *)self.window.rootViewController;
	
    UINavigationController *navigationController = [tabBarController viewControllers][0];
	
    
    UIImage* icon1 = [UIImage imageNamed:@"icon1.png"];
    UITabBarItem *updatesItem = [[UITabBarItem alloc] initWithTitle:@"Recipes" image:icon1 tag:0];
    [updatesItem setFinishedSelectedImage:icon1 withFinishedUnselectedImage:icon1];
    
    [navigationController setTabBarItem:updatesItem];
    
    
    UIImage* icon2 = [UIImage imageNamed:@"icon2.png"];
    UITabBarItem *item2 = [[UITabBarItem alloc] initWithTitle:@"Steps" image:icon2 tag:1] ;
    [item2 setFinishedSelectedImage:icon2 withFinishedUnselectedImage:icon2];
    
    UIViewController* controller2 = [tabBarController viewControllers][1];
    [controller2 setTabBarItem:item2];
    
    
    UIViewController *controller3 = [tabBarController viewControllers][2];
    
    UIImage* icon3 = [UIImage imageNamed:@"icon3.png"];
    
    UITabBarItem *item3 = [[UITabBarItem alloc] initWithTitle:@"Elements" image:icon3 tag:2] ;
    [item3 setFinishedSelectedImage:icon3 withFinishedUnselectedImage:icon3];
    [controller3 setTabBarItem:item3];
    
    UIViewController *controller4 = [tabBarController viewControllers][3];
    
    UITabBarItem *item4 = [[UITabBarItem alloc] initWithTitle:@"Label 4" image:icon3 tag:3];
    [item4 setFinishedSelectedImage:icon3 withFinishedUnselectedImage:icon3];
    [controller4 setTabBarItem:item4];
    
}



@end
