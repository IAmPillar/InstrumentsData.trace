//
//  GZCandidateCell.h
//  HanvonKeyboard
//
//  Created by hanvon on 2018/4/24.
//  Copyright © 2018年 hanvon. All rights reserved.
//

#import <UIKit/UIKit.h>


/**
 *候选栏 cell
 ***/

@interface GZCandidateCell : UICollectionViewCell
@property (nonatomic,copy) UILabel *titleLabel;
- (void)setTitleText:(NSString*)text;
@end
