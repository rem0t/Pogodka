//
//  PatternViewCell.h
//  Pogodka
//
//  Created by Vladislav Kalaev on 03.04.17.
//  Copyright © 2017 Vladislav Kalaev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PatternViewCell : UICollectionViewCell

@property (nonatomic, weak) IBOutlet UIImageView *weatherIcon;
@property (nonatomic, weak) IBOutlet UILabel *timeLabel;
@property (nonatomic, weak) IBOutlet UILabel *cellLabel;

@end
