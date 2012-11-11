//
//  RestaurantViewController.m
//  Bestaurant
//
//  Created by Ishaan Gulrajani on 11/10/12.
//
//

#import "RestaurantViewController.h"
#import "AddressAnnotation.h"
#import "DataProvider.h"
#import "UIImageView+AFNetworking.h"
@implementation RestaurantViewController

- (id)initWithItem:(NSDictionary *)item
{
    _item = item;
    self = [super initWithNibName:nil bundle:nil];
    return self;
}

- (IBAction)dislike:(id)sender {
    [[DataProvider shared] savePreference:NO forItem:_item[@"result_id"]];
}

- (IBAction)like:(id)sender {
    [[DataProvider shared] savePreference:YES forItem:_item[@"result_id"]];
}


-(void)viewDidLoad {
    self.title = _item[@"name"];
    
    
    // mapView setup
    CLLocationCoordinate2D coord = CLLocationCoordinate2DMake([_item[@"lat"] doubleValue],
                                                              [_item[@"lng"] doubleValue]
                                                              );
    MKCoordinateSpan span = {.latitudeDelta =  .003, .longitudeDelta =  .003};
    MKCoordinateRegion region = {coord, span};
    [self.mapView setRegion:region];

    UITapGestureRecognizer *tgr = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self action:@selector(mapTouched)];
    [self.mapView addGestureRecognizer:tgr];
    
    AddressAnnotation *addAnnotation = [[AddressAnnotation alloc] initWithCoordinate:coord];
    [self.mapView addAnnotation:addAnnotation];
    
    
    // imageView setup;
    [self.imageView setImageWithURL:[NSURL URLWithString:_item[@"image_url"]] placeholderImage:[UIImage imageNamed:@"black.png"]];
    
    
    // star ratings
    int stars = 0;
    if(_item[@"average_ratings"])
        stars = (int)round([[_item[@"average_ratings"] allValues][0] doubleValue]);
    self.starsView.image = [UIImage imageNamed:[NSString stringWithFormat:@"stars%i.png",stars]];
}

-(void)mapTouched {
    NSLog(@"opening %@",[@"http://maps.apple.com/maps?q=" stringByAppendingString:_item[@"address"]]);
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[@"http://maps.apple.com/maps?q=" stringByAppendingString:[_item[@"address"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]]];
//    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[@"http://maps.apple.com/maps?q=" stringByAppendingString:_item[@"address"]]]];
}

@end
