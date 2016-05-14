//
//  PersonalTableViewCell.m
//  DayLine
//
//  Created by zxk on 16/4/26.
//  Copyright © 2016年 TianXingJian. All rights reserved.
//

#import "PersonalTableViewCell.h"

@implementation PersonalTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)HomeZambiBut:(UIButton *)sender forEvent:(UIEvent *)event {
    if (_delegate && [_delegate respondsToSelector:@selector(applyAction4:)]) {
        [_delegate applyAction4:_indexPath];
  }
}


- (IBAction)pinglunAction:(UIButton *)sender forEvent:(UIEvent *)event {
    if (_delegate && [_delegate respondsToSelector:@selector(applyAction3:)]) {
        [_delegate applyAction3:_indexPath];
    }
}


- (IBAction)HomenewsBut:(UIButton *)sender forEvent:(UIEvent *)event {
    if (_delegate && [_delegate respondsToSelector:@selector(applyAction2:)]) {
        [_delegate applyAction2:_indexPath];
    }
}
@end
