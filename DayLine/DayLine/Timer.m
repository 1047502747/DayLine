//
//  Timer.m
//  VC
//
//  Created by Sunday on 16/4/18.
//  Copyright © 2016年 Sunday. All rights reserved.
//

#import "Timer.h"

@interface Timer ()

@property (nonatomic,strong) dispatch_source_t timer;

@end

@implementation Timer

+ (instancetype)shareInstance
{
    static dispatch_once_t once;
    static Timer *timer;
    
    dispatch_once(&once,^{timer = [Timer new];});
    
    return timer;
}

- (void)startTaskWithTask : (void (^) ())task interval: (unsigned int) interval {
    //  获得队列
    dispatch_queue_t queue = dispatch_get_main_queue();
    
    //  创建一个定时器
    _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    
    //  开始的时间
    dispatch_time_t start = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC));
    
    //  多少秒循环一次
    uint64_t interval64 = (uint64_t)(interval * NSEC_PER_SEC);
    
    //  创建任务
    dispatch_source_set_timer(self.timer, start, interval64, 0);
    
    //  设置任务回调
    dispatch_source_set_event_handler(self.timer, task);
    
    //  启动定时器
    dispatch_resume(self.timer);
}

- (void)cancelTask {
    dispatch_cancel(self.timer);
}

@end
