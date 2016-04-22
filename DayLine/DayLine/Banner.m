//
//  Banner.m
//  VC
//
//  Created by Sunday on 16/4/18.
//  Copyright © 2016年 Sunday. All rights reserved.
//

#import "Banner.h"

#import "Timer.h"

@interface Banner ()<UIScrollViewDelegate>

@property (nonatomic,strong) Timer *timer;

@property (nonatomic,strong) NSMutableArray<UIImageView *> *datas;

@end

@implementation Banner

- (instancetype)init
{
    CGSize size = [UIScreen mainScreen].bounds.size;
    self = [self initWithFrame:CGRectMake(0, 100, size.width, 100)];
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.bounces = NO;
        self.showsHorizontalScrollIndicator = NO;
        self.pagingEnabled = YES;
        self.delegate = self;
    }
    return self;
}
- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    
    if (_dataSource) [self layoutImageView];
}

- (void)setDataSource:(id<BannerDataSource>)dataSource {
    _dataSource = dataSource;
    
    [self bulidView];
    [self layoutImageView];
}
- (void)bulidView {
    
    NSAssert(_dataSource, @"not datatSource");
    
    NSAssert([self.dataSource respondsToSelector: @selector(numberOfItemsInBanner:)], @"respondsToSelector: @selector(numberOfItemsInBanner:) is null");
   
    NSUInteger num = [self.dataSource numberOfItemsInBanner: self];
    num = num == 1 ? 1 : num + 2;
    
    _datas = [NSMutableArray<UIImageView *> arrayWithCapacity: num];
    
    UIImageView *iv;
    for (unsigned int i = 0; i < num; i++) {
        if (i == 0) {
            iv = [self buildImageViewWithIndex: num - 2 - 1];
            iv.tag = 0;
        }
        else if (i == num - 1) {
            iv = [self buildImageViewWithIndex: 0];
            iv.tag = num - 1;
        }
        else {
            iv = [self buildImageViewWithIndex: i - 1];
            iv.tag = i - 1;
        }
        [self.datas addObject: iv];
        [self addSubview: iv];
        
    }
    
}
#pragma mark - 各种事件
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    UIView *view = [touch view];
    if ([view isKindOfClass: [UIImageView class]]) {
        NSUInteger index = view.tag;
        
        if (self.bannerDelegate && [self.bannerDelegate respondsToSelector:@selector(bannerView:didSelectImageAtIndex:)]) {
            [self.bannerDelegate bannerView:self didSelectImageAtIndex:index];
        }
        
        [self stopPlay];
    }
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    UIView *view = [touch view];
    if ([view isKindOfClass: [UIImageView class]]) {
        [self startPlay];
    }
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    UIView *view = [touch view];
    if ([view isKindOfClass: [UIImageView class]]) {
        [self startPlay];
    }
}

#pragma mark - 创建imageview
- (UIImageView *)buildImageViewWithIndex : (NSUInteger) index {
    
    NSAssert([self.dataSource respondsToSelector:@selector(bannerView:imageInIndex:)], @"respondsToSelector:@selector(bannerView:imageInIndex:) is null");
    UIImage *image = [self.dataSource bannerView:self imageInIndex:index];
    UIImageView *iv = [[UIImageView alloc] initWithImage:image];
    iv.userInteractionEnabled = YES;
    //    iv.contentMode = UIViewContentModeScaleAspectFit;
    return iv;
}

#pragma mark - 布局
- (void)layoutImageView {
    __weak typeof(self) weakSelf = self;
    [_datas enumerateObjectsUsingBlock:^(UIImageView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        const CGFloat width = CGRectGetWidth(weakSelf.frame);
        const CGFloat height = CGRectGetHeight(weakSelf.frame);
        const CGFloat y = 0.f;
        CGFloat x = idx * CGRectGetWidth(weakSelf.frame);
        obj.frame = CGRectMake(x, y, width, height);
        
        if (idx == weakSelf.datas.count - 1) {
            self.contentSize = CGSizeMake(CGRectGetMaxX(obj.frame), self.contentSize.height);
            
            // 是否为一张图片
            self.contentOffset = self.datas.count == 1 ? CGPointMake(0, self.contentOffset.y) : CGPointMake(CGRectGetWidth(self.frame), self.contentOffset.y);
        }
    }];
}

#pragma mark - 重写scrollview方法
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGPoint point = self.contentOffset;
    NSUInteger index = 0;
    if (point.x == 0)
        index = self.datas.count - 2;
    else if (point.x == self.frame.size.width * (self.datas.count - 1))
        index = 1;
    else
        return;
    self.contentOffset = CGPointMake(CGRectGetWidth(self.frame) * index, 0);
}

#pragma mark - 轮播
- (void)startPlay {
    if (self.datas.count == 1) return; // 只有一张图片不轮播
    
    _timer = [Timer shareInstance];
    
    __weak typeof(self) weakSelf = self;
    [self.timer startTaskWithTask:^{
        const CGFloat x = weakSelf.contentOffset.x +  CGRectGetWidth(weakSelf.frame);
        [weakSelf setContentOffset:CGPointMake(x, weakSelf.contentOffset.y) animated:YES];
        
    } interval:2];
}

- (void)stopPlay {
    if (_timer) {
        [_timer cancelTask];
    }
}



@end
