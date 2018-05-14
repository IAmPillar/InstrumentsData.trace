//
//  GZCandidateCell.m
//  HanvonKeyboard
//
//  Created by hanvon on 2018/4/24.
//  Copyright © 2018年 hanvon. All rights reserved.
//

#import "GZCandidateCell.h"
//#import "CALayer+GZCandidateLayer.h"


@interface GZCandidateCell()
//@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) CAShapeLayer *pathLayer;
@end

@implementation GZCandidateCell
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self){
        [self creatUIWithFrame:frame];
    }
    return self;
}

- (void)creatUIWithFrame:(CGRect)frame {
    CGRect newBound = self.bounds;
    _titleLabel = [[UILabel alloc] initWithFrame:newBound];
    _titleLabel.backgroundColor = [UIColor clearColor];
    _titleLabel.opaque = YES;
    _titleLabel.textColor = [UIColor blackColor];
    _titleLabel.textAlignment = NSTextAlignmentLeft;
    _titleLabel.font = [UIFont systemFontOfSize:18];
    _titleLabel.numberOfLines = 1;
    [self.contentView addSubview:_titleLabel];
//    _sLayer = [CALayer layer];
//    _sLayer.frame = newBound;
//    [self.layer addSublayer:_sLayer];
}
- (void)setTitleText:(NSString*)text {
    _titleLabel.frame = self.bounds;
    _titleLabel.text = text;
//    [_pathLayer removeFromSuperlayer];
//    [_pathLayer removeAllAnimations];
//    _pathLayer = nil;
//    _pathLayer = [_titleLabel.layer setupTextLayerWithText:text fontSize:18 fontColor:[UIColor blackColor] fontAlignment:NSTextAlignmentLeft];
}

- (void)dealloc {
    NSLog(@"自定义cell 销毁");
    [_titleLabel removeFromSuperview];
    _titleLabel = nil;
//    [_pathLayer removeFromSuperlayer];
//    [_pathLayer removeAllAnimations];
//    _pathLayer = nil;
    [self removeFromSuperview];
}
@end
