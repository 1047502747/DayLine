//
//  ShoppingViewController.h
//  DayLine
//
//  Created by zxk on 16/4/19.
//  Copyright © 2016年 TianXingJian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShoppingViewController : UIViewController
- (IBAction)SignInAction:(UIBarButtonItem *)sender;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

- (IBAction)integralAction:(UIButton *)sender forEvent:(UIEvent *)event;
- (IBAction)orderAction:(UIButton *)sender forEvent:(UIEvent *)event;
- (IBAction)EarnpointsAction:(UIButton *)sender forEvent:(UIEvent *)event;

@end
