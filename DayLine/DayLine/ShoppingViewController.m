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
#import "TableViewCell.h"
#import "ActivityObject.h"
#import <SDWebImage/UIImageView+WebCache.h>
@interface ShoppingViewController (){
    NSInteger page;
    NSInteger perPage;
    NSInteger totalPage;
    BOOL isLoading;
}
@property(strong,nonatomic)NSMutableArray *objectsForShow;
@property (strong,nonatomic) UIActivityIndicatorView *avi;

@end

@implementation ShoppingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initializeData];
    [self naviConfiguration];
    [self uiConfiguaration];

//    self.navigationController.navigationBar.hidden = YES;
    CGSize size = [UIScreen mainScreen].bounds.size;
    
    Banner *bv = [[Banner alloc]init];
    bv.frame = CGRectMake(0,115, size.width, 110);
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

-(void)naviConfiguration {
    //通过字典来射中文字的属性，在以下属性中只对应的值决定文字的颜色
    NSDictionary* textTitleOpt = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor darkGrayColor], NSForegroundColorAttributeName, nil];
    //将上述文字属性字典设置到导航条标题文字中
    [self.navigationController.navigationBar setTitleTextAttributes:textTitleOpt];
    //设置导航条的背景色
    self.navigationController.navigationBar.barTintColor = [UIColor orangeColor];
    //设置导航条中所有左上角或者右上角按钮（bar Button Items）的文字后者图片颜色
    self.navigationController.navigationBar.tintColor = [UIColor darkGrayColor];
    //设置导航条是否隐藏
    self.navigationController.navigationBar.hidden = NO;
    //设置导航条
    [self.navigationController.navigationBar setTranslucent:YES];
}

-(void)initializeData {
    isLoading = NO;
    perPage = 5;
    _avi = [Utilities getCoverOnView:self.view];
    
    [self refreshData];
}
-(void)refreshData {
    if (!isLoading) {
        isLoading = YES;
        page = 1;
        
        [self networkRequest];
    }else {
        [self endRefreshing];
    }
}

-(void)uiConfiguaration {
    //初始化下拉刷新控件
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    //给下拉刷新控件添加下标
    refreshControl.tag = 10001;
    //创建下拉刷新控件标题文字
    NSString *title = [NSString stringWithFormat:@"努力加载中"];
    NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle]mutableCopy];
    [style setAlignment:NSTextAlignmentCenter];
    [style setLineBreakMode:NSLineBreakByTruncatingTail];
    NSDictionary *attrsDictionary = @{NSUnderlineStyleAttributeName:@(NSUnderlineStyleNone),
                                      NSFontAttributeName:[UIFont preferredFontForTextStyle:UIFontTextStyleBody],
                                      NSParagraphStyleAttributeName:style,
                                      NSForegroundColorAttributeName:[UIColor brownColor]};
    NSAttributedString *attributedTitle = [[NSAttributedString alloc] initWithString:title attributes:attrsDictionary];
    refreshControl.attributedTitle = attributedTitle;
    //将下拉刷新控件的风格颜色设置为棕色（风格颜色：刷新指示器的颜色）
    refreshControl.tintColor = [UIColor brownColor];
    //将下拉刷新控件的背景颜色设置为淡灰色
    refreshControl.backgroundColor = [UIColor groupTableViewBackgroundColor];
    //定义当用户触发下拉事件时要执行的方法
    [refreshControl addTarget:self action:@selector(refreshData) forControlEvents:UIControlEventValueChanged];
    //将下拉刷新控件添加到tableView中（在tableView中，下拉刷新控件会自动放置在表格视图顶部后侧位置）
    [self.tableView addSubview:refreshControl];
    
}
-(void)networkRequest{
    _tableView.tableFooterView = [[UIView alloc] init];
    NSString *request =  @"/goods/list";
    //入参
    NSDictionary *parameters = @{@"type":@2,@"page":@(page),@"perPage":@(perPage)};
    
    [RequestAPI getURL:request withParameters:parameters success:^(id responseObject) {
        NSLog(@"result = %@",responseObject);
        isLoading = NO;
        [_avi stopAnimating];
        if ([responseObject[@"resultFlag"] integerValue] == 8001) {
            NSLog(@"成功");
            //[[StorageMgr singletonStorageMgr] addKey:@"memberId" andValue:memberId];
            NSDictionary *rootDict = responseObject[@"result"];
            NSArray *dataArr = rootDict[@"models"];
            if (page == 1) {
                _objectsForShow = nil;
                _objectsForShow = [NSMutableArray new];
            }
            for (NSDictionary *dict in dataArr) {
                ActivityObject *activity = [[ActivityObject alloc]initWithDictionary:dict];
                [_objectsForShow addObject:activity];
            }
            NSLog(@"_objectsForShow = %@", _objectsForShow);
            [_tableView reloadData];
            
            NSDictionary *pagerDict = rootDict[@"pagingInfo"];
            totalPage = [pagerDict[@"totalPage"] integerValue];
            
            
        }else {
            [Utilities popUpAlertViewWithMsg:@"请求错误" andTitle:nil onView:self];
        }
        
    } failure:^(NSError *error) {
        NSLog(@"Error = %@",error.description);
        isLoading = NO;
        [_avi stopAnimating];
        [self endRefreshing];
        [self loadDataEnd];
        [Utilities popUpAlertViewWithMsg:@"error" andTitle:nil onView:self];
        
    }];
    
}
//翻页结束
- (void)loadDataEnd {
    //将多余的下划线删除，其实将footer视图不存在位置，所以footer视图消失将隐藏
    self.tableView.tableFooterView = [[UIView alloc] init];
    
}
-(void)endRefreshing {
    UIRefreshControl *refreshControl = (UIRefreshControl *)[self.tableView viewWithTag:10001];
    [refreshControl endRefreshing];
}

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
    cell.commodityID.text = [NSString stringWithFormat:@"商品ID：%@",activity.spId];
    cell.surplus.text = [NSString stringWithFormat:@"剩余数量：%@",activity.spAmount];
    cell.integralLbl.text = [NSString stringWithFormat:@"所需积分：%@",activity.spScore];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}




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
