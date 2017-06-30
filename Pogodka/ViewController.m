//
//  ViewController.m
//  Pogodka
//
//  Created by Vladislav Kalaev on 15.02.17.
//  Copyright © 2017 Vladislav Kalaev. All rights reserved.
//
 


#import "ViewController.h"
#import "PatternViewCell.h"

@interface ViewController ()

{
    NSMutableArray *connectingImages;
}

@property (strong, nonatomic) UIImageView *imgConnection;
@property (strong, nonatomic) UIView *viewWaitingScreen;


@end

@implementation ViewController

- (void)viewDidLoad
{
    
    [self playAnimation];
    
    [super viewDidLoad];
    
    [self initForecast];
 
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(updateLabele)
                                                 name:@"MyNotification"
                                               object:nil];
    
    
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

# pragma mark - Today CollectionView -

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}


-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    
    return 6;
}


-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    PatternViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PatternCell" forIndexPath:indexPath];
    
    
    cell.cellLabel.text = [NSString stringWithFormat:@"%li°", (long)roundf([self.weatherForcast.arrayWithWeater[indexPath.row][@"temp"][@"eve"] floatValue])];

    cell.weatherIcon.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@", [self.weatherForcast.jsonIcon objectAtIndex:indexPath.row]]];
    
    
    NSInteger timeinterval = [self.weatherForcast.arrayWithWeater[indexPath.item][@"dt"] integerValue];

    NSDate * date = [[NSDate alloc] initWithTimeIntervalSince1970:timeinterval];
    NSDateFormatter *formatter = [NSDateFormatter new];
    formatter.dateFormat = @"EEE";
    cell.timeLabel.text = [formatter stringFromDate:date];
    
    return cell;
    
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    return CGSizeMake(90.0, 140.0);
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    
    return UIEdgeInsetsMake(5, 5, 5, 5);
}

# pragma mark - WeatherForecast - 

-(void) initForecast        // что тут не так 
{
    
    self.weatherForcast = [[Forcast alloc]init];
    
    [self.weatherForcast setLocation];
    
}


# pragma mark - Values Label On View -

- (void) updateLabele
{

    self.cityLable.text = [NSString stringWithFormat:@"%@", self.weatherForcast.locality]; // место
    self.iboCurrentTemperature.text =  [NSString stringWithFormat:@"%d°", [[[[self.weatherForcast.arrayWithWeater
                                                                             valueForKey:@"temp" ]
                                                                             valueForKey:@"day"] firstObject] intValue] ];
 // температура
    
    self.humidityLabel.text = [NSString stringWithFormat:NSLocalizedString(@"humidity_LAB", nil), [[[self.weatherForcast.arrayWithWeater
                                                                                                     valueForKey:@"humidity"] firstObject] intValue]]; // влажность
    
    
    self.windLabel.text = [NSString stringWithFormat:NSLocalizedString(@"wind_LAB", nil),[[[self.weatherForcast.arrayWithWeater
                                                                                            valueForKey:@"speed"] firstObject] intValue]]; // ветер
    
    self.pressureLabel.text = [NSString stringWithFormat:NSLocalizedString(@"pressure_LAB", nil),[[[self.weatherForcast.arrayWithWeater valueForKey:@"pressure"] firstObject] floatValue]*0.75006375541921]; // давление
   
    
    
    self.apperentTemp.text = [NSString stringWithFormat:NSLocalizedString(@"felt_lab", nil), [[[[self.weatherForcast.arrayWithWeater valueForKey:@"temp" ] valueForKey:@"eve"] firstObject] intValue] ]; // ощущается как
    
    
    
    [self setbackgroundMainUI];
    
    [self hideWaitingScreen];
    
    [self.todayCollectionView reloadData];  

}
# pragma mark - changePicForUI - 


- (void) setbackgroundMainUI
{
    
    NSURL *url;
    
    if ([[self.weatherForcast.jsonIcon firstObject] isEqualToString: @"Rain"])
    {
        url = [[NSBundle mainBundle] URLForResource:@"bkRain" withExtension:@"gif"];
    }
    else if ([[self.weatherForcast.jsonIcon firstObject] isEqualToString: @"Clear"])
    {
        url = [[NSBundle mainBundle] URLForResource:@"bkDefault" withExtension:@"gif"];
    }
    else if ([[self.weatherForcast.jsonIcon firstObject] isEqualToString: @"Snow"])
    {
        url = [[NSBundle mainBundle] URLForResource:@"bkSnow" withExtension:@"gif"];
    }
    else if ([[self.weatherForcast.jsonIcon firstObject] isEqualToString: @"Cloud"])
    {
        url = [[NSBundle mainBundle] URLForResource:@"bkCloud" withExtension:@"gif"];
    }
    else
    {
        url = [[NSBundle mainBundle] URLForResource:@"bkDefault" withExtension:@"gif"];
        
    }
    

    self.background.image = [UIImage animatedImageWithAnimatedGIFURL:url];

    
}



# pragma mark - Animations -

// preview loading animations

-(void) playAnimation {
 
    self.viewWaitingScreen = [[UIView alloc] initWithFrame: [[UIScreen mainScreen] bounds]];
    
    self.viewWaitingScreen.backgroundColor = [UIColor colorWithRed: 0/255
                                                             green: 60/255
                                                              blue: 60/255
                                                             alpha: 0.95];
    
    self.imgConnection = [[UIImageView alloc] initWithFrame: CGRectMake (self.viewWaitingScreen.frame.origin.x,
                                                                         self.viewWaitingScreen.frame.origin.y,
                                                                         100,
                                                                         100)];
    
    self.imgConnection.center = self.viewWaitingScreen.center;
    
    [self initConnectionImages];
    
    [self startConnectionAnimation];
    
    self.imgConnection.backgroundColor = [UIColor purpleColor];
    
    [self.viewWaitingScreen addSubview:self.imgConnection];
    
    [self.view addSubview: self.viewWaitingScreen];
    
    
    
}


- (void)hideWaitingScreen
{
    [UIView transitionWithView: self.view
                      duration: 0.7f
                       options: UIViewAnimationOptionTransitionCrossDissolve
                    animations: ^{
                        
                        [self.viewWaitingScreen removeFromSuperview];
                        [self stopConnectionAnimation];
                        
                    } completion:nil];
}

- (void)initConnectionImages
{
    connectingImages = [[NSMutableArray alloc] initWithObjects:
                        [UIImage imageNamed:@"Clear"],
                        [UIImage imageNamed:@"clear-night"],
                        [UIImage imageNamed:@"Snow"],
                        [UIImage imageNamed:@"cloudy"],
                        nil];
    
    self.imgConnection.animationImages = connectingImages;
    self.imgConnection.animationDuration = 1;
}

- (void)startConnectionAnimation
{
    [self.imgConnection startAnimating];
}

- (void)stopConnectionAnimation
{
    [self.imgConnection stopAnimating];
}

@end
