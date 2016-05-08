//
//  dynamicTableViewCell.h
//  DayLine
//
//  Created by zxk on 16/4/22.
//  Copyright © 2016年 TianXingJian. All rights reserved.
//

#import <UIKit/UIKit.h>
//协议第一步：甲方草拟一份协议（创建一个协议）
@protocol dynamicTableViewCellDelegate <NSObject>
@required
- (void)applyAction:(NSIndexPath *)indexPath;
- (void)applyAction2:(NSIndexPath *)indexPath;
//- (void)cellLongPressAtIndexPath:(NSIndexPath *)indexPath;
//- (void)photoTapAtIndexPath:(NSIndexPath *)indexPath;

@end
@interface dynamicTableViewCell : UITableViewCell


@property (weak, nonatomic) IBOutlet UIImageView *lmageportrait;
@property (weak, nonatomic) IBOutlet UILabel *username;
@property (weak, nonatomic) IBOutlet UILabel *publishtime;
@property (weak, nonatomic) IBOutlet UITextView *showView;
@property (weak, nonatomic) IBOutlet UIImageView *pictureView;

@property (weak, nonatomic) IBOutlet UILabel *NumberLbl;


//协议第二步：甲方打印一份协议（将协议实例化
@property (weak,nonatomic) id<dynamicTableViewCellDelegate>delegate;
@property (strong,nonatomic) NSIndexPath *indexPath;
- (IBAction)KeyBut:(UIButton *)sender forEvent:(UIEvent *)event;
- (IBAction)PostBut:(UIButton *)sender forEvent:(UIEvent *)event;
- (IBAction)ZambiBut:(UIButton *)sender forEvent:(UIEvent *)event;

- (IBAction)newsBut:(UIButton *)sender forEvent:(UIEvent *)event;



@end
