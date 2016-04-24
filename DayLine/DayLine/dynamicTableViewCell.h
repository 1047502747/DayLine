//
//  dynamicTableViewCell.h
//  DayLine
//
//  Created by zxk on 16/4/22.
//  Copyright © 2016年 TianXingJian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface dynamicTableViewCell : UITableViewCell


@property (weak, nonatomic) IBOutlet UIImageView *lmageportrait;
@property (weak, nonatomic) IBOutlet UILabel *username;
@property (weak, nonatomic) IBOutlet UILabel *publishtime;
@property (weak, nonatomic) IBOutlet UITextView *showView;
@property (weak, nonatomic) IBOutlet UIImageView *pictureView;
@property (weak, nonatomic) IBOutlet UILabel *comment;
@property (weak, nonatomic) IBOutlet UILabel *NumberLbl;

- (IBAction)PostBut:(UIButton *)sender forEvent:(UIEvent *)event;
- (IBAction)ZambiBut:(UIButton *)sender forEvent:(UIEvent *)event;
- (IBAction)nickname:(UIButton *)sender forEvent:(UIEvent *)event;



@end
