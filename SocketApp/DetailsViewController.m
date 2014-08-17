//
//  DetailsViewController.m
//  SocketApp
//
//  Created by Darren Mason on 8/16/14.
//  Copyright (c) 2014 bitcows. All rights reserved.
//

#import "DetailsViewController.h"
#import "AppDelegate.h"

@interface DetailsViewController ()
{
    AppDelegate *appDelegate;
}
@end

@implementation DetailsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [self setNeedsStatusBarAppearanceUpdate];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //register a notification for messages
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleUsersMessages:)
                                                 name:MESSAGES_FROM_SEVER_USERS
                                               object:nil];
    //register a notification for messages
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleTempMessages:)
                                                 name:MESSAGES_FROM_SEVER_TEMP
                                               object:nil];
    
    self.view.backgroundColor = [UIColor colorWithRed:(2/255.0f) green:(160/255.0f) blue:(224/255.0f) alpha:1];
    appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    NSData *data = [[NSData alloc] initWithData:[@"users" dataUsingEncoding:NSASCIIStringEncoding]];
    [appDelegate.outputStream write:[data bytes] maxLength:[data length]];

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSData *data = [[NSData alloc] initWithData:[@"temp" dataUsingEncoding:NSASCIIStringEncoding]];
        [appDelegate.outputStream write:[data bytes] maxLength:[data length]];
    });
    
    
    
    _serverMessages.layer.cornerRadius = 10;
    _serverTemp.layer.cornerRadius =10;
}

#pragma mark - Messages
-(void)handleUsersMessages:(NSNotification *) notification{
    
    [_serverMessages setText:notification.userInfo[@"message"]];
}
-(void)handleTempMessages:(NSNotification *) notification{
    
    [_serverTemp setText:notification.userInfo[@"message"]];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Actions

- (IBAction)done:(id)sender
{
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}
@end
