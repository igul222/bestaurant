//
//  DataProvider.h
//  Bestaurant
//
//  Created by Ishaan Gulrajani on 11/10/12.
//  Copyright (c) 2012 Ishaan Gulrajani. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataProvider : NSObject

+(DataProvider *)shared;

-(NSArray *)itemsForLatitude:(double)latitude longitude:(double)longitude;
-(void)savePreference:(BOOL)liked forItem:(NSString *)itemID;
-(NSArray *)recommendedItemsForLatitude:(double)latitude longitude:(double)longitude;

@end
