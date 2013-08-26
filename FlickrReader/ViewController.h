//
//  ViewController.h
//  GiphyReader
//
//  Created by alexchoi1 on 8/10/13.
//  Copyright (c) 2013 Good Time Games. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Giphy.h"
#import "GiphyPhoto.h"
#import "GiphyPhotoCell.h"



@interface ViewController : UIViewController <UISearchBarDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>


@property(nonatomic, strong) Giphy * giphy;
@property (nonatomic, strong) NSMutableArray * searchResults; //processed results from giphy api manager
@property (nonatomic, strong) NSString * searchTerm;
@property int searchOffset;

@property (strong, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;




@end
