//
//  LibraryUtility.m
//  HanvonNote
//
//  Created by gao guoling on 11-11-14.
//  Copyright (c) 2011年 Hanwang Technology Co. All rights reserved.
//

#import "LibraryUtility.h"
#import <stdio.h>

// 读取文件
// filePath 文件路径
// contentBytes 返回文件长度
// 返回 文件内容
long* loadFile(const char *filePath, unsigned int *contentBytes)
{
    if (contentBytes != NULL) {
        *contentBytes = 0;
    }
    
    if (filePath == NULL) {
        return NULL;
    }
    
    FILE* fp = fopen(filePath, "rb");
    if (fp == NULL) {
        return NULL;
    }
    
    fseek( fp, 0, SEEK_END );
    int fileSize = (int)ftell(fp);
    long* content = new long[(fileSize + fileSize % 4) >> 2];
    if (content == NULL) {
        return NULL;
    }
    
    fseek(fp, 0, SEEK_SET);
    fread(content, fileSize, 1, fp);
    fclose(fp);
    if (contentBytes != NULL) {
        *contentBytes = fileSize;
    }
    return content;
}

// 保存文件
int saveFile(const void *content, unsigned int contentBytes, const char*filePath)
{
    if (filePath == NULL) {
        return -1;
    }
    
    FILE *fp = fopen(filePath, "wb");
    if (fp == NULL) {
        return -2;
    }
    
    fwrite(content, contentBytes, 1, fp);
    fclose(fp);
    
    return 0;
}

// 申请内存
long* allocMemory(int bytes)
{
    return new long[(bytes + bytes % 4) >> 2];
}

// 释放内容
int releaseMemory(void* memory)
{
    delete[] (long*)memory;
    return 0;
}
