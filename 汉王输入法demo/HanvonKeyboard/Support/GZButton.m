//
//  GZButton.m
//  HanvonKeyboard
//
//  Created by hanvon on 2017/11/10.
//  Copyright © 2017年 hanvon. All rights reserved.
//

#import "GZButton.h"
#import <AudioToolbox/AudioToolbox.h>
//#import <AVFoundation/AVFoundation.h>

@interface GZButton() {
    SystemSoundID soundFileObject;
}
@end
@implementation GZButton
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent*)event {
    GZUserDefaults *share = [GZUserDefaults shareUserDefaults];
    if ([[GZPublicMethod sharedPublicMethod] isAllowFullAccess]) {
        NSNumber *sound = [share getValueForKey:@"sound"];
        if ([sound isEqualToNumber:@1]) {
            AudioServicesPlaySystemSound(1306); //声音
        }
    }

    [super touchesBegan:touches withEvent:event];
}
- (void)playSoundEffect:(NSString*)name type:(NSString*)type {
    NSString *soundFilePath =[[NSBundle mainBundle] pathForResource:name ofType:type]; //得到音效文件的地址
    NSURL *soundURL = [NSURL fileURLWithPath:soundFilePath]; //将地址字符串转换成url
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)soundURL, &soundFileObject); //生成系统音效id
    AudioServicesPlaySystemSound(soundFileObject); //播放系统音效
}
@end


//键盘字母按键
@implementation GZKeyButton
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent*)event {
    GZUserDefaults *share = [GZUserDefaults shareUserDefaults];
    if ([[GZPublicMethod sharedPublicMethod] isAllowFullAccess]) {
        NSNumber *sound = [share getValueForKey:@"sound"];
        if ([sound isEqualToNumber:@1]) {
            AudioServicesPlaySystemSound(1104); //1103-1105
        }
    }

    [super touchesBegan:touches withEvent:event];
}
@end


//数字按键
@implementation GZNumberButton
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent*)event {
    GZUserDefaults *share = [GZUserDefaults shareUserDefaults];
    if ([[GZPublicMethod sharedPublicMethod] isAllowFullAccess]) {
        NSNumber *sound = [share getValueForKey:@"sound"];
        if ([sound isEqualToNumber:@1]) {
            AudioServicesPlaySystemSound(1200); //1200-1211
        }
    }

    [super touchesBegan:touches withEvent:event];
}
@end


//符号按键
@implementation GZSymbolButton
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent*)event {
    GZUserDefaults *share = [GZUserDefaults shareUserDefaults];
    if ([[GZPublicMethod sharedPublicMethod] isAllowFullAccess]) {
        NSNumber *sound = [share getValueForKey:@"sound"];
        if ([sound isEqualToNumber:@1]) {
            AudioServicesPlaySystemSound(1103);
        }
    }

    [super touchesBegan:touches withEvent:event];
}
@end

//候选框按键
@implementation GZCadidateButton
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent*)event {
    GZUserDefaults *share = [GZUserDefaults shareUserDefaults];
    if ([[GZPublicMethod sharedPublicMethod] isAllowFullAccess]) {
        NSNumber *sound = [share getValueForKey:@"sound"];
        if ([sound isEqualToNumber:@1]) {
            AudioServicesPlaySystemSound(1103);
        }
    }

    [super touchesBegan:touches withEvent:event];
}
@end

//功能符号按键
@implementation GZFunctionButton
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent*)event {
    GZUserDefaults *share = [GZUserDefaults shareUserDefaults];
    if ([[GZPublicMethod sharedPublicMethod] isAllowFullAccess]) {
        NSNumber *sound = [share getValueForKey:@"sound"];
        if ([sound isEqualToNumber:@1]) {
            AudioServicesPlaySystemSound(1105);
        }
    }

    [super touchesBegan:touches withEvent:event];
}
@end

//功能按键 手写键盘左侧
@implementation GZFunctionButton_wright_l
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent*)event {
    GZUserDefaults *share = [GZUserDefaults shareUserDefaults];
    if ([[GZPublicMethod sharedPublicMethod] isAllowFullAccess]) {
        NSNumber *sound = [share getValueForKey:@"sound"];
        if ([sound isEqualToNumber:@1]) {
            AudioServicesPlaySystemSound(1105);
        }
    }

    [super touchesBegan:touches withEvent:event];
}
@end

//功能按键 符号键盘左侧
@implementation GZFunctionButton_symbol_l
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent*)event {
    GZUserDefaults *share = [GZUserDefaults shareUserDefaults];
    if ([[GZPublicMethod sharedPublicMethod] isAllowFullAccess]) {
        NSNumber *sound = [share getValueForKey:@"sound"];
        if ([sound isEqualToNumber:@1]) {
            AudioServicesPlaySystemSound(1105);
        }
    }

    [super touchesBegan:touches withEvent:event];
}
@end

//功能按键 符号键盘底端
@implementation GZFunctionButton_symbol_b
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent*)event {
    GZUserDefaults *share = [GZUserDefaults shareUserDefaults];
    if ([[GZPublicMethod sharedPublicMethod] isAllowFullAccess]) {
        NSNumber *sound = [share getValueForKey:@"sound"];
        if ([sound isEqualToNumber:@1]) {
            AudioServicesPlaySystemSound(1105);
        }
    }

    [super touchesBegan:touches withEvent:event];
}
@end

//删除按键
@implementation GZDeleteButton
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent*)event {
    GZUserDefaults *share = [GZUserDefaults shareUserDefaults];
    if ([[GZPublicMethod sharedPublicMethod] isAllowFullAccess]) {
        NSNumber *sound = [share getValueForKey:@"sound"];
        if ([sound isEqualToNumber:@1]) {
            AudioServicesPlaySystemSound(1105);
        }
    }

    [super touchesBegan:touches withEvent:event];
}
@end
