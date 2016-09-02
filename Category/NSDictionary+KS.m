//
//  NSDictionary+KS.m
//  SKS_Collection
//
//  Created by KeSen on 8/19/16.
//  Copyright © 2016 SenKe. All rights reserved.
//

#import "NSDictionary+KS.h"

@implementation NSDictionary (KS)

/**
 *  返回 url 中的参数列表
 */
+ (instancetype)ks_dictionaryInURL:(NSString *)url
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    NSURLComponents *components = [NSURLComponents componentsWithString:url];
    for(NSURLQueryItem *item in components.queryItems) {
        BOOL isValidateValue = item.name && item.value && ![item.name isEqualToString:@""] && ![item.value isEqualToString:@""];
        if (isValidateValue) {
            [dict setObject:item.value forKey:item.name];
        } else {
            return nil;
        }
    }
    return dict;
}

/**
 *  JSON 字符串返回字典
 */
+ (instancetype)ks_dictionaryFromString:(NSString *)jsonString
{
    NSData *data = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    
    NSError *error;
    NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
    if (error) {
        NSLog(@"%@", error);
    }
    
    return jsonDict;
}

/**
 *  字典返回json字符串
 */
- (NSString *)ks_jsonString
{
    NSError *parseError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self options:NSJSONWritingPrettyPrinted error:&parseError];
    
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}

@end
