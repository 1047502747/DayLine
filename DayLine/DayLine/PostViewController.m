//
//  PostViewController.m
//  DayLine
//
//  Created by zxk on 16/4/19.
//  Copyright © 2016年 TianXingJian. All rights reserved.
//
#import "ActivityObject2.h"
#import "PostViewController.h"
#import "testViewController.h"
#import "SigninViewController.h"
#import "commentViewController.h"
#import "dynamicTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "PublishViewController.h"
#import "PersonalViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
@interface PostViewController () <dynamicTableViewCellDelegate,UIScrollViewDelegate>
//协议第四步：乙方将协议摊开在自己面前（将协议引入本类）
{
    NSInteger page;
    NSInteger perPage;
    NSInteger totalPage;
    
    BOOL isLoading;
}

@property (strong, nonatomic) NSMutableArray *objectsForShow;
@property (strong, nonatomic) UIActivityIndicatorView *aiv;

@end

@implementation PostViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self refreshData];
    [self Monitor];
    [self naviConfiguration];
    [self uiConfiguaration];
    _objectsForShow = [NSMutableArray new];
    _tableView.tableFooterView = [[UIView alloc] init];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(requestData) name:@"RefreshPost" object:nil];
    // Do any additional setup after loading the view.
    
}


- (void)didReceiveMemoryWarning {
       [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



//检测是否登录了帐号
-(void)Monitor{
    NSNumber *memberId = [[StorageMgr singletonStorageMgr] objectForKey:@"memberId"];
    if ([memberId integerValue]==0) {
        NSString *msg = [NSString stringWithFormat:@"您还没有登录哦，请先登录在查看动态哦！"];
        //创建一个风格为UIAlertControllerStyleAlert的UIAlertController实例
        UIAlertController *alertView = [UIAlertController alertControllerWithTitle:@"提示" message:msg preferredStyle:UIAlertControllerStyleAlert];
        //创建“确认”按钮，风格为UIAlertActionStyleDefault
        UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            SigninViewController *tabVC = [Utilities getStoryboardInstanceByIdentity:@"Main" byIdentity:@"SignInVc"];
            [self.navigationController pushViewController:tabVC animated:YES];
        }];
            [alertView addAction:confirmAction];
            [self presentViewController:alertView animated:YES completion:nil];
            [self requestData];
        }
    }
- (void)requestData {
    _aiv = [Utilities getCoverOnView:self.view];
    [self refreshData];
  }





- (void)naviConfiguration{
//设置导航条标题的文字颜色
//通过字典来设置文字的属性，在以下属性中只设置了文字的前景色（NSForegroundColorAttributeName建对应的值来决定文字颜色）
    NSDictionary* textTitleOpt = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor darkGrayColor], NSForegroundColorAttributeName, nil];
//将上述文字属性字典设置到导航条标题文字中
    [self.navigationController.navigationBar setTitleTextAttributes:textTitleOpt];
//设置导航条的背景色
    self.navigationController.navigationBar.barTintColor = [UIColor blackColor];
//设置导航条中所有左上角或者右上角的按钮（Bar Button Itens）的文字或者图片颜色
    self.navigationController.navigationBar.tintColor = [UIColor darkGrayColor];
//设置导航条是否隐藏
    self.navigationController.navigationBar.hidden = NO;
//设置导航条有否有毛玻璃效果（类似半透明）
    [self.navigationController.navigationBar setTranslucent:YES];
    
}

//进入页面：菊花膜+初始数据（第一页数据）
- (void)initlalizeData {
    //刚来到页面进行数据初始化时将是否正在加载数据的指针设置为否
    isLoading = NO;
    
    perPage = 3;
    //在根视图上放置菊花膜并开始旋转
    _aiv = [Utilities getCoverOnView:self.view];
    [self refreshData];
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
        [self refreshData];
        
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
    loadMore.text = @"下拉刷新";
    
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


-(void)uiConfiguaration {
//初始化下拉刷新控件
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
//给下拉刷新控件添加下标
    refreshControl.tag = 10001;
//创建下拉刷新控件标题文字
    NSString *title = [NSString stringWithFormat:@"正在刷新"];
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
    refreshControl.tintColor = [UIColor blackColor];
//将下拉刷新控件的背景颜色设置为淡灰色
    refreshControl.backgroundColor = [UIColor groupTableViewBackgroundColor];
//定义当用户触发下拉事件时要执行的方法
    [refreshControl addTarget:self action:@selector(refreshData) forControlEvents:UIControlEventValueChanged];
//将下拉刷新控件添加到tableView中（在tableView中，下拉刷新控件会自动放置在表格视图顶部后侧位置）
    [self.tableView addSubview:refreshControl];
    
}

- (void)endRefreshing {
//在tableView中根据10001下标找到对应的视图（在这里10001对应的视图就是下拉刷新控件）（根据下标获得控件的方法必须指明在什么超视图中去寻找这个下标对应的子视图）
    UIRefreshControl *refreshControl = (UIRefreshControl *)[self.tableView viewWithTag:10001];
//将上面找到的下拉刷新控件停止刷新
    [refreshControl endRefreshing];
}

//数据请求
- (void)refreshData {
    
    [_objectsForShow removeAllObjects];
    PFUser *currentUser = [PFUser currentUser];
//  NSPredicate *predicate = [NSPredicate predicateWithFormat:@"poster != %@", currentUser];
    PFQuery *query = [PFQuery queryWithClassName:@"Posts"];
    [query orderByDescending:@"createdAt"];
    [query includeKey:@"poster"];
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        [_aiv stopAnimating];
        UIRefreshControl *rc = (UIRefreshControl *)[_tableView viewWithTag:10001];
        [rc endRefreshing];
        if (!error) {
            NSLog(@"objects = %@",objects);
            _objectsForShow = [NSMutableArray arrayWithArray:objects];
            [_tableView reloadData];
            
        }else{
            
            NSLog(@"Error: %@",error.userInfo);
            [Utilities popUpAlertViewWithMsg:@"请保持网络连接畅通" andTitle:nil onView:self];
        }
    }];

    
}



//翻页结束
- (void)loadDataEnd {
//将多余的下划线删除，其实将footer视图不存在位置，所以footer视图消失将隐藏
    self.tableView.tableFooterView = [[UIView alloc] init];
}




- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _objectsForShow.count;
}




- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
   dynamicTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    PFObject *obj = _objectsForShow[indexPath.row];
    PFUser *user = obj[@"poster"];
    NSString *name = user[@"nickname"];
    NSString *topic = obj[@"topic"];
    NSString *content = obj[@"content"];
    NSNumber *praise = obj[@"praise"];
    NSDate *date = obj.createdAt;
    self.navigationItem.title = user[@"name"];
    PFFile *photoFile = user[@"photo"];
    PFFile *photoFile2 = obj[@"photo"];
    NSString *photoURLStr = photoFile.url;
    NSString *photoURLStr2 = photoFile2.url;
    NSURL *photoURL = [NSURL URLWithString:photoURLStr];
    NSURL *photoURL2= [NSURL URLWithString:photoURLStr2];
    [cell.lmageportrait sd_setImageWithURL:photoURL placeholderImage:[UIImage imageNamed:@"Default"]];
    [cell.pictureView sd_setImageWithURL:photoURL2 placeholderImage:[UIImage imageNamed:@"Default"]];
    cell.username.text = name;
    cell.NumberLbl.text = [NSString stringWithFormat:@"%@",praise];
    NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateString = [dateFormat stringFromDate:date];
    cell.publishtime.text = dateString;
    cell.showView.text = topic;

    
//协议第五步：乙方签字（被委托方声明将对协议负责）
    cell.delegate = self;
    cell.indexPath = indexPath;
    return cell;
}



//查看某个用户的动态
- (void)applyAction:(NSIndexPath *)indexPath {
     PFObject *posts = _objectsForShow[indexPath.row];
    PersonalViewController *tabVC = [Utilities getStoryboardInstanceByIdentity:@"Main" byIdentity:@"A"];
//    tabVC.posts = posts;
    [self.navigationController pushViewController:tabVC animated:YES];
    
    
}

//- (void)cellLongPressAtIndexPath:(NSIndexPath *)indexPath{
//    //根据indexPath获得当前被按按钮对应的细胞的行所对应的活动数据
//    ActivityObject2 *activity = [_objectsForShow objectAtIndex:indexPath.row];
//    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:@"复制操作" message:@"复制活动名称或内容" preferredStyle:UIAlertControllerStyleActionSheet];
//    UIAlertAction *copyNameAction = [UIAlertAction actionWithTitle:@"复制用户ID" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
//        //创建复制板
//        UIPasteboard *pasteBoard = [UIPasteboard generalPasteboard];
//        //将活动名称复制
//        [pasteBoard setString:activity.name];
//    }];
//    UIAlertAction *copyContentAction = [UIAlertAction actionWithTitle:@"复制话题内容" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
//        UIPasteboard *pasteBoard = [UIPasteboard generalPasteboard];
//        [pasteBoard setString:activity.content];
//    }];
//    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
//    //在UIAlertControllerStyleActionSheet风格中，先加入UIAlertController的UIAlertAction对象会出现在越上方（自上而下排列），UIAlertActionStyleCancel风格的UIAlertAction对象会出现在最下方并与其他UIAlertAction对象空开一段间距
//    [actionSheet addAction:copyNameAction];
//    [actionSheet addAction:copyContentAction];
//    [actionSheet addAction:cancelAction];
//    [self presentViewController:actionSheet animated:YES completion:nil];
//}



//- (void)photoTapAtIndexPath:(NSIndexPath *)indexPath{
//    
//    ActivityObject2 *activity = [_objectsForShow objectAtIndex:indexPath.row];
//    _zoomIV = [[UIImageView alloc] initWithFrame:[UIScreen mainScreen].bounds];
//    _zoomIV.userInteractionEnabled = YES;
//    _zoomIV.backgroundColor = [UIColor blackColor];
//    //_zoomIV.image = [self imageUrl:activity.imgUrl];
//    //使用SD所写的这一行代码，看似比我们上面注释掉的那一行代码复杂，但是我们上面自己写的那一行代码执行的是同步加载，而SD执行的是异步加载，同步加载在加载过程中会锁死页面而异步不会
//    [_zoomIV sd_setImageWithURL:[NSURL URLWithString:activity.imgUrl] placeholderImage:[UIImage imageNamed:@"Image"]];
//    _zoomIV.contentMode = UIViewContentModeScaleAspectFit;
//    //[UIApplication sharedApplication]获得当前APP的实例，keyWindow方法可以拿到APP实例的主窗口
//    [[UIApplication sharedApplication].keyWindow addSubview:_zoomIV];
//    
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(zoomTap:)];
//    [_zoomIV addGestureRecognizer:tap];
//}



//跳转评论页面
- (void)applyAction2:(NSIndexPath *)indexPath {
    PFObject *post = _objectsForShow[indexPath.row];
    commentViewController *tabVC2 = [Utilities getStoryboardInstanceByIdentity:@"Main" byIdentity:@"B"];
    tabVC2.post = post;
    [self.navigationController pushViewController:tabVC2 animated:YES];
    
    
}


//评论帖子
- (void)applyAction3:(NSIndexPath *)indexPath {
    PFObject *post = _objectsForShow[indexPath.row];
    
    NSString *content = _reply[@"reply"];
//创建一个风格为UIAlertControllerStyleAlert的UIAlertController实例
    UIAlertController *alertView = [UIAlertController alertControllerWithTitle:content.floatValue != 0 ? @"评论" : @"" message:@"请输入您要评论的内容" preferredStyle:UIAlertControllerStyleAlert];
//创建“确认”按钮，风格为UIAlertActionStyleDefault
    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
//获取弹出框上文本输入框的实例（由于弹出框上只有一个文本输入框，因此我们从文本输入框列表中提取第一个就是这个我们要的文本输入框）
        UITextField *textField = alertView.textFields.firstObject;
        NSString *content = textField.text;
//判断评论是否为空 ，空的话则不做按钮事件。
        if ([textField.text isEqualToString:@""]) {
            NSLog(@"NONE");
            return;
        }
        PFObject *reply = [PFObject objectWithClassName:@"Reply"];
        reply[@"content"] = content;
        PFUser *currentUser = [PFUser currentUser];
        reply[@"commenter"] = currentUser;
        reply[@"post"] = post;
        self.navigationController.view.userInteractionEnabled = NO;
        UIActivityIndicatorView *aiv = [Utilities getCoverOnView:self.view];
        [reply saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        self.navigationController.view.userInteractionEnabled = YES;
        [aiv stopAnimating];
        if (succeeded) {
//创建刷新“我的”页面的通知
            commentViewController *tabVC2 = [Utilities getStoryboardInstanceByIdentity:@"Main" byIdentity:@"B"];
            [self.navigationController pushViewController:tabVC2 animated:YES];
            } else {
        [Utilities popUpAlertViewWithMsg:@"当前上传用户有点多哦，请稍候再试" andTitle:nil onView:self ];
                         }
                }];
       }];
    
//创建“取消”按钮，风格为UIAlertActionStyleCancel
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
//将以上两个按钮添加进弹出窗（按钮添加的顺序决定按钮的排版：从左到右；从上到下。如果是取消风格UIAlertActionStyleCancel的按钮会放在最左边）
    [alertView addAction:confirmAction];
    [alertView addAction:cancelAction];
//添加一个文本输入框
    [alertView addTextFieldWithConfigurationHandler:^(UITextField *textField) {
    textField.delegate = NULL;
    textField.keyboardType = UIKeyboardTypeNamePhonePad;
//用present modal的方式跳转到另一个页面（显示alertView）
    [self presentViewController:alertView animated:YES completion:nil];
                 }
           ];
     }







//点赞
- (void)applyAction4:(NSIndexPath *)indexPath {
    
    
    
}
#pragma mark - Navigation

//// In a storyboard-based application, you will often want to do a little preparation before navigation
//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//
//    if ([segue.identifier isEqualToString:@"Publish"]) {
//        NSIndexPath *indexPath = _tableView.indexPathForSelectedRow;
//        PFObject *posts = _objectsForShow[indexPath.row];
//        PFObject *photo2 = _objectsForShow[indexPath.row];
//        PublishViewController *cdVC = segue.destinationViewController;
//        PublishViewController *bdVC = segue.destinationViewController;
//        bdVC.photo2 = photo2;
//        cdVC.posts = posts;
//    }
//    
//}
//


@end
