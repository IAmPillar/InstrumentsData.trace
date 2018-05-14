/*
 * Copyright (C) 2009-2016 Hanwang Technology Company
 * All rights reserved.
 *
 * file name: HWIM_SDK.h
 * date created: June 18, 2009
 * last modified: Aug 3, 2016
 */

#ifndef __HW_INPUT_METHOD_SDK__
#define __HW_INPUT_METHOD_SDK__

/* -------------------Recognition Language---------------- */
#define HWLANG_Chinese_Mainland   0x1000
#define HWLANG_Chinese_Taiwan     0x1010
#define HWLANG_Chinese_Hongkong   0x1020

#define HWLANG_Japanese         0x2000

#define HWLANG_Korean           0x3000

#define HWLANG_English          0x4000

/* -------------------Fuzzy Pinyin Setting-Multiple-Choice--------------- */
#define HW_FUZZY_Z_ZH      0x0001 // z<-->zh
#define HW_FUZZY_C_CH      0x0002 // c<-->ch
#define HW_FUZZY_S_SH      0x0004 // s<-->sh
#define HW_FUZZY_F_H       0x0008 // f<-->h
#define HW_FUZZY_K_G       0x0010 // k<-->g
#define HW_FUZZY_L_N       0x0020 // l<-->n
#define HW_FUZZY_L_R       0x0040 // l<-->r
#define HW_FUZZY_IAN_IANG  0x0080 // ian<-->iang
#define HW_FUZZY_UAN_UANG  0x0100 // uan<-->uang
#define HW_FUZZY_AN_ANG    0x0200 // an<-->ang
#define HW_FUZZY_EN_ENG    0x0400 // en<-->eng
#define HW_FUZZY_IN_ING    0x0800 // in<-->ing

/* -----------------常量定义---------------------- */
#define HWIM_MAX_PHONETIC_LEN           6  // 拼音的最大长度
#define HWRE_MAX_CHINESE_WORD_LEN       12 // 中文词典中的最大词长.
#define HWRE_MAX_LATIN_WORD_LEN         31 // 拉丁文最大词长

// 中文输入模式下，最大分组个数。
// 目前分组功能只适用于拼音输入法和注音输入法。
// 分组是根据第一个自动分割符位置区分的。
#define HWRE_MAX_PHONETIC_GROUP_NUM     20

// 中文拼音分组所占字符个数
#define HWRE_OUT_PHONETIC_BUFSIZE  \
    (HWRE_MAX_PHONETIC_GROUP_NUM*(HWIM_MAX_PHONETIC_LEN+1))

// 最大可输入码长，包括手动分割符
#define HW_MAX_INPUTSTR_LEN     64

// 最大的显示输入串长
#define HW_MAX_INPUT_SHOW_LEN  (HW_MAX_INPUTSTR_LEN*2)


/* -------------配置属性--------------------------- */
#define HWKEYIM_MIN_RAMSIZE  (3*1024 * 1024) //运算空间大小

/* -------------------Keyboard Mode---------------- */
#define HWIM_KEYBOARD_NOTREDUCE         1 // 全键盘
#define HWIM_KEYBOARD_REDUCE            2 // 压缩键盘

/* -------------------输入法模式---------------- */

// 拼音输入法:
//   可设置为缩减键盘布局 、非缩减键盘布局和自定义键盘布局。
//   非缩减键盘布局接受'a-z'字符和分隔符。
//   缩减键盘为9宫格布局，接受'2-9'字符、分隔符。
//
#define HWIM_MODE_PINYIN         101

#define HWIM_MODE_ZHUYIN         102

#define HWIM_MODE_BIHUA          103

#define HWIM_MODE_CANGJIE        104

#define HWIM_MODE_JYUTPING       106

#define HWIM_MODE_HIRAGANA       201

#define HWIM_MODE_ROMAJI         202

#define HWIM_MODE_KATAKANA       203

/* ---------------- Code ----------------------------*/
// 空格符
#define  HW_KEY_SpaceBar_Code   (0x20)
// 分隔符
#define  HW_KEY_Separator_Code  (0x27)
// 通配符
#define  HW_KEY_Wildcard_Code   (0x2A)
// 退格符
#define  HW_KEY_BackSpace_Code  (0x08)

/* -------------错误代码--------------------------- */
#define HWERR_SUCCESS                        (0) // 成功
#define HWERR_INVALID_PARAM                 (-1) // 参数错误
#define HWERR_NOT_ENOUGH_MEMORY             (-2) // 内存不足
#define HWERR_INVALID_DATA                  (-3) // 无效的数据
#define HWERR_INVALID_MEMORY                (-4) // 无效的内存指针
#define HWERR_READ_DICT_FAIL                (-5) // 字典读取错误
#define HWERR_HANDLE_NOT_ENOUGH             (-6) // 句柄内存不够
#define HWERR_NO_FILE_NAME                  (-7) // 缺少文件名
#define HWERR_NO_LOADER_CALLBACK            (-8) // 缺少加载字典函数
#define HWERR_NO_CHINESE                    (-9) // 不是中文输入法
#define HWERR_NEED_INIT                     (-10) // 需要先初始化
#define HWERR_NO_SYSDICT                    (-11) // 系统字典未加载
#define HWERR_INVALID_INPUT                 (-12) // 非法输入
#define HWERR_INVALID_SYSDICT               (-13) // 非法的语言字典
#define HWERR_INVALID_USERDICT              (-14) // 非法用户字典
#define HWERR_NO_RELEASER_CALLBACK          (-15) // 缺少释放字典函数
#define HWERR_INVALID_POINTER               (-16) // 无效的指针
#define HWERR_WRITE_FILE_FAIL               (-17) // 写入文件失败
#define HWERR_NEED_WORKSPACE                (-18) // 缺少运算空间
#define HWERR_NOT_SUPORT_LANGUAGE           (-19) // 不支持的语言
#define HWERR_NOT_SUPORT_COMMAND            (-20) // 不支持的命令
#define HWERR_OPEN_FILE_FAIL                (-21) // 打开文件失败
#define HWERR_NOT_SUPPORT_KEYBOARDMODE      (-22) // 不支持的键盘布局模式
#define HWERR_WORD_EXIST                    (-23) // 存在该词
#define HWERR_INVALID_UDB_WORDTYPE          (-24) // 错误的用户词类型
#define HWERR_INVALID_CHARACTER             (-25) // 非当前字符集中的字
#define HWERR_NO_USERDICT                   (-26) // 未加载用户字典
#define HWERR_FINISH                        (-27) // 候选已选择完成
#define HWERR_BHCJNORESULT                  (-28) // 笔画或仓颉输入法，输入串没有对应的候选
#define HWERR_INPUT_TOOLONG                 (-29) // 输入串过长
#define HWERR_DIC_ALREADY_EXISTS            (-30) // 已存在相同的字典
#define HWERR_DIC_SPACE_IS_FULL             (-31) // 字典空间已满，不能加入更多的字典
#define HWERR_NO_SPECIFIED_DIC              (-32) // 没有指定的字典
#define HWERR_RELEASE_DIC_FAILED            (-33) // 释放字典失败
#define HWERR_EXPIRED                       (-100) // 过期

/* Dictionary file priority. */
#define HWDIC_PRIORITY_HIGHEST   0
#define HWDIC_PRIORITY_LOWEST    15

/* Dictionary subtype. For POI. */
#define HWDIC_SUBTYPE_MINIMUM    0
#define HWDIC_SUBTYPE_MAXIMUM    255

// HWIM_HANDLE结构表示空间
typedef struct tagHWIM_HANDLE {
    unsigned long Handle[128];
} HWIM_HANDLE;

#ifdef WIN32
#define HWAPI __declspec(dllexport)
#else
#define HWAPI
#endif

#ifdef __cplusplus
extern "C" {
#endif

/*
HWCBK_LoadDict：加载字典回调函数。
功能：打开字典文件，加载到内存中。
参数：
    const char *    :[in]字典文件的路径名称字符串。
    uint32_t *      :[out]字典文件大小。
返回值：
    加载字典的内存指针，要4字节对齐。
*/
typedef void *(*HWCBK_LoadDict)(const char*, unsigned int*);

/*
HWCBK_SaveDict：保存字典回调函数。
功能：把内存中的字典保存为文件。
参数：
    void *         :[in]要保存的内存指针。
    unsigned int   :[in]保存内存的大小。
    const char *   :[in]字典文件的路径名称字符串。
返回值：
    错误代码。
*/
typedef int (*HWCBK_SaveDict)(const void* , unsigned int, const char*);

/*
HWCBK_ReleaseDict：卸载字典回调函数。
功能：释放字典内存。
参数：
    unsigned char *    :[in]字典在内存中的指针。
返回值：
    错误代码。
*/
typedef int (*HWCBK_ReleaseDict)(void *);

/*
HWKIM_GetVersion: 获得版本号
功能：获取输入法引擎的版本号。
返回值：
    版本号
*/
HWAPI const char *HWKIM_GetVersion(void);

/*
HWKIM_Init: 输入法初始化句柄
参数：
    pHandle             ：[in]输入法句柄结构指针。
    CallbackFileLoader  ：[in]用户定义的加载字典回调函数。
    CallbackReleaser    ：[in]用户定义的释放内存回调函数。
返回值：
    错误类型。
*/
HWAPI int HWKIM_Init(HWIM_HANDLE *pHandle,
                     HWCBK_LoadDict CallbackFileLoader,
                     HWCBK_ReleaseDict CallbackReleaser,
                     HWCBK_SaveDict CallbackSaver);

/*
HWKIM_SetWorkSpace：设置输入法工作空间。
功能：设置输入法的运算内存。
参数：
    pHandle   ：[in]输入法句柄结构指针。
    pcRam     ：[in]运算内存指针，4字节对齐，至少为HWKEYIM_MIN_RAMSIZE字节。
    lRamSize  ：[in]该内存的字节数，4的整数倍。
返回值：
    错误类型。
*/
HWAPI int HWKIM_SetWorkSpace(HWIM_HANDLE *pHandle,
                             void *pRam, unsigned int nRamSize);

/*
HWKIM_SetLanguageDict：设置系统字典
功能：把系统字典指针，保存到句柄中。
参数：
    pHandle             : [in] 输入法句柄结构指针。
    nLanguage           : [in] 语言编号。
    pszDictFilePathName : [in] 字典文件路径名。
    nPriorty            : [in] 系统字典的优先级。请参看 HWDIC_PRIORITY_XXX。
返回值：
    错误类型。
*/
HWAPI int HWKIM_SetLanguageDict(HWIM_HANDLE *pHandle, int nLanguage,
                                const char *pszDictFilePathName,
                                int nPriority);

/*
HWKIM_ReleaseLanguageDict：释放系统字典
功能：释放系统字典内存。
参数：
    pHandle        ：[in]输入法句柄结构指针
返回值：
    错误类型。
*/
HWAPI int HWKIM_ReleaseLanguageDict(HWIM_HANDLE *pHandle);

/*
HWKIM_GetLanguage：获取输入语言设置
功能：返回句柄中的输入语言设置。
参数：
    pHandle       ：[in]输入法句柄结构指针
返回值：
    输入语言设置，或错误代码。
*/
HWAPI int HWKIM_GetLanguage(HWIM_HANDLE *pHandle);

/*
HWKIM_SetUserDict：设置中文用户字典
功能：把用户字典指针，保存到句柄中。
参数：
    pHandle              : [in] 输入法句柄结构指针
    pszDictFilePathName  : [in] 字典文件路径名
                                如果该参数设置为NULL， 则表示不加载用户字典
    nPriority            : [in] 用户字典优先级。请参看HWDIC_PRIORITY_XXX。
返回值：
    错误类型。
*/
HWAPI int HWKIM_SetUserDict(HWIM_HANDLE *pHandle,
                            const char *pszDictFilePathName, int nPriority);

/*
HWKIM_SaveUserDict：保存中文用户字典
功能：把用户字典，保存到文件中。
参数：
    pHandle              : [in] 输入法句柄结构指针。
    pszDictFilePathName  : [in] 字典文件路径名。
    CBK_DictSaver        : [in] 保存用户字典的回调函数。
返回值：
    错误类型。
*/
HWAPI int HWKIM_SaveUserDict(HWIM_HANDLE *pHandle);

/*
HWKIM_ReleaseUserDict：释放用户字典
功能：释放用户字典内存。
参数：
    pHandle             : [in]输入法句柄结构指针。
返回值：
    错误类型。
*/
HWAPI int HWKIM_ReleaseUserDict(HWIM_HANDLE *pHandle);

/*
HWKIM_SetKeyboardMode：设置键盘模式
功能：设置句柄中的键盘模式。
参数：
    pHandle        ：[in]输入法句柄结构指针。
    nKeyboard      ：[in]键盘模式。
返回值：
    错误类型。
*/
HWAPI int HWKIM_SetKeyboardMode(HWIM_HANDLE *pHandle, int nKeyboard);

/*
HWKIM_GetKeyboardMode：获取当前键盘模式
功能：返回句柄中的键盘模式设置。
参数：
    pHandle      ：[in]输入法句柄结构指针。
返回值：
    键盘模式，或错误代码。
*/
HWAPI int HWKIM_GetKeyboardMode(HWIM_HANDLE *pHandle);

/*
HWKIM_SetInputMode：设置输入模式。
功能：设置句柄中的输入模式。
参数：
    pHandle         ：[in]输入法句柄结构指针。
    nInputMode      ：[in]中文输入模式编号。
返回值：
    错误代码。
*/
HWAPI int HWKIM_SetInputMode(HWIM_HANDLE *pHandle, int nInputMode);

/*
HWKIM_GetChineseInputMode：获取当前输入模式
功能：返回句柄中的输入模式设置。
参数：
    pHandle       ：[in]输入法句柄结构指针。
返回值：
    中文输入模式，或错误代码。
*/
HWAPI int HWKIM_GetInputMode(HWIM_HANDLE *pHandle);


/*
HWKIM_SetPinyinFuzzy：设置拼音模糊音
功能：设置句柄中的拼音模糊音。
参数：
    pHandle        ：[in]输入法句柄结构指针。
    nFuzzyCode     ：[in]模糊音设置位编码。
返回值：
    错误代码。
*/
HWAPI int HWKIM_SetPinyinFuzzy(HWIM_HANDLE *pHandle, int nFuzzyCode);

/*
HWKIM_GetPinyinFuzzy：获取模糊音设置
功能：返回句柄中的拼音模糊音设置。
参数：
    pHandle     ：[in]输入法句柄结构指针。
返回值：
    中文模糊音设置，或错误代码。
*/
HWAPI int HWKIM_GetPinyinFuzzy(HWIM_HANDLE *pHandle);

/*
HWKIM_InputStrClean:输入串初始化函数.
功能：输入串初始化函数，用于快速全部清空中间结果。
参数说明：
    pHandle  ：[in]输入法句柄结构指针。
返回值：
    错误类型。
*/
HWAPI int HWKIM_InputStrClean(HWIM_HANDLE *pHandle);

/*
HWKIM_AddChar:输入串加字符操作函数.
功能：输入串加字符操作函数, 最长48个字符
参数说明：
    pHandle   ：[in]输入法句柄结构指针。
    wChar     ：[in]字符；接受HWIM_KEY_BackSpace_Code,以及相应语言、输入法模式对应的输入符号。
返回值：
    错误代码
*/
HWAPI int HWKIM_AddChar(HWIM_HANDLE *pHandle, unsigned int wChar);

/*
HWKIM_AddStr: 输入串加字符串操作函数.
功能：输入串加字符串操作函数，最长48个字符
参数说明：
    pHandle    ：[in]输入法句柄结构指针。
    wAddStr    ：[in]字符串；HWIM_KEY_BackSpace_Code,以及相应语言、输入法模式对应的输入符号。
返回值：
    错误代码
*/
HWAPI int HWKIM_AddStr(HWIM_HANDLE *pHandle, const unsigned short *pwAddStr);

/*
HWKIM_GetInputTransResult:得到输入串的转换函数。
功能：得到输入串的转换
参数说明：
    pHandle            ：[in]输入法句柄结构指针。
    pwOutString        ：[out]用来保存输出显示的串，
                         长度为HW_MAX_INPUT_SHOW_LEN*2+2，宽字符编码。
返回值：
    用于显示的串长度，或错误代码。
*/
HWAPI int HWKIM_GetInputTransResult(HWIM_HANDLE *pHandle,
                                    unsigned short *pwOutString);

/*
HWKIM_GetConvertedCharNum: 获取转换出的汉字的个数
功能: 在成功调用HWKIM_ChooseCandWord()后，有些拼音可能还未转换成汉字。
      该函数的功能是获取已转换的汉字的个数。
参数:
    pHandle     : [in] 输入法句柄结构指针
返回值:
    转换汉字个数，或错误码。
*/
HWAPI int HWKIM_GetConvertedCharNum(HWIM_HANDLE *pHandle);

/*
功能：得到分组。
参数说明：
    pHandle               : [in]输入法句柄结构指针。
    pwOutPhoneticGroups   : [out]发音分组内容，字符串以0间隔，宽字符编码，
                                 缓冲区大小至少为HWRE_OUT_PHONETIC_BUFSIZE
返回值：
    实际的发音分组个数。
*/
HWAPI int HWKIM_GetPhoneticGroup(HWIM_HANDLE *pHandle,
                                 unsigned short *pwOutPhoneticGroups);

/*
HWKIM_GetWordCandidates:得到候选词函数。
参数说明：
    pHandle              ：[in]输入法句柄结构指针
    nSelectPhoneIndex    ：[in]分组索引
    nStartWordIndex      ：[in]输入，表示要输出的候选词的总索引位置
    pwCandWordBuf        ：[out]输出候选词的内存空间指针。要求4字节对齐
    nCandWordBufSize     ：[in]输入，候选词的内存空间大小，以字节为单位
返回值：
    实际得到的候选词个数
*/
HWAPI int HWKIM_GetWordCandidates(HWIM_HANDLE *pHandle,
                                  int nSelectPhoneIndex,
                                  unsigned short *pwCandWordBuf,
                                  int nCandWordBufSize);
/*
HWKIM_GetSelSylPos: 获取已选音节在转换串的位置
参数说明：
    pHandle              : [in] 输入法句柄结构指针
    start                : [out] 起始位置
    end                  : [out] 结束位置
返回值:
    错误码
说明：
    有效位置为 [*start, *end)

*/
HWAPI int HWKIM_GetSelSylPos(HWIM_HANDLE *pHandle,
                             unsigned int *start,
                             unsigned int *end);

/*
HWKIM_ChooseCandWord：选择候选词函数。
功能：选择候选词
参数说明：
    pHandle          : [in]输入法句柄结构指针。
    nWordIndex       : [in]选中候选词的索引，该索引是在所有候选中的绝对索引
返回值：
    错误代码
*/

HWAPI int HWKIM_ChooseCandWord(HWIM_HANDLE *pHandle, int nWordIndex);

/*
HWKIM_IsFinish：查询用户输入完成函数。
功能：查询用户输入的字符是否都转换成汉字。
参数说明：
    pHandle         : [in]输入法句柄结构指针。
返回值：
    1：是。
    0：否。
    其他：错误代码。
*/
HWAPI int HWKIM_IsFinish(HWIM_HANDLE *pHandle);

/*
HWKIM_GetFullPhonetic：获得最终结果的完整读音的函数
参数说明：
    pHandle        ：[in]输入法句柄结构指针。
    pwFullPhonetic ：[out]输出最终结果的完整拼写方式,
                     大小至少为HW_MAX_INPUTSTR_LEN*(HWIM_MAX_PHONETIC_LEN+1)
返回值：
    全拼的长度，或错误代码。
*/
HWAPI int HWKIM_GetFullPhonetic(HWIM_HANDLE *pHandle,
                                unsigned short *pwFullPhonetic);

/*
HWKIM_UpdateUserDict：更新用户词函数
功能：更新用户词
参数说明：
    pHandle              ：[in]输入法句柄结构指针
    pwFullPhonetic       ：[in]词的读音，以'\0'结尾
    pwWord               ：[in]词，以'\0'结尾
返回值：
    错误代码
*/
HWAPI int HWKIM_UpdateUserDict(HWIM_HANDLE *pHandle,
                               const unsigned short *pwFullPhonetic,
                               const unsigned short *pwWord);

/*
HWKIM_GetPredictResult：获取联想词函数
功能：获取联想词。候选的最大长度为32. 最多2048个候选。
参数说明：
    pHandle            ：[in]输入法句柄结构指针
    pwInWordPrefix     ：[in]需要进行联想的词的字符串指针，以'\0'结尾
    pwInPhonetic       ：[in]pwInWordPrefix对应的读音，可为NULL
    pwCandWordBuf      ：[out]联想结果空间缓冲，每个词以'\0'分隔
    nCandWordBufSize   ：[in]联想空间的大小，字节为单位
返回值：
    联想到的词个数，或错误代码。
*/
HWAPI int HWKIM_GetPredictResult(HWIM_HANDLE *pHandle,
                                 const unsigned short *pwInWordPrefix,
                                 const unsigned short *pwInPhonetic,
                                 unsigned short *pwCandWordBuf,
                                 int nCandWordBufSize);

/*
HWKIM_GetUserWordCount: 获取用户词个数。
参数:
    pHandle   : [in] 句柄指针
返回值:
    用户词个数。
*/
HWAPI int HWKIM_GetUserWordCount(HWIM_HANDLE *pHandle);

/*
HWKIM_ResetChsUserDict
功能：重置中文用户字典，删除所有用户词和调频信息。
参数：
    pHandle : [in] 句柄指针
返回值：
    错误码
*/
HWAPI int HWKIM_ResetChsUserDict(HWIM_HANDLE *pHandle);

/*
HWKIM_GetSrcSequence: 获取字符的拼音列表
功能：获取字符的拼音列表
参数：
    pHandle : [in] 句柄指针
    wUnicode : [in] 字符的unicode码
    pwSrcCode : [out] 字符拼音缓冲区
返回值：
    拼音个数或错误码
*/
HWAPI int HWKIM_GetSrcSequence(HWIM_HANDLE *pHandle, unsigned short wUnicode,
                               unsigned short *pwSrcCode,
                               unsigned int nSrcCodeBufSize);

#ifdef __cplusplus
}
#endif

#endif
