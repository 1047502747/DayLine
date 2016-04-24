//
//  PostViewController.h
//  DayLine
//
//  Created by zxk on 16/4/19.
//  Copyright © 2016年 TianXingJian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PostViewController : UIViewController
@property (strong, nonatomic) PFObject *user;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
