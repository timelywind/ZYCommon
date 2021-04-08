//
//  NSDictionary+Safe.h
//
//  Created by zhenyu on 2019/3/15.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (Safe)

- (NSDictionary *_Nullable)safe_dictionaryForKey:(nonnull NSString *)key;

- (NSInteger)safe_intForKey:(NSString *_Nonnull)key;
- (NSString *_Nullable)safe_stringForKey:(NSString *_Nonnull)key;

@end

NS_ASSUME_NONNULL_BEGIN
@interface NSMutableDictionary(Safe)

//NSMutableDictionary setObject:forKey:的安全方法，避免anObject或aKey为nil时造成的崩溃
- (void)safe_setObject:(id)anObject forKey:(id <NSCopying>)aKey;

@end

@interface NSArray (Safe)

/// 安全的获取Object（预防越界）
- (id)safe_objectAtIndex:(NSUInteger)index;

/// 获取安全的NSString，(确保返回NSString，空的话返回@""）
- (id)safe_stringAtIndex:(NSUInteger)index;

@end

@interface NSMutableArray(Safe)

//NSMutableArray addObject:的安全方法，避免anObject为nil时造成的崩溃
- (void)safe_addObject:(id)anObject;

//NSMutableArray insertObject:atIndex:的安全方法，避免index越界以及anObject为nil时造成的崩溃
- (void)safe_insertObject:(id)anObject atIndex:(NSUInteger)index;

//NSMutableArray removeObjectAtIndex:的安全方法，避免数组越界造成的崩溃
- (void)safe_removeObjectAtIndex:(NSUInteger)index;

//NSMutableArray replaceObjectAtIndex:withObject:的安全方法，避免index越界以及anObject为nil时造成的崩溃
- (void)safe_replaceObjectAtIndex:(NSUInteger)index withObject:(id)anObject;

@end
NS_ASSUME_NONNULL_END
