//
//  OptionsViewController.h
//  GIFEngine
//
//  Created by Andres Castillo on 8/25/13.
//  Copyright (c) 2013 Good Time Games. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OptionsViewController.h"
#import <Social/Social.h>
#import <Accounts/Accounts.h>
#import "UIImage+animatedGIF.h"
#import "GiphyPhoto.h"
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>

@interface OptionsViewController : UIViewController <MFMailComposeViewControllerDelegate>



@property(strong,nonatomic)GiphyPhoto * incomingImage;


@end
