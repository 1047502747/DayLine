//
//  PurchaseTableViewCell.h
//  DayLine
//
//  Created by zxk on 16/4/24.
//  Copyright © 2016年 TianXingJian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PurchaseTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *pictures;
@property (weak, nonatomic) IBOutlet UILabel *Commodityname;
@property (weak, nonatomic) IBOutlet UILabel *commodityID;
@property (weak, nonatomic) IBOutlet UILabel *Quantity;
@property (weak, nonatomic) IBOutlet UILabel *Price;

@end
