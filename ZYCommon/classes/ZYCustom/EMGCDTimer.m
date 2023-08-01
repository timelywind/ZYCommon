//
//  EMGCDTimer.m
//  ZYSetting
//
//  Created by zhenyu on 2023/7/31.
//

#import "EMGCDTimer.h"

@interface EMGCDTimer ()

@property (nonatomic, strong) dispatch_source_t dispatchTimer;
@property (nonatomic, assign) BOOL isSuspended;         // 是否暂停

@property (nonatomic, assign) NSTimeInterval interval;  // 时间间隔
@property (nonatomic, assign) BOOL repeats;             // 是否循环

@end

@implementation EMGCDTimer

+ (EMGCDTimer *)scheduledGCDTimerTimeInterval:(NSTimeInterval)interval repeats:(BOOL)repeats handler:(void (^) (void))handler {
    return [[self alloc] initWithTimeInterval:interval repeats:repeats handler:handler dispatchQueue:nil];
}

- (id)initWithTimeInterval:(NSTimeInterval)interval repeats:(BOOL)repeats handler:(void (^) (void))handler
         dispatchQueue:(dispatch_queue_t)dispatchQueue {
    if (self = [super init]) {
        _isSuspended = NO;
        _interval  = interval;
        _repeats = repeats;
        if (!dispatchQueue) {
            dispatchQueue = dispatch_get_main_queue();
        }
        dispatch_source_t dispatchTimer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatchQueue);
        _dispatchTimer = dispatchTimer;
        dispatch_source_set_timer(dispatchTimer, DISPATCH_TIME_NOW, interval * NSEC_PER_SEC, 0);
        dispatch_source_set_event_handler(dispatchTimer, ^{
            if (!repeats) {
                dispatch_source_cancel(dispatchTimer);
            }
            if (handler) {
                handler();
            };
        });
        dispatch_resume(dispatchTimer);
    }
    return self;
}

/// 重设定时器
- (void)resetTimeInterval:(NSTimeInterval)interval repeats:(BOOL)repeats {
    if (!self.isValid) {
        return;
    }
    [self suspend];
    _interval  = interval;
    _repeats = repeats;
    dispatch_time_t startTime = dispatch_time(DISPATCH_TIME_NOW, interval * NSEC_PER_SEC);
    dispatch_source_set_timer(self.dispatchTimer, startTime, repeats ? interval * NSEC_PER_SEC : DISPATCH_TIME_FOREVER, 0);
    dispatch_resume(self.dispatchTimer);
    _isSuspended = NO;
}

/// 暂停
- (void)suspend {
    if (self.isValid && !_isSuspended) {
        dispatch_suspend(self.dispatchTimer);
        _isSuspended = YES;
    }
}

/// 恢复
- (void)resume {
    if (!self.isValid && !_isSuspended) {
        return;
    }
    [self resetTimeInterval:_interval repeats:_repeats];
}

/// 停止并销毁
- (void)stop {
    if (self.isValid) {
        dispatch_source_cancel(self.dispatchTimer);
        _dispatchTimer = nil;
    }
}

/// 当前定时器是否有效
- (BOOL)isValid {
    return (self.dispatchTimer && !dispatch_source_testcancel(self.dispatchTimer));
}

- (void)dealloc {
    [self stop];
}

@end
