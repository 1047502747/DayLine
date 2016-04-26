//
//  PurchaseViewController.m
//  DayLine
//
//  Created by zxk on 16/4/23.
//  Copyright © 2016年 TianXingJian. All rights reserved.
//

#import "PurchaseViewController.h"
#import "TableViewCell.h"
#import "ActivityObject.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface PurchaseViewController (){
    NSInteger page;
    NSInteger perPage;
    NSInteger totalPage;
    BOOL isLoading;
}
@property(strong,nonatomic)NSMutableArray *objectsForShow;

@end

@implementation PurchaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//-(void)networkRequest{
//    _tableView.tableFooterView = [[UIView alloc] init];
//    NSString *request =  @"/goods/list";
//    //入参
//    NSDictionary *parameters = @{@"type":@2,@"page":@(page),@"perPage":@(perPage)};
//    
//    [RequestAPI getURL:request withParameters:parameters success:^(id responseObject) {
//        NSLog(@"result = %@",responseObject);
//        isLoading = NO;
//        [_avi stopAnimating];
//        [self endRefreshing];
//        if ([responseObject[@"resultFlag"] integerValue] == 8001) {
//            NSLog(@"成功");
//            //[[StorageMgr singletonStorageMgr] addKey:@"memberId" andValue:memberId];
//            NSDictionary *rootDict = responseObject[@"result"];
//            NSArray *dataArr = rootDict[@"models"];
//            if (page == 1) {
//                _objectsForShow = nil;
//                _objectsForShow = [NSMutableArray new];
//            }
//            for (NSDictionary *dict in dataArr) {
//                ActivityObject *activity = [[ActivityObject alloc]initWithDictionary:dict];
//                [_objectsForShow addObject:activity];
//            }
//            NSLog(@"_objectsForShow = %@", _objectsForShow);
//            [_tableView reloadData];
//            
//            NSDictionary *pagerDict = rootDict[@"pagingInfo"];
//            totalPage = [pagerDict[@"totalPage"] integerValue];
//            
//            
//        }else {
//            [Utilities popUpAlertViewWithMsg:@"请求错误" andTitle:nil onView:self];
//        }
//        
//    } failure:^(NSError *error) {
//        NSLog(@"Error = %@",error.description);
//        isLoading = NO;
//        [_avi stopAnimating];
//        [self endRefreshing];
//        [self loadDataEnd];
//        [Utilities popUpAlertViewWithMsg:@"error" andTitle:nil onView:self];
//        
//    }];
//    
//}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _objectsForShow.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    TableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    ActivityObject *activity = _objectsForShow[indexPath.row];
    NSURL *URL = [NSURL URLWithString:activity.imgUrl];
    
    [cell.imageView sd_setImageWithURL:URL placeholderImage:[UIImage imageNamed:@"First"]];
    //    NSLog(@"activity.imgUrl = %@",activity.imgUrl);
    cell.SPname.text = [NSString stringWithFormat:@"商品名称：%@",activity.spName];
    cell.integralLbl.text = [NSString stringWithFormat:@"所需积分：%@",activity.spScore];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


- (IBAction)PurchaseBut:(UIButton *)sender forEvent:(UIEvent *)event {
}
@end
