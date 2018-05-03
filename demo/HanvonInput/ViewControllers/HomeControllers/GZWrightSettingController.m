//
//  GZWrightSettingController.m
//  HanvonInput
//
//  Created by hanvon on 2017/11/14.
//  Copyright © 2017年 hanvon. All rights reserved.
//

#import "GZWrightSettingController.h"
#import "KZDefaultColorViewController.h"

@interface GZWrightSettingController ()<UITableViewDelegate,UITableViewDataSource,UIActionSheetDelegate,KZDefaultColorControllerDelegate>

@property (nonatomic,assign) int pen_Width; //笔画粗细
@property (nonatomic,assign) float penColor_Blue; //蓝
@property (nonatomic,assign) float penColor_Green; //绿
@property (nonatomic,assign) float penColor_Red; //红
@property (nonatomic,assign) float penColor_Alpha; //透明
//@property (nonatomic,assign) int pen_Style; //1铅笔 2钢笔 3毛笔

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSArray *dataArr;
@property (nonatomic,strong) UILabel *penWidthTitle; //画笔粗细 标题
@property (nonatomic,strong) UILabel *penWidthLabel; //画笔粗细
@property (nonatomic,strong) UIView *colorView; //选定的笔画颜色
@property (nonatomic,strong) UIButton *colorMoreBtn; //更多颜色
@end

@implementation GZWrightSettingController

- (void)dealloc {
    NSLog(@"手写设置 销毁");
    if (_tableView) {
        [_tableView removeFromSuperview];
        _tableView = nil;
    }
    if (_penWidthLabel) {
        [_penWidthLabel removeFromSuperview];
        _penWidthLabel = nil;
    }
    if (_penWidthTitle) {
        [_penWidthTitle removeFromSuperview];
        _penWidthTitle = nil;
    }
    if (_colorView) {
        [_colorView removeFromSuperview];
        _colorView = nil;
    }
    if (_dataArr) {
        _dataArr = nil;
    }
    for (UIView *view in self.view.subviews) {
        [view removeFromSuperview];
    }
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    _colorView.backgroundColor = RGBA(_penColor_Red, _penColor_Green, _penColor_Blue, _penColor_Alpha);
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"手写设置";
    self.navigationItem.rightBarButtonItem = [[GZPublicMethod sharedPublicMethod] barButtonTitle:@"保存" Image:nil Target:self Sel:@selector(saveSwitchesStatus)];

    [self getSwitchesStatus];
    _dataArr = [NSArray arrayWithObjects:@[@"竖屏识别模式",@"横屏识别模式"],@[@"笔画样式"],@[@"笔画粗细"],@[@"笔画颜色"], nil];

    [self createUI];
}



//获取新的设置
- (void)getSwitchesStatus {
    GZUserDefaults *share = [GZUserDefaults shareUserDefaults];
    _pen_Width = [[share getGroupValueForKey:@"penWidth"] intValue]; //笔画粗细
    _penColor_Blue = [[share getGroupValueForKey:@"penColorBlue"] floatValue];
    _penColor_Green = [[share getGroupValueForKey:@"penColorGreen"] floatValue];
    _penColor_Red = [[share getGroupValueForKey:@"penColorRed"] floatValue];
    _penColor_Alpha = [[share getGroupValueForKey:@"penColorAlpha"] floatValue];
}
//存储新的颜色设置
- (void)saveSwitchesStatus {
    GZUserDefaults *share = [GZUserDefaults shareUserDefaults];
    [share saveGroupValue:@(_pen_Width) forKey:@"penWidth"];
    [share saveGroupValue:@(_penColor_Blue) forKey:@"penColorBlue"];
    [share saveGroupValue:@(_penColor_Green) forKey:@"penColorGreen"];
    [share saveGroupValue:@(_penColor_Red) forKey:@"penColorRed"];
    [share saveGroupValue:@(_penColor_Alpha) forKey:@"penColorAlpha"];
    [self.navigationController popViewControllerAnimated:YES];
}

//创建UI
- (void)createUI {
    CGFloat h;
    if (IS_IPHONE_X) {
        h = 20;
    }else {
        h = 0;
    }
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-h) style:UITableViewStyleGrouped];
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _dataArr.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[_dataArr objectAtIndex:section] count];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        return 10;
    }
    return 30;
}
- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {

    CGFloat height = 30;
    CGFloat left = 20;

    UIView *superView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, height)];
    superView.backgroundColor = [UIColor clearColor];
    if (section == 2) {
        if (!_penWidthLabel) {
            _penWidthLabel = [[UILabel alloc] initWithFrame:CGRectMake(left, 0, SCREEN_WIDTH-left, height)];
            _penWidthLabel.backgroundColor = [UIColor clearColor];
            _penWidthLabel.textColor = [UIColor blackColor];
            _penWidthLabel.textAlignment = NSTextAlignmentLeft;
            _penWidthLabel.font = [UIFont systemFontOfSize:16];
            [superView addSubview:_penWidthLabel];
        }
        _penWidthLabel.text = [NSString stringWithFormat:@"笔画粗细：%d",_pen_Width];
    }

    if (section == 3) {
        CGFloat titleWidth = 90;
        if (!_penWidthTitle) {
            _penWidthTitle = [[UILabel alloc] initWithFrame:CGRectMake(left, 0, titleWidth, height)];
            _penWidthTitle.backgroundColor = [UIColor clearColor];
            _penWidthTitle.textColor = [UIColor blackColor];
            _penWidthTitle.textAlignment = NSTextAlignmentLeft;
            _penWidthTitle.font = [UIFont systemFontOfSize:16];
            _penWidthTitle.text = @"笔画颜色：";
            [superView addSubview:_penWidthTitle];
        }

        if (!_colorView) {
            CGFloat colorH = 25;
            _colorView = [[UIView alloc] initWithFrame:CGRectMake(left+titleWidth, (height-colorH)/2.0, colorH, colorH)];
            [superView addSubview:_colorView];
        }
        _colorView.backgroundColor = RGBA(_penColor_Red, _penColor_Green, _penColor_Blue, _penColor_Alpha);

        if (!_colorMoreBtn) {
            _colorMoreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            _colorMoreBtn.frame = CGRectMake(SCREEN_WIDTH-10-titleWidth, 0, titleWidth, height);
//            _colorMoreBtn.backgroundColor = [UIColor whiteColor];
            [_colorMoreBtn setTitle:@"更多颜色" forState:UIControlStateNormal];
            [_colorMoreBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            _colorMoreBtn.titleLabel.font = [UIFont systemFontOfSize:15];
            [_colorMoreBtn addTarget:self action:@selector(selectMoreColorAction:) forControlEvents:UIControlEventTouchUpInside];
            [superView addSubview:_colorMoreBtn];
        }
    }

    return superView;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    GZUserDefaults *share = [GZUserDefaults shareUserDefaults];

    static NSString *cellID = @"switchSettingCell";
    if (indexPath.section == 0) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellID];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

        cell.textLabel.text = _dataArr[indexPath.section][indexPath.row];

        if (indexPath.row == 0) {
            NSNumber *mode_V = [share getGroupValueForKey:@"wrightMode_Vertical"];
            if ([mode_V isEqualToNumber:@1]) {
                //叠写
                cell.detailTextLabel.text = @"叠写";
            }else if ([mode_V isEqualToNumber:@2]) {
                //行写
                cell.detailTextLabel.text = @"行写";
            }
//            else if ([mode_V isEqualToNumber:@3]) {
//                //自由写
//                cell.detailTextLabel.text = @"自由写";
//            }
            else {

            }
        }

        if (indexPath.row == 1) {
            NSNumber *mode_H = [share getGroupValueForKey:@"wrightMode_Horizontal"];
            if ([mode_H isEqualToNumber:@1]) {
                //叠写
                cell.detailTextLabel.text = @"叠写";
            }else if ([mode_H isEqualToNumber:@2]) {
                //行写
                cell.detailTextLabel.text = @"行写";
            }
//            else if ([mode_H isEqualToNumber:@3]) {
//                //自由写
//                cell.detailTextLabel.text = @"自由写";
//            }
            else {

            }
        }
        return cell;
    }

    if (indexPath.section == 1) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellID];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

        cell.textLabel.text = _dataArr[indexPath.section][indexPath.row];

        NSNumber *mode_V = [share getGroupValueForKey:@"penStyle"];
        if ([mode_V isEqualToNumber:@1]) {
            //铅笔
            cell.detailTextLabel.text = @"铅笔";
        }else if ([mode_V isEqualToNumber:@2]) {
            //钢笔
            cell.detailTextLabel.text = @"钢笔";
        }else if ([mode_V isEqualToNumber:@3]) {
            //毛笔
            cell.detailTextLabel.text = @"毛笔";
        }else {

        }
        return cell;
    }

    if (indexPath.section == 2) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        }else {
            for (UIView *view in cell.contentView.subviews) {
                [view removeFromSuperview];
            }
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryNone;

        CGFloat cellHeight = 44;
        CGFloat height = 30;
        CGFloat left = 30;
        CGFloat space = 10;
        CGFloat sliderW = SCREEN_WIDTH - 2*left - 2*height - 2*space;
        CGFloat sliderH = 20;

        UILabel *xiLabel = [[UILabel alloc] initWithFrame:CGRectMake(left, (cellHeight-height)/2.0, height, height)];
        xiLabel.backgroundColor = [UIColor clearColor];
        xiLabel.textColor = [UIColor blackColor];
        xiLabel.textAlignment = NSTextAlignmentCenter;
        xiLabel.font = [UIFont systemFontOfSize:16];
        xiLabel.text = @"细";
        [cell.contentView addSubview:xiLabel];

        UILabel *cuLabel = [[UILabel alloc] initWithFrame:CGRectMake(left+height+space+sliderW+space, (cellHeight-height)/2.0, height, height)];
        cuLabel.backgroundColor = [UIColor clearColor];
        cuLabel.textColor = [UIColor blackColor];
        cuLabel.textAlignment = NSTextAlignmentCenter;
        cuLabel.font = [UIFont systemFontOfSize:16];
        cuLabel.text = @"粗";
        [cell.contentView addSubview:cuLabel];

        UISlider *slider = [[UISlider alloc] initWithFrame:CGRectMake(left+height+space, (cellHeight-sliderH)/2.0, sliderW, sliderH)];
        slider.minimumValue = 1;// 设置最小值
        slider.maximumValue = 10;// 设置最大值
        slider.value = _pen_Width;// 设置初始值
        slider.continuous = YES;// 设置可连续变化
        [slider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
        [cell.contentView addSubview:slider];

        return cell;
    }

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }else {
        for (UIView *view in cell.contentView.subviews) {
            [view removeFromSuperview];
        }
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryNone;

    NSArray *reds = [NSArray arrayWithObjects:@0,@255,@255,@254,@128,@16,@0,@2, nil];
    NSArray *greens = [NSArray arrayWithObjects:@0,@42,@130,@249,@34,@64,@247,@252, nil];
    NSArray *blues = [NSArray arrayWithObjects:@0,@26,@34,@52,@127,@251,@44,@254, nil];
    NSArray *alphas = [NSArray arrayWithObjects:@1,@1,@1,@1,@1,@1,@1,@1, nil];

    CGFloat cellHeight = 44;
    CGFloat height = 30;
    CGFloat left = 30;
    CGFloat space = 20;
    int num = (int)reds.count;
    CGFloat width = (SCREEN_WIDTH-left*2-space*(num-1))/num;
    for (int i=0; i<num; i++) {
        float r = [reds[i] floatValue];
        float g = [greens[i] floatValue];
        float b = [blues[i] floatValue];
        float a = [alphas[i] floatValue];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(left + i*(width+space), (cellHeight-height)/2.0, width, height);
        button.backgroundColor = RGBA(r, g, b, a);
        [button addTarget:self action:@selector(selecteColor:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = 11+i;
        [cell.contentView addSubview:button];
    }

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"请选择" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"叠写",@"行写", nil];
            [sheet showInView:self.view];
            sheet.tag = 100;
        }else if (indexPath.row == 1) {
            UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"请选择" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"叠写",@"行写", nil];
            [sheet showInView:self.view];
            sheet.tag = 200;
        }else {

        }
    }
    if (indexPath.section == 1) {
        UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"请选择" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"铅笔",@"钢笔",@"毛笔", nil];
        [sheet showInView:self.view];
        sheet.tag = 300;
    }
}


#pragma mark -- 点击交互
// slider变动时改变label值
- (void)sliderValueChanged:(id)sender {
    UISlider *slider = (UISlider *)sender;
    _pen_Width = (int)floor(slider.value);//)*0.4;
    _penWidthLabel.text = [NSString stringWithFormat:@"笔画粗细：%d",_pen_Width];//(int)ceil(slider.value)];
}

//选择备选颜色
- (void)selecteColor:(UIButton*)sender {
    UIButton *button = (UIButton*)sender;
    NSInteger tag = button.tag - 11;

    NSArray *reds = [NSArray arrayWithObjects:@0,@255,@255,@254,@128,@16,@0,@2, nil];
    NSArray *greens = [NSArray arrayWithObjects:@0,@42,@130,@249,@34,@64,@247,@252, nil];
    NSArray *blues = [NSArray arrayWithObjects:@0,@26,@34,@52,@127,@251,@44,@254, nil];
    NSArray *alphas = [NSArray arrayWithObjects:@1,@1,@1,@1,@1,@1,@1,@1, nil];

    _penColor_Alpha = [alphas[tag] floatValue];
    _penColor_Red = [reds[tag] floatValue];
    _penColor_Blue = [blues[tag] floatValue];
    _penColor_Green = [greens[tag] floatValue];

    _colorView.backgroundColor = RGBA(_penColor_Red, _penColor_Green, _penColor_Blue, _penColor_Alpha);
}



#pragma mark -- 选择更多颜色
- (void)selectMoreColorAction:(UIButton*)sender {
    KZDefaultColorViewController* viewController = [[KZDefaultColorViewController alloc] init];
    viewController.delegate = self;
    viewController.selectedColor = RGBA(_penColor_Red, _penColor_Green, _penColor_Blue, _penColor_Alpha);
    [self.navigationController pushViewController:viewController animated:YES];
}
//协议
- (void)defaultColorController:(KZDefaultColorViewController *)controller didChangeColor:(UIColor *)color {
//    const CGFloat *components = CGColorGetComponents(color.CGColor);
//    CGFloat r,g,b;
//    switch (CGColorSpaceGetModel(CGColorGetColorSpace(color.CGColor))) {
//        case kCGColorSpaceModelMonochrome:
//            r = g = b = components[0];
//            break;
//        case kCGColorSpaceModelRGB: {
//            r = components[0];
//            g = components[1];
//            b = components[2];
//            break;
//        }
//        default:
//            r = g = b = 0;
//            break;
//    }

    CGFloat red = 0.0;
    CGFloat green = 0.0;
    CGFloat blue = 0.0;
    CGFloat alpha = 0.0;
    [color getRed:&red green:&green blue:&blue alpha:&alpha];

    _penColor_Red = red*255;
    _penColor_Green = green*255;
    _penColor_Blue = blue*255;
    _penColor_Alpha = 1;
    _colorView.backgroundColor = [UIColor colorWithRed:red green:green blue:blue alpha:1];
}

#pragma mark -- sheet
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    GZUserDefaults *share = [GZUserDefaults shareUserDefaults];

    //竖屏
    if (actionSheet.tag == 100) {
        if (buttonIndex == 0) {
            //NSLog(@"叠写");
            [share saveGroupValue:@1 forKey:@"wrightMode_Vertical"];
        }else if (buttonIndex == 1) {
            //NSLog(@"行写");
            [share saveGroupValue:@2 forKey:@"wrightMode_Vertical"];
        }
//        else if (buttonIndex == 2) {
//            NSLog(@"自由写");
//            [share saveGroupValue:@3 forKey:@"wrightMode_Vertical"];
//        }
        else {

        }

        NSIndexPath *index = [NSIndexPath indexPathForRow:0 inSection:0];
        //UITableViewCell *cell = [_tableView cellForRowAtIndexPath:index];
        [_tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:index,nil] withRowAnimation:UITableViewRowAnimationNone];
    }
    //横屏
    if (actionSheet.tag == 200) {
        if (buttonIndex == 0) {
            //NSLog(@"叠写");
            [share saveGroupValue:@1 forKey:@"wrightMode_Horizontal"];
        }else if (buttonIndex == 1) {
            //NSLog(@"行写");
            [share saveGroupValue:@2 forKey:@"wrightMode_Horizontal"];
        }
//        else if (buttonIndex == 2) {
//            NSLog(@"自由写");
//            [share saveGroupValue:@3 forKey:@"wrightMode_Horizontal"];
//        }
        else {

        }

        NSIndexPath *index = [NSIndexPath indexPathForRow:1 inSection:0];
        [_tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:index,nil] withRowAnimation:UITableViewRowAnimationNone];
    }

    //笔画样式
    if (actionSheet.tag == 300) {
        if (buttonIndex == 0) {
            NSLog(@"铅笔");
            [share saveGroupValue:@1 forKey:@"penStyle"];
        }else if (buttonIndex == 1) {
            NSLog(@"钢笔");
            [share saveGroupValue:@2 forKey:@"penStyle"];
        }else if (buttonIndex == 2) {
            NSLog(@"毛笔");
            [share saveGroupValue:@3 forKey:@"penStyle"];
        }else {

        }

        NSIndexPath *index = [NSIndexPath indexPathForRow:0 inSection:1];
        [_tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:index,nil] withRowAnimation:UITableViewRowAnimationNone];
    }
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
