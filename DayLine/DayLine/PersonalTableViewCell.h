//
//  PersonalTableViewCell.h
//  DayLine
//
//  Created by zxk on 16/4/26.
//  Copyright © 2016年 TianXingJian. All rights reserved.
//

#import <UIKit/UIKit.h>


//协议第一步：甲方草拟一份协议（创建一个协议）
@protocol dynamicTableViewCellDelegate <NSObject>
@required
- (void)applyAction:(NSIndexPath *)indexPath;
- (void)applyAction2:(NSIndexPath *)indexPath;
- (void)applyAction3:(NSIndexPath *)indexPath;
- (void)applyAction4:(NSIndexPath *)indexPath;
@end

@interface PersonalTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *Homelmage;
@property (weak, nonatomic) IBOutlet UILabel *Homeusername;
@property (weak, nonatomic) IBOutlet UILabel *Homepublishtime;
@property (weak, nonatomic) IBOutlet UITextView *HomeshowView;
@property (weak, nonatomic) IBOutlet UILabel *HomenumberLbl;
@property (weak, nonatomic) IBOutlet UIImageView *HomepictureView;




//协议第二步：甲方打印一份协议（将协议实例化
@property (weak,nonatomic) id<dynamicTableViewCellDelegate>delegate;
@property (strong,nonatomic) NSIndexPath *indexPath;
- (IBAction)HomeZambiBut:(UIButton *)sender forEvent:(UIEvent *)event;
- (IBAction)HomenewsBut:(UIButton *)sender forEvent:(UIEvent *)event;
- (IBAction)pinglunAction:(UIButton *)sender forEvent:(UIEvent *)event;
@property (weak, nonatomic) IBOutlet UIButton *PLBut;
@end
