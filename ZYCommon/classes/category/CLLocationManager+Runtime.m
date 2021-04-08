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
    if (NSClassFromString(@"CLLocationManager")) {
        SEL originalSelectorRequestInUse = @selector(requestWhenInUseAuthorization);
        SEL swizzledSelectorRequestInUse  = @selector(swizzled_requestWhenInUseAuthorization);
        SEL originalSelectorStartUpdatingLocation = @selector(startUpdatingLocation);
        SEL swizzledSelectorStartUpdatingLocation = @selector(swizzled_startUpdatingLocation);
        SEL originalSelectorRequestAlwaysAuthorization = @selector(requestAlwaysAuthorization);
        SEL swizzledSelectorRequestAlwaysAuthorization = @selector(swizzled_requestAlwaysAuthorization);
        [self swizzleInstanceMethod:NSClassFromString(@"CLLocationManager") originSelector:originalSelectorRequestInUse otherSelector:swizzledSelectorRequestInUse];
        [self swizzleInstanceMethod:NSClassFromString(@"CLLocationManager") originSelector:originalSelectorStartUpdatingLocation otherSelector:swizzledSelectorStartUpdatingLocation];
        [self swizzleInstanceMethod:NSClassFromString(@"CLLocationManager") originSelector:originalSelectorRequestAlwaysAuthorization otherSelector:swizzledSelectorRequestAlwaysAuthorization];
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
