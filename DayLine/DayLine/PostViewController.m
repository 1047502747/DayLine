//
//  PostViewController.m
//  DayLine
//
//  Created by zxk on 16/4/19.
//  Copyright © 2016年 TianXingJian. All rights reserved.
//

#import "PostViewController.h"
#import "dynamicTableViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "PublishViewController.h"

@interface PostViewController ()
@property (strong, nonatomic) NSMutableArray *objectsForShow;
@property (strong, nonatomic) UIActivityIndicatorView *aiv;

@end

@implementation PostViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self refreshData];
    _tableView.tableFooterView = [[UIView alloc] init];
    UIRefreshControl *rc = [[UIRefreshControl alloc] init];
    rc.tag = 10001;
    rc.tintColor = [UIColor darkGrayColor];
    [rc addTarget:self action:@selector(refreshData) forControlEvents:UIControlEventValueChanged];
    [_tableView addSubview:rc];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(requestData) name:@"RefreshPost" object:nil];
    // Do any additional setup after loading the view.
    
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
    
//    让导航条失去交互能力
//    self.navigationController.view.userInteractionEnabled = NO;
//在根视图上创建一朵菊花，并且让它转动
    UIActivityIndicatorView *aiv = [Utilities getCoverOnView:self.view];
    [aiv stopAnimating];
    
    
    
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
//    NSString *nickname = user[@"commenter"];
    NSNumber *praise = obj[@"praise"];
    NSString *date = [NSString stringWithFormat:@"%@",obj.createdAt];
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
    cell.publishtime.text = date;
    cell.showView.text = topic;
    cell.comment.text = content;
    
   
    return cell;
}




#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

    if ([segue.identifier isEqualToString:@"Publish"]) {
        NSIndexPath *indexPath = _tableView.indexPathForSelectedRow;
        PFObject *posts = _objectsForShow[indexPath.row];
        PFObject *photo2 = _objectsForShow[indexPath.row];
        PublishViewController *cdVC = segue.destinationViewController;
        PublishViewController *bdVC = segue.destinationViewController;
        bdVC.photo2 = photo2;
        cdVC.posts = posts;
    }
    
}


- (IBAction)pickAction:(UITapGestureRecognizer *)sender {
}
@end
