//
//  LeftViewController.h
//  DayLine
//
//  Created by zxk on 16/4/25.
//  Copyright © 2016年 TianXingJian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LeftViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *headportrait;
@property (weak, nonatomic) IBOutlet UILabel *Sideslipname;
@property (weak, nonatomic) IBOutlet UILabel *Sideslipintegral;
- (IBAction)SideslipexitBut:(UIButton *)sender forEvent:(UIEvent *)event;

@end
