//
//  SignUpViewController.m
//  DistributedD
//
//  Created by XZhai on 4/9/14.
//  Copyright (c) 2014 XZhai. All rights reserved.
//

#import "SignUpViewController.h"

#include <ifaddrs.h>
#include <arpa/inet.h>
#include <net/if.h>

#define IOS_CELLULAR    @"pdp_ip0"
#define IOS_WIFI        @"en0"
#define IP_ADDR_IPv4    @"ipv4"
#define IP_ADDR_IPv6    @"ipv6"


@interface SignUpViewController ()
{
    NSString *lat,*lng;
    NSString *IPAdd;
    
}

@end

@implementation SignUpViewController

@synthesize email,psw,name,age;
@synthesize confirm;


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
    
    
    lm = [[CLLocationManager alloc] init];
    if ([CLLocationManager locationServicesEnabled]) {
        lm.delegate = self;
        lm.desiredAccuracy = kCLLocationAccuracyBest;
        lm.distanceFilter = 1000.0f;
        [lm startUpdatingLocation];
     
    }
    

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)View_TouchDown:(id)sender {
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
}// Hide keyboard when touch the screen


- (IBAction)emailTextField_DidEndOnExit:(id)sender {
    [self.psw becomeFirstResponder];
}

- (IBAction)pswTextField_DidEndOnExit:(id)sender {
    [self.name becomeFirstResponder];
}

- (IBAction)nameTextField_DidEndOnExit:(id)sender {
    [self.age becomeFirstResponder];
}


- (IBAction)ageTextField_DidEndOnExit:(id)sender {
    [sender resignFirstResponder];
    [self.confirm sendActionsForControlEvents:UIControlEventTouchUpInside];
    
}

- (IBAction)confirmButton:(id)sender{
    
    NSString *urlBaseString = @"http://ec2-54-85-248-35.compute-1.amazonaws.com:8000/bsignup?";
    NSString *emailText =email.text;
    NSString *pswText = psw.text;
    NSString *nameText = name.text;
    NSString *ageText = age.text;
    IPAdd = [self getIPAddress:true];
    NSString *urlFinal = [NSString stringWithFormat:
                          @"%@Email=%@&Psw=%@&Name=%@&Disc=%@&Location=%@+%@&IP=%@",
                          urlBaseString,emailText,pswText,nameText,ageText,lat,lng,IPAdd];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:urlFinal]];
    
    [request setHTTPMethod:@"GET"];
    
    NSHTTPURLResponse *response = nil;
    
    [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];
    
    NSLog(@"%@",urlFinal);
    NSLog(@"%d",[response statusCode]);
    
    if ([response statusCode] == 200)
    {
        NSLog(@"!!!!!!!!!");
        NSLog(@"ButtonPressed");
        NSLog(@"%@",urlFinal);
        [self performSegueWithIdentifier:@"signUp" sender:self]; //Change the seque identifier
    }
    else if([response statusCode] == 404)
        
    {
        NSLog(@"!!!!!404!!!!!!");

        UIAlertView *wrongAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:[NSString stringWithFormat:@"User already exit"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [wrongAlert show];
        
    }
    

    
}


- (void) locationManager: (CLLocationManager *) manager
     didUpdateToLocation: (CLLocation *) newLocation
            fromLocation: (CLLocation *) oldLocation{
    lat = [[NSString alloc] initWithFormat:@"%g",
                     newLocation.coordinate.latitude];
    
    lng = [[NSString alloc] initWithFormat:@"%g",
                     newLocation.coordinate.longitude];
    
    NSLog(@"<%@,%@>",lat,lng);
}

    


- (void) locationManager: (CLLocationManager *) manager
        didFailWithError: (NSError *) error {
    NSString *msg = @"Error obtaining location";
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle:@"Error"
                          message:msg
                          delegate:nil
                          cancelButtonTitle: @"Done"
                          otherButtonTitles:nil];
    [alert show];
}

- (NSString *)getIPAddress:(BOOL)preferIPv4
{
    NSArray *searchArray = preferIPv4 ?
    @[ IOS_WIFI @"/" IP_ADDR_IPv4, IOS_WIFI @"/" IP_ADDR_IPv6, IOS_CELLULAR @"/" IP_ADDR_IPv4, IOS_CELLULAR @"/" IP_ADDR_IPv6 ] :
    @[ IOS_WIFI @"/" IP_ADDR_IPv6, IOS_WIFI @"/" IP_ADDR_IPv4, IOS_CELLULAR @"/" IP_ADDR_IPv6, IOS_CELLULAR @"/" IP_ADDR_IPv4 ] ;
    
    NSDictionary *addresses = [self getIPAddresses];
    //NSLog(@"addresses: %@", addresses);
    
    __block NSString *address;
    [searchArray enumerateObjectsUsingBlock:^(NSString *key, NSUInteger idx, BOOL *stop)
     {
         address = addresses[key];
         if(address) *stop = YES;
     } ];
    return address ? address : @"0.0.0.0";
}

- (NSDictionary *)getIPAddresses
{
    NSMutableDictionary *addresses = [NSMutableDictionary dictionaryWithCapacity:8];
    
    // retrieve the current interfaces - returns 0 on success
    struct ifaddrs *interfaces;
    if(!getifaddrs(&interfaces)) {
        // Loop through linked list of interfaces
        struct ifaddrs *interface;
        for(interface=interfaces; interface; interface=interface->ifa_next) {
            if(!(interface->ifa_flags & IFF_UP) || (interface->ifa_flags & IFF_LOOPBACK)) {
                continue; // deeply nested code harder to read
            }
            const struct sockaddr_in *addr = (const struct sockaddr_in*)interface->ifa_addr;
            if(addr && (addr->sin_family==AF_INET || addr->sin_family==AF_INET6)) {
                NSString *name = [NSString stringWithUTF8String:interface->ifa_name];
                char addrBuf[INET6_ADDRSTRLEN];
                if(inet_ntop(addr->sin_family, &addr->sin_addr, addrBuf, sizeof(addrBuf))) {
                    NSString *key = [NSString stringWithFormat:@"%@/%@", name, addr->sin_family == AF_INET ? IP_ADDR_IPv4 : IP_ADDR_IPv6];
                    addresses[key] = [NSString stringWithUTF8String:addrBuf];
                }
            }
        }
        // Free memory
        freeifaddrs(interfaces);
    }
    return [addresses count] ? addresses : nil;
}






/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
