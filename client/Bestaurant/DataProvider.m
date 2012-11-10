//
//  DataProvider.m
//  Bestaurant
//
//  Created by Ishaan Gulrajani on 11/10/12.
//  Copyright (c) 2012 Ishaan Gulrajani. All rights reserved.
//

#import "DataProvider.h"

@implementation DataProvider
static DataProvider *sharedInstance = nil;

+(DataProvider *)shared {
    @synchronized(self) {
        if(!sharedInstance)
            sharedInstance = [[DataProvider alloc] init];
        
        return sharedInstance;
    }
}

-(NSArray *)itemsForLatitude:(double)latitude longitude:(double)longitude {
    return nil;
}

-(void)savePreference:(BOOL)liked forItem:(NSString *)itemID {
    
}

-(NSArray *)recommendedItemsForLatitude:(double)latitude longitude:(double)longitude {
    return nil;
}

@end