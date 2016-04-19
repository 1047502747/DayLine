//
//  registerViewController.h
//  DayLine
//
//  Created by zxk on 16/4/19.
//  Copyright © 2016年 TianXingJian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface registerViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *userPhone;
@property (weak, nonatomic) IBOutlet UITextField *passwordTF;
@property (weak, nonatomic) IBOutlet UITextField *confirmPwdTF;
@property (weak, nonatomic) IBOutlet UITextField *textField;
- (IBAction)getCodeAction:(UIButton *)sender forEvent:(UIEvent *)event;
- (IBAction)signUpAction:(UIButton *)sender forEvent:(UIEvent *)event;

@end
