//
//  SignUpViewController.m
//  DistributedD
//
//  Created by XZhai on 4/9/14.
//  Copyright (c) 2014 XZhai. All rights reserved.
//

#import "SignUpViewController.h"

@interface SignUpViewController ()
{
    NSString *lat,*lng;
    
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
    NSString *urlFinal = [NSString stringWithFormat:
                          @"%@Email=%@&Psw=%@&Name=%@&Disc=%@&Location=%@+%@",
                          urlBaseString,emailText,pswText,nameText,ageText,lat,lng];
    
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
