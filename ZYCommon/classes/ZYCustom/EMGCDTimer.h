//
//  EMGCDTimer.h
//  ZYSetting
//
//  Created by zhenyu on 2023/7/31.
//  封装GCDTimer

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface EMGCDTimer : NSObject

+ (EMGCDTimer *)scheduledGCDTimerTimeInterval:(NSTimeInterval)interval repeats:(BOOL)repeats handler:(void (^) (void))handler;

/// 重设定时器
- (void)resetTimeInterval:(NSTimeInterval)interval repeats:(BOOL)repeats;
/// 暂停
- (void)suspend;
/// 恢复
- (void)resume;

/// 停止并销毁定时器
- (void)stop;

@end

NS_ASSUME_NONNULL_END
