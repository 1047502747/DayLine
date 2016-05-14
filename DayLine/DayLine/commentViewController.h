//
//  commentViewController.h
//  DayLine
//
//  Created by zxk on 16/5/6.
//  Copyright © 2016年 TianXingJian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface commentViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (strong, nonatomic) PFObject *post;

@end
