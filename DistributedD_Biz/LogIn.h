//
//  LogIn.h
//  DistributedD
//
//  Created by XZhai on 4/5/14.
//  Copyright (c) 2014 XZhai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>


@interface LogIn : UIViewController
{
    IBOutlet UITextField *email;
    IBOutlet UITextField *psw;
    IBOutlet UIButton *signUp;
    IBOutlet UIButton *signIn;
    CLLocationManager *lm;
}

@property (nonatomic, retain) IBOutlet UIButton *signIn;

@property (nonatomic, retain) IBOutlet UITextField *email;
@property (nonatomic, retain) IBOutlet UITextField *psw;

@property (nonatomic, retain) IBOutlet UIButton *signUp;

- (IBAction)TextField_DidEndOnExit:(id)sender;
- (IBAction)emailTextField_DidEndOnExit:(id)sender;
- (IBAction)pswTextField_DidEndOnExit:(id)sender;
- (IBAction)signInButton:(id)sender;
- (IBAction)View_TouchDown:(id)sender;

- (void) locationManager: (CLLocationManager *) manager
     didUpdateToLocation: (CLLocation *) newLocation
            fromLocation: (CLLocation *) oldLocation;

- (void) locationManager: (CLLocationManager *) manager
        didFailWithError: (NSError *) error;


@end
