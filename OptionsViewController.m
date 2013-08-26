//
//  OptionsViewController.m
//  GIFEngine
//
//  Created by Andres Castillo on 8/25/13.
//  Copyright (c) 2013 Good Time Games. All rights reserved.
//

#import "OptionsViewController.h"
#import <Social/Social.h>
#import <Accounts/Accounts.h>
#import "UIImage+animatedGIF.h"

@interface OptionsViewController ()
{
    
    IBOutlet UIImageView *imageView;
    IBOutlet UIButton *easyFacebookButton;
    IBOutlet UIButton *easyTwitterButton;
    IBOutlet UIButton *easyWeiboButton;
}
- (IBAction)facebook:(id)sender;
- (IBAction)twitter:(id)sender;
- (IBAction)weibo:(id)sender;
- (IBAction)mail:(id)sender;
- (IBAction)copyGif:(id)sender;

@end

@implementation OptionsViewController
@synthesize incomingImage;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated {
    
    imageView.image = incomingImage.fixedWidthImage;
    [super viewWillAppear:animated];

}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)facebook:(id)sender {
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]) {
        
        SLComposeViewController *mySLComposerSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
        
        [mySLComposerSheet setInitialText:@"TEXT"];
        
        //        [mySLComposerSheet addImage:[UIImage imageNamed:@"SHARK.gif"]];
        
        [mySLComposerSheet addURL:incomingImage.fixedWidthImageURL];
        
        
        [mySLComposerSheet setCompletionHandler:^(SLComposeViewControllerResult result) {
            
            switch (result) {
                case SLComposeViewControllerResultCancelled:
                    NSLog(@"Post Canceled");
                    break;
                case SLComposeViewControllerResultDone:
                    NSLog(@"Post Sucessful");
                    break;
                    
                default:
                    break;
            }
        }];
        
        [self presentViewController:mySLComposerSheet animated:YES completion:nil];
    }
}
- (IBAction)twitter:(id)sender {
    
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter]) {
        
        SLComposeViewController *mySLComposerSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
        
        [mySLComposerSheet setInitialText:@"TEXT"];
        
        //        [mySLComposerSheet addImage:[UIImage imageNamed:@"SHARK.gif"]];
        
        [mySLComposerSheet addURL:incomingImage.fixedWidthImageURL];
        
        [mySLComposerSheet setCompletionHandler:^(SLComposeViewControllerResult result) {
            
            switch (result) {
                case SLComposeViewControllerResultCancelled:
                    NSLog(@"Post Canceled");
                    break;
                case SLComposeViewControllerResultDone:
                    NSLog(@"Post Sucessful");
                    break;
                    
                default:
                    break;
            }
        }];
        
        [self presentViewController:mySLComposerSheet animated:YES completion:nil];
    }

}
- (IBAction)weibo:(id)sender {
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeSinaWeibo]) {
        
        SLComposeViewController *mySLComposerSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeSinaWeibo];
        
        [mySLComposerSheet setInitialText:@"TEXT"];
        
        //        [mySLComposerSheet addImage:[UIImage imageNamed:@"SHARK.gif"]];
        
        [mySLComposerSheet addURL:incomingImage.fixedWidthImageURL];
        
        [mySLComposerSheet setCompletionHandler:^(SLComposeViewControllerResult result) {
            
            switch (result) {
                case SLComposeViewControllerResultCancelled:
                    NSLog(@"Post Canceled");
                    break;
                case SLComposeViewControllerResultDone:
                    NSLog(@"Post Sucessful");
                    break;
                    
                default:
                    break;
            }
        }];
        
        [self presentViewController:mySLComposerSheet animated:YES completion:nil];
    }

}
- (IBAction)mail:(id)sender {
    
    if ([MFMailComposeViewController canSendMail])
    {
        MFMailComposeViewController *mailer = [[MFMailComposeViewController alloc] init];
        
        mailer.mailComposeDelegate = self;
        
        [mailer setSubject:@"Subject"];
        
        //        NSArray *toRecipients = [NSArray arrayWithObjects:@"fisrtMail@example.com", @"secondMail@example.com", nil];
        //        [mailer setToRecipients:toRecipients];
        //        NSMutableString * imagePathString = [NSMutableString stringWithString: [[NSBundle mainBundle] resourcePath]];
        //        [imagePathString appendString:incomingImage.fixedWidthImage];
        
        //        UIImage *myImage = incomingImage.fixedWidthImage;
        [mailer addAttachmentData:incomingImage.imageData mimeType:@"image/gif" fileName:@"AnimatedGif"];
        
        NSString *emailBody = @"MESSAGE HERE";
        [mailer setMessageBody:emailBody isHTML:NO];
        
        // only for iPad
        // mailer.modalPresentationStyle = UIModalPresentationPageSheet;
        
        [self presentViewController:mailer animated:YES completion:^{
            
        }];
    }
    else
    {  UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Failure"
                                                       message:@"Your device doesn't support the composer sheet"
                                                      delegate:nil
                                             cancelButtonTitle:@"OK"
                                             otherButtonTitles: nil];
        [alert show];
        
        
    }

}
- (IBAction)copyGif:(id)sender {
    UIPasteboard *pasteBoard=[UIPasteboard generalPasteboard];
    [pasteBoard setData:incomingImage.imageData forPasteboardType:@"public.png"];
}


- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:ACAccountStoreDidChangeNotification];
}
- (void)sharingStatus {
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]) {
        NSLog(@"service available");
        easyFacebookButton.enabled = YES;
        easyFacebookButton.alpha = 1.0f;
    } else {
        easyFacebookButton.enabled = NO;
        easyFacebookButton.alpha = 0.5f;
    }
    
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter]) {
        NSLog(@"service available");
        easyTwitterButton.enabled = YES;
        easyTwitterButton.alpha = 1.0f;
    }
    else {
        easyTwitterButton.enabled = NO;
        easyTwitterButton.alpha = 0.5f;
    }
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeSinaWeibo]) {
        NSLog(@"service available");
        easyWeiboButton.enabled = YES;
        easyWeiboButton.alpha = 1.0f;
    }
    else {
        easyWeiboButton.enabled = NO;
        easyWeiboButton.alpha = 0.5f;
    }
    
}

@end
