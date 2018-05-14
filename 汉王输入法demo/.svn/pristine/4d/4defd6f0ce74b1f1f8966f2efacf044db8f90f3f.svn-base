//
//  GZUserPhrasesController.m
//  HanvonInput
//
//  Created by hanvon on 2017/12/21.
//  Copyright © 2017年 hanvon. All rights reserved.
//

#import "GZUserPhrasesController.h"
#import "GZAlertInputView.h"

@interface GZUserPhrasesController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataArr;
@end

@implementation GZUserPhrasesController

- (void)dealloc {
    NSLog(@"手写设置 销毁");
    if (_tableView) {
        [_tableView removeFromSuperview];
        _tableView = nil;
    }
    if (_dataArr) {
        [_dataArr removeAllObjects];
        _dataArr = nil;
    }
    for (UIView *view in self.view.subviews) {
        [view removeFromSuperview];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"常用短语";

    self.navigationItem.rightBarButtonItem = [[GZPublicMethod sharedPublicMethod] barButtonTitle:@"新增" Image:nil Target:self Sel:@selector(addNewPhrases)];

    NSArray *data = [[GZUserPlist sharedUserPlist] getAllUsefulPhrases];
    _dataArr = [[NSMutableArray alloc] initWithArray:data];
    
    [self createUI];
}

- (void)createUI {
    CGFloat h;
    if (IS_IPHONE_X) {
        h = 20;
    }else {
        h = 0;
    }
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-h) style:UITableViewStylePlain];
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.tableFooterView = [[UIView alloc] init];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArr.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"userPhareseCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    cell.textLabel.text = _dataArr[indexPath.row];

    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *str = _dataArr[indexPath.row];
    if (str.length != 0 && str) {
        [self editPhrasesAtIndex:(int)indexPath.row];
        GZAlertInputView *alertInput = (GZAlertInputView*)[self.view viewWithTag:100];
        [alertInput setInputTextDetail:str];
    }
}

#pragma mark -- 交互
//左滑删除
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}
- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath{
    __weak GZUserPhrasesController *weakSelf = self;
    UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"移除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        [tableView setEditing:NO animated:YES];
        [weakSelf deletePhrase:indexPath.row];
        [weakSelf.dataArr removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
    }];
    deleteAction.backgroundColor = [UIColor redColor];

    return @[deleteAction];
}
- (void)deletePhrase:(NSInteger)index {
    GZUserPlist *phrase = [GZUserPlist sharedUserPlist];
    [phrase deleteUserPhrases:index];
}

//添加新短语
- (void)addNewPhrases {
    GZAlertInputView *alertInput = [[GZAlertInputView alloc] initWithFrame:self.view.bounds title:@"添加短语" detail:@"请输入常用短语"];
    alertInput.tag = 99;
    [self.view addSubview:alertInput];

    self.navigationController.navigationBar.userInteractionEnabled = NO;

    __weak GZUserPhrasesController *weakSelf = self;

    alertInput.sendInputString = ^(NSString *inputString) {
        if (inputString != nil) {
            GZUserPlist *phrase = [GZUserPlist sharedUserPlist];
            [phrase saveUsefulPhrases:inputString];
            [weakSelf.dataArr addObject:inputString];
            [weakSelf.tableView reloadData];
        }
        //移除
        GZAlertInputView *alert = (GZAlertInputView*)[self.view viewWithTag:99];
        [alert removeFromSuperview];
        alert = nil;
        weakSelf.navigationController.navigationBar.userInteractionEnabled = YES;
    };
}

//编辑短语
- (void)editPhrasesAtIndex:(int)index {
    GZAlertInputView *alertInput = [[GZAlertInputView alloc] initWithFrame:self.view.bounds title:@"编辑短语" detail:@"请输入常用短语"];
    alertInput.tag = 100;
    [self.view addSubview:alertInput];
    
    self.navigationController.navigationBar.userInteractionEnabled = NO;
    
    __weak GZUserPhrasesController *weakSelf = self;
    
    alertInput.sendInputString = ^(NSString *inputString) {
        if (inputString != nil) {
            GZUserPlist *phrase = [GZUserPlist sharedUserPlist];
            [phrase replaceUsefullPhrases:inputString atIndex:index];
            [weakSelf.dataArr replaceObjectAtIndex:index withObject:inputString];
            [weakSelf.tableView reloadData];
        }
        //移除
        GZAlertInputView *alert = (GZAlertInputView*)[self.view viewWithTag:100];
        [alert removeFromSuperview];
        alert = nil;
        weakSelf.navigationController.navigationBar.userInteractionEnabled = YES;
    };
}

//返回
- (void)backAction {
    [self.navigationController popViewControllerAnimated:YES];
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
