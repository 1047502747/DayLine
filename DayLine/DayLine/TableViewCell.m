//
//  TableViewCell.m
//  DayLine
//
//  Created by zxk on 16/4/19.
//  Copyright © 2016年 TianXingJian. All rights reserved.
//

#import "TableViewCell.h"

@implementation TableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    UILongPressGestureRecognizer *cellLongPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(cellLongPress:)];
    [self addGestureRecognizer:cellLongPress];
    
    UITapGestureRecognizer *photoTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(photoTap:)];
    [self.aviimageView addGestureRecognizer:photoTap];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (IBAction)purchase:(UIButton *)sender forEvent:(UIEvent *)event {
//    //如果协议存在且能响应
//    if (_delegate && [_delegate respondsToSelector:@selector(applyAction:)]) {
//        [_delegate applyAction:_indexPath];
//    }
//}
//- (void)cellLongPress:(UILongPressGestureRecognizer *)sender {
//    if (sender.state == UIGestureRecognizerStateBegan) {
//        if (_delegate && _indexPath && [_delegate respondsToSelector:@selector(cellLongPressAtIndexPath:)]) {
//            [_delegate cellLongPressAtIndexPath:_indexPath];
//        }
//    }
//}
//
//- (void)photoTap:(UITapGestureRecognizer *)sender {
//    if (sender.state == UIGestureRecognizerStateRecognized) {
//        if (_delegate && _indexPath && [_delegate respondsToSelector:@selector(photoTapAtIndexPath:)]) {
//            [_delegate photoTapAtIndexPath:_indexPath];
//        }
//    }
}


    @end
