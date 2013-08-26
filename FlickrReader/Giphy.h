//
//  Giphy.h
//  Giphy Search
//
//  Created by alexchoi1 on 8/10/13.
//  Copyright (c) 2013 Good Time Games. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "GiphyPhoto.h"

@class GiphyPhoto;

typedef void (^GiphySearchCompletionBlock)(NSString *searchTerm, NSArray *results, NSError *error);
typedef void (^GiphyPhotoCompletionBlock)(UIImage *photoImage, NSError *error);

@interface Giphy : NSObject
@property(strong) NSString *apiKey;
@property int offset;
@property(strong,nonatomic) NSMutableArray * fullResultsArray; ///array of dictionaries from api
@property(strong,nonatomic) NSMutableArray * processedResultsArray; ///array of giphyphoto objects


- (void)searchGiphyForTerm:(NSString *) term withOffset:(int) offset completionBlock:(GiphySearchCompletionBlock) completionBlock;
+ (void)loadImageForPhoto:(GiphyPhoto *)giphyPhoto thumbnail:(BOOL)thumbnail completionBlock:(GiphyPhotoCompletionBlock) completionBlock;
+ (NSString *)giphyPhotoURLForGiphyPhoto:(GiphyPhoto *) flickrPhoto size:(NSString *) size;

@end
