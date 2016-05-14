//
//  commentTableViewCell.h
//  DayLine
//
//  Created by zxk on 16/5/6.
//  Copyright © 2016年 TianXingJian. All rights reserved.
//

#import <UIKit/UIKit.h>
//协议第一步：甲方草拟一份协议（创建一个协议）
@protocol commentTableViewCellDelegate <NSObject>
@required
- (void)applyAction5:(NSIndexPath *)indexPath;
@end


@interface commentTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *huifu;
@property (weak, nonatomic) IBOutlet UILabel *content;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UIImageView *Userprofile;
@property (weak, nonatomic) IBOutlet UILabel *nickname;
@property (weak, nonatomic) IBOutlet UIImageView *headportrait;
@property (weak, nonatomic) IBOutlet UILabel *username;
@property (weak, nonatomic) IBOutlet UILabel *Publishedtime;
@property (weak, nonatomic) IBOutlet UIImageView *Photo;
@property (weak, nonatomic) IBOutlet UIImageView *Zambia;
@property (weak, nonatomic) IBOutlet UILabel *Zambias;
@property (weak, nonatomic) IBOutlet UILabel *showcontents;
@property (weak, nonatomic) IBOutlet UIImageView *Userprofileview;
@property (weak, nonatomic) IBOutlet UILabel *nicknameLbl;
@property (weak, nonatomic) IBOutlet UIImageView *Zambiaview;
@property (weak, nonatomic) IBOutlet UILabel *ZambiasLbl;


//协议第二步：甲方打印一份协议（将协议实例化
@property (weak,nonatomic) id<commentTableViewCellDelegate>delegate;
@property (strong,nonatomic) NSIndexPath *indexPath;
- (IBAction)commentBut:(UIButton *)sender forEvent:(UIEvent *)event;




@end
