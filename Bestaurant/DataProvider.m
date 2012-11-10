//
//  DataProvider.m
//  Bestaurant
//
//  Created by Ishaan Gulrajani on 11/10/12.
//  Copyright (c) 2012 Ishaan Gulrajani. All rights reserved.
//

#import "DataProvider.h"
#import "AFJSONRequestOperation.h"

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


// http://api.hunch.com/api/v1/get-results?query=WHATEVER&topic_ids=list_restaurant
// query parameter can be nil
-(void)itemsForLatitude:(double)latitude longitude:(double)longitude query:(NSString *)query callback:(void(^)(NSArray *items))callback {
    
//    NSURL *url = [NSURL URLWithString:@"https://whatever..."];
//    NSURLRequest *request = [NSURLRequest requestWithURL:url];
//    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
//        
//        // you might need to process json to be in some good format or whatever instead of just using it. idk.
//        callback(JSON);
//        
//    } failure:nil];
//    [operation start];

    callback( @[@{@"name": @"Le Bec Fin", @"id": @"k8J(#kIhusdf8w9hrf3e", @"image": @"http://lorempixel.com/500/500/"}] );
    
}

-(void)savePreference:(BOOL)liked forItem:(NSString *)itemID {
    [likes writeToFile:[self pathForFilename:@"likes.plist"] atomically:YES];
    [dislikes writeToFile:[self pathForFilename:@"dislikes.plist"] atomically:YES];
}

-(void)recommendedItemsForLatitude:(double)latitude longitude:(double)longitude callback:(void(^)(NSArray *items))callback {
    callback( @[@{@"name": @"Good Recommendation", @"id": @"k8J(#kIhusdf8w9hrf3e", @"image": @"http://lorempixel.com/500/500/"}] );
}

-(NSString *)pathForFilename:(NSString *)filename {
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0] stringByAppendingPathComponent:filename];
}

@end