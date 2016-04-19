//
//  ShoppingViewController.m
//  DayLine
//
//  Created by zxk on 16/4/19.
//  Copyright © 2016年 TianXingJian. All rights reserved.
//

#import "ShoppingViewController.h"
#import "SigninViewController.h"
@interface ShoppingViewController ()

@end

@implementation ShoppingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.navigationController.navigationBar.hidden = YES;
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
@end
