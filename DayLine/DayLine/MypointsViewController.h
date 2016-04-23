//
//  MypointsViewController.h
//  DayLine
//
//  Created by zxk on 16/4/23.
//  Copyright © 2016年 TianXingJian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MypointsViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *pointsLbl;
- (IBAction)RechargeBut:(UIButton *)sender forEvent:(UIEvent *)event;
- (IBAction)incomeBut:(UIButton *)sender forEvent:(UIEvent *)event;
- (IBAction)expenditureBut:(UIButton *)sender forEvent:(UIEvent *)event;

@end
