//
//  ActivityObject.m
//  ActivityTableView
//
//  Created by Zly on 16/1/14.
//  Copyright © 2016年 Zly. All rights reserved.
//

#import "ActivityObject.h"

@implementation ActivityObject

- (id)initWithDictionary:(NSDictionary *)dict{
    self = [super init];
    //以下操作表示针对来自网络请求结果的各种不同数据类型的防范式编程
    self.imgUrl = [dict[@"goodsImg"] isKindOfClass:[NSNull class]]? @"":dict[@"goodsImg"];
    self.spName = [dict[@"goodsName"] isKindOfClass:[NSNull class]]? @"":dict[@"goodsName"];
    self.spId = [dict[@"goodsId"] isKindOfClass:[NSNull class]]? @"":dict[@"goodsId"];
    self.spScore = [dict[@"goodsScore"] isKindOfClass:[NSNull class]]? @"" : [dict[@"goodsScore"] stringValue];
    self.spAmount = [dict[@"goodsAmount"] isKindOfClass:[NSNull class]]? @"" : [dict[@"goodsAmount"] stringValue];
    
    self.isApplied =  NO;
    
    return self;
}

@end
