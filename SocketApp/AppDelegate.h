//
//  AppDelegate.h
//  SocketApp
//
//  Created by Darren Mason on 8/4/14.
//  Copyright (c) 2014 bitcows. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate,NSStreamDelegate>

@property (strong, nonatomic) UIWindow *window;

- (void)initNetworkCommunication;

@property (nonatomic, retain) NSInputStream *inputStream;
@property (nonatomic, retain) NSOutputStream *outputStream;
@property (weak, nonatomic) NSString *ipFieldHolder;


@end
