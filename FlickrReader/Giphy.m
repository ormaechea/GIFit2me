//
//  Giphy.m
//  Giphy Search
//
//  Created by alexchoi1 on 8/10/13.
//  Copyright (c) 2013 Good Time Games. All rights reserved.
//

#import "Giphy.h"
#define kGiphyAPIKey @"moVVtNDUEHbe8"

@implementation Giphy
@synthesize fullResultsArray, processedResultsArray;

- (id) init
{
    self = [super init];
    if (self)
    {
        
    }
    return self;
}


/*
 ///returns size of photo in url - modify or remove - remove probably since i can demand whatever size i want
 + (NSString *)flickrPhotoURLForFlickrPhoto:(FlickrPhoto *) flickrPhoto size:(NSString *) size
 {
 if(!size)
 {
 size = @"m";
 }
 return [NSString stringWithFormat:@"http://farm%d.staticflickr.com/%d/%lld_%@_%@.jpg",flickrPhoto.farm,flickrPhoto.server,flickrPhoto.photoID,flickrPhoto.secret,size];
 }
 */



///transforms input search term into output URL
+ (NSString *)giphySearchURLForSearchTerm:(NSString *) searchTerm withOffset: (int) offset
{
    ///deal with offsets and limits later
    
    int limit = 10;
    searchTerm = [searchTerm stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    return [NSString stringWithFormat:@"http://api.giphy.com/v1/gifs/search?q=%@&api_key=%@&offset=%i&limit=%i",searchTerm, kGiphyAPIKey, offset,limit];
}

- (void)searchGiphyForTerm:(NSString *) searchTerm withOffset: (int) offset completionBlock:(GiphySearchCompletionBlock) completionBlock
{
    
    NSString *searchURLString = [Giphy giphySearchURLForSearchTerm:searchTerm withOffset:offset];
    ////subbed in nsurlconnection, nsoperationqueue, and nsurlcache. enable time out, caching, operation queue abstraction, and who knows what else!
    NSURL * searchURL = [NSURL URLWithString:searchURLString];
    NSURLRequest * searchRequest = [NSURLRequest requestWithURL:searchURL cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    [NSURLConnection sendAsynchronousRequest:searchRequest queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * searchResponse, NSData * searchData, NSError * searchError)
     {
         if (searchError != nil) {
             completionBlock(searchTerm,nil,searchError);
         }
         else
         {
             NSDictionary *searchResultsDict = [NSJSONSerialization JSONObjectWithData:searchData
                                                                               options:kNilOptions
                                                                                 error:&searchError];
             NSLog(@"json received");
             ///passes error to block
             if(searchError != nil)
             {
                 completionBlock(searchTerm,nil,searchError);
             }
             else
             {
                 fullResultsArray = searchResultsDict[@"data"];
                 NSMutableArray *imageArray = [@[] mutableCopy];
                 
                 [fullResultsArray enumerateObjectsUsingBlock:^(NSDictionary *objDictionary, NSUInteger idx, BOOL *stop)
                  {
                      GiphyPhoto * photo = [[GiphyPhoto alloc] initWithDataDictionary:objDictionary];
                      photo.photoNumber = idx;
                      
                      [imageArray addObject:photo];
                  }];
                 NSLog(@"%@", [imageArray description]);
                 completionBlock(searchTerm,imageArray,nil);
                 NSLog(@"searchgiphyforterm completion block passed");
             }
         }
     }];
}





////old code that uses gcd and other old lower level connection stuffs
/*
 dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
 
 dispatch_async(queue, ^{
 NSError *error = nil;
 NSString *searchResultString = [NSString stringWithContentsOfURL:[NSURL URLWithString:searchURL]
 encoding:NSUTF8StringEncoding
 error:&error];
 if (error != nil) {
 completionBlock(searchTerm,nil,error);
 }
 else
 {
 
 NSData *jsonData = [searchResultString dataUsingEncoding:NSUTF8StringEncoding];
 NSDictionary *searchResultsDict = [NSJSONSerialization JSONObjectWithData:jsonData
 options:kNilOptions
 error:&error];
 NSLog(@"search sent");
 ///passes error to block
 if(error != nil)
 {
 completionBlock(searchTerm,nil,error);
 }
 else
 
 ///for now, request is for 10 items only. return 10 items. later:
 ///factor out processing of fullResultsArray
 /// replace with call to processing, include processedResultsArray
 
 
 {
 fullResultsArray = searchResultsDict[@"data"];
 NSMutableArray *imageArray = [@[] mutableCopy];
 
 [fullResultsArray enumerateObjectsUsingBlock:^(NSDictionary *objDictionary, NSUInteger idx, BOOL *stop)
 {
 GiphyPhoto * photo = [[GiphyPhoto alloc] initWithDataDictionary:objDictionary];
 photo.photoNumber = idx;
 
 [imageArray addObject:photo];
 }];
 completionBlock(searchTerm,imageArray,nil);
 NSLog(@"searchgiphyforterm completion block passed");
 }
 
 }
 });
 */






/// as far as i can see this is never called
+ (void)loadImageForPhoto:(GiphyPhoto *)giphyPhoto thumbnail:(BOOL)thumbnail completionBlock:(GiphyPhotoCompletionBlock) completionBlock
{
    NSLog(@"loadimageforphoto, does this ever get called?");
    NSString *size = thumbnail ? @"m" : @"b";
    
    NSString *searchURL = [Giphy giphyPhotoURLForGiphyPhoto:giphyPhoto size:size];
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    dispatch_async(queue, ^{
        NSError *error = nil;
        
        NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:searchURL]
                                                  options:0
                                                    error:&error];
        if(error)
        {
            completionBlock(nil,error);
        }
        else
        {
            UIImage *image = [UIImage imageWithData:imageData];
            if([size isEqualToString:@"m"])
            {
                giphyPhoto.fixedWidthImage = image;
            }
            else
            {
                giphyPhoto.originalSizeImage = image;
            }
            completionBlock(image,nil);
        }
        
    });
    
}

@end
