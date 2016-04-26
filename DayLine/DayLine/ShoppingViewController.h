//
//  ShoppingViewController.h
//  DayLine
//
//  Created by zxk on 16/4/26.
//  Copyright © 2016年 TianXingJian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShoppingViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITableView *TableView;
- (IBAction)signinAction:(UIBarButtonItem *)sender;
@property (weak, nonatomic) IBOutlet UILabel *integral;

@end
