//
//  ViewController.m
//  SocketApp
//
//  Created by Darren Mason on 8/4/14.
//  Copyright (c) 2014 bitcows. All rights reserved.
//

#import "ViewController.h"
#import "AppDelegate.h"


@interface ViewController (){
    AppDelegate *appDelegate;
}

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    appDelegate.ipFieldHolder = @"192.168.0.119";
    
    [appDelegate initNetworkCommunication];

    //used so that when you minimize the app it inits the the network again.
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationEnteredForeground:)
                                                 name:UIApplicationWillEnterForegroundNotification
                                               object:nil];
    //register a notification for messages
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleMessages:)
                                                 name:MESSAGES_FROM_SEVER_STD
                                               object:nil];
    
    _lightToggle.selectedSegmentIndex = 1;
    
    
    _logo.layer.cornerRadius = _logo.frame.size.width / 2;
    _logo.clipsToBounds = YES;
    _logo.layer.borderColor = [[UIColor whiteColor] CGColor];
    _logo.layer.borderWidth = 6;
    
    self.view.backgroundColor = [UIColor colorWithRed:(2/255.0f) green:(160/255.0f) blue:(224/255.0f) alpha:1];
    _ipView.backgroundColor = self.view.backgroundColor;
}


//handles any messages posted
-(void)handleMessages:(NSNotification *) notification{

    [_serverMessages setText:notification.userInfo[@"message"]];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
}
- (BOOL)prefersStatusBarHidden
{
    return YES;
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
    
    [self setNeedsStatusBarAppearanceUpdate];
    appDelegate.ipFieldHolder = @"192.168.0.119";
    [_serverMessages setText:@""];
    [appDelegate initNetworkCommunication];
}
- (void)applicationEnteredForeground:(NSNotification *)notification {
    appDelegate.ipFieldHolder = @"192.168.0.119";
    [_serverMessages setText:@""];
    [appDelegate initNetworkCommunication];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)ToggleLight:(id)sender {
    
    @try {
        UISegmentedControl *button = ((UISegmentedControl*)sender);
        long tag = button.tag;
        
        NSString *response  = [NSString stringWithFormat:@"P%ld%@", tag , button.selectedSegmentIndex?@"H" : @"L"];
        NSData *data = [[NSData alloc] initWithData:[response dataUsingEncoding:NSASCIIStringEncoding]];
        [appDelegate.outputStream write:[data bytes] maxLength:[data length]];
    }
    @catch (NSException *exception) {
        NSLog(@"%@",[exception debugDescription]);
    }
}

- (IBAction)shutdown:(id)sender {

    @try {
        NSData *data = [[NSData alloc] initWithData:[@"shutdown" dataUsingEncoding:NSASCIIStringEncoding]];
        [appDelegate.outputStream write:[data bytes] maxLength:[data length]];
        
    }
    @catch (NSException *exception) {
        NSLog(@"%@",[exception debugDescription]);
    }

}

- (IBAction)reboot:(id)sender {
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"REBOOT?" message:@"Are you sure you want to reboot?" delegate:self cancelButtonTitle:@"OH.. No wait!" otherButtonTitles:@"Yes Reboot!", nil];
    
    [alert show];

}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if(buttonIndex == 1){
        
        NSData *data = [[NSData alloc] initWithData:[@"reboot" dataUsingEncoding:NSASCIIStringEncoding]];
        [appDelegate.outputStream write:[data bytes] maxLength:[data length]];
        NSLog(@"YES %@",data);
    }
}

- (IBAction)reset:(id)sender {
    [appDelegate initNetworkCommunication];
}

- (IBAction)changeIP:(id)sender {
    _ipField.text = appDelegate.ipFieldHolder;
    _ipField.keyboardType = UIKeyboardTypeDecimalPad;
    [_ipView setHidden:NO];
}

- (IBAction)iPSet:(id)sender {
    appDelegate.ipFieldHolder = _ipField.text;
    [appDelegate initNetworkCommunication];
    [self.view endEditing:YES];
    [_ipView setHidden:YES];
}

@end
