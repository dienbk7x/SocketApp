//
//  DetailsViewController.h
//  SocketApp
//
//  Created by Darren Mason on 8/16/14.
//  Copyright (c) 2014 bitcows. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailsViewController : UIViewController
{

}
@property (weak, nonatomic) IBOutlet UITextView *serverMessages;

- (IBAction)done:(id)sender;

@end
