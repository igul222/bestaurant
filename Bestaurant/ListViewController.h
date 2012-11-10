//
//  ListViewController.h
//  Bestaurant
//
//  Created by Ishaan Gulrajani on 11/10/12.
//
//

#import <UIKit/UIKit.h>

typedef enum _ListViewControllerType {
    ListViewControllerTypeNearby,
    ListViewControllerTypeRecommended
} ListViewControllerType;

@interface ListViewController : UITableViewController
@property(nonatomic) ListViewControllerType type;

-(id)initWithType:(ListViewControllerType)type;

@end
