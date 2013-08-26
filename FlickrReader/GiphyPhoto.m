//
//  GiphyPhoto.m
//  Giphy Search
//
//  Created by alexchoi1 on 8/10/13.
//  Copyright (c) 2013 Good Time Games. All rights reserved.
//

#import "GiphyPhoto.h"
#import "UIImage+animatedGIF.h"
#import "MrSingleton.h"



@implementation GiphyPhoto

@synthesize fixedWidthImage, originalSizeImage, fixedWidthImageURL, originalSizeImageURL, photoNumber, imageData, imageID;


-(instancetype)initWithDataDictionary:(NSDictionary *)objDictionary {
    self = [super init];
    if (self)
    {
        NSLog(@"initwithdatadictionary");
        [self setPropertiesWithDictionary:objDictionary];
    }
    return self;
}

-(void) setPropertiesWithDictionary: (NSDictionary *) objDictionary
{
    imageID = objDictionary[@"id"];
    NSDictionary * imagesDictionary = objDictionary[@"images"];
    NSDictionary * fixedHeightDictionary = imagesDictionary[@"fixed_width"];
    NSDictionary * originalSizeDictionary = imagesDictionary[@"original"];
    
    NSString * fixedHeightURLString = fixedHeightDictionary[@"url"];
    fixedWidthImageURL = [NSURL URLWithString:fixedHeightURLString];
    NSString * originalSizeURLString = originalSizeDictionary[@"url"];
    originalSizeImageURL = [NSURL URLWithString:originalSizeURLString];
    
    NSMutableString * nyanCatPathString = [NSMutableString stringWithString: [[NSBundle mainBundle] resourcePath]];
    [nyanCatPathString appendString:@"/nyancat200x200.gif"];
    ///imageData property starts as placeholder nyan cat and default placeholder image uses this data
    imageData = [NSData dataWithContentsOfFile:nyanCatPathString];
    fixedWidthImage = [UIImage animatedImageWithAnimatedGIFData:imageData];
    [self replacePlaceholder];
}

-(void) replacePlaceholder
{
    /// on init, async request for actual animated gif begins. on successful completion, image is replaced and CVC is notified.
    //enabled caching via nsurlcache
    NSURLRequest * request = [NSURLRequest requestWithURL:fixedWidthImageURL cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    //moving block to mainqueue
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
    {
        if (data)
        {
            imageData = data;
            fixedWidthImage =  [UIImage animatedImageWithAnimatedGIFData:data];
             ///replace notification object with photonumber
            [[NSNotificationCenter defaultCenter] postNotificationName:@"fixedWidthDownloaded" object: [NSNumber numberWithInt:photoNumber ]];
        }
        else
        {
            NSLog(@"%@", error);
        }
    }];
}


@end
