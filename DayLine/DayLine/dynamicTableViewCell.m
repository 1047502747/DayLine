//
//  dynamicTableViewCell.m
//  DayLine
//
//  Created by zxk on 16/4/22.
//  Copyright © 2016年 TianXingJian. All rights reserved.
//

#import "dynamicTableViewCell.h"

@implementation dynamicTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

//第三步：甲方决定何时启动条款，在触发时乙方使用方法
- (IBAction)KeyBut:(UIButton *)sender forEvent:(UIEvent *)event {
    if (_delegate && [_delegate respondsToSelector:@selector(applyAction:)]) {
        [_delegate applyAction:_indexPath];
    }
}

- (IBAction)PostBut:(UIButton *)sender forEvent:(UIEvent *)event {
    
}


- (IBAction)ZambiBut:(UIButton *)sender forEvent:(UIEvent *)event {
    
}



- (IBAction)newsBut:(UIButton *)sender forEvent:(UIEvent *)event {
    if (_delegate && [_delegate respondsToSelector:@selector(applyAction2:)]) {
        [_delegate applyAction2:_indexPath];
    }
}


@end
