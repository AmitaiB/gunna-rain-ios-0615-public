//
//  FISViewController.m
//  gunnaRain
//
//  Created by Joe Burgess on 6/27/14.
//  Copyright (c) 2014 Joe Burgess. All rights reserved.
//

#import "FISViewController.h"
#import <Forecastr.h>

@interface FISViewController ()
@property (nonatomic) BOOL isRaining;
@property (weak, nonatomic) IBOutlet UITextField *latitudeField;
@property (weak, nonatomic) IBOutlet UITextField *longitudeField;
- (IBAction)getMyLocationButtonTapped:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *staticLatitudeLabel;
@property (weak, nonatomic) IBOutlet UILabel *staticLongitudeLabel;
@property (weak, nonatomic) IBOutlet UILabel *currentLatitudeLabel;
@property (weak, nonatomic) IBOutlet UILabel *currentLongitudeLabel;
@property (nonatomic, strong) CLLocation *currentLocation;

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
    [NSThread sleepForTimeInterval:1];
//    self.latitudeField.hidden = YES;
//    self.longitudeField.hidden = YES;
    
    Forecastr *forecastManager = [Forecastr sharedManager];
    forecastManager.apiKey = @"494b30eb0b57eaa2ea9124eb3dede8c4";
    
    int degreesLat = (int)self.currentLocation.coordinate.latitude;
    int degreesLng = (int)self.currentLocation.coordinate.longitude;

    __block NSMutableDictionary *APIresponse = [@{} mutableCopy];
     [forecastManager getForecastForLatitude:degreesLat longitude:degreesLng time:nil exclusions:nil extend:nil success:^(id JSON) {
         NSLog(@"JSON Response was: %@", JSON);
         APIresponse = [JSON mutableCopy];
     } failure:^(NSError *error, id response) {
         NSLog(@"Error while retrieving forecast: ");
     }];
    
    NSNumber *precipProb = APIresponse[@"currently"][@"precipProbability"];
    
    self.isRaining = NO;

    if (precipProb.intValue == 1) {
        self.isRaining = YES;
    }
    
    if (self.isRaining) {
        self.weatherStatus.text = @"Yep";
    } else {
        self.weatherStatus.text = @"Nope";
    }
    
    
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
    self.currentLocation = [locations lastObject];
    NSLog(@"didUpdateLocations --> [locations lastObject]: %@", self.currentLocation);
    
    if (self.currentLocation != nil) {
        self.currentLongitudeLabel.text = [NSString stringWithFormat:@"%.8f", self.currentLocation.coordinate.longitude];
        self.currentLatitudeLabel.text = [NSString stringWithFormat:@"%.8f", self.currentLocation.coordinate.latitude];
    
    
    
    
    }

}

@end
