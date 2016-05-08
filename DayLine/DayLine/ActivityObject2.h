//
//  ActivityObject2.h
//  DayLine
//
//  Created by admin2 on 16/5/8.
//  Copyright © 2016年 TianXingJian. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface ActivityObject2 : NSObject

@property (strong,nonatomic) NSString *imgUrl;
@property (strong,nonatomic) NSString *name;
@property (strong,nonatomic) NSString *content;
@property (strong,nonatomic) NSString *like;
@property (strong,nonatomic) NSString *unlike;
@property (nonatomic) BOOL applied;

- (id)initWithDictionary:(NSDictionary *)dict;


@end
