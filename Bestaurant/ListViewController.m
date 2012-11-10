//
//  ListViewController.m
//  Bestaurant
//
//  Created by Ishaan Gulrajani on 11/10/12.
//
//

#import "ListViewController.h"

@implementation ListViewController

-(id)initWithType:(ListViewControllerType)type {
    self.type = type;
    
    self = [super initWithStyle:UITableViewStylePlain];
    if(self) {
        if(_type == ListViewControllerTypeNearby) {
            self.title = @"Nearby";
            self.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Nearby" image:[UIImage imageNamed:@"first.png"] tag:1];
        } else if(_type == ListViewControllerTypeRecommended) {
            self.title = @"Recommended";
            self.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Recommended" image:[UIImage imageNamed:@"second.png"] tag:1];
        }
    }
    return self;
}

-(void)viewDidLoad {
    
}

@end
