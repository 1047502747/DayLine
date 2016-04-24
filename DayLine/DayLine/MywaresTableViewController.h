//
//  MywaresTableViewController.h
//  DayLine
//
//  Created by zxk on 16/4/23.
//  Copyright © 2016年 TianXingJian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MywaresTableViewController : UITableViewController
@property (weak, nonatomic) IBOutlet UITableView *TableView;

- (IBAction)AddAction:(UIBarButtonItem *)sender;

@end
