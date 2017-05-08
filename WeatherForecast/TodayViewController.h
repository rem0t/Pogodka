//
//  TodayViewController.h
//  WeatherForecast
//
//  Created by Vladislav Kalaev on 08.05.17.
//  Copyright © 2017 Vladislav Kalaev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Forcast.h"
#import "UIImage+animatedGIF.h"


@interface TodayViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *todayWeatherImage;
@property (weak, nonatomic) IBOutlet UILabel *todayCityName;
@property (weak, nonatomic) IBOutlet UILabel *tomorrowWeather;
@property (weak, nonatomic) IBOutlet UILabel *todayTemp;

@property (strong, nonatomic) Forcast *forecastClass;


@end
