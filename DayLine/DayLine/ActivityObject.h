//
//  ActivityObject.h
//  ActivityTableView
//
//  Created by Zly on 16/1/14.
//  Copyright © 2016年 Zly. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ActivityObject : NSObject

@property (strong, nonatomic)NSString *imgUrl;
@property (strong, nonatomic)NSString *spId;
@property (strong, nonatomic)NSString *spAmount;
@property (strong, nonatomic)NSString *spScore;
@property (strong, nonatomic)NSString *spName;
@property (nonatomic)BOOL isApplied;

- (id)initWithDictionary:(NSDictionary *)dict;

@end
