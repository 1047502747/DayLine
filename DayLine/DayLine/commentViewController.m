//
//  commentViewController.m
//  DayLine
//
//  Created by zxk on 16/5/6.
//  Copyright © 2016年 TianXingJian. All rights reserved.
//

#import "commentViewController.h"
#import "commentTableViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
@interface commentViewController ()
@property (strong, nonatomic) NSMutableArray *objectsForShow;
@property (strong, nonatomic) NSArray *replyObjectsForShow;
@property (strong, nonatomic) UIActivityIndicatorView *aiv;

@end

@implementation commentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
      [self refreshData];
    _objectsForShow = [NSMutableArray new];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//数据请求
- (void)refreshData {
    
    [_objectsForShow removeAllObjects];
    PFUser *currentUser = [PFUser currentUser];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"poster != %@", currentUser];
    PFQuery *query = [PFQuery queryWithClassName:@"Posts"];
    [query orderByDescending:@"updatedAt"];
    [query includeKey:@"poster"];
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        [_aiv stopAnimating];
        UIRefreshControl *rc = (UIRefreshControl *)[_tableview viewWithTag:10001];
        [rc endRefreshing];
        if (!error) {
            NSLog(@"objects = %@",objects);
            _objectsForShow = [NSMutableArray arrayWithArray:objects];
            
            [_tableview reloadData];
            
        }else{
            
            NSLog(@"Error: %@",error.userInfo);
            [Utilities popUpAlertViewWithMsg:@"请保持网络连接畅通" andTitle:nil onView:self];
        }
    }];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _objectsForShow.count;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    commentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    PFObject *obj = _objectsForShow[indexPath.row];
//    PFRelation *relationReply = [obj relationForKey:@"reply"];
//    PFQuery *replyQuery = [relationReply query];
//    [replyQuery includeKey:@"commenter"];
//    [replyQuery findObjectsInBackgroundWithBlock:^(NSArray * _Nullable replyObjects, NSError * _Nullable error) {
//        if (!error) {
//            _replyObjectsForShow = replyObjects;
//                        for (PFObject *replyObj in replyObjects ) {
//                          NSLog(@"reply = %@",replyObj[@"commenter"]);
//                            PFUser *user2 = replyObj[@"commenter"];
//                            NSLog(@"user2 = %@",user2[@"nickname"]);
//                        }
//            [_tableview reloadData];
//        } else {
//            NSLog(@"error = %@",error.userInfo);
//        }
//    }];
    
    
    
    //       PFObject *replyObj = _replyObjectsForShow[0];
    //        NSLog(@"reply = %@",replyObj[@"commenter"]);
    //        PFUser *user2 = replyObj[@"commenter"];
    //        NSLog(@"user2 = %@",user2[@"nickname"]);

    
    
    PFUser *user = obj[@"poster"];
    NSString *name = user[@"nickname"];
    NSString *content = obj[@"content"];
    NSNumber *praise = obj[@"praise"];
    NSString *date = obj.createdAt;
    self.navigationItem.title = user[@"name"];
    PFFile *photoFile = user[@"photo"];
    PFFile *photoFile2 = obj[@"photo"];
    NSString *photoURLStr = photoFile.url;
    NSString *photoURLStr2 = photoFile2.url;
    NSURL *photoURL = [NSURL URLWithString:photoURLStr];
    NSURL *photoURL2= [NSURL URLWithString:photoURLStr2];
    [cell.Userprofile sd_setImageWithURL:photoURL placeholderImage:[UIImage imageNamed:@"Default"]];
    [cell.Zambia sd_setImageWithURL:photoURL2 placeholderImage:[UIImage imageNamed:@"Default"]];
    cell.nickname.text = name;
    cell.Zambias.text = [NSString stringWithFormat:@"%@",praise];
//转换时间格式
    NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateString = [dateFormat stringFromDate:date];
    cell.time.text = dateString;
    cell.showcontents.text = content;
    return cell;
}

//设置cell的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 150;
}

@end
