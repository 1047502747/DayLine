//
//  SigninViewController.m
//  DayLine
//
//  Created by zxk on 16/4/19.
//  Copyright © 2016年 TianXingJian. All rights reserved.
//

#import "SigninViewController.h"
#import "TableViewController.h"

@interface SigninViewController ()
@property (strong, nonatomic) UIActivityIndicatorView *aiv;
@end

@implementation SigninViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[StorageMgr singletonStorageMgr] addKey:@"SignUpSuccessfully" andValue:@NO];
    self.navigationController.navigationBar.hidden = YES;
}



//每一次这个页面出现的时候都会调用这个方法，并且时机点是页面将要出现之前
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //判断是否记忆了用户名
    if (![[Utilities getUserDefaults:@"Username"] isKindOfClass:[NSNull class]]) {
        //如果有记忆就把记忆显示在用户名文本输入框中
        _usernameTF.text = [Utilities getUserDefaults:@"Username"];
    }
}



//每一次这个页面出现的时候都会调用这个方法，并且时机点是页面已然出现以后
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    //判断是否是从注册页面注册成功后回到的这个登录页面
    if ([[[StorageMgr singletonStorageMgr] objectForKey:@"SignUpSuccessfully"] boolValue]) {
        //在自动登录前将flag恢复为默认的NO
        [[StorageMgr singletonStorageMgr] removeObjectForKey:@"SignUpSuccessfully"];
        [[StorageMgr singletonStorageMgr] addKey:@"SignUpSuccessfully" andValue:@NO];
        //从单例化全局变量中提取用户名和密码
        NSString *username = [[StorageMgr singletonStorageMgr] objectForKey:@"Username"];
        NSString *password = [[StorageMgr singletonStorageMgr] objectForKey:@"Password"];
        //清除用完的用户名和密码
        [[StorageMgr singletonStorageMgr] removeObjectForKey:@"Username"];
        [[StorageMgr singletonStorageMgr] removeObjectForKey:@"Password"];
        //执行自动登录
        [self signInWithUsername:username andPassword:password];
    }
}



- (void)popUpShopping {
    //根据故事版的名称和故事版中页面的名称获得这个页面
    TableViewController *tabVC = [Utilities getStoryboardInstanceByIdentity:@"Main" byIdentity:@"Tab"];
    //modal方式跳转到上述页面
    [self presentViewController:tabVC animated:YES completion:nil];
    //使用push方法 跳入TabBar [self.navigationController pushViewController:tabVC animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



//封装登录操作
- (void)signInWithUsername:(NSString *)username andPassword:(NSString *)password {
    //开始登录
    [PFUser logInWithUsernameInBackground:username password:password block:^(PFUser *user, NSError *error) {
        //登录完成的回调
        [_aiv stopAnimating];
        //判断登录是否成功
        if (user) {
            NSLog(@"登录成功");
            //记忆用户名
            [Utilities setUserDefaults:@"Username" content:username];
            //将密码文本输入框中的内容清掉
            _passwordTF.text = @"";
            //跳转到首页
            [self popUpShopping];
        } else {
            switch (error.code) {
                case 101:
                    [Utilities popUpAlertViewWithMsg:@"用户名或密码错误" andTitle:nil onView:self];
                    break;
                case 100:
                    [Utilities popUpAlertViewWithMsg:@"网络不给力，请稍候再试" andTitle:nil onView:self];
                    break;
                default:
                    [Utilities popUpAlertViewWithMsg:@"服务器正在维护，请稍候再试" andTitle:nil onView:self];
                    break;
            }
        }
    }];
}




- (IBAction)signInAction:(UIButton *)sender forEvent:(UIEvent *)event {
    if (_usernameTF.text.length == 0 || _passwordTF.text.length == 0) {
        [Utilities popUpAlertViewWithMsg:@"请填写所有信息" andTitle:nil onView:self];
        return;
    }
    
    NSDictionary *dic = @{ @"deviceType" : @7001,
                           @"deviceId" : [Utilities uniqueVendor]};
    
    _aiv = [Utilities getCoverOnView:self.view];
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
            
            //去单例化全局变量中拿指数与模数
            //            NSString *exponent = [[StorageMgr singletonStorageMgr] objectForKey:@"exponent"];
            //            NSString *modulus = [[StorageMgr singletonStorageMgr] objectForKey:@"modulus"];
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
                     NSDictionary *dict = responseObject[@"result"];
                     NSString *memberId = dict[@"memberId"];
                     [[StorageMgr singletonStorageMgr] addKey:@"memberId" andValue:memberId];
                     //执行登录
                     [self signInWithUsername:_usernameTF.text andPassword:_passwordTF.text];
                     //[self popUpMall];
                 }else{
                     [_aiv stopAnimating];
                     [Utilities popUpAlertViewWithMsg:@"用户名或密码错误" andTitle:nil onView:self];
                 }
                 
             } failure:^(NSError *error) {
                 NSLog(@"error:%@",error.description);
             }];
        } else {
            [_aiv stopAnimating];
        }
    } failure:^(NSError *error) {
        NSLog(@"error:%@",error.description);
    }];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}



- (IBAction)signUpAction:(UIButton *)sender forEvent:(UIEvent *)event {
}

- (IBAction)Visitor:(UIButton *)sender forEvent:(UIEvent *)event {
}
@end
