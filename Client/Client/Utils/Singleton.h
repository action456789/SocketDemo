//
//  Singleton.h
//  iFanPhoto
//
//  Created by kesen on 14/12/3.
//  Copyright (c) 2014年 柯森. All rights reserved.
//

#ifndef Singleton
#define Singleton

/*
 专门用来保存单例代码
 最后一行不要加 \
 */

// @interface
#define singleton_interface(className) \
+ (className *)sharedInstance;

// @implementation
#define singleton_implementation(className) \
static className *_instance; \
+ (id)allocWithZone:(NSZone *)zone \
{ \
    static dispatch_once_t onceToken; \
    dispatch_once(&onceToken, ^{ \
        _instance = [super allocWithZone:zone]; \
    }); \
    return _instance; \
} \
\
- (id)copyWithZone:(NSZone *)zone\
{ \
    return _instance;\
} \
\
+ (className *)sharedInstance \
{ \
    static dispatch_once_t onceToken; \
    dispatch_once(&onceToken, ^{ \
        _instance = [[self alloc] init]; \
    }); \
    return _instance; \
}

#endif
