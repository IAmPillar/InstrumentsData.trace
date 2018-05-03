//
//  GZUserDefaults.h
//  HanvonInput
//
//  Created by hanvon on 2017/11/3.
//  Copyright © 2017年 hanvon. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *封装  对NSUserDefaults的读取操作
 ***/

@interface GZUserDefaults : NSObject

+ (id)shareUserDefaults;
- (void)releaseUserDefaults;

//普通存储
- (void)saveValue:(id)value forKey:(NSString *)key;
- (id)getValueForKey:(NSString *)key;
- (void)removeValueForKey:(NSString *)key;

//容器和宿主之间的通信
- (void)saveGroupValue:(id)value forKey:(NSString*)key;
- (id)getGroupValueForKey:(NSString*)key;
- (void)removeGroupValueForKey:(NSString*)key;
@end
