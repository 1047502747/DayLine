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
@property (strong, nonatomic) UIActivityIndicatorView *aiv;
@end

@implementation commentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
      [self refreshData];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    PFUser *user = obj[@"poster"];
    NSString *name = user[@"nickname"];

    NSNumber *praise = obj[@"praise"];
//    NSString *date = [NSString stringWithFormat:@"%@",obj.createdAt];
    self.navigationItem.title = user[@"name"];
    PFFile *photoFile = user[@"photo"];
    NSString *photoURLStr = photoFile.url;
    NSURL *photoURL = [NSURL URLWithString:photoURLStr];
    [cell.Userprofile sd_setImageWithURL:photoURL placeholderImage:[UIImage imageNamed:@"Default"]];

    cell.nickname.text = name;
    cell.Zambias.text = [NSString stringWithFormat:@"%@",praise];
//    cell.Homepublishtime.text = date;
//    cell.HomeshowView.text = topic;
//    cell.Homecomment.text = content;
    
    return cell;
}


@end
