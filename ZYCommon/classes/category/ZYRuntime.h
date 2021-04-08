
#import <Foundation/Foundation.h>

@interface ZYRuntime : NSObject

@end


@interface NSObject (ResolveNoMethod)

+ (void)swizzleInstanceMethod:(Class)class originSelector:(SEL)originSelector otherSelector:(SEL)otherSelector;

@end
