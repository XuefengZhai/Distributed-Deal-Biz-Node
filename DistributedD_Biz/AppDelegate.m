//
//  AppDelegate.m
//  DistributedD_Biz
//
//  Created by XZhai on 4/24/14.
//  Copyright (c) 2014 XZhai. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.

    socketServer = [[AsyncSocket alloc] initWithDelegate:self];
    
    NSError *error = nil;
    if (![socketServer acceptOnPort:8001 error:&error])
    {
		NSLog(@"Unable to listen to due to invalid configuration: %@", error);
	}
    NSLog(@"- Server is listening -");
    
    return YES;
}

#pragma SocketCommunication
- (void)onSocket:(AsyncSocket *)sock didAcceptNewSocket:(AsyncSocket *)newSocket
{
    NSLog(@"- A new client connected to the server -");
    clientSocket = newSocket;
    [clientSocket setDelegate:self];
    [clientSocket readDataWithTimeout:-1 tag:0];

}
- (void)onSocket:(AsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
{
	NSString *response = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"Client socket read data:  \n%@",response);
    
    //Send reply
    NSString *replyStr;
    if([response isEqualToString:@"getInfo"])
        replyStr = @"Name:Business1, SomeOtherInfo:ROFL";
    else if([response isEqualToString:@"getDeals"])
        replyStr = @"Name:Deal1, Desc:Description1";
    else if([response isEqualToString:@"subscribe"])
        replyStr = @"Subscription:OK";
    else
        replyStr = @"Bad Request";
    NSData *replyData = [replyStr dataUsingEncoding:NSUTF8StringEncoding];
    [clientSocket writeData:replyData withTimeout:-1 tag:0];
    
    //Read again
    [clientSocket readDataWithTimeout:-1 tag:0];
}

#pragma AppLife-cycle
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
