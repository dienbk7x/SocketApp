//
//  ViewController.h
//  SocketApp
//
//  Created by Darren Mason on 8/4/14.
//  Copyright (c) 2014 bitcows. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController<NSStreamDelegate,UIAlertViewDelegate>
{
    
}

@property (nonatomic, retain) NSInputStream *inputStream;
@property (nonatomic, retain) NSOutputStream *outputStream;
@property (weak, nonatomic) IBOutlet UISegmentedControl *lightToggle;
@property (weak, nonatomic) IBOutlet UIButton *logo;
@property (strong, nonatomic) IBOutlet UITextField *ipField;
@property (weak, nonatomic) NSString *ipFieldHolder;
@property (weak, nonatomic) IBOutlet UIView *ipView;

@property (weak, nonatomic) IBOutlet UILabel *serverMessages;

- (IBAction)ToggleLight:(id)sender;
- (IBAction)shutdown:(id)sender;
- (IBAction)reboot:(id)sender;
- (IBAction)reset:(id)sender;
- (IBAction)changeIP:(id)sender;
- (IBAction)iPSet:(id)sender;




@end
