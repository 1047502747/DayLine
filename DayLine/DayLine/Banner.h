//
//  Banner.h
//  VC
//
//  Created by Sunday on 16/4/18.
//  Copyright © 2016年 Sunday. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Banner;

@protocol BannerDataSource <NSObject>

@required

//  图片资源
- (UIImage *)bannerView: (Banner *)bannerView imageInIndex : (NSUInteger) index;

//  图片数量的数量
- (NSUInteger)numberOfItemsInBanner: (Banner *)Banner;

@end

@protocol BannerDelegate <NSObject>

@optional

- (void)bannerView: (Banner *)bannerView didSelectImageAtIndex: (NSUInteger) index;

@end

@interface Banner : UIScrollView

@property (nonatomic,assign) id<BannerDataSource> dataSource;

@property (nonatomic,assign) id<BannerDelegate> bannerDelegate;

- (void)startPlay;

@end

//@interface Banner : UIViewController

//@end
