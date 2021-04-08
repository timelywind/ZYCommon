
#import "ZYRuntime.h"
#import <objc/runtime.h>

// MARK: - NSObject (ResolveNoMethod)
@implementation NSObject (ResolveNoMethod)

+ (void)load {
    if (NSClassFromString(@"NSObject")) {
        SEL originalSelector = @selector(methodSignatureForSelector:);
        SEL swizzledSelector = @selector(swizzled_methodSignatureForSelector:);
        
        [self swizzleInstanceMethod:[NSObject class] originSelector:originalSelector otherSelector:swizzledSelector];
        
        originalSelector = @selector(forwardInvocation:);
        swizzledSelector = @selector(swizzled_forwardInvocation:);
        
        [self swizzleInstanceMethod:[NSObject class] originSelector:originalSelector otherSelector:swizzledSelector];
    }
}

/// 方法交换
+ (void)swizzleInstanceMethod:(Class)class originSelector:(SEL)originSelector otherSelector:(SEL)otherSelector {
    Method otherMehtod  = class_getInstanceMethod(class, otherSelector);
    Method originMehtod = class_getInstanceMethod(class, originSelector);
    
    BOOL didAddMethod =
    class_addMethod(class, originSelector, method_getImplementation(otherMehtod), method_getTypeEncoding(otherMehtod));
    if (didAddMethod) {
        class_replaceMethod(class, otherSelector, method_getImplementation(originMehtod), method_getTypeEncoding(originMehtod));
    } else {
        // 交换2个方法的实现
        method_exchangeImplementations(otherMehtod, originMehtod);
    }
}

/// 返回方法简介（签名信息）
- (NSMethodSignature *)swizzled_methodSignatureForSelector:(SEL)aSelector {
    NSMethodSignature *signature = [self swizzled_methodSignatureForSelector:aSelector];
    if (signature == nil && [NSStringFromClass([self class]) hasPrefix:@"ZY"]) {
        if ([ZYRuntime instancesRespondToSelector:aSelector]) {
            signature = [ZYRuntime instanceMethodSignatureForSelector:aSelector];
        }
    }
    return signature;
}
/// 方法传递
- (void)swizzled_forwardInvocation:(NSInvocation *)anInvocation {
    if ([self respondsToSelector:anInvocation.selector]) {
        [self swizzled_forwardInvocation:anInvocation];
    } else if([NSStringFromClass([self class]) hasPrefix:@"ZY"]){
#ifdef DEBUG
        NSAssert(NO, @"找不到方法：%@:%@", NSStringFromClass([self class]), NSStringFromSelector(anInvocation.selector));
#else
        NSLog(@"there is a serious problem with method name:%@", NSStringFromSelector(anInvocation.selector));
#endif
    } else {
        [self swizzled_forwardInvocation:anInvocation];
    }
}


@end



// MARK: - ZYRuntime

static NSMutableArray *selectorList;

@implementation ZYRuntime

+ (BOOL)resolveInstanceMethod:(SEL)sel {
    if (selectorList == nil) {
        selectorList = [[NSMutableArray alloc]init];
        [selectorList addObject:@"methodForAllSelector"];
    }
    
    // 方法存在判断
    for (NSString *selectorString in selectorList) {
        if ([selectorString isEqualToString:NSStringFromSelector(sel)]) {
            return YES;
        }
    }
    
    [selectorList addObject:NSStringFromSelector(sel)];
    
    SEL originalSelector = @selector(methodForAllSelector);
    Method originalMethod = class_getInstanceMethod([self class], originalSelector);
    
    // 新增方法
    BOOL didAddMethod =
    class_addMethod([self class],
                    sel,
                    method_getImplementation(originalMethod),
                    method_getTypeEncoding(originalMethod));
    
    if (didAddMethod) {
        return YES;
    }
    
    return NO;
}

/// 替代所有未知方法的方法
- (void)methodForAllSelector {
}

@end

