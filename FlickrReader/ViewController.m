//
//  ViewController.m
//  GiphyReader
//
//  Created by alexchoi1 on 8/10/13.
//  Copyright (c) 2013 Good Time Games. All rights reserved.
//

#import "ViewController.h"
#import "MrSingleton.h"
#import "SWRevealViewController.h"
#import "OptionsViewController.h"
#import "UIBarButtonItem+FlatUI.h"
#import "UINavigationBar+FlatUI.h"
#import "UIColor+FlatUI.h"
#import "UIFont+FlatUI.h"

@interface ViewController ()
{
    __weak IBOutlet UICollectionView *oCollectionView;
    BOOL waitingForMoreResults;
    int loadedItems;
    int row;
}


@end

@implementation ViewController
@synthesize giphy, searchResults, searchOffset, searchTerm;
- (void)viewDidLoad
{
    [super viewDidLoad];
    searchResults = [@[] mutableCopy];
    giphy = [[Giphy alloc] init];
    searchOffset = 0;
    loadedItems = 0;
    waitingForMoreResults = NO;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cellImageDownloaded:) name:@"fixedWidthDownloaded" object:nil];
    
    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(-5.0, 0.0, 320.0, 44.0)];
    searchBar.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    UIView *searchBarView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 310.0, 44.0)];
    searchBarView.autoresizingMask = 0;
    searchBar.delegate = self;
    [searchBarView addSubview:searchBar];
    self.navigationItem.titleView = searchBarView;
    

    
    // Set the side bar button action. When it's tapped, it'll show up the sidebar.
_sidebarButton.target = self.revealViewController;
_sidebarButton.action = @selector(revealToggle:);
    
    // Set the gesture
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    
    [self.navigationController.navigationBar configureFlatNavigationBarWithColor:[UIColor peterRiverColor]];
    [self.navigationItem.leftBarButtonItem configureFlatButtonWithColor:[UIColor alizarinColor] highlightedColor:[UIColor pumpkinColor] cornerRadius:3];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    NSLog(@"MEMORY WARNING");
}

-(void) cellImageDownloaded: (NSNotification *) notification
{


    ///replaced photo notification with photo.number
   // GiphyPhoto * giphyPhoto = notification.object;
   // NSInteger photoNumber = giphyPhoto.photoNumber;
     NSInteger photoNumber = [notification.object integerValue];
    NSLog(@"downloaded photonumber %i. reloading item", photoNumber);
    loadedItems = loadedItems + 1;
    ///there's a bug in reloaditemsatindexpaths that crashes the app at low numbers. tracking the loaded items is a workaround.
    if (loadedItems < 2)
    {
        [oCollectionView reloadData];
    }
    else
        
    {
        NSIndexPath * indexPath = [NSIndexPath indexPathForRow:photoNumber inSection:0];
        [oCollectionView reloadItemsAtIndexPaths:@[indexPath]];
    }
}

#pragma mark UISearchBarDelegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    ///new search resets offset, resets results
    searchOffset = 0;
    searchResults = [@[] mutableCopy];
    [oCollectionView reloadData];
    searchTerm = searchBar.text;
    [self searchGiphyWithSearchTerm];
    [searchBar resignFirstResponder];
}

-(void) searchGiphyWithSearchTerm
{
    waitingForMoreResults = YES;
    [giphy searchGiphyForTerm:searchTerm withOffset:searchOffset completionBlock:^(NSString *searchTerm, NSArray *results, NSError *error)
     {
         if (results && results.count > 0)
         {
             [searchResults addObjectsFromArray:results];
             NSLog(@"%@", [searchResults description]);
             [oCollectionView reloadData];
         }
         else
         {
             NSLog(@"error searching giphy: %@", error.localizedDescription);
         }
         waitingForMoreResults = NO;
     }];
}

#pragma mark - UICollectionView Datasource

- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section
{
    return searchResults.count;
}

- (NSInteger)numberOfSectionsInCollectionView: (UICollectionView *)collectionView
{
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath
{

    GiphyPhotoCell *cell = [cv dequeueReusableCellWithReuseIdentifier:@"GiphyPhotoCell" forIndexPath:indexPath];
    //if (searchResults.count>0)
   // {
    GiphyPhoto * photo = [searchResults objectAtIndex:indexPath.row];
    cell.imageView.image = photo.fixedWidthImage;
    [cell.imageView sizeToFit];
  //  }
    return cell;
}

/*- (UICollectionReusableView *)collectionView:
 (UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
 {
 return [[UICollectionReusableView alloc] init];
 }*/

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    // TODO: Select Item
}
- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    row=indexPath.row;
    NSLog(@"HELLLOOO I AMMMM HERE   %i",indexPath.row);
    [self performSegueWithIdentifier:@"toOptionsView" sender:self];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    GiphyPhoto * photo = [searchResults objectAtIndex:row+1];
    OptionsViewController * optionsViewController= segue.destinationViewController;
    optionsViewController.incomingImage=photo;
}


#pragma mark – UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ///Asks the delegate for the size of the specified item’s cell.
    /// if zero size, uses 100,100 placeholder, otherwise, size of image.
    GiphyPhoto *photo =  [searchResults  objectAtIndex:indexPath.row];
    CGSize retval;
    if (photo.fixedWidthImage.size.width > 0)
    {
        retval = photo.fixedWidthImage.size;
    }
    else
    {
        retval = CGSizeMake(100,100);
    }
    
    retval.height += 0;
    retval.width += 0;
    return retval;
}


- (UIEdgeInsets)collectionView:
(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 0, 0, 0);
}


#pragma mark - ScrollViewDidScroll

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    CGPoint contentOffset = scrollView.contentOffset; // contentOffset is  the current location of the top-left corner of the scroll bounds
    CGRect bounds = scrollView.bounds; ///what you see at one time
    CGSize size = scrollView.contentSize; ///size of the scrollable content
    UIEdgeInsets inset = scrollView.contentInset; //buffer space. can be used to keep menus from interfering with content
    float y = contentOffset.y + bounds.size.height - inset.bottom; ///y coordinate of bottom of scrollview minus bottom inset. distance from bottom of content?
    float h = size.height; //height of the scrollable content
    
    float reload_distance = 25;
    if  (y > h + reload_distance) //if scrollview goes below 25 from bottom of content?
    {
        if(!waitingForMoreResults)
        {
            NSLog(@"trigger next offset request");
            searchOffset = searchOffset + 25;
            [self searchGiphyWithSearchTerm];
            NSLog(@"search giphy with next offset");
            
            
            ///expand collectionvinew and put in placeholders before images come in or put in loading icon thingy
            
            ///use boolean for telling when search is running if (y> h+ reload_distance && notLoading)??
            /// set notloading = no at beginning of method and to yes after block has run?
        }
        else
        {
            NSLog(@"isRequestingData already");
        }
    }
}


@end
