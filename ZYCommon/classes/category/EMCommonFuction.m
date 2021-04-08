//
//  EMCommonFuction.m
//
//  Created by zhenyu on 2020/9/5.
//

#import "EMCommonFuction.h"

/// 安全的字符串（将NSNull类型转化成nil、number类型转成string）
inline NSString *EMSafeString(id value) {
    if ([value isKindOfClass:[NSString class]]) {
        return value;
    } else if ([value isKindOfClass:[NSNumber class]]) {
        return [value stringValue];
    }
    return nil;
}

/// 返回安全的、不为空的string
inline NSString *EMSafeNonnullString(id value) {
    return EMSafeString(value) ? : @"";
}

inline NSString *EMSafeStringFromDictionary(NSDictionary *dictionary, NSString *key) {
    if (![dictionary isKindOfClass:[NSDictionary class]] || ![key isKindOfClass:[NSString class]]) {
        return nil;
    }
    return EMSafeString(dictionary[key]);
}

/// 判断是否为iPhone_X系列 (判断是否有安全区域)
inline BOOL EMAppConfig_is_iPhone_X (void) {
    UIEdgeInsets safeAreaInsets = EMAppSafeAreaInsets();
    return (safeAreaInsets.bottom > 0 || safeAreaInsets.left > 20);
}

/// 获取safeAreaInsets
UIEdgeInsets EMAppSafeAreaInsets (void) {
    if (@available(iOS 11.0, *)) {
        UIWindow *window = [[UIApplication sharedApplication] delegate].window;
        if (window) {
            return window.safeAreaInsets;
        } else if ([[UIScreen mainScreen] bounds].size.height >= 812.0f || [[UIScreen mainScreen] bounds].size.width >= 812.0f) {  // 防止此时delegate.window未加载
            if ((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)) {
                return UIEdgeInsetsMake(24, 0, 20, 0);
            }
            return UIEdgeInsetsMake(44, 0, 34, 0);
        }
    }
    return UIEdgeInsetsZero;
}

/// 根据屏幕宽度375等比例适配size
inline CGFloat EMAppAdaptScreenSize(CGFloat size) {
    if ((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)) {
        return size * 1.5;
    }
    CGSize screenSize = [[UIScreen mainScreen] bounds].size;
    return size * MIN(screenSize.width, screenSize.height) / 375.0;
}

