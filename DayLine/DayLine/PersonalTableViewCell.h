//
//  PersonalTableViewCell.h
//  DayLine
//
//  Created by zxk on 16/4/26.
//  Copyright © 2016年 TianXingJian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PersonalTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *Homelmage;
@property (weak, nonatomic) IBOutlet UILabel *Homeusername;
@property (weak, nonatomic) IBOutlet UILabel *Homepublishtime;
@property (weak, nonatomic) IBOutlet UITextView *HomeshowView;
@property (weak, nonatomic) IBOutlet UILabel *HomenumberLbl;
@property (weak, nonatomic) IBOutlet UIImageView *HomepictureView;

- (IBAction)HomeZambiBut:(UIButton *)sender forEvent:(UIEvent *)event;
- (IBAction)HomenewsBut:(UIButton *)sender forEvent:(UIEvent *)event;
@end
