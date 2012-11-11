//
//  DataProvider.h
//  Bestaurant
//
//  Created by Ishaan Gulrajani on 11/10/12.
//  Copyright (c) 2012 Ishaan Gulrajani. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataProvider : NSObject {
    NSMutableArray *likes;
    NSMutableArray *dislikes;
    NSString *currentQuery;
}

+(DataProvider *)shared;

-(void)itemsForLatitude:(double)latitude longitude:(double)longitude query:(NSString *)query callback:(void(^)(NSArray *items))callback;
-(void)savePreference:(BOOL)liked forItem:(NSString *)itemID;
-(void)recommendedItemsForLatitude:(double)latitude longitude:(double)longitude callback:(void(^)(NSArray *items))callback;


@end
