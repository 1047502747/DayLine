//
//  PublishViewController.h
//  DayLine
//
//  Created by zxk on 16/4/24.
//  Copyright © 2016年 TianXingJian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PublishViewController : UIViewController

@property (weak, nonatomic)PFObject *posts;
@property (weak, nonatomic)PFObject *photo2;
@property (weak, nonatomic) IBOutlet UITextField *content;
@property (weak, nonatomic) IBOutlet UIImageView *photo;
- (IBAction)upload:(UIButton *)sender forEvent:(UIEvent *)event;
- (IBAction)pickAction:(UITapGestureRecognizer *)sender;

@end
