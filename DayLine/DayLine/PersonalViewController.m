//
//  PersonalViewController.m
//  DayLine
//
//  Created by zxk on 16/4/26.
//  Copyright © 2016年 TianXingJian. All rights reserved.
//

#import "PersonalViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "PersonalTableViewCell.h"
@interface PersonalViewController ()
@property (strong, nonatomic) NSMutableArray *objectsForShow;
@property (strong, nonatomic) UIActivityIndicatorView *aiv;
@end

@implementation PersonalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self refreshData];
//    _tableView.tableFooterView = [[UIView alloc] init];
//    UIRefreshControl *rc = [[UIRefreshControl alloc] init];
//    rc.tag = 10001;
//    rc.tintColor = [UIColor darkGrayColor];
//    [rc addTarget:self action:@selector(refreshData) forControlEvents:UIControlEventValueChanged];
//    [_tableView addSubview:rc];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(requestData) name:@"RefreshPost" object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (void)requestData {
    _aiv = [Utilities getCoverOnView:self.view];
    [self refreshData];
}



//数据请求
- (void)refreshData {
    
    [_objectsForShow removeAllObjects];
    PFUser *currentUser = [PFUser currentUser];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"poster = %@", currentUser];
    PFQuery *query = [PFQuery queryWithClassName:@"Posts"];
    [query orderByDescending:@"updatedAt"];
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
//    //在根视图上创建一朵菊花，并且让它转动
//    UIActivityIndicatorView *aiv = [Utilities getCoverOnView:self.view];
//    [aiv stopAnimating];
//    
    
    
//}
////翻页结束
//- (void)loadDataEnd {
//    //将多余的下划线删除，其实将footer视图不存在位置，所以footer视图消失将隐藏
//    self.tableView.tableFooterView = [[UIView alloc] init];
//}




- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _objectsForShow.count;
}




- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    PersonalTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    PFObject *obj = _objectsForShow[indexPath.row];
    PFUser *user = obj[@"poster"];
    NSString *name = user[@"nickname"];
    NSString *topic = obj[@"topic"];
    NSString *content = obj[@"content"];
    NSNumber *praise = obj[@"praise"];
    NSString *date = [NSString stringWithFormat:@"%@",obj.createdAt];
    self.navigationItem.title = user[@"name"];
    PFFile *photoFile = user[@"photo"];
    PFFile *photoFile2 = obj[@"photo"];
    NSString *photoURLStr = photoFile.url;
    NSString *photoURLStr2 = photoFile2.url;
    NSURL *photoURL = [NSURL URLWithString:photoURLStr];
    NSURL *photoURL2= [NSURL URLWithString:photoURLStr2];
    [cell.Homelmage sd_setImageWithURL:photoURL placeholderImage:[UIImage imageNamed:@"Default"]];
    [cell.HomepictureView sd_setImageWithURL:photoURL2 placeholderImage:[UIImage imageNamed:@"Default"]];
    cell.Homeusername.text = name;
    cell.HomenumberLbl.text = [NSString stringWithFormat:@"%@",praise];
    cell.Homepublishtime.text = date;
    cell.HomeshowView.text = topic;
    cell.Homecomment.text = content;
    
    return cell;
}


@end
