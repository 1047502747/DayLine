//
//  SigninViewController.m
//  DayLine
//
//  Created by zxk on 16/4/19.
//  Copyright © 2016年 TianXingJian. All rights reserved.
//

#import "SigninViewController.h"
#import "TableViewController.h"
#import "TabNavViewController.h"
@interface SigninViewController (){}

@end

@implementation SigninViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.hidden = YES;
    
    NSDictionary *dic = @{ @"deviceType" : @7001,
                           @"deviceId" : [Utilities uniqueVendor]};
    
    [RequestAPI getURL:@"/login/getKey" withParameters:dic success:^(id responseObject) {
        NSLog(@"responseOject:%@",responseObject);
        if ([responseObject[@"resultFlag"] integerValue] == 8001) {
            NSDictionary *dict = responseObject[@"result"];
            NSString *exponent = dict[@"exponent"];
            NSString *modulus = dict[@"modulus"];
            //从单例化全局变量中删除数据
            [[StorageMgr singletonStorageMgr]removeObjectForKey:@"exponent"];
            [[StorageMgr singletonStorageMgr]removeObjectForKey:@"modulus"];
            //将指数与模数存进单例化全局变量
            [[StorageMgr singletonStorageMgr] addKey:@"exponent" andValue:exponent];
            [[StorageMgr singletonStorageMgr] addKey:@"modulus" andValue:modulus];
        }
        
    } failure:^(NSError *error) {
        NSLog(@"error:%@",error.description);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)signInAction:(UIButton *)sender forEvent:(UIEvent *)event {
    //去单例化全局变量中拿指数与模数
    NSString *exponent = [[StorageMgr singletonStorageMgr] objectForKey:@"exponent"];
    NSString *modulus = [[StorageMgr singletonStorageMgr] objectForKey:@"modulus"];
    //将原始密码进行MD5加密
    NSString *md5Pwd = [_passwordTF.text getMD5_32BitString];
    //将MD5加密过后的密码进行RSA非对称加密
    NSString *rsaPwd = [NSString encryptWithPublicKeyFromModulusAndExponent:md5Pwd.UTF8String modulus:modulus exponent:exponent];
    NSDictionary *parameters = @{@"userName" :_usernameTF.text,
                                 @"password" :rsaPwd,
                                 @"deviceType" : @7001,
                                 @"deviceId" : [Utilities uniqueVendor]};
    
    
    [RequestAPI postURL:@"/login" withParameters:parameters success:^(id responseObject)
     {
         NSLog(@"responseOject:%@",responseObject);
         if ([responseObject[@"resultFlag"] integerValue] == 8001) {
             TableViewController *tab = [Utilities getStoryboardInstanceByIdentity:@"Main" byIdentity:@"Tab"];
             [self presentViewController:tab animated:YES completion:nil];
             
         }else{
             [Utilities popUpAlertViewWithMsg:@"用户名或密码错误" andTitle:nil onView:self];
         }
         
     } failure:^(NSError *error) {
         NSLog(@"error:%@",error.description);
     }];
}

- (IBAction)signUpAction:(UIButton *)sender forEvent:(UIEvent *)event {
}

- (IBAction)Visitor:(UIButton *)sender forEvent:(UIEvent *)event {
}
@end
