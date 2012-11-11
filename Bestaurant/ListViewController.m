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
#import "UIImageView+AFNetworking.h"
#import "BumpClient.h"

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
        } else if(_type == ListViewControllerTypeBump) {
            self.title = @"Bump";
            self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                                                                   target:self
                                                                                                   action:@selector(dismiss)];
            
            self.likes = @[];
            self.dislikes = @[];
        }
    }

    return self;
}

-(void)dismiss {
    [self dismissModalViewControllerAnimated:YES];
}

-(void)viewDidLoad {
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    [locationManager startUpdatingLocation];
    
    if(_type == ListViewControllerTypeNearby) {
        UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
        searchBar.delegate = self;
        self.tableView.tableHeaderView = searchBar;
        
        searchController = [[UISearchDisplayController alloc] initWithSearchBar:searchBar contentsController:self];
        searchController.delegate = self;
        searchController.searchResultsDataSource = self;
        searchController.searchResultsDelegate = self;
    }
    
    UIColor *color = [UIColor colorWithPatternImage:[UIImage tallImageNamed:@"leather-background.png"]];
    [self.view setBackgroundColor:color];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.tableView.rowHeight = 62.0;
}

-(void)viewWillAppear:(BOOL)animated {
    [self refresh];
}

#pragma mark - Refreshing

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    CLLocation *locationObject = [locations lastObject];
    location = locationObject.coordinate;
    [self refresh];

    if([locationObject horizontalAccuracy] <= 100.0)
        [locationManager stopUpdatingLocation];
}

// make it super-obvious that we're refreshing
-(void)explicitRefresh {
    data = nil;
    [self.tableView reloadData];
    [self refresh];
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
    } else if(_type == ListViewControllerTypeBump) {
        [[DataProvider shared] recommendedItemsForLatitude:location.latitude
                                                 longitude:location.longitude
                                                     likes:self.likes
                                                  dislikes:self.dislikes
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
        [[NSBundle mainBundle] loadNibNamed:@"ListCell"
                                      owner:self
                                    options:nil];
        cell = self.listCell;
        self.listCell = nil;
    }
    
    NSDictionary *item = (tableView == self.tableView ? data : searchData)[indexPath.row];
    
    // name
    ((UILabel *)[cell viewWithTag:1002]).text = item[@"name"];

    // image
    [(UIImageView *)[cell viewWithTag:1001] setImageWithURL:[NSURL URLWithString:item[@"image_url"]]
                                           placeholderImage:[UIImage imageNamed:@"black.png"]];

    // stars
    int stars = 0;
    if(item[@"average_ratings"])
        stars = (int)round([[item[@"average_ratings"] allValues][0] doubleValue]);
    ((UIImageView *)[cell viewWithTag:1003]).image = [UIImage imageNamed:[NSString stringWithFormat:@"stars%i.png",stars]];

    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [[BumpClient sharedClient] simulateBump];
    RestaurantViewController *vc = [[RestaurantViewController alloc] initWithItem:(tableView == self.tableView ? data : searchData)[indexPath.row]];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
