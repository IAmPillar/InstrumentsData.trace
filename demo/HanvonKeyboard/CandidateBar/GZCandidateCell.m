//
//  GZCandidateCell.m
//  HanvonKeyboard
//
//  Created by hanvon on 2018/4/24.
//  Copyright © 2018年 hanvon. All rights reserved.
//

#import "GZCandidateCell.h"
@implementation GZCandidateCell
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self){
        self.backgroundColor = [UIColor whiteColor];
        [self creatUIWithFrame:frame];
    }
    return self;
}
- (void)creatUIWithFrame:(CGRect)frame {
    CGRect newBound = self.bounds;
    _titleLabel = [[UILabel alloc] initWithFrame:newBound];
    _titleLabel.backgroundColor = [UIColor whiteColor];
    _titleLabel.textColor = [UIColor blackColor];
    _titleLabel.textAlignment = NSTextAlignmentLeft;
    _titleLabel.font = [UIFont systemFontOfSize:18];
    _titleLabel.numberOfLines = 1;
    [self.contentView addSubview:_titleLabel];
}
- (void)setTitleText:(NSString*)text {
    _titleLabel.frame = self.bounds;
    _titleLabel.text = text;
}
@end
