//
//  GZChineseKeyboardCore.m
//  HanvonKeyboard
//
//  Created by hanvon on 2017/12/29.
//  Copyright © 2017年 hanvon. All rights reserved.
//

#import "GZChineseKeyboardCore.h"


@interface GZChineseKeyboardCore()
{
    HWIM_HANDLE imHandle;
    char* imRam;
    int dictionaryType; //初始化的字典类型 //0中文 1英文 2手写联想
    //    BOOL isFirstInit; //是否是首次加载单例=字典未加载过
}
@end

@implementation GZChineseKeyboardCore

static GZChineseKeyboardCore *share;
static dispatch_once_t onceToken;

+ (id)shareChineseKeyboardCore {
    dispatch_once(&onceToken, ^{
        share = [[self alloc] init];
    });
    return share;
}
- (id)init {
    self = [super init];
    if (self) {
        dictionaryType = -1;
        //        isFirstInit = YES;
        [self initChineseKeyboardWorkSpace];
    }
    return self;
}
- (BOOL)initChineseKeyboardWorkSpace {
    NSLog(@"chinese键盘 初始化工作空间");
    imRam = (char*)allocMemory(HWKEYIM_MIN_RAMSIZE);
    //memset(&imHandle, 0, sizeof(HWIM_HANDLE));

    int initnum = HWKIM_Init(&imHandle, (HWCBK_LoadDict)&loadFile, (HWCBK_ReleaseDict)&releaseMemory, (HWCBK_SaveDict)&saveFile);
    if (0 != initnum) {
        NSLog(@"初始化失败 1 %d",initnum);
        return NO;
    }
    int initnum2 = HWKIM_SetWorkSpace(&imHandle, imRam, HWKEYIM_MIN_RAMSIZE);
    if (0 != initnum2) {
        NSLog(@"初始化失败 2 %d",initnum2);
        return NO;
    }

    return YES;
}


- (HWIM_HANDLE *)getHandle {
    return &imHandle;
}

- (char*)getRam {
    return imRam;
}

- (void)cleanData {
    HWKIM_InputStrClean(&imHandle);
}

- (void)releaseDictionary {
    NSLog(@"chinese 释放词典");
    dictionaryType = -1;

    HWKIM_InputStrClean(&imHandle);
    int save = HWKIM_SaveUserDict(&imHandle);
    if (0 != save) {
        NSLog(@"错误%d -键盘--SaveUserDict",save);
    }
    int release = HWKIM_ReleaseLanguageDict(&imHandle);
    if (0 != release) {
        NSLog(@"错误%d -键盘--ReleaseLanguageDict",release);
    }
    //    isFirstInit = YES;
}

- (void)releaseWorkspace {
    NSLog(@"chineseKeyboardRease");
    HWKIM_InputStrClean(&imHandle);
    int save = HWKIM_SaveUserDict(&imHandle);
    if (0 != save) {
        NSLog(@"错误%d-键盘--SaveUserDict",save);
    }
    int release = HWKIM_ReleaseLanguageDict(&imHandle);
    if (0 != release) {
        NSLog(@"错误%d-键盘--ReleaseLanguageDict",release);
    }
    //    if (0 != HWKIM_ReleaseUserDict(&imHandle)) {
    //        NSLog(@"键盘--ReleaseUserDict");
    //    }

    if (imRam) {
        releaseMemory(imRam);
        imRam = NULL;
    }

    share = nil;
    onceToken = 0;
}

- (BOOL)changeDictionary:(int)type {
    //0中文 1英文 2手写联想
    if (type < 0) {
        return NO;
    }

    if (type == dictionaryType) {
        return NO;
    }

    NSLog(@"核心 改变字典");

    dictionaryType = type;

    NSString *systemDicStr = nil;
    NSString *userDicStr = nil;
    NSInteger language = 0;

    if (type == 0) {
        systemDicStr = @"ml-sys.dic";
        userDicStr = @"ml-user.dic";
        language = HWLANG_Chinese_Mainland;
    }else if (type == 1) {
        systemDicStr = @"en-sys.dic";
        userDicStr = @"en-user.dic";
        language = HWLANG_English;
    }else if (type == 2) {
        systemDicStr = @"ml-wp.dic";
        userDicStr = @"ml-user.dic";
        language = HWLANG_Chinese_Mainland;
    }else {}

    NSFileManager *manager = [NSFileManager defaultManager];
    GZUserPlist *plist = [GZUserPlist sharedUserPlist];

    NSString *systemD = [NSString stringWithFormat:@"%@/%@",[[NSBundle mainBundle] bundlePath], systemDicStr];
    NSString *userD = [plist getUserDictionaryPath:userDicStr];
    if (![manager fileExistsAtPath:userD]) {
        [plist saveUserDictionary:userDicStr]; //中文全键盘、中文九键盘、中文笔画键盘
        userD = [plist getUserDictionaryPath:userDicStr];
    }

    if (![plist isHaveUserDictionary:userDicStr]) {
        NSLog(@"存储失败");
        return NO;
    }

    int setL = HWKIM_SetLanguageDict(&imHandle, (int)language, [systemD UTF8String], 0);
    if (0 != setL) {
        NSLog(@"错误%d ~change~  HWKIM_SetLanguageDict",setL);
    }
    int setU = HWKIM_SetUserDict(&imHandle, [userD UTF8String], 0);
    if (0 != setU) {
        NSLog(@"错误%d ~change~  HWKIM_SetUserDict",setU);
    }

    //    isFirstInit = NO;

    return YES;
}


@end
