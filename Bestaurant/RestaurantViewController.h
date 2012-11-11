//
//  RestaurantViewController.h
//  Bestaurant
//
//  Created by Ishaan Gulrajani on 11/10/12.
//
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface RestaurantViewController : UIViewController {
    NSDictionary *_item;
}
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIImageView *starsView;

- (id)initWithItem:(NSDictionary *)item;

- (IBAction)dislike:(id)sender;
- (IBAction)like:(id)sender;

@end
