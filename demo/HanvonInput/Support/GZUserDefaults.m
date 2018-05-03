//
//  GZUserDefaults.m
//  HanvonInput
//
//  Created by hanvon on 2017/11/3.
//  Copyright © 2017年 hanvon. All rights reserved.
//

#import "GZUserDefaults.h"


static GZUserDefaults *_sharedManager;
static dispatch_once_t onceToken;

@implementation GZUserDefaults

+ (GZUserDefaults *)shareUserDefaults {
    dispatch_once(&onceToken, ^{
        _sharedManager = [[GZUserDefaults alloc] init];
    });
    return _sharedManager;
}

- (void)releaseUserDefaults {
    onceToken = 0;
    _sharedManager = nil;
}


//普通的存储
- (void)saveValue:(id)value forKey:(NSString *)key {
    NSUserDefaults *shared = [NSUserDefaults standardUserDefaults];
    [shared removeObjectForKey:key];
    [shared setValue:value forKey:key];
    [shared synchronize];
}
- (id)getValueForKey:(NSString *)key {
    NSUserDefaults *shared = [NSUserDefaults standardUserDefaults];
    return [shared valueForKey:key];
}
- (void)removeValueForKey:(NSString *)key {
    NSUserDefaults *shared = [NSUserDefaults standardUserDefaults];
    [shared removeObjectForKey:key];
    [shared synchronize];
}

//容器和宿主之间的通信
- (void)saveGroupValue:(id)value forKey:(NSString*)key {
    NSUserDefaults *shared = [[NSUserDefaults alloc] initWithSuiteName:@"group.com.hanwang.hanvonInput"];
    //[shared removeObjectForKey:key];
    [shared setValue:value forKey:key];
    [shared synchronize];
}
- (id)getGroupValueForKey:(NSString*)key {
    NSUserDefaults *shared = [[NSUserDefaults alloc] initWithSuiteName:@"group.com.hanwang.hanvonInput"];
    return [shared valueForKey:key];
}
- (void)removeGroupValueForKey:(NSString*)key {
    NSUserDefaults *shared = [[NSUserDefaults alloc] initWithSuiteName:@"group.com.hanwang.hanvonInput"];
    [shared removeObjectForKey:key];
    [shared synchronize];
}


@end
