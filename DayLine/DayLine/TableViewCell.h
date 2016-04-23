//
//  TableViewCell.h
//  DayLine
//
//  Created by zxk on 16/4/19.
//  Copyright © 2016年 TianXingJian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *SPname;
@property (weak, nonatomic) IBOutlet UILabel *commodityID;
@property (weak, nonatomic) IBOutlet UILabel *surplus;
@property (weak, nonatomic) IBOutlet UILabel *integralLbl;
- (IBAction)commodityAction:(UIButton *)sender forEvent:(UIEvent *)event;

@end
