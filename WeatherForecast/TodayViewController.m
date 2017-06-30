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
    
    [self initForecast];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(getCurrentData)
                                                 name:@"MyNotification"
                                               object:nil];
    
  //  self.extensionContext.widgetLargestAvailableDisplayMode = NCWidgetDisplayModeExpanded; // больше меньше

}

//- (void)widgetActiveDisplayModeDidChange:(NCWidgetDisplayMode)activeDisplayMode withMaximumSize:(CGSize)maxSize { // реализация больше меньше
//    if (activeDisplayMode == NCWidgetDisplayModeExpanded) {
//        self.preferredContentSize = CGSizeMake(0.0, 200.0);
//    } else if (activeDisplayMode == NCWidgetDisplayModeCompact) {
//        self.preferredContentSize = maxSize;
//    }
//}



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
    
    
    self.todayCityName.text = [NSString stringWithFormat:@"%@", self.weatherForcast.locality];
    self.todayTemp.text = [NSString stringWithFormat:NSLocalizedString(@"todayTemp", nil), [[[[self.weatherForcast.arrayWithWeater
                                                                        valueForKey:@"temp" ]
                                                                       valueForKey:@"day"] firstObject] intValue] ];
    
    self.tomorrowWeather.text = [NSString stringWithFormat:NSLocalizedString(@"tomorrowWeather", nil), [self.weatherForcast.jsonIcon objectAtIndex:1]];

    
    [self setTodayIconGif];

}

-(void) initForecast
{
    
    self.weatherForcast = [[Forcast alloc]init];
    
    [self.weatherForcast setLocation];
    
    
}

- (void) setTodayIconGif
{
    NSURL *url;
    
    if ([[self.weatherForcast.jsonIcon firstObject] isEqualToString: @"Rain"])
    {
        url = [[NSBundle mainBundle] URLForResource:@"rain" withExtension:@"gif"];
    }
    else if ([[self.weatherForcast.jsonIcon firstObject] isEqualToString: @"Clear"])
    {
        url = [[NSBundle mainBundle] URLForResource:@"sunny" withExtension:@"gif"];
    }
    else if ([[self.weatherForcast.jsonIcon firstObject] isEqualToString: @"Snow"])
    {
        url = [[NSBundle mainBundle] URLForResource:@"snow" withExtension:@"gif"];
    }
    else if ([[self.weatherForcast.jsonIcon firstObject] isEqualToString: @"Cloud"])
    {
        url = [[NSBundle mainBundle] URLForResource:@"cloudy1" withExtension:@"gif"];
    }
    else
    {
        url = [[NSBundle mainBundle] URLForResource:@"fog" withExtension:@"gif"];
    }
    
    self.todayWeatherImage.image = [UIImage animatedImageWithAnimatedGIFURL:url];

}


@end
