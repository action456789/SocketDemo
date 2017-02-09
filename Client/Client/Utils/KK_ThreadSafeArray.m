//
//  KK_ThreadSafeArray.m
//  KsCollection
//
//  Created by KeSen on 16/4/25.
//  Copyright © 2016年 KeSen. All rights reserved.
//

#import "KK_ThreadSafeArray.h"

#define LOCK(...) dispatch_semaphore_wait(_lock, DISPATCH_TIME_FOREVER); \
__VA_ARGS__; \
dispatch_semaphore_signal(_lock);

@interface KK_ThreadSafeArray()
{
    NSMutableArray *_array;
    dispatch_semaphore_t _lock;
}
@end

@implementation KK_ThreadSafeArray

- (instancetype)init {
    if (self = [super init]) {
        _array = [NSMutableArray array];
        _lock = dispatch_semaphore_create(1);
    }
    return self;
}

- (instancetype)initWithArray:(NSMutableArray *)otherArray {
    if (self = [super init]) {
        _array = [NSMutableArray arrayWithArray:otherArray];
        _lock = dispatch_semaphore_create(1);
    }
    return self;
}

/**
 @discussion 只有通过 KVO 的方式获取 array 对象，才会触发监听数组内容变化通知。
 @warning 如果声明 array 为 property，在 get 方法中调用 mutableArrayValueForKey 方法将会触发死循环。
 */
+ (instancetype)array {
    KK_ThreadSafeArray *array = [[KK_ThreadSafeArray alloc] init];
    return array;
}

- (void)addObject:(id)object {
    LOCK([_array addObject:object]);
}

- (void)removeObject:(id)object {
    LOCK([_array removeObject:object]);
}

- (NSUInteger)indexOfObject:(id)anObject {
    LOCK(NSUInteger index = [_array indexOfObject:anObject]);
    return index;
}

- (void)insertObject:(id)anObject atIndex:(NSUInteger)index {
    LOCK([_array insertObject:anObject atIndex:index]);
}

- (id)objectAtIndex:(NSUInteger)index {
    LOCK(id object = [_array objectAtIndex:index]);
    return object;
}

- (id)lastObject {
    LOCK(id object = [_array lastObject]);
    return object;
}

- (void)removeLastObject {
    LOCK([_array removeLastObject]);
}

// 入队
- (void)push:(id)object {
    LOCK([_array insertObject:object atIndex:0]);
}

// 出队
- (id)pop {
    dispatch_semaphore_wait(_lock, DISPATCH_TIME_FOREVER);
    
    id object = [_array lastObject];
    [_array removeLastObject];
    
    dispatch_semaphore_signal(_lock);
    
    return object;
}

#pragma mark - 实现下标操作
- (id)objectAtIndexedSubscript:(NSUInteger)idx {
    LOCK(id object = _array[idx]);
    return object;
}
- (void)setObject:(id)obj atIndexedSubscript:(NSUInteger)idx {
    LOCK(_array[idx] = obj);
}

#pragma mark - getter

- (NSInteger)count {
    LOCK(NSUInteger count = _array.count);
    return count;
}

/**
 @discussion 要有 for in 表达式的功能，必须要实现 NSFastEnumeration 协议
 */
#pragma mark - NSFastEnumeration delegate
- (NSUInteger)countByEnumeratingWithState:(NSFastEnumerationState *)state objects:(id __unsafe_unretained [])buffer count:(NSUInteger)len {
    LOCK(NSInteger count = [_array countByEnumeratingWithState:state objects:buffer count:len]);
    return count;
}

- (NSString *)description {
    dispatch_semaphore_wait(_lock, DISPATCH_TIME_FOREVER);
     NSString *str = @"";
     for (id obj in _array) {
         str = [str stringByAppendingString:@"\n"];
         str = [str stringByAppendingString:[NSString stringWithFormat:@"%@ ", obj]];
     }
    dispatch_semaphore_signal(_lock);
    return str;
    
}

- (KK_ThreadSafeArray *)sortedArrayUsingSelector:(SEL)comparator {
    dispatch_semaphore_wait(_lock, DISPATCH_TIME_FOREVER);
     NSArray *array  = [_array sortedArrayUsingSelector:comparator];
     KK_ThreadSafeArray *threadSafeArray = [[KK_ThreadSafeArray alloc] initWithArray:(NSMutableArray *)array];
    dispatch_semaphore_signal(_lock);
    return  threadSafeArray;
}

@end
