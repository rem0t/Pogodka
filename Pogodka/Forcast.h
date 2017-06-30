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


- (void) setLocation;


// Propertis for Labels
@property(strong,nonatomic) NSString* locality;
@property (strong, nonatomic) NSArray* arrayWithWeater;

// ***


// Propertis for UICollectionView
@property (strong,nonatomic) NSArray* jsonIcon;

// ***



@end
