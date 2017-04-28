//
//  Forecast.m
//  Pogodka
//
//  Created by Vladislav Kalaev on 24.02.17.
//  Copyright © 2017 Vladislav Kalaev. All rights reserved.
//


#import "Forcast.h"

#define API_KEY @"f032f3940de70aef8cb66eb16d389bd5"

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
    
    UIAlertController* alertError = [UIAlertController alertControllerWithTitle:@"ERROR" //  | сделать в отдельном классе 
                                                                        message:@"Ошибка получения геолокации, для корректной работы программы нужно подключить службы геолокации"
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
            
             [self forecastCall];
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
 
                       self.locality = placemark.locality; // Город
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"MyNotification" object:nil];
   
                   }];
    
}

# pragma mark - NowForecastCall -

-(void) forecastCall
{
    NSString *url = [NSString stringWithFormat:@"http://api.openweathermap.org/data/2.5/weather?lat=%@&lon=%@&APPID=%@&units=metric",self.currentLatitude,self.currentLongitude, API_KEY];
    
    NSURL *weatherURL = [NSURL URLWithString:url];
    NSData *date = [NSData dataWithContentsOfURL:weatherURL];
    NSDictionary *jsonDate = [NSJSONSerialization JSONObjectWithData:date options:0 error:nil];
    
    
    NSDictionary *currentDate = [jsonDate valueForKey:@"main"];
    NSString *currentTemperature = [currentDate valueForKey:@"temp"];
    NSString *apparentTemperature = [currentDate valueForKey:@"temp_min"];
    NSString *currentHumidity = [currentDate valueForKey:@"humidity"];
    NSString *currentPressure = [currentDate valueForKey:@"pressure"];
    
    NSArray *weatherArray = [[jsonDate valueForKey:@"weather"] firstObject];
    NSString *iconName = [weatherArray valueForKey:@"main"];
    
    NSDictionary *currentDatewind = [jsonDate valueForKey:@"wind"];
    NSString *currentWind = [currentDatewind valueForKey:@"speed"];
    

    self.currentAperentTemp = apparentTemperature;
    self.currentTemp = currentTemperature;
    self.humidity = currentHumidity;
    self.pressure = currentPressure;
    self.wind = currentWind;
    self.iconName = iconName;
    
    [self hourlyForecastCall];

}

# pragma mark - Weather -

- (float) currentCel {
    
    float celsios = [self.currentTemp intValue];
    
    return celsios;
    
}

- (float) apperentCel {
    
    float celsiosApparent = [self.currentAperentTemp intValue];
    
    return celsiosApparent;
}

- (float) currentHumidity {
    
    float humidity = [self.humidity intValue];
    
    return humidity;
}

- (float) currentPressure {
    
    float pressure = [self.pressure intValue];
    
    pressure *= 0.75006375541921; // перевод в мм. рт. ст.
    
    return pressure;
}

- (float) currentWind {
    
    float wind = [self.wind intValue];
    
    return wind;
}

# pragma mark - HourlyForecastCall -

-(void) hourlyForecastCall
{

NSString *url = [NSString stringWithFormat:@"http://api.openweathermap.org/data/2.5/forecast/daily?lat=%@&lon=%@&APPID=%@&units=metric&cnt=6",self.currentLatitude,self.currentLongitude, API_KEY];
    
NSURL *weatherURL = [NSURL URLWithString:url];
NSData *date = [NSData dataWithContentsOfURL:weatherURL];
NSDictionary *jsonDate = [NSJSONSerialization JSONObjectWithData:date options:0 error:nil];
    
NSArray *dailyjson = [jsonDate valueForKey:@"list"];
NSArray *data = [dailyjson valueForKey:@"dt"];
    
NSArray *jsonTemp = [dailyjson valueForKey:@"temp"];
NSArray *jsonTempEve = [jsonTemp valueForKey:@"eve"];
    
NSArray *jsonWeather = [dailyjson valueForKey:@"weather"];
  
NSMutableArray *name = [[NSMutableArray alloc] init];

for (NSArray *dict in jsonWeather )
{
    [name addObject:[dict firstObject]];
}
    
NSArray *newArray =[name valueForKey:@"main"];
    
    self.jsontime = data;
    self.jsontemp = jsonTempEve;
    self.jsonIcon = newArray;
   
}


@end
