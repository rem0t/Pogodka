//
//  ViewController.h
//  Pogodka
//
//  Created by Vladislav Kalaev on 15.02.17.
//  Copyright © 2017 Vladislav Kalaev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "AppDelegate.h"
#import "Forcast.h"
#import "UIImage+animatedGIF.h"

@interface ViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UICollectionView *todayCollectionView;

@property (strong, nonatomic) IBOutlet UILabel *iboCurrentTemperature;
@property (strong, nonatomic) IBOutlet UILabel *cityLable;
@property (strong, nonatomic) IBOutlet UILabel *humidityLabel;
@property (strong, nonatomic) IBOutlet UILabel *windLabel;
@property (strong, nonatomic) IBOutlet UILabel *pressureLabel; // давление
@property (strong, nonatomic) IBOutlet UILabel *apperentTemp;

@property (strong, nonatomic) IBOutlet UIImageView *background;


@property (strong, nonatomic) Forcast *weatherForcast;


@end

