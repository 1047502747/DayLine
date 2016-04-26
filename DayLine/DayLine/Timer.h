//
//  Timer.h
//  VC
//
//  Created by Sunday on 16/4/18.
//  Copyright © 2016年 Sunday. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Timer : NSObject

+ (instancetype)shareInstance;

- (void)startTaskWithTask : (void (^) ())task interval: (unsigned int) interval;

- (void)cancelTask;

@end
