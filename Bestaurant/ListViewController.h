//
//  ListViewController.h
//  Bestaurant
//
//  Created by Ishaan Gulrajani on 11/10/12.
//
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

typedef enum _ListViewControllerType {
    ListViewControllerTypeNearby,
    ListViewControllerTypeRecommended
} ListViewControllerType;

@interface ListViewController : UITableViewController <CLLocationManagerDelegate> {
    NSArray *data;
    CLLocationManager *locationManager;
}
@property(nonatomic) ListViewControllerType type;

-(id)initWithType:(ListViewControllerType)type;

@end
