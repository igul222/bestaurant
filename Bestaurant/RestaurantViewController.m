//
//  RestaurantViewController.m
//  Bestaurant
//
//  Created by Ishaan Gulrajani on 11/10/12.
//
//

#import "RestaurantViewController.h"
#import "AddressAnnotation.h"
@implementation RestaurantViewController

- (id)initWithItem:(NSDictionary *)item
{
    _item = item;
    self = [super initWithNibName:nil bundle:nil];
    return self;
}

- (IBAction)dislike:(id)sender {
}

- (IBAction)like:(id)sender {
}


-(void)viewDidLoad {
    self.title = _item[@"name"];
    
    CLLocationCoordinate2D coord = CLLocationCoordinate2DMake([_item[@"lat"] doubleValue],
                                                              [_item[@"lng"] doubleValue]
                                                              );
    MKCoordinateSpan span = {.latitudeDelta =  .003, .longitudeDelta =  .003};
    MKCoordinateRegion region = {coord, span};
    [self.mapView setRegion:region];

    AddressAnnotation *addAnnotation = [[AddressAnnotation alloc] initWithCoordinate:coord];
    [self.mapView addAnnotation:addAnnotation];
    
}

@end
