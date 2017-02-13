//
//  KK_ThreadSafeDictionary.h
//  Client
//
//  Created by ke sen. on 2017/2/11.
//  Copyright © 2017年 SenKe. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KK_ThreadSafeDictionary : NSObject <NSCopying, NSMutableCopying, NSFastEnumeration>

@property (readonly) NSUInteger count;

- (id)objectForKey:(id)aKey;
- (void)removeObjectsForKeys:(NSArray *)keyArray;

/// 下标访问
- (id)objectForKeyedSubscript:(id)key;
- (void)setObject:(id)obj forKeyedSubscript:(id <NSCopying> )key;

@end
