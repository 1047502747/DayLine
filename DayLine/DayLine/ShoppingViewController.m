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
@interface ShoppingViewController ()<ActivityTableViewCellDelegate,UIScrollViewDelegate>
{
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
//    [self hdintegral];

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

//关于scrollview的协议，当手指已经停止拖拽并且惯性正好完全抵消时调用方法（如果你的拖拽是没有惯性因素的则当手指离开屏幕的一瞬间调用）
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    //当内容高度大于框架高度时执行if中的操作，反之执行else中的操作(两种情况下判断是否上拉的方式是不同的)
    if (scrollView.contentSize.height +64 > scrollView.frame.size.height) {
        //当内容高度大于框架高度的情况下，如果Y轴方向的offset值加上框架高度的和大于内容高度时说明上拉了
        if (!isLoading && scrollView.contentOffset.y + scrollView.frame.size.height > scrollView.contentSize.height) {
            NSLog(@"上拉啦");
            [self loadDataBegi];
        }
    }else{
        //当框架高度大于内容高度的情况下，如果Y轴方向的offset缩大与0则说明上拉了
        if (!isLoading && scrollView.contentOffset.y > -64) {
            NSLog(@"上拉啦");
            [self loadDataBegi];
        }
    }
}

//做上拉翻页的页面准备工作
-(void)loadDataBegi{
    //上拉开始执行了就必须将isLoading属性设置为YES，这样才能保证在这个上拉操作真正完全完成以前不会有别的操作对它产生干扰
    isLoading = YES;
    [self createTableFooter];
    [self loadDataing];
}
//开始加载新一页数据
-(void)loadDataing{
    //判断是否还存在下一页
    if (totalPage >page) {
        //翻页
        page ++;
        //页码设置正确以后，直接去请求新的数据
        [self networkRequest];
        
    }else{
        [self beforeLoadEnd];
    }
}

//在没有下一页的情况下，告诉用户当前已无更多数据
-(void)beforeLoadEnd{
    //根据9001下标拿到表格的footer视图上的标签
    UILabel *loadMore = [self.tableView.tableFooterView viewWithTag:9001];
    //修改标签内容
    loadMore.text = @"已无更多数据";
    //重新设置标签位置（由于指示器被隐藏以后,标签位置就不能算居中了，所以需要更新）
    loadMore.frame = CGRectMake((UI_SCREEN_W - 120) / 2, 0, 120, 40);
    //根据9002
    UIActivityIndicatorView *footerAI = (UIActivityIndicatorView *)[self.tableView.tableFooterView viewWithTag:9002];
    //让指示器停转
    [footerAI stopAnimating];
    isLoading = NO;
    //之所以要过0.25秒再执行隐藏表格footer这个方法是因为我们希望给用户0.25秒时间可以看到“当前已无更多数据”这句话，这样才是一个更优秀的用户体验
    [self performSelector:@selector(loadDataEnd) withObject:nil afterDelay:0.25];
    
}

-(void)createTableFooter{
    //当为表格设置footer视图的时候，y值设置为0就表示纵向位置上紧贴着表格的底部
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 40)];
    //创建一个标签作为加载中状态的文字提示
    UILabel *loadMore = [[UILabel alloc] initWithFrame:CGRectMake((UI_SCREEN_W - 90)/2, 0, 116, 40)];
    loadMore.textAlignment = NSTextAlignmentCenter;
    //给标签加上9001的下标
    loadMore.tag = 9001;
    loadMore.text = @"玩命加载中...";
    
    //footerView.backgroundColor = [UIColor blueColor];
    //将标签的文字字体设置为B_Font大小的系统字体（B_Font表示15号字体：这是由于我们在Constants常量包中已经做好过该设置）
    loadMore.font = [UIFont systemFontOfSize:B_Font];
    //将该标签放置于表格的footer视图上
    [footerView addSubview:loadMore];
    //创建一个指示器作为加载中状态的图示提示
    UIActivityIndicatorView *footerAI = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake((UI_SCREEN_W - 90)/2 - 30, 10, 20, 20)];
    
    footerAI.tag = 9002;
    //将指示器（菊花）的颜色从默认的白色改为灰色
    footerAI.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    //让指示器开始旋转
    [footerAI startAnimating];
    //将该指示器放置于表格的footer视图上
    [footerView addSubview:footerAI];
    
    //将上述footer视图添加到表格中
    self.tableView.tableFooterView =footerView;
    
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
        [self endRefreshing];
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

//-(void)hdintegral{
//    NSString *path = @"/score/memberScore";
//    NSDictionary *dic =@{
//                         @"memberId":_numID
//                         };
//    [RequestAPI getURL:path withParameters:dic success:^(id responseObject) {
//        NSLog(@"result:%@",responseObject);
//        if ([responseObject[@"resultFlag"] integerValue] == 8001) {
//            NSLog(@"成功");
//            
//        }
//    } failure:^(NSError *error) {
//        NSLog(@"error: %@",error.description);
//    }];
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
    cell.commodityID.text = [NSString stringWithFormat:@"商品ID：%@",activity.spId];
    cell.quantity.text = [NSString stringWithFormat:@"剩余数量：%@",activity.spAmount];
    cell.integralLbl.text = [NSString stringWithFormat:@"所需积分：%@",activity.spScore];
       return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)applyAction:(NSIndexPath *)indexPath{
    //创建一个风格为UIAlertControllerStyleAlert的UIAlertController实例
    ActivityObject * activity = _objectsForShow[indexPath.row];
    UIAlertController *alertView = [UIAlertController alertControllerWithTitle:@"Tip" message:activity.isApplied ? @"是否确定取消报名？" : @"是否确定报名？" preferredStyle:UIAlertControllerStyleAlert];
    //创建“确认”按钮，风格为UIAlertActionStyleDefault
    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"对的" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        activity.isApplied = !activity.isApplied;
        //刷新当前行
        //更新改变了活动报名状态的数据对应的细胞
        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }];
    //创建“取消”按钮，风格为UIAlertActionStyleCancel
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"不要" style:UIAlertActionStyleCancel handler:nil];
    //将以上两个按钮添加进弹出窗（按钮添加的顺序决定按钮的排版：从左到右；从上到下。如果是取消风格UIAlertActionStyleCancel的按钮会放在最左边）
    [alertView addAction:confirmAction];
    [alertView addAction:cancelAction];
    //用present modal的方式跳转到另一个页面（显示alertView）
    [self presentViewController:alertView animated:YES completion:nil];
}

-(void)cellLongPressAtIndexPath:(NSIndexPath *)indexPath{
    ActivityObject * activity = _objectsForShow[indexPath.row];
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:@"复制操作" message:@"复制活动名称或内容?" preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *copyNameAction = [UIAlertAction actionWithTitle:@"复制活动名称" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        //创建复制板
        UIPasteboard *pasteBoard = [UIPasteboard generalPasteboard];
        //将活动名称复制
        [pasteBoard setString:activity.spName];
    }];
    UIAlertAction *copyContentAction = [UIAlertAction actionWithTitle:@"复制活动内容" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        UIPasteboard *pasteBoard = [UIPasteboard generalPasteboard];
        [pasteBoard setString:activity.spId];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    //在UIAlertControllerStyleActionSheet风格中，先加入UIAlertController的UIAlertAction对象会出现在越上方（自上而下排列），UIAlertActionStyleCancel风格的UIAlertAction对象会出现在最下方并与其他UIAlertAction对象空开一段间距
    [actionSheet addAction:copyNameAction];
    [actionSheet addAction:copyContentAction];
    [actionSheet addAction:cancelAction];
    [self presentViewController:actionSheet animated:YES completion:nil];
}

- (void)photoTapAtIndexPath:(NSIndexPath *)indexPath{
    ActivityObject *activity = [_objectsForShow objectAtIndex:indexPath.row];
    //获取屏幕的实例UIScreen mainScreen，bounds屏幕的边界
    _zoomIV = [[UIImageView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    _zoomIV.userInteractionEnabled = YES;
    _zoomIV.backgroundColor = [UIColor blackColor];
    //_zoomIV.image = [self imageUrl:activity.imgUrl];
    //使用SD所写的这一行代码，看似比我们上面注释掉的那一行代码复杂，但是我们上面自己写的那一行代码执行的是同步加载，而SD执行的是异步加载，同步加载在加载过程中会锁死页面而异步不会
    [_zoomIV sd_setImageWithURL:[NSURL URLWithString:activity.imgUrl] placeholderImage:[UIImage imageNamed:@"Image"]];
    _zoomIV.contentMode = UIViewContentModeScaleAspectFit;
    //添加到windows层视图(所有视图都有),不能放到根视图，因为tableview不能放其他控件，只能放细胞
    //[UIApplication sharedApplication]获得当前app的实例，keyWindow可以拿到app实例的主窗口
    [[UIApplication sharedApplication].keyWindow addSubview:_zoomIV];
    //手势
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(zoomTap:)];
    [_zoomIV addGestureRecognizer:tap];
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
