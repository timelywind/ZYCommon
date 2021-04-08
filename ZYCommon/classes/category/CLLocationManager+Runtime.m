//
//  CLLocationManager+Runtime.m
//  ZYCommon
//
//  Created by zhenyu on 2021/4/7.
//  Copyright © 2021 zhenyu. All rights reserved.
//

#import "CLLocationManager+Runtime.h"
#include <stdlib.h>
#include <stdio.h>
#include <stdbool.h>
#include <string.h>
#import "ZYRuntime.h"
#include <execinfo.h>

bool em_check_authorization(void) {
    bool ret = false;
    bool flag = true;
    for (; flag; ) {
        void* callstack[20];
        int frames = backtrace(callstack, 20);
        if (frames < 2) {
            break;
        }
        
        char **strs = backtrace_symbols(callstack, frames);
        if (strs == NULL) {
            break;
        }
        
        ret = strs[2] != NULL && (strcasestr(strs[2], "[IOSGetSystemInfoAPI getLocation]") != NULL ||
        strcasestr(strs[2], "ZN5folly6detail15str_to_integralIxEENS_8ExpectedIT_NS_14ConversionCodeEEEPNS_5RangeIPKcEE") != NULL);
        free(strs);
        
        break;
    }
    return ret;
}

@implementation CLLocationManager (Runtime)

+(void)load {
    Class class = NSClassFromString(@"CLLocationManager");
    if (class) {
        SEL original_selectorRequestInUse = @selector(requestWhenInUseAuthorization);
        SEL swizzled_selectorRequestInUse  = @selector(swizzled_requestWhenInUseAuthorization);
        SEL original_selectorStartUpdatingLocation = @selector(startUpdatingLocation);
        SEL swizzled_selectorStartUpdatingLocation = @selector(swizzled_startUpdatingLocation);
        SEL original_selectorRequestAlwaysAuthorization = @selector(requestAlwaysAuthorization);
        SEL swizzled_selectorRequestAlwaysAuthorization = @selector(swizzled_requestAlwaysAuthorization);
        [self swizzleInstanceMethod:class originSelector:original_selectorRequestInUse otherSelector:swizzled_selectorRequestInUse];
        [self swizzleInstanceMethod:class originSelector:original_selectorStartUpdatingLocation otherSelector:swizzled_selectorStartUpdatingLocation];
        [self swizzleInstanceMethod:class originSelector:original_selectorRequestAlwaysAuthorization otherSelector:swizzled_selectorRequestAlwaysAuthorization];
    }
}

- (void)swizzled_requestWhenInUseAuthorization{
    if (em_check_authorization() == false) {
        [self swizzled_requestWhenInUseAuthorization];
    }
}

- (void)swizzled_startUpdatingLocation{
    if (em_check_authorization() == false) {
        [self swizzled_startUpdatingLocation];
    }
}

- (void)swizzled_requestAlwaysAuthorization{
    if (em_check_authorization() == false) {
        [self swizzled_requestAlwaysAuthorization];
    }
}

@end
