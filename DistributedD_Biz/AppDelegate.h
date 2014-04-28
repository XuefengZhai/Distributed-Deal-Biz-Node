//
//  AppDelegate.h
//  DistributedD_Biz
//
//  Created by XZhai on 4/24/14.
//  Copyright (c) 2014 XZhai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AsyncSocket.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate, AsyncSocketDelegate>{
    AsyncSocket *clientSocket;
    AsyncSocket *socketServer;
}

@property (strong, nonatomic) UIWindow *window;



@end
