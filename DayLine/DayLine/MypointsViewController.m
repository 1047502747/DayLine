//
//  MypointsViewController.m
//  DayLine
//
//  Created by zxk on 16/4/23.
//  Copyright © 2016年 TianXingJian. All rights reserved.
//

#import "MypointsViewController.h"
#import "ActivityObject.h"

@interface MypointsViewController ()


@end

@implementation MypointsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self integale];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)integale{
    NSNumber *meID =[[StorageMgr singletonStorageMgr] objectForKey:@"memberId"];
    
    if ([meID integerValue]==0) {
        [Utilities popUpAlertViewWithMsg:@"请登录账号" andTitle:nil onView:self];
        return;
    }else{
        NSString * peth =@"/score/memberScore";
        NSDictionary*dic =@{
                            @"memberId":meID                    };
        [RequestAPI getURL:peth withParameters:dic success:^(id responseObject) {
            if ([responseObject[@"resultFlag"]integerValue] == 8001) {
                
                NSNumber *ing = responseObject[@"result"];
                [[StorageMgr singletonStorageMgr]addKey:@"integale" andValue:ing];
                
                NSString *inG = [NSString stringWithFormat:@"积分：%@",ing];
                _pointsLbl.text = inG;
            }
            
        } failure:^(NSError *error) {
            NSLog(@"error :%@",error.description);
        }];
        
    }
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)RechargeBut:(UIButton *)sender forEvent:(UIEvent *)event {
}

- (IBAction)incomeBut:(UIButton *)sender forEvent:(UIEvent *)event {
}

- (IBAction)expenditureBut:(UIButton *)sender forEvent:(UIEvent *)event {
}

- (IBAction)ObtainBut:(UIButton *)sender forEvent:(UIEvent *)event {
}
@end
