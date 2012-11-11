//
//  DataProvider.m
//  Bestaurant
//
//  Created by Ishaan Gulrajani on 11/10/12.
//  Copyright (c) 2012 Ishaan Gulrajani. All rights reserved.
//

#import "DataProvider.h"
#import "AFJSONRequestOperation.h"

#define AUTH_TOKEN @"a9778a4bd4ad67e179d72937819e6776e2434bc7"

@implementation DataProvider
static DataProvider *sharedInstance = nil;

-(id)init {
    self = [super init];
    if(self) {
        likes = [NSMutableArray arrayWithContentsOfFile:[self pathForFilename:@"likes.plist"]];
        if(!likes)
            likes = [[NSMutableArray alloc] init];
        
        dislikes = [NSMutableArray arrayWithContentsOfFile:[self pathForFilename:@"dislikes.plist"]];
        if(!dislikes)
            dislikes = [[NSMutableArray alloc] init];
    }
    return self;
}

+(DataProvider *)shared {
    @synchronized(self) {
        if(!sharedInstance)
            sharedInstance = [[DataProvider alloc] init];
        
        return sharedInstance;
    }
}

//http://api.hunch.com/api/v1/get-results/?auth_token=a9778a4bd4ad67e179d72937819e6776e2434bc7&lat=40&lng=50&radius=10

// http://api.hunch.com/api/v1/get-results?query=WHATEVER&topic_ids=list_restaurant
// query parameter can be nil
-(void)itemsForLatitude:(double)latitude longitude:(double)longitude query:(NSString *)query callback:(void(^)(NSArray *items))callback {
    
    if(query)
        currentQuery = query;
    NSString *query_str = (query ? [NSString stringWithFormat:@"query=%@&",[query stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] : @"");
    
    NSString *url_str = [NSString stringWithFormat:
                       @"http://api.hunch.com/api/v1/get-results?auth_token=%@&lat=%f&lng=%f&radius=10&%@topic_ids=list_restaurant",
                       AUTH_TOKEN,
                       latitude,
                       longitude,
                       query_str
                    ];
    
    NSLog(@"getting items, url: %@",url_str);
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url_str]];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        NSLog(@"received items: %@",JSON);
        
        if(!query || (currentQuery && [currentQuery isEqualToString:query]))
            callback(JSON[@"results"]);
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        NSLog(@"error getting items: %@", error.userInfo);
    }];
    [operation start];
}

-(void)savePreference:(BOOL)liked forItem:(NSString *)item_id {
    if (liked) {
        [likes addObject:item_id];
    }
    else{
        [dislikes addObject:item_id];
    }
    [likes writeToFile:[self pathForFilename:@"likes.plist"] atomically:YES];
    [dislikes writeToFile:[self pathForFilename:@"dislikes.plist"] atomically:YES];
}

//http://api.hunch.com/api/v1/get-recommendations/?auth_token=a9778a4bd4ad67e179d72937819e6776e2434bc7&lat=40.74&lng=-74&radius=10&likes=hn_217541&dislikes=hn_217545

-(void)recommendedItemsForLatitude:(double)latitude longitude:(double)longitude callback:(void(^)(NSArray *items))callback {
    NSString *url_str = [NSString stringWithFormat:
                         @"http://api.hunch.com/api/v1/get-recommendations?auth_token=%@&lat=%f&lng=%f&radius=30&likes=%@&dislikes=%@&topic_ids=list_restaurant",
                         AUTH_TOKEN,
                         latitude,
                         longitude,
                         [likes componentsJoinedByString:@","],
                         [dislikes componentsJoinedByString:@","]
                         ];
    
    
    NSLog(@"getting recommendations, url: %@",url_str);
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url_str]];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        NSLog(@"received recommendations: %@",JSON);
        callback(JSON[@"recommendations"]);
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        NSLog(@"error getting recommendations: %@", error.userInfo);
    }];
    [operation start];
}

-(NSString *)pathForFilename:(NSString *)filename {
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0] stringByAppendingPathComponent:filename];
}

@end