//
//  ListViewController.m
//  Bestaurant
//
//  Created by Ishaan Gulrajani on 11/10/12.
//
//

#import "ListViewController.h"
#import "DataProvider.h"

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
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    [locationManager startUpdatingLocation];
}

#pragma mark - Refreshing

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    CLLocation *location = [locations lastObject];
    [self refreshWithLocation:location.coordinate];
}

-(void)refreshWithLocation:(CLLocationCoordinate2D)location {
    if(_type == ListViewControllerTypeNearby) {
        [[DataProvider shared] itemsForLatitude:location.latitude
                                             longitude:location.longitude
                                                 query:nil
                                              callback:^(NSArray *items) {
                                                  data = items;
                                                  [self.tableView reloadData];
                                               }];
    } else if(_type == ListViewControllerTypeRecommended) {
        [[DataProvider shared] recommendedItemsForLatitude:location.latitude
                                                 longitude:location.longitude
                                                  callback:^(NSArray *items) {
                                                      data = items;
                                                      [self.tableView reloadData];
                                                  }];
    }
}

#pragma mark - Table view

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return data.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellID = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellID];
    if(!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellID];
    }
    
    NSDictionary *item = data[indexPath.row];
    cell.textLabel.text = item[@"name"];

    return cell;
}

@end
