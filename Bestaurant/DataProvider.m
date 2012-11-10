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
        likes = [NSArray arrayWithContentsOfFile:[self pathForFilename:@"likes.plist"]];
        if(!likes)
            likes = [[NSArray alloc] init];
        
        dislikes = [NSArray arrayWithContentsOfFile:[self pathForFilename:@"dislikes.plist"]];
        if(!dislikes)
            dislikes = [[NSArray alloc] init];
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
    NSString *authToken= [@"auth_token=" stringByAppendingString:AUTH_TOKEN];
    NSString *lat= [@"lat=" stringByAppendingFormat:@"%f",latitude];
    NSString *lng= [@"lng=" stringByAppendingFormat:@"%f",longitude];
    NSString *rad= @"radius=10";
    NSString *que=[@"query=" stringByAppendingFormat:@"%@", [query stringByReplacingOccurrencesOfString:@" " withString: @"+"]];
    NSString *topic=@"topic_id=list_restaurants";
    NSArray *params=[NSArray arrayWithObjects:authToken,lat,lng, rad, que, topic, nil];
    NSString *base=@"http://api.hunch.com/api/v1/";
    NSString *method=@"get-results/?";
    NSString *unEscapedUrl = [base stringByAppendingFormat:@"%@/%@", method, [params componentsJoinedByString:@"&"]];
    
    NSString* escapedUrl = [unEscapedUrl
                            stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:escapedUrl];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {

        // you might need to process json to be in some good format or whatever instead of just using it. idk.
        callback(JSON);

    } failure:nil];
    [operation start];

    callback( @[@{@"name": @"Le Bec Fin", @"id": @"k8J(#kIhusdf8w9hrf3e", @"image": @"http://lorempixel.com/500/500/"}] );
    
}

-(void)savePreference:(BOOL)liked forItem:(NSString *)itemID {
    [likes writeToFile:[self pathForFilename:@"likes.plist"] atomically:YES];
    [dislikes writeToFile:[self pathForFilename:@"dislikes.plist"] atomically:YES];
}

//http://api.hunch.com/api/v1/get-recommendations/?auth_token=a9778a4bd4ad67e179d72937819e6776e2434bc7&lat=40.74&lng=-74&radius=10&likes=hn_217541&dislikes=hn_217545

-(void)recommendedItemsForLatitude:(double)latitude longitude:(double)longitude callback:(void(^)(NSArray *items))callback {
    callback( @[@{@"name": @"Good Recommendation", @"id": @"k8J(#kIhusdf8w9hrf3e", @"image": @"http://lorempixel.com/500/500/"}] );
}

-(NSString *)pathForFilename:(NSString *)filename {
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0] stringByAppendingPathComponent:filename];
}

@end