//
//  ListViewController.m
//  Bestaurant
//
//  Created by Ishaan Gulrajani on 11/10/12.
//
//

#import "ListViewController.h"
#import "DataProvider.h"
#import "RestaurantViewController.h"
#import "UIImage+iPhone5.h"

@implementation ListViewController

-(id)initWithType:(ListViewControllerType)type {
    self.type = type;
    
    self = [super initWithStyle:UITableViewStylePlain];
    if(self) {
        if(_type == ListViewControllerTypeNearby) {
            self.title = @"Nearby";
            self.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Nearby" image:nil tag:1];
            [self.tabBarItem setFinishedSelectedImage:[UIImage imageNamed:@"first.png"] withFinishedUnselectedImage:[UIImage imageNamed:@"first.png"]];
        } else if(_type == ListViewControllerTypeRecommended) {
            self.title = @"Recommended";
            self.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Recommended" image:nil tag:1];
            [self.tabBarItem setFinishedSelectedImage:[UIImage imageNamed:@"second.png"] withFinishedUnselectedImage:[UIImage imageNamed:@"second.png"]];
        }
    }

    return self;
}

-(void)viewDidLoad {
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    [locationManager startUpdatingLocation];
    
    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    searchBar.delegate = self;
    self.tableView.tableHeaderView = searchBar;
    
    searchController = [[UISearchDisplayController alloc] initWithSearchBar:searchBar contentsController:self];
    searchController.delegate = self;
    searchController.searchResultsDataSource = self;
    searchController.searchResultsDelegate = self;
    
    UIColor *color = [UIColor colorWithPatternImage:[UIImage tallImageNamed:@"leather-background.png"]];
    [self.view setBackgroundColor:color];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

#pragma mark - Refreshing

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    CLLocation *locationObject = [locations lastObject];
    location = locationObject.coordinate;
    [self refresh];

    if([locationObject horizontalAccuracy] <= 100.0)
        [locationManager stopUpdatingLocation];
}

-(void)refresh {
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

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    searchData = nil;
    [[DataProvider shared] itemsForLatitude:location.latitude
                                  longitude:location.longitude
                                      query:searchText
                                   callback:^(NSArray *items) {
                                       searchData = items;
                                       [self.searchDisplayController.searchResultsTableView reloadData];
                                   }];
}

#pragma mark - Table view

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(tableView == self.tableView)
        return data.count;
    else
        return searchData.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellID = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellID];
    if(!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellID];
    }
    
    NSDictionary *item = (tableView == self.tableView ? data : searchData)[indexPath.row];
    cell.textLabel.text = item[@"name"];

    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    RestaurantViewController *vc = [[RestaurantViewController alloc] initWithItem:(tableView == self.tableView ? data : searchData)[indexPath.row]];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
