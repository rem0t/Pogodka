//
//  Forecast.h
//  Pogodka
//
//  Created by Vladislav Kalaev on 24.02.17.
//  Copyright © 2017 Vladislav Kalaev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface Forcast : UIViewController <CLLocationManagerDelegate>


- (void) forecastCall;
- (void) cityNameMethod;
- (void) setLocation;

- (float) currentCel;
- (float) apperentCel;
- (float) currentHumidity;
- (float) currentPressure;
- (float) currentWind;


@property (nonatomic) CLLocationManager *locationManager;
@property (strong,nonatomic) NSString* currentLongitude;
@property (strong,nonatomic) NSString* currentLatitude;


@property(strong,nonatomic) NSString* locality;        // Город subLocality - Район subThoroughfare - проезд

@property (strong,nonatomic) NSString* humidity;
@property (strong,nonatomic) NSString* wind;
@property (strong,nonatomic) NSString* pressure;
@property (strong,nonatomic) NSString* city;
@property (strong,nonatomic) NSString* currentTemp;
@property (strong,nonatomic) NSString* currentTemp1;
@property (strong,nonatomic) NSString* currentAperentTemp;
@property (strong,nonatomic) NSNumber* time;
@property (strong,nonatomic) NSString* iconName;


@property (strong,nonatomic) NSArray* jsontime;
@property (strong,nonatomic) NSArray* jsontemp;
@property (strong,nonatomic) NSArray* jsonIcon;



@end
