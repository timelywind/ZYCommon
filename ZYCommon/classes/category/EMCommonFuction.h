//
//  EMCommonFuction.h
//
//  Created by zhenyu on 2020/9/5.
//  一些公共方法

#import <UIKit/UIKit.h>

/// 类型识别（保证返回string类型或者nil)
NSString * _Nullable EMSafeString(id _Nullable value);
/// 返回安全的、不为空的string）(不会返回nil)
NSString * _Nonnull  EMSafeNonnullString(id _Nullable value);
/// 从NSDictionary取出安全的NSString（会检测NSDictionary类型正确性））(可能返回nil)
NSString * _Nullable EMSafeStringFromDictionary(NSDictionary * _Nullable dictionary, NSString * _Nullable key);

/// 判断是否为iPhone_X系列
BOOL EMAppConfig_is_iPhone_X (void);

/// 获取safeAreaInsets
UIEdgeInsets EMAppSafeAreaInsets (void);

/// 根据屏幕宽度375等比例适配size
CGFloat EMAppAdaptScreenSize(CGFloat size);
