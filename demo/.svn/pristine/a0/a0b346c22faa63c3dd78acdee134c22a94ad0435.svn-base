//
//  GZSetHelpController.m
//  HanvonInput
//
//  Created by hanvon on 2017/11/4.
//  Copyright © 2017年 hanvon. All rights reserved.
//

#import "GZSetHelpController.h"

@interface GZSetHelpController ()<UIWebViewDelegate>
@property (nonatomic, strong) UIWebView *helpWebView;
@end

@implementation GZSetHelpController

- (void)dealloc {
    NSLog(@"网页 销毁");
    [_helpWebView removeFromSuperview];
    _helpWebView = nil;
    for (UIView *view in self.view.subviews) {
        if (view) {
            [view removeFromSuperview];
        }
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = self.naviTitle;

    [self createUI];
}


- (void)createUI {
    CGFloat h;
    if (IS_IPHONE_X) {
        h = 20;
    }else {
        h = 0;
    }

    NSString *path = [[NSBundle mainBundle] pathForResource:_URLstring ofType:@"html"];
    NSString *htmlString = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];

    _helpWebView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-h)];
    _helpWebView.delegate = self;
    [_helpWebView loadHTMLString:htmlString baseURL:[NSURL URLWithString:path]];
    [self.view addSubview:_helpWebView];
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
