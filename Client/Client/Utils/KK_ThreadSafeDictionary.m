//
//  KK_ThreadSafeDictionary.m
//  Client
//
//  Created by ke sen. on 2017/2/11.
//  Copyright © 2017年 SenKe. All rights reserved.
//

#import "KK_ThreadSafeDictionary.h"

#define LOCK(...) dispatch_semaphore_wait(_lock, DISPATCH_TIME_FOREVER); \
__VA_ARGS__; \
dispatch_semaphore_signal(_lock);

@implementation KK_ThreadSafeDictionary {
    NSMutableDictionary *_dic;  //Subclass a class cluster...
    dispatch_semaphore_t _lock;
}

#pragma mark - init

- (instancetype)init {
    if (self = [super init]) {
        _dic = [NSMutableDictionary dictionary];
        _lock = dispatch_semaphore_create(1);
    }
    return self;
}

#pragma mark - method

- (NSUInteger)count {
    LOCK(NSUInteger c = _dic.count);
    return c;
}

- (id)objectForKey:(id)aKey {
    LOCK(id o = [_dic objectForKey:aKey]);
    return o;
}

- (NSEnumerator *)keyEnumerator {
    LOCK(NSEnumerator * e = [_dic keyEnumerator]);
    return e;
}

- (NSArray *)allKeys {
    LOCK(NSArray * a = [_dic allKeys]);
    return a;
}

- (NSArray *)allKeysForObject:(id)anObject {
    LOCK(NSArray * a = [_dic allKeysForObject:anObject]);
    return a;
}

- (NSArray *)allValues {
    LOCK(NSArray * a = [_dic allValues]);
    return a;
}

- (NSString *)description {
    LOCK(NSString * d = [_dic description]);
    return d;
}

- (NSString *)descriptionInStringsFileFormat {
    LOCK(NSString * d = [_dic descriptionInStringsFileFormat]);
    return d;
}

- (NSString *)descriptionWithLocale:(id)locale {
    LOCK(NSString * d = [_dic descriptionWithLocale:locale]);
    return d;
}

- (NSString *)descriptionWithLocale:(id)locale indent:(NSUInteger)level {
    LOCK(NSString * d = [_dic descriptionWithLocale:locale indent:level]);
    return d;
}

- (NSEnumerator *)objectEnumerator {
    LOCK(NSEnumerator * e = [_dic objectEnumerator]); return e;
}

- (NSArray *)objectsForKeys:(NSArray *)keys notFoundMarker:(id)marker {
    LOCK(NSArray * a = [_dic objectsForKeys:keys notFoundMarker:marker]);
    return a;
}

- (NSArray *)keysSortedByValueUsingSelector:(SEL)comparator {
    LOCK(NSArray * a = [_dic keysSortedByValueUsingSelector:comparator]);
    return a;
}

- (void)getObjects:(id __unsafe_unretained[])objects andKeys:(id __unsafe_unretained[])keys {
    LOCK([_dic getObjects:objects andKeys:keys]);
}

- (void)enumerateKeysAndObjectsUsingBlock:(void (^)(id key, id obj, BOOL *stop))block {
    LOCK([_dic enumerateKeysAndObjectsUsingBlock:block]);
}

- (void)enumerateKeysAndObjectsWithOptions:(NSEnumerationOptions)opts usingBlock:(void (^)(id key, id obj, BOOL *stop))block {
    LOCK([_dic enumerateKeysAndObjectsWithOptions:opts usingBlock:block]);
}

- (NSArray *)keysSortedByValueUsingComparator:(NSComparator)cmptr {
    LOCK(NSArray * a = [_dic keysSortedByValueUsingComparator:cmptr]);
    return a;
}

- (NSArray *)keysSortedByValueWithOptions:(NSSortOptions)opts usingComparator:(NSComparator)cmptr {
    LOCK(NSArray * a = [_dic keysSortedByValueWithOptions:opts usingComparator:cmptr]);
    return a;
}

- (NSSet *)keysOfEntriesPassingTest:(BOOL (^)(id key, id obj, BOOL *stop))predicate {
    LOCK(NSSet * a = [_dic keysOfEntriesPassingTest:predicate]);
    return a;
}

- (NSSet *)keysOfEntriesWithOptions:(NSEnumerationOptions)opts passingTest:(BOOL (^)(id key, id obj, BOOL *stop))predicate {
    LOCK(NSSet * a = [_dic keysOfEntriesWithOptions:opts passingTest:predicate]);
    return a;
}

#pragma mark - mutable

- (void)removeObjectForKey:(id)aKey {
    LOCK([_dic removeObjectForKey:aKey]);
}

- (void)setObject:(id)anObject forKey:(id <NSCopying> )aKey {
    LOCK([_dic setObject:anObject forKey:aKey]);
}

- (void)addEntriesFromDictionary:(NSDictionary *)otherDictionary {
    LOCK([_dic addEntriesFromDictionary:otherDictionary]);
}

- (void)removeAllObjects {
    LOCK([_dic removeAllObjects]);
}

- (void)removeObjectsForKeys:(NSArray *)keyArray {
    LOCK([_dic removeObjectsForKeys:keyArray]);
}

#pragma mark - 实现下标操作

- (id)objectForKeyedSubscript:(id)key {
    LOCK(id o = [_dic objectForKeyedSubscript:key]);
    return o;
}

- (void)setObject:(id)obj forKeyedSubscript:(id <NSCopying> )key {
    LOCK([_dic setObject:obj forKeyedSubscript:key]);
}

#pragma mark - NSCopying protocol

- (id)copyWithZone:(NSZone *)zone {
    return [self mutableCopyWithZone:zone];
}

#pragma mark - NSMutableCopying protocol

- (id)mutableCopyWithZone:(NSZone *)zone {
    LOCK(id copiedDictionary = [[self.class allocWithZone:zone] initWithDictionary:_dic]);
    return copiedDictionary;
}

#pragma mark - NSFastEnumeration protocal

- (NSUInteger)countByEnumeratingWithState:(NSFastEnumerationState *)state
                                  objects:(id __unsafe_unretained[])stackbuf
                                    count:(NSUInteger)len {
    LOCK(NSUInteger count = [_dic countByEnumeratingWithState:state objects:stackbuf count:len]);
    return count;
}

- (NSUInteger)hash {
    LOCK(NSUInteger hash = [_dic hash]);
    return hash;
}

@end
