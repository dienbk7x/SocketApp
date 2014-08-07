//
//  ViewController.m
//  SocketApp
//
//  Created by Darren Mason on 8/4/14.
//  Copyright (c) 2014 bitcows. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    
    _lightToggle.selectedSegmentIndex = 1;
}

- (void)viewDidAppear:(BOOL)animated{
    [self initNetworkCommunication];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initNetworkCommunication {
    CFReadStreamRef readStream;
    CFWriteStreamRef writeStream;
    CFStreamCreatePairWithSocketToHost(NULL, (CFStringRef)@"192.168.0.117", 7777, &readStream, &writeStream);
    _inputStream = (NSInputStream *)CFBridgingRelease(readStream);
    _outputStream = (NSOutputStream *)CFBridgingRelease(writeStream);
    
    [_inputStream setDelegate:self];
	[_outputStream setDelegate:self];
    
    [_inputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
	[_outputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    
    [_inputStream open];
	[_outputStream open];
    
}

- (IBAction)ToggleLight:(id)sender {
    
    UISegmentedControl *button = ((UISegmentedControl*)sender);
    long tag = button.tag;
    
	NSString *response  = [NSString stringWithFormat:@"P%ld%@", tag , button.selectedSegmentIndex?@"H" : @"L"];
	NSData *data = [[NSData alloc] initWithData:[response dataUsingEncoding:NSASCIIStringEncoding]];
    [_outputStream write:[data bytes] maxLength:[data length]];
    
}

- (IBAction)shutdown:(id)sender {

	NSData *data = [[NSData alloc] initWithData:[@"shutdown" dataUsingEncoding:NSASCIIStringEncoding]];
    [_outputStream write:[data bytes] maxLength:[data length]];
    
}

- (IBAction)reboot:(id)sender {
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"REBOOT?" message:@"Are you sure you want to reboot?" delegate:self cancelButtonTitle:@"OH.. Hell No!" otherButtonTitles:@"I said REBOOT!", nil];
    
    [alert show];

}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if(buttonIndex == 1){
        
        NSData *data = [[NSData alloc] initWithData:[@"reboot" dataUsingEncoding:NSASCIIStringEncoding]];
        [_outputStream write:[data bytes] maxLength:[data length]];
        NSLog(@"YES %@",data);
    }
}

- (IBAction)reset:(id)sender {
    [self initNetworkCommunication];
}

@end
