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
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) Forecastr *forcastManager;
@property (nonatomic, strong) NSString *longtitude;
@property (nonatomic, strong) NSString *latitude;
@property (nonatomic, strong) NSDictionary *weatherDictionary;


@end

@implementation FISViewController {
    CLLocationManager *locationManager;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    Forecastr *forecastManager = [Forecastr sharedManager];
    forecastManager.apiKey = @"494b30eb0b57eaa2ea9124eb3dede8c4";

    
    
	// Do any additional setup after loading the view, typically from a nib.
    locationManager = [[CLLocationManager alloc] init];
}

-(void)viewDidAppear:(BOOL)animated {
    [self getLocation];
    
    NSLog(@"%@, %@", self.latitude, self.longtitude);
    [self.forcastManager getForecastForLatitude:[self.latitude integerValue]
                                      longitude:[self.longtitude integerValue]
                                           time:nil
                                     exclusions:nil
                                         extend:nil
                                        success:^(id JSON) {
                                            self.weatherDictionary = JSON[@"currently"];
                                        } failure:^(NSError *error, id response) {
                                            NSLog(@"Error while retrieving forecast: %@", [self.forcastManager messageForError:error withResponse:response]);
                                        }];
}

-(void)getLocation {
    //Create the location manager (only) in case the object
    //does not already have one.
    //This will prepare the 'recepticle' for the location info.
    if (nil == _locationManager) {
        _locationManager = [[CLLocationManager alloc] init];
    }
    self.locationManager.delegate = self;
    
    //This will secure the Authorization to get the location info.
    [self safeRequestForWhenInUseAuth];
    
    [locationManager startUpdatingLocation];
    [NSThread sleepForTimeInterval:1];

    self.latitude = [NSString stringWithFormat:@"%+.6f", self.locationManager.location.coordinate.latitude];
    self.longtitude = [NSString stringWithFormat:@"%+.6f", self.locationManager.location.coordinate.longitude];
}

//Thanks to Jordan Gugges for finding this snippet online
-(void) safeRequestForWhenInUseAuth {
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    
    if (status == kCLAuthorizationStatusDenied ||
        status == kCLAuthorizationStatusRestricted ||
        status == kCLAuthorizationStatusRestricted ||
        status == kCLAuthorizationStatusNotDetermined) {
        
        NSString *title;
        
        title = (status == kCLAuthorizationStatusDenied ||
                 status == kCLAuthorizationStatusRestricted)? @"Location Services Are Off" : @"Background use is not enabled";
        
        NSString *message = @"Go to settings";
        
        UIAlertController *settingsAlert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *goToSettings = [UIAlertAction actionWithTitle:@"Settings" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            NSURL *settingsURL = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
            
            [[UIApplication sharedApplication]openURL:settingsURL];
        }];
        
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
        
        [settingsAlert addAction:goToSettings];
        [settingsAlert addAction:cancel];
        
        [self presentViewController:settingsAlert animated:YES completion:nil];
    
    } else if (status == kCLAuthorizationStatusNotDetermined) {
        [self.locationManager requestWhenInUseAuthorization];
    }
}

    


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)updateWeatherStatusLabel
{
    if ((NSInteger)self.weatherDictionary[@"precipProbability"] != 1) {
        self.weatherStatus.text = @"Nope";
    } else {
        self.weatherStatus.text = @"Yep";
    }
}



#pragma mark - CLLocationManagerDelegate

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"didFailWithError: %@", error);
    UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:@"DON'T PANIC :-)" message:@"But there was an ERROR: we failed to get your location." delegate:nil cancelButtonTitle:@"Uh, ok..." otherButtonTitles:nil];
    
    [errorAlert show];
}


@end
