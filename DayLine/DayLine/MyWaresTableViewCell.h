//
//  MyWaresTableViewCell.h
//  DayLine
//
//  Created by zxk on 16/5/8.
//  Copyright © 2016年 TianXingJian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyWaresTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *SPImageView;
@property (weak, nonatomic) IBOutlet UILabel *SPNameLbl;
@property (weak, nonatomic) IBOutlet UILabel *SPIDLbl;
@property (weak, nonatomic) IBOutlet UILabel *SPNumberLbl;
@property (weak, nonatomic) IBOutlet UILabel *SPIntegralLbl;

@end
