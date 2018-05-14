//
//  LibraryUtility.h
//  HanvonNote
//
//  Created by gao guoling on 11-11-14.
//  Copyright (c) 2011年 Hanwang Technology Co. All rights reserved.
//

// 识别语言
//typedef enum {
//    NSLanguageTypeCN,
//    NSLanguageTypeTW,
//    NSLanguageTypeEN,
//    NSLanguageTypeLast,
//} NSLanguageType;

#ifdef __cplusplus
extern "C" {
#endif

    // 读取文件
    // filePath 文件路径
    // contentBytes 返回文件长度
    // 返回 文件内容
    long* loadFile(const char *filePath, unsigned int *contentBytes);
    
    // 保存文件
    int saveFile(const void *content, unsigned int contentBytes, const char*filePath);

    // 申请内存
    long* allocMemory(int bytes);
    
    // 释放内存
    int releaseMemory(void* memory);

#ifdef __cplusplus
}
#endif
