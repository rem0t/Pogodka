//
//  Forecast.m
//  Pogodka
//
//  Created by Vladislav Kalaev on 24.02.17.
//  Copyright © 2017 Vladislav Kalaev. All rights reserved.
//


#import "Forcast.h"


@interface Forcast ()

@property (nonatomic) CLLocationManager *locationManager;
@property (strong,nonatomic) NSString* currentLongitude;
@property (strong,nonatomic) NSString* currentLatitude;


@end


static const NSString *apiKey = @"f032f3940de70aef8cb66eb16d389bd5";



@implementation Forcast



# pragma mark - Location -

- (void) setLocation
{
    
    if([CLLocationManager authorizationStatus] != kCLAuthorizationStatusDenied)
    {
        self.locationManager = [[CLLocationManager alloc] init];

        self.locationManager.delegate = self;

        [self.locationManager requestWhenInUseAuthorization];
        
        [self.locationManager startUpdatingLocation];
        
    }

}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"didFailWithError: %@", error);
    
    UIAlertController* alertError = [UIAlertController alertControllerWithTitle:@"ERROR" 
                                                                        message:NSLocalizedString(@"ERROR", nil)
                                                                 preferredStyle:UIAlertControllerStyleAlert];
    
    [self presentViewController:alertError animated:YES completion:nil];
}



- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations
{
    
    NSLog(@"didUpdateLocations");

    CLLocation *newLocation = locations[0];
    NSLog(@"didUpdateToLocation: %@", newLocation);
    CLLocation *currentLocation = newLocation;
    
    [self.locationManager stopUpdatingLocation];   // Disable future updates to save power.
    
    if (currentLocation != nil)
    {
        
        self.currentLongitude = [NSString stringWithFormat:@"%.8f", currentLocation.coordinate.longitude];
        self.currentLatitude = [NSString stringWithFormat:@"%.8f", currentLocation.coordinate.latitude];
        
        
       static dispatch_once_t onceToken; // вызываем метод один раз т.е. обращаемся за данными к серверу.
        dispatch_once(&onceToken, ^{
            
            [self weekWeatherForecastRequest];
            
           [self cityNameMethod];

        });
        
    }

}

 
- (void) cityNameMethod
{
    
    CLGeocoder *geocoder = [[CLGeocoder alloc] init] ;
    [geocoder reverseGeocodeLocation:self.locationManager.location completionHandler:^(NSArray *placemarks, NSError *error) {
                       NSLog(@"reverseGeocodeLocation:completionHandler: Completion Handler called!");
                       
                       if (error){
                           
                           NSLog(@"Geocode failed with error: %@", error);
                        
                           return;
                           
                       }
                       
                       CLPlacemark *placemark = [placemarks objectAtIndex:0];
 
                       self.locality = placemark.locality; // район subLocality | проезд subThoroughfare
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"MyNotification" object:nil];
   
                   }];
    
}



# pragma mark - HourlyForecastCall -

-(void) weekWeatherForecastRequest

{

NSString *url = [NSString stringWithFormat:@"http://api.openweathermap.org/data/2.5/forecast/daily?lat=%@&lon=%@&APPID=%@&units=metric&cnt=6",self.currentLatitude,self.currentLongitude,apiKey];
    
NSURL *weatherURL = [NSURL URLWithString:url];
NSData *date = [NSData dataWithContentsOfURL:weatherURL];
NSDictionary *jsonDate = [NSJSONSerialization JSONObjectWithData:date options:0 error:nil];
    
self.arrayWithWeater = jsonDate[@"list"];   
        
    
NSArray *dailyjson = [jsonDate valueForKey:@"list"];
    
NSArray *jsonWeather = [dailyjson valueForKey:@"weather"];
  
NSMutableArray *name = [[NSMutableArray alloc] init];

    
for (NSArray *dict in jsonWeather )
{
    [name addObject:[dict firstObject]];
}
    
NSArray *newArray =[name valueForKey:@"main"];
    
    self.jsonIcon = newArray;
   
}


@end
