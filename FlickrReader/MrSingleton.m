//
//  MrSingleton.m
//  GIFEngine
//
//  Created by alexchoi1 on 8/20/13.
//  Copyright (c) 2013 Good Time Games. All rights reserved.
//

#import "MrSingleton.h"

@implementation MrSingleton
@synthesize operationQueue;


static MrSingleton * mrSingleton;



+ (MrSingleton *) sharedInstance
{
    
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        mrSingleton = [[MrSingleton alloc] init];
    });
    
    
    return mrSingleton;
}

- (id) init
{
    self = [super init];
    
    if (self)
    {
        operationQueue =   [[NSOperationQueue alloc] init];
        NSLog(@"hi!  mr singleton here!");
    }
    return self;
}

- (void) describe
{
    NSLog(@"mr singleton %@", self);
}


@end
