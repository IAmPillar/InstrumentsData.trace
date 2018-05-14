//
//  GZCandidateBarView.m
//  HanvonKeyboard
//
//  Created by hanvon on 2017/11/4.
//  Copyright © 2017年 hanvon. All rights reserved.
//

#import "GZCandidateBarView.h"
#import "GZCandidateCell.h"
#import <AudioToolbox/AudioToolbox.h>

#define pinyinHeight 15.0 //拼音串的高度
#define lineHeight 0.5 //分割线高度
#define candidetes 30 //候选栏的最大数量

@interface GZCandidateBarView()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (nonatomic,copy) NSArray *data;
@property (nonatomic,strong) UICollectionView *collectionView;
@property (nonatomic,assign) BOOL isShowMore; //是否是展示更多候选 状态
@property (nonatomic,assign) BOOL changeToDelete; //更多候选按钮 是否转成删除功能
@end


@implementation GZCandidateBarView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        //创建view
        self.layer.borderWidth = lineHeight;
        self.layer.borderColor = [Color_background_kb CGColor];

        _isShowMore = NO;
        //创建固定view
        [self createFixedUI];
    }
    return self;
}

//改变拼音
- (void)changeShowPinyin:(NSString *)pinyin andRange:(NSRange)range {
    if (!pinyin || pinyin.length == 0) {
        UILabel *PinyinLabel = (UILabel*)[self viewWithTag:10];
        [PinyinLabel removeFromSuperview];
        return;
    }

    CGFloat left = 7.0;
    CGFloat height = pinyinHeight; //拼音的高度
    CGFloat showButtonH = self.frame.size.height; //展开更多的宽高

    //拼音label
    UILabel *PinyinLabel = (UILabel*)[self viewWithTag:10];
    if (!PinyinLabel) {
        PinyinLabel = [[UILabel alloc] initWithFrame:CGRectMake(left, 0, self.frame.size.width-showButtonH-left, height)];
        PinyinLabel.backgroundColor = [UIColor whiteColor];;
        PinyinLabel.font = [UIFont systemFontOfSize:13];
        PinyinLabel.textAlignment = NSTextAlignmentLeft;
        PinyinLabel.textColor = [UIColor blackColor];
        [self addSubview:PinyinLabel];
        PinyinLabel.tag = 10;
    }

    if (range.length > 0) {
        PinyinLabel.attributedText = [self addUnderlineWithPinyin:pinyin andRange:range];
    }else {
        PinyinLabel.text = pinyin;
    }
    pinyin = nil;
}

//改变候选的展示内容
- (void)changeShowText:(NSArray*)textArr {
    _data = textArr;
    if (_collectionView) {
        _collectionView.delegate = nil;
        _collectionView.dataSource = nil;
        [_collectionView removeFromSuperview];
        _collectionView = nil;
    }
    [self createCandideteColection];

//    [_collectionView reloadData];
//    [_collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
    textArr = nil;
}

//是否存在候选内容
- (BOOL)isTabBarHasData {
    for (UIButton *bbt in self.subviews) {
        if (bbt) {
            return YES;
        }
    }
    return NO;
}

//是否有拼音
- (BOOL)isTabBarHasPinyin {
    UILabel *PinyinLabel = (UILabel*)[self viewWithTag:10];
    NSString *string = PinyinLabel.text;
    if (string != nil && string.length != 0) {
        return YES;
    }
    return NO;
}

//改变展示更多 按钮   0收起 1展示更多
- (void)changeShowMoreButton:(int)type {
    UIButton *moreButton = (UIButton*)[self viewWithTag:7];
    if (!moreButton) {
        return;
    }

    if (type == 0) {
        //收起
        _isShowMore = NO;
        [moreButton setImage:[UIImage imageNamed:@"keyboard_down"] forState:UIControlStateNormal];
    }else if (type == 1) {
        //展开
        _isShowMore = YES;
        [moreButton setImage:[UIImage imageNamed:@"keyboard_up"] forState:UIControlStateNormal];
    }else {

    }
}

//改变展示更多按钮 成为删除按钮 1添加删除 0移除删除并移除tabbar
- (void)changeShowMoreToDelete:(BOOL)changeToDelete {
    _changeToDelete = changeToDelete;

    UIButton *moreButton = (UIButton*)[self viewWithTag:7];

    if (!changeToDelete) {
        //移除tabbar 并移除删除按钮
        if (moreButton) {
            if (!_isShowMore) {
                [moreButton setImage:[UIImage imageNamed:@"keyboard_down"] forState:UIControlStateNormal];
            }else {
                [moreButton setImage:[UIImage imageNamed:@"keyboard_up"] forState:UIControlStateNormal];
            }
            [moreButton setTitle:nil forState:UIControlStateNormal];
        }
    }else {
        //添加删除按钮
        [moreButton setImage:nil forState:UIControlStateNormal];
        [moreButton setTitle:@"X" forState:UIControlStateNormal];
    }
}

//获取候选内容
- (NSArray*)getCadidateArray {
    return _data;
}

//获取候选第一个
- (NSString*)getFirstCandidate {
    return [_data objectAtIndex:0];
}

//获取拼音
- (NSString*)getPinyin {
    UILabel *PinyinLabel = (UILabel*)[self viewWithTag:10];
    NSString *text = PinyinLabel.text;
    if (text != nil && text.length != 0) {
        text = [text stringByReplacingOccurrencesOfString:@"'" withString:@""];
        return text;
    }
    return nil;
}


//切换横竖屏时，传入的新高度
- (void)changeViewFrame:(CGRect)newFrame {

    self.frame = newFrame;

    //展开候选
    UIButton *showButton = (UIButton*)[self viewWithTag:7];
    CGFloat showButtonH = self.frame.size.height-pinyinHeight-0.5;
    CGFloat showButtonX = newFrame.size.width - showButtonH;
    showButton.frame = CGRectMake(showButtonX, pinyinHeight+0.5, showButtonH, showButtonH);

    //候选、拼音 分割线
    UILabel *line = (UILabel*)[self viewWithTag:8];
    line.frame = CGRectMake(0, line.frame.origin.y, newFrame.size.width, lineHeight);

    //拼音
    UILabel *PinyinLabel = (UILabel*)[self viewWithTag:10];
    CGRect frame = PinyinLabel.frame;
    PinyinLabel.frame = CGRectMake(frame.origin.x, frame.origin.y, newFrame.size.width-showButtonH-frame.origin.x, frame.size.height);

    //候选
    CGFloat y = pinyinHeight+lineHeight; //候选按钮的y
    CGFloat candidateShowWidth = self.frame.size.width - showButtonH; //候选区域的总宽度
    _collectionView.frame = CGRectMake(0, y, candidateShowWidth, showButtonH);
}

//更改模式颜色
- (void)changeBackgroudColor {
    //背景色
    self.backgroundColor = [UIColor whiteColor];

    GZFunctionButton *showButton = (GZFunctionButton*)[self viewWithTag:7];
    showButton.backgroundColor = [UIColor whiteColor];

    //拼音
    UILabel *PinyinLabel = (UILabel*)[self viewWithTag:10];
    PinyinLabel.backgroundColor = [UIColor whiteColor];

    //候选
    _collectionView.backgroundColor = [UIColor whiteColor];
}

//点击删除键 删除第一个候选内容的 最后一个字符（手写键盘专用）
- (void)deleteBackwardActionByNowCandidates:(NSArray*)texArr complation:(SuccesDeleteBackwardBlock)data {

    NSMutableArray *newTexArr = [[NSMutableArray alloc] init];
    if (!texArr || texArr.count == 0) {
        UIScrollView *candidateView = (UIScrollView*)[self viewWithTag:6];
        for (UIView *bbt in candidateView.subviews) {
            if ([bbt isKindOfClass:[UIButton class]]) {
                UIButton *button = (UIButton*)bbt;
                NSString *text = button.titleLabel.text;
                [newTexArr addObject:text];
            }
        }
    }else {
        newTexArr = [texArr mutableCopy];
    }

    //候选框没有任何候选内容
    if (newTexArr.count == 0 || !newTexArr) {
        data(YES,YES);//第一个候选  只有一个字符  直接移除当前候选框
        return;
    }


    NSString *first = [newTexArr objectAtIndex:0];
    if (first.length <= 1) {
        data(YES,YES);//第一个候选  只有一个字符  直接移除当前候选框
        return;
    }

    NSString *newFirst = [first substringToIndex:first.length-1];
    [newTexArr replaceObjectAtIndex:0 withObject:newFirst];

    [self changeShowText:newTexArr];
    data(YES,NO);
}

#pragma mark -- UI
//候选框父视图
- (void)createFixedUI {
    //展开候选 按钮
    CGFloat showButtonH = self.frame.size.height-pinyinHeight-0.5; //展开更多按钮的宽高
    CGFloat showButtonX = self.frame.size.width - showButtonH;
    CGFloat showButtonY = pinyinHeight+0.5;
    GZFunctionButton *showButton = (GZFunctionButton*)[self viewWithTag:7];
    if (!showButton) {
        showButton = [GZFunctionButton buttonWithType:UIButtonTypeCustom];
        showButton.backgroundColor = [UIColor whiteColor];
        //        showButton.layer.borderWidth = lineHeight;
        //        showButton.layer.borderColor = [Color_background_kb CGColor];
        showButton.frame = CGRectMake(showButtonX, showButtonY, showButtonH, showButtonH);
        [showButton addTarget:self action:@selector(showMoreTap:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:showButton];
        showButton.tag = 7;

        [showButton setTitleColor:[UIColor colorWithHexString:float_Color_button_function] forState:UIControlStateNormal];
        showButton.titleLabel.font = [UIFont systemFontOfSize:20];
        [showButton setImage:[UIImage imageNamed:@"keyboard_down"] forState:UIControlStateNormal];
    }

    CGFloat height = pinyinHeight; //拼音的高度

    //分割线
    UILabel *line = (UILabel*)[self viewWithTag:8];
    if (!line) {
        line = [[UILabel alloc] initWithFrame:CGRectMake(0, height, self.frame.size.width, lineHeight)];
        line.backgroundColor = RGBA(210, 213, 219, 1);
        [self addSubview:line];
        line.tag = 8;
    }

    //候选栏
    [self createCandideteColection];
}

//候选栏collection
- (void)createCandideteColection {
    if (!_collectionView) {
        CGFloat height = self.frame.size.height-pinyinHeight-lineHeight; //候选按钮的高度
        CGFloat y = pinyinHeight+lineHeight; //候选按钮的y
        CGFloat showButtonH = height; //展开更多按钮的宽高
        CGFloat candidateShowWidth = self.frame.size.width - showButtonH; //候选区域的总宽度

        UICollectionViewFlowLayout *flow = [[UICollectionViewFlowLayout alloc] init];
        flow.scrollDirection = UICollectionViewScrollDirectionHorizontal; //水平滑动方向
        flow.minimumInteritemSpacing = 20; //水平最小间距
        flow.minimumLineSpacing = 20;

        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, y, candidateShowWidth, height) collectionViewLayout:flow];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.bounces = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        [_collectionView registerClass:[GZCandidateCell class] forCellWithReuseIdentifier:@"candidateCell"];
        [self addSubview:_collectionView];

        flow = nil;
    }
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (_data.count > 30) {
        return 30;
    }
    return _data.count;
}
//定义每个Section 的 margin
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 7, 0, 0);//分别为上、左、下、右
}
//cell的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat height = self.frame.size.height-pinyinHeight-lineHeight; //候选按钮的高度
    NSString *str = _data[indexPath.row];
    CGFloat width = [[GZPublicMethod sharedPublicMethod] widthForString:str font:18 andHeight:height];
    if (width < 30) {
        width = 30;
    }

    return CGSizeMake(width, height);
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"candidateCell";
    GZCandidateCell *cell = (GZCandidateCell*)[collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    [cell setTitleText:_data[indexPath.row]];
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.sendSelectedStr) {
        NSString *str =_data[indexPath.row];
        self.sendSelectedStr(str, (int)indexPath.row);
    }
}
//当cell高亮时返回是否高亮
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
- (void)collectionView:(UICollectionView *)collectionView didHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
    //NSLog(@"高亮");
    GZCandidateCell *cell = (GZCandidateCell*)[collectionView cellForItemAtIndexPath:indexPath];
    cell.backgroundColor = float_Color_button_hightlight;
}
- (void)collectionView:(UICollectionView *)collectionView didUnhighlightItemAtIndexPath:(NSIndexPath *)indexPath {
    //NSLog(@"正常");
    GZCandidateCell *cell = (GZCandidateCell*)[collectionView cellForItemAtIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
}

- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    
}


#pragma mark -- private
//点击展示更多
- (void)showMoreTap:(UIButton*)tap {
    if (_changeToDelete) {
        if (self.sendRemoveTabbar) {
            self.sendRemoveTabbar(YES);
        }
        return;
    }

    UIButton *moreButton = (UIButton*)[self viewWithTag:7];

    _isShowMore = !_isShowMore;

    if (_isShowMore) {
        //展示
        [moreButton setImage:[UIImage imageNamed:@"keyboard_up"] forState:UIControlStateNormal];
        if (_data && self.sendShowMoreFunc) {
            self.sendShowMoreFunc(YES,_data);
        }
    }else {
        //收起
        [moreButton setImage:[UIImage imageNamed:@"keyboard_down"] forState:UIControlStateNormal];
        if (self.sendShowMoreFunc) {
            self.sendShowMoreFunc(NO,nil);
        }
    }
}

//拼音下划线
- (NSMutableAttributedString*)addUnderlineWithPinyin:(NSString*)pinyin andRange:(NSRange)range {
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:pinyin];
    [attrStr addAttribute:NSForegroundColorAttributeName //NSUnderlineStyleAttributeName
                    value:float_Color_button_hightlight //[NSNumber numberWithInteger:NSUnderlineStyleSingle]
                    range:range];
    return attrStr;
}


- (void)dealloc {
    NSLog(@"候选框 销毁");
    _data = nil;
    //分割线
    UILabel *line = (UILabel*)[self viewWithTag:8];
    if (line) {
        [line removeFromSuperview];
        line = nil;
    }
    if (_collectionView) {
        [_collectionView removeFromSuperview];
        _collectionView = nil;
    }
    //拼音
    UILabel *PinyinLabel = (UILabel*)[self viewWithTag:10];
    [PinyinLabel removeFromSuperview];
    PinyinLabel = nil;

    UIScrollView *candidateView = (UIScrollView*)[self viewWithTag:6];
    if (candidateView) {
        [candidateView removeFromSuperview];
        candidateView = nil;
    }

    UIButton *showButton = (UIButton*)[self viewWithTag:7];
    if (showButton) {
        [showButton removeFromSuperview];
        showButton = nil;
    }

    self.sendSelectedStr = nil;
    self.sendShowMoreFunc = nil;
    self.sendRemoveTabbar = nil;

    [self removeFromSuperview];
}

@end
