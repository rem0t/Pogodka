//
//  TodayViewController.m
//  WeatherForecast
//
//  Created by Vladislav Kalaev on 08.05.17.
//  Copyright © 2017 Vladislav Kalaev. All rights reserved.
//

#import "TodayViewController.h"
#import <NotificationCenter/NotificationCenter.h>

@interface TodayViewController () <NCWidgetProviding>

@end

@implementation TodayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    NSURL *url = [[NSBundle mainBundle] URLForResource:@"test" withExtension:@"gif"];
    self.todayWeatherImage.image = [UIImage animatedImageWithAnimatedGIFURL:url];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)widgetPerformUpdateWithCompletionHandler:(void (^)(NCUpdateResult))completionHandler {
    // Perform any setup necessary in order to update the view.
    
    // If an error is encountered, use NCUpdateResultFailed
    // If there's no update required, use NCUpdateResultNoData
    // If there's an update, use NCUpdateResultNewData

    completionHandler(NCUpdateResultNewData);
}

-(void) getCurrentData {
    
    self.todayCityName.text = _forecastClass.locality;
    self.todayTemp.text = _forecastClass.currentTemp;
    self.tomorrowWeather.text = [_forecastClass.jsonIcon objectAtIndex:1];
    
    
    
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"RainGif" withExtension:@"gif"];
    self.todayWeatherImage.image = [UIImage animatedImageWithAnimatedGIFData:[NSData dataWithContentsOfURL:url]];
   // self.urlImageView.image = [UIImage animatedImageWithAnimatedGIFURL:url];
    
//    url = [[NSBundle mainBundle] URLForResource:@"variableDuration" withExtension:@"gif"];
//    self.variableDurationImageView.image = [UIImage animatedImageWithAnimatedGIFURL:url];
//
    
    
    
    
}






@end
