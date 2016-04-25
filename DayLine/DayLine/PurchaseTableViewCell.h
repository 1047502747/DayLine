//
//  PurchaseTableViewCell.h
//  DayLine
//
//  Created by zxk on 16/4/24.
//  Copyright © 2016年 TianXingJian. All rights reserved.
//

#import <UIKit/UIKit.h>
//甲方决定何时做，乙方决定怎么做
//甲方草拟一份协议
@protocol ActivityTableViewCellDelegate <NSObject>


@required

- (void)applyAction: (NSIndexPath *)indexPath;
- (void)cellLongPressAtIndexPath:(NSIndexPath *)indexPath;
- (void)photoTapAtIndexPath:(NSIndexPath *)indexPath;
@end
@interface PurchaseTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *pictures;
@property (weak, nonatomic) IBOutlet UILabel *Commodityname;
@property (weak, nonatomic) IBOutlet UILabel *commodityID;
@property (weak, nonatomic) IBOutlet UILabel *Quantity;
@property (weak, nonatomic) IBOutlet UILabel *Price;


//甲方打印一份协议
@property (weak,nonatomic) id <UITableViewDelegate> delegate;

@end
