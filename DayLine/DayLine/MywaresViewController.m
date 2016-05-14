//
//  MywaresViewController.m
//  DayLine
//
//  Created by zxk on 16/5/8.
//  Copyright © 2016年 TianXingJian. All rights reserved.
//

#import "MywaresViewController.h"
#import "ActivityObject.h"
#import "MyWaresTableViewCell.h"
@interface MywaresViewController (){
    NSInteger page;
    NSInteger perPage;
    NSInteger totalPage;
    BOOL isLoading;
}
@property(strong,nonatomic)NSMutableArray *objectsForShow;
@property (strong,nonatomic) UIActivityIndicatorView *avi;


@end

@implementation MywaresViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initializeData];
    [self naviConfiguration];
    [self uiConfiguaration];
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
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
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
    UILabel *loadMore = [self.TableView.tableFooterView viewWithTag:9001];
    //修改标签内容
    loadMore.text = @"已无更多数据";
    //重新设置标签位置（由于指示器被隐藏以后,标签位置就不能算居中了，所以需要更新）
    loadMore.frame = CGRectMake((UI_SCREEN_W - 120) / 2, 0, 120, 40);
    //根据9002
    UIActivityIndicatorView *footerAI = (UIActivityIndicatorView *)[self.TableView.tableFooterView viewWithTag:9002];
    //让指示器停转
    [footerAI stopAnimating];
    isLoading = NO;
    //之所以要过0.25秒再执行隐藏表格footer这个方法是因为我们希望给用户0.25秒时间可以看到“当前已无更多数据”这句话，这样才是一个更优秀的用户体验
    [self performSelector:@selector(loadDataEnd) withObject:nil afterDelay:0.25];
    
}

-(void)createTableFooter{
    //当为表格设置footer视图的时候，y值设置为0就表示纵向位置上紧贴着表格的底部
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.TableView.frame.size.width, 40)];
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
    self.TableView.tableFooterView =footerView;
    
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
    [self.TableView addSubview:refreshControl];
    
}
-(void)networkRequest{
    NSNumber *mId =[[StorageMgr singletonStorageMgr]objectForKey:@"memberId"];
    _TableView.tableFooterView = [[UIView alloc] init];
    NSString *request =  @"/stock/list";
    //入参
    NSDictionary *parameters = @{@"memberId":mId,@"page":@(page),@"perPage":@(perPage)};
    
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
            [_TableView reloadData];
            
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
        [Utilities popUpAlertViewWithMsg:@"请保持网络畅通" andTitle:nil onView:self];
        
    }];
    
}
//翻页结束
- (void)loadDataEnd {
    //将多余的下划线删除，其实将footer视图不存在位置，所以footer视图消失将隐藏
    self.TableView.tableFooterView = [[UIView alloc] init];
    
}
-(void)endRefreshing {
    UIRefreshControl *refreshControl = (UIRefreshControl *)[self.TableView viewWithTag:10001];
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
    
    MyWaresTableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
//    //乙方签署协议,每一个cell都签一个协议
//    cell.delegate = self;
//    cell.indexPath = indexPath;
    
    //下划线顶住屏幕
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        //下划线距离，边界缩进0
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
        //不保留间距
        [cell setPreservesSuperviewLayoutMargins:NO];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    
    ActivityObject *activity = _objectsForShow[indexPath.row];
    cell.TimeLbl.text = [NSString stringWithFormat:@"商品名称：%@",activity.spDate];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
//页面消失后执行
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    //[self.navigationController.viewControllers]将返回当前页面对应的导航系的层级关系，通过一个数组来维护（数组中按顺序存放着导航系中所有打开的页面）
    if (![[self.navigationController viewControllers] containsObject:self]) {
        //在这里释放所有监听（事件Action,协议Delegate,手势Gesture以及通知notification）
    }
}

//该方法是整个控制器最后会调用的方法，将会在viewDidDisappear：调用完毕后调用
//如果页面中还有未释放的监听，则该方法不会被调用
//内存的释放必须在该方法中执行，否则直接闪退
-(void)dealloc{
    //释放所有对象的内存(设为nil)
}
@end
