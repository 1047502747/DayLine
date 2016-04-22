//
//  ShoppingViewController.m
//  DayLine
//
//  Created by zxk on 16/4/19.
//  Copyright © 2016年 TianXingJian. All rights reserved.
//

#import "ShoppingViewController.h"
#import "SigninViewController.h"
#import "Banner.h"
@interface ShoppingViewController ()

@end

@implementation ShoppingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.navigationController.navigationBar.hidden = YES;
    CGSize size = [UIScreen mainScreen].bounds.size;
    
    Banner *bv = [[Banner alloc]init];
    bv.frame = CGRectMake(0, 100, size.width, 142);
    bv.bannerDelegate = self;
    bv.dataSource = self;
    [bv startPlay];
    [self.view addSubview:bv];
}
//  点击图片
- (void)bannerView:(Banner *)bannerView didSelectImageAtIndex:(NSUInteger)index
{
    
}
//  图片数量
- (NSUInteger)numberOfItemsInBanner:(Banner *)Banner
{
    return 4;
}

//  图片资源
- (UIImage *)bannerView:(Banner *)bannerView imageInIndex:(NSUInteger)index {
    NSArray *ary = @[[UIImage imageNamed:@"1"], [UIImage imageNamed:@"2"], [UIImage imageNamed:@"3"],[UIImage imageNamed:@"4"]];
    return ary[index];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)SignInAction:(UIBarButtonItem *)sender {
    SigninViewController *sign = [Utilities getStoryboardInstanceByIdentity:@"Main" byIdentity:@"SignInVc"];
    [self.navigationController pushViewController:sign animated:YES];
}
- (IBAction)integralAction:(UIButton *)sender forEvent:(UIEvent *)event {
}

- (IBAction)orderAction:(UIButton *)sender forEvent:(UIEvent *)event {
}

- (IBAction)EarnpointsAction:(UIButton *)sender forEvent:(UIEvent *)event {
}
@end
