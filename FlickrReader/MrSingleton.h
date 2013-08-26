//
//  MrSingleton.h
//  GIFEngine
//
//  Created by alexchoi1 on 8/20/13.
//  Copyright (c) 2013 Good Time Games. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MrSingleton : NSObject
@property (strong, nonatomic) NSOperationQueue * operationQueue;
+ (MrSingleton *) sharedInstance;
- (void) describe;
@end
