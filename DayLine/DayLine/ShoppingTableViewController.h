//
//  ShoppingTableViewController.h
//  DayLine
//
//  Created by zxk on 16/4/25.
//  Copyright © 2016年 TianXingJian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShoppingTableViewController : UITableViewController
@property (weak, nonatomic) IBOutlet UITableView *TableView;
- (IBAction)SignInAction:(UIBarButtonItem *)sender;

@property (weak, nonatomic) IBOutlet UILabel *integral;

@end
