//
//  testViewController.m
//  DayLine
//
//  Created by admin2 on 16/5/7.
//  Copyright © 2016年 TianXingJian. All rights reserved.
//

#import "testViewController.h"

@implementation testViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self relation];
}

- (void)relation {
    PFQuery *query1 = [PFQuery queryWithClassName:@"Posts"];
    [query1 findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects1, NSError * _Nullable error) {
        if (!error) {
            PFObject *postObj = objects1.firstObject;
            NSLog(@"%@",postObj[@"topic"]);
            PFRelation *relationReply = [postObj relationForKey:@"reply"];
            
            PFQuery *query2 = [PFQuery queryWithClassName:@"Reply"];
            [query2 findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects2, NSError * _Nullable error) {
                if (!error) {
                    for (int i = 0; i < 3; i++) {
                        PFObject *obj = objects2[i];
                        NSLog(@"2 = %@",obj[@"content"]);
                        [relationReply addObject:obj];
                        [postObj saveInBackground];
                    }
                } else {
                    NSLog(@"error = %@",error.userInfo);
                }
            }];
        } else {
            NSLog(@"error = %@",error.userInfo);
        }
    }];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
