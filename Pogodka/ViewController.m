//
//  ViewController.m
//  Pogodka
//
//  Created by Vladislav Kalaev on 15.02.17.
//  Copyright © 2017 Vladislav Kalaev. All rights reserved.
//
// 1) Виджет
// 2) Выбор города и закладки 
// 3) главная фича заключается в том что предупреждает о наступающем дожде например каждый 3-6 часов отправляет запрос и если будет дождь то у ведомляет пользователя (вместо облака будет будильник для сие задумки)
// 4) левое меню - поле для города, таблица для ранне выбранных городов, кнопка для добавления. Юзер пишет город - нажимет на кнопку - обновляется погода


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
    
    
    NSString *myString1 = [NSString stringWithFormat:@"%ld°", (long)[self.weatherForcast.jsontemp [indexPath.row] integerValue]];
    NSString *myString2 = [NSString stringWithFormat:@"%@", [self.weatherForcast.jsonIcon objectAtIndex:indexPath.row]];
 
    cell.cellLabel.text = myString1;
    cell.weatherIcon.image = [UIImage imageNamed:myString2];
    
    NSInteger timeinterval = [self.weatherForcast.jsontime[indexPath.row] integerValue];
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

-(void) initForecast
{
    
    self.weatherForcast = [[Forcast alloc] init];

    [self.weatherForcast setLocation];
    
    
}


# pragma mark - set Values Labele On View -

- (void) updateLabele
{
    
    self.cityLable.text = [NSString stringWithFormat:@"%@", self.weatherForcast.locality]; // место
    self.iboCurrentTemperature.text =  [NSString stringWithFormat: @"%.f°", self.weatherForcast.currentCel]; // температура
    self.humidityLabel.text = [NSString stringWithFormat:NSLocalizedString(@"humidity_LAB", nil), self.weatherForcast.currentHumidity]; // влажность
    self.windLabel.text = [NSString stringWithFormat:NSLocalizedString(@"wind_LAB", nil),self.weatherForcast.currentWind]; // ветер
    self.pressureLabel.text = [NSString stringWithFormat:NSLocalizedString(@"pressure_LAB", nil),self.weatherForcast.currentPressure ]; // давление
    self.apperentTemp.text = [NSString stringWithFormat:NSLocalizedString(@"felt_lab", nil), self.weatherForcast.apperentCel]; // ощущается как
    
    [self setbackgroundMainUI];
    
    [self hideWaitingScreen];
    
    [self.todayCollectionView reloadData];  

}
# pragma mark - changePicForUI - 


- (void) setbackgroundMainUI
{
    if ([self.weatherForcast.iconName isEqualToString: @"Rain"])
    {
        [self changeMainBackgroundToRain];
    }
    else if ([self.weatherForcast.iconName isEqualToString: @"Clear"])
    {
        [self changeMainBackgroundToClear];
    }
    else if ([self.weatherForcast.iconName isEqualToString: @"Snow"])
    {
        [self changeMainBackgroundToSnow];
    }
    else if ([self.weatherForcast.iconName isEqualToString: @"Cloud"])
    {
        [self changeMainBackgroundToCloud];
    }
    else
    {
        [self changeMainBackgroundToDefault];
    }
}


-(void) changeMainBackgroundToRain
{

    UIGraphicsBeginImageContext(self.view.frame.size);
    [[UIImage imageNamed:@"Wrain"] drawInRect:self.view.bounds];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    self.view.backgroundColor = [UIColor colorWithPatternImage:image];

}

-(void) changeMainBackgroundToCloud
{

    UIGraphicsBeginImageContext(self.view.frame.size);
    [[UIImage imageNamed:@"Wcloud"] drawInRect:self.view.bounds];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    self.view.backgroundColor = [UIColor colorWithPatternImage:image];

}

-(void) changeMainBackgroundToSnow
{
    UIGraphicsBeginImageContext(self.view.frame.size);
    [[UIImage imageNamed:@"Wsnow"]drawInRect:self.view.bounds];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:image];
    
}

-(void) changeMainBackgroundToClear
{
    UIGraphicsBeginImageContext(self.view.frame.size);
    [[UIImage imageNamed:@"Wclear"]drawInRect:self.view.bounds];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:image];
    
}

-(void) changeMainBackgroundToDefault
{
    UIGraphicsBeginImageContext(self.view.frame.size);
    [[UIImage imageNamed:@"Default"]drawInRect:self.view.bounds];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:image];
    
}

# pragma mark - Side menu button -

- (IBAction)sideMenu:(id)sender { //Side menu button
    
    self.app = (AppDelegate*) [[UIApplication sharedApplication] delegate];

    [_app.driwerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
    
}

- (IBAction)updateForecast:(id)sender {
    
    [self playAnimation];
    
    [NSTimer scheduledTimerWithTimeInterval:2.5
                                     target:self
                                   selector:@selector(hideWaitingScreen)
                                   userInfo:nil
                                    repeats:NO];
}

# pragma mark - Animations -


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
