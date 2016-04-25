//
//  PurchaseViewController.h
//  DayLine
//
//  Created by zxk on 16/4/23.
//  Copyright © 2016年 TianXingJian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PurchaseViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *SPpictures;
@property (weak, nonatomic) IBOutlet UILabel *Commodityname;
@property (weak, nonatomic) IBOutlet UILabel *Quantity;
@property (weak, nonatomic) IBOutlet UILabel *Price;
@property (weak, nonatomic) IBOutlet UILabel *commodityID;
- (IBAction)PurchaseBut:(UIButton *)sender forEvent:(UIEvent *)event;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
