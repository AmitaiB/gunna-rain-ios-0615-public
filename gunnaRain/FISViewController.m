//
//  FISViewController.m
//  gunnaRain
//
//  Created by Joe Burgess on 6/27/14.
//  Copyright (c) 2014 Joe Burgess. All rights reserved.
//

#import "FISViewController.h"

@interface FISViewController ()
@property (nonatomic) BOOL isRaining;
@property (weak, nonatomic) IBOutlet UITextField *latitudeField;
@property (weak, nonatomic) IBOutlet UITextField *longitudeField;
- (IBAction)getMyLocationButtonTapped:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *staticLatitudeLabel;
@property (weak, nonatomic) IBOutlet UILabel *staticLongitudeLabel;
@property (weak, nonatomic) IBOutlet UILabel *currentLatitudeLabel;
@property (weak, nonatomic) IBOutlet UILabel *currentLongitudeLabel;

@end

@implementation FISViewController {
    CLLocationManager *locationManager;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

	// Do any additional setup after loading the view, typically from a nib.
    locationManager = [[CLLocationManager alloc] init];
    self.staticLatitudeLabel.text = @"for Latitude:";
    self.staticLongitudeLabel.text = @"for Longitude:";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)getMyLocationButtonTapped:(id)sender {
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    [locationManager requestWhenInUseAuthorization];
    
    [locationManager startUpdatingLocation];
    
    self.latitudeField.hidden = YES;
    self.longitudeField.hidden = YES;
    
}


#pragma mark - CLLocationManagerDelegate

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"didFailWithError: %@", error);
    UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:@"DON'T PANIC :-)" message:@"But there was an ERROR: we failed to get your location." delegate:nil cancelButtonTitle:@"Uh, ok..." otherButtonTitles:nil];
    
    [errorAlert show];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLLocation *currentLocation = [[CLLocation alloc] init];
    
    if (self.longitudeField.text != nil && self.latitudeField != nil) {
        CLLocationDegrees inputLat = [self.latitudeField.text integerValue];
        CLLocationDegrees inputLng = [self.longitudeField.text integerValue];
        
        currentLocation = [[CLLocation alloc] initWithLatitude:inputLat longitude:inputLng];
    } else {
        currentLocation = [locations lastObject];
    }
    
    NSLog(@"didUpdateLocations --> [locations lastObject]: %@", currentLocation);
    
    
    if (currentLocation != nil) {
        self.currentLongitudeLabel.text = [NSString stringWithFormat:@"%.8f", currentLocation.coordinate.longitude];
        self.currentLatitudeLabel.text = [NSString stringWithFormat:@"%.8f", currentLocation.coordinate.latitude];
    }
    

}

@end
