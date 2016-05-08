//
//  ActivityObject2.m
//  DayLine
//
//  Created by admin2 on 16/5/8.
//  Copyright © 2016年 TianXingJian. All rights reserved.
//

#import "ActivityObject2.h"

@implementation ActivityObject2


- (id)initWithDictionary:(NSDictionary *)dict{
self = [super init];
self.imgUrl = [dict[@"imgUrl"] isKindOfClass:[NSNull class]] ? @"" : dict[@"imgUrl"];
self.name = [dict[@"name"] isKindOfClass:[NSNull class]] ? @"为公开活动" : dict[@"name"];
self.content = [dict[@"content"] isKindOfClass:[NSNull class]] ? @"抱歉！活动具体内容暂不对外公布。" : dict[@"content"];
self.like =  [dict[@"reliableNumber"] isKindOfClass:[NSNull class]] ? @"0" : [dict[@"reliableNumber"] stringValue];
self.unlike = [dict[@"unReliableNumber"] isKindOfClass:[NSNull class]] ? @"0" : [dict[@"unReliableNumber"] stringValue];
self.applied = NO;
    
return self;
}


@end
