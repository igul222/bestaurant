//
//  AppDelegate.m
//  Bestaurant
//
//  Created by Ishaan Gulrajani on 11/10/12.
//
//

#import "AppDelegate.h"
#import "ListViewController.h"
#import "BumpClient.h"
#import "DataProvider.m"

@implementation AppDelegate

- (void) configureBump {
    [BumpClient configureWithAPIKey:@"17b8e2502d664df5a4c1b70167a41ed0" andUserID:[[UIDevice currentDevice] name]];
    
    [[BumpClient sharedClient] setMatchBlock:^(BumpChannelID channel) {
        NSLog(@"Matched with user: %@", [[BumpClient sharedClient] userIDForChannel:channel]);
        [[BumpClient sharedClient] confirmMatch:YES onChannel:channel];
    }];
    
    
    [[BumpClient sharedClient] setChannelConfirmedBlock:^(BumpChannelID channel) {
        NSLog(@"Channel with %@ confirmed.", [[BumpClient sharedClient] userIDForChannel:channel]);
        [[BumpClient sharedClient] sendData:[[NSArray arrayWithObjects:
                                              @"cake",
                                              [[DataProvider shared] getLikes],
                                              [[DataProvider shared] getDislikes], nil] dataUsingEncoding:NSUTF8StringEncoding]
                                  toChannel:channel];
    }];
    
    [[BumpClient sharedClient] setDataReceivedBlock:^(BumpChannelID channel, NSData *data) {
        NSLog(@"Data received from %@: %@",
              [[BumpClient sharedClient] userIDForChannel:channel],
              [NSString stringWithCString:[data bytes] encoding:NSUTF8StringEncoding]);
    }];
    
    [[BumpClient sharedClient] setConnectionStateChangedBlock:^(BOOL connected) {
        if (connected) {
            NSLog(@"Bump connected...");
        } else {
            NSLog(@"Bump disconnected...");
        }
    }];
    
    [[BumpClient sharedClient] setBumpEventBlock:^(bump_event event) {
        switch(event) {
            case BUMP_EVENT_BUMP:
                NSLog(@"Bump detected.");
                break;
            case BUMP_EVENT_NO_MATCH:
                NSLog(@"No match.");
                break;
        }
    }];
}



- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

    self.tabBarController = [[UITabBarController alloc] init];
    self.tabBarController.viewControllers = @[
        [[UINavigationController alloc] initWithRootViewController:[[ListViewController alloc] initWithType:ListViewControllerTypeNearby]],
        [[UINavigationController alloc] initWithRootViewController:[[ListViewController alloc] initWithType:ListViewControllerTypeRecommended]]
    ];

    self.window.rootViewController = self.tabBarController;
    [self.window makeKeyAndVisible];
    [self configureBump];
    return YES;
}

@end
