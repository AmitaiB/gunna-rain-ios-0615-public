//
//  FISViewController.h
//  gunnaRain
//
//  Created by Joe Burgess on 6/27/14.
//  Copyright (c) 2014 Joe Burgess. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <Forecastr.h>

@interface FISViewController : UIViewController <CLLocationManagerDelegate>
@property (strong, nonatomic) IBOutlet UILabel *weatherStatus;
@end
