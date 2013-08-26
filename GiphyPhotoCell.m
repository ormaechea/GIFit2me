//
//  GiphyPhotoCell.m
//  GiphyReader
//
//  Created by alexchoi1 on 8/10/13.
//  Copyright (c) 2013 Good Time Games. All rights reserved.
//

#import "GiphyPhotoCell.h"
#import "GiphyPhoto.h"



@implementation GiphyPhotoCell
@synthesize imageView, photo;


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.imageView.frame = CGRectMake(0, 0, 200, 200);
        NSLog(@"giphyphotocellinitframe");
    }
    return self;
}
///inits with coder
-(id) initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
       self.imageView.frame = CGRectMake(0, 0, 200, 200);
    }
    return self;
}
/*

-(void) setPhoto:(GiphyPhoto *)vphoto {
    
    if(photo != vphoto) {
        photo = vphoto;
    }
    self.imageView.image = photo.fixedWidthImage;
}
*/




/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
