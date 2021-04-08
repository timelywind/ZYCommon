//
//  NSDictionary+Safe.m
//
//  Created by zhenyu on 2019/3/15.
//

#import "NSDictionary+Safe.h"
#import "EMCommonFuction.h"

// MARK: - 字典Category
@implementation NSDictionary (Safe)

- (NSDictionary *_Nullable)safe_dictionaryForKey:(nonnull NSString *)key {
    id dic = [self objectForKey:key];
    if ([dic isKindOfClass:[NSDictionary class]]) {
        return dic;
    }
    return nil;
}

- (NSInteger)safe_intForKey:(NSString *_Nonnull)key {
    id obj = [self objectForKey:key];
    if ([obj isKindOfClass:[NSNumber class]] || [obj isKindOfClass:[NSString class]] ) {
        return ((NSString *)obj).integerValue;
    }
    return 0;
}

- (NSString *_Nullable)safe_stringForKey:(NSString *_Nonnull)key {
    id obj = [self objectForKey:key];
    if ([obj isKindOfClass:[NSString class]]) {
        return obj;
    } else if ([obj isKindOfClass:[NSNumber class]]) {
        return ((NSNumber *)obj).stringValue;
    }
    return nil;
}

@end

@implementation NSMutableDictionary(Safe)

- (void)safe_setObject:(id)anObject forKey:(id <NSCopying>)aKey {
    if(!aKey || !anObject) {
    } else {
        [self setObject:anObject forKey:aKey];
    }
}

@end

// MARK: - 数组Category
@implementation NSArray (Safe)

// 安全的获取Object（预防越界）
- (id)safe_objectAtIndex:(NSUInteger)index {
    if (self.count <= index) {
        return nil;
    }
    return ([self objectAtIndex:index]);
}

// 获取安全的NSString，(确保返回NSString，空的话返回@""）
- (id)safe_stringAtIndex:(NSUInteger)index {
    NSString *string = [self safe_objectAtIndex:index];
    return EMSafeString(string) ? : @"";
}

@end

@implementation NSMutableArray(Safe)

- (void)safe_addObject:(id)anObject
{
    if(!anObject) {
        return;
    }
    [self addObject:anObject];
}

- (void)safe_insertObject:(id)anObject atIndex:(NSUInteger)index
{
    if(index > MAX(self.count - 1.f, 0)) {
        return;
    }
    if(!anObject) {
        return;
    }
    [self insertObject:anObject atIndex:index];
}

- (void)safe_removeObjectAtIndex:(NSUInteger)index
{
    if (self.count <= 0) {
        return;
    }
    if(index > MAX(self.count - 1.f, 0)) {
        return;
    }
    [self removeObjectAtIndex:index];
}

- (void)safe_replaceObjectAtIndex:(NSUInteger)index withObject:(id)anObject
{
    if (self.count <= 0) {
        return;
    }
    if(index > MAX(self.count - 1.f, 0)) {
        return;
    }
    if(!anObject) {
        return;
    }
    [self replaceObjectAtIndex:index withObject:anObject];
}

@end
