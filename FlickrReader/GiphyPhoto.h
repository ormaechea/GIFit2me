//
//  GiphyPhoto.h
//  Giphy Search
//
//  Created by alexchoi1 on 8/10/13.
//  Copyright (c) 2013 Good Time Games. All rights reserved.
//


#import <Foundation/Foundation.h>


@interface GiphyPhoto : NSObject
@property(nonatomic,strong) UIImage *fixedWidthImage;
@property(nonatomic,strong) UIImage *originalSizeImage;
@property(nonatomic,strong) NSURL * fixedWidthImageURL;
@property(nonatomic,strong) NSURL * originalSizeImageURL;
@property(nonatomic,strong) NSData * imageData;
@property(nonatomic,strong) NSString * imageID;

@property  int photoNumber;

-(instancetype)initWithDataDictionary:(NSDictionary *)objDictionary;
-(void) setPropertiesWithDictionary: (NSDictionary *) objDictionary;


@end
