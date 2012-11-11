//
//  RestaurantViewController.h
//  Bestaurant
//
//  Created by Ishaan Gulrajani on 11/10/12.
//
//

#import <UIKit/UIKit.h>

@interface RestaurantViewController : UIViewController {
    NSDictionary *_item;
}

- (id)initWithItem:(NSDictionary *)item;


@end
