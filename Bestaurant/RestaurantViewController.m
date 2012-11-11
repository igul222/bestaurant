//
//  RestaurantViewController.m
//  Bestaurant
//
//  Created by Ishaan Gulrajani on 11/10/12.
//
//

#import "RestaurantViewController.h"

@implementation RestaurantViewController

- (id)initWithItem:(NSDictionary *)item
{
    _item = item;
    self = [super initWithNibName:nil bundle:nil];
    
    return self;
}


-(void)viewDidLoad {
    self.title = _item[@"name"];
}

@end
