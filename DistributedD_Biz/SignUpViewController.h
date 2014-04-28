//
//  SignUpViewController.h
//  DistributedD
//
//  Created by XZhai on 4/9/14.
//  Copyright (c) 2014 XZhai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>



@interface SignUpViewController : UIViewController  <CLLocationManagerDelegate>
{
    IBOutlet UITextField *email;
    IBOutlet UITextField *name;
    IBOutlet UITextField *psw;
    IBOutlet UITextField *age;
    IBOutlet UIButton *confirm;
    CLLocationManager *lm;
}

@property (nonatomic, retain) IBOutlet UIButton *confirm;

@property (nonatomic, retain) IBOutlet UITextField *email;
@property (nonatomic, retain) IBOutlet UITextField *psw;
@property (nonatomic, retain) IBOutlet UITextField *name;
@property (nonatomic, retain) IBOutlet UITextField *age;

- (IBAction)emailTextField_DidEndOnExit:(id)sender;
- (IBAction)pswTextField_DidEndOnExit:(id)sender;
- (IBAction)nameTextField_DidEndOnExit:(id)sender;
- (IBAction)ageTextField_DidEndOnExit:(id)sender;
- (IBAction)confirmButton:(id)sender;
- (IBAction)View_TouchDown:(id)sender;

- (void) locationManager: (CLLocationManager *) manager
     didUpdateToLocation: (CLLocation *) newLocation
            fromLocation: (CLLocation *) oldLocation;

- (void) locationManager: (CLLocationManager *) manager
        didFailWithError: (NSError *) error;



@end
