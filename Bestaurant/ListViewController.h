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

@interface ListViewController : UITableViewController <CLLocationManagerDelegate, UISearchBarDelegate, UISearchDisplayDelegate> {
    NSArray *data;
    NSArray *searchData;
    CLLocationCoordinate2D location;
    CLLocationManager *locationManager;
    UISearchDisplayController *searchController;
}

@property(nonatomic) ListViewControllerType type;
@property (strong, nonatomic) IBOutlet UITableViewCell *listCell;

-(id)initWithType:(ListViewControllerType)type;

@end
