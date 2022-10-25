//
//  ViewController.m
//  Example
//
//  Created by XUZY on 2022/10/24.
//

#import "ViewController.h"
#import "Masonry.h"
#import "Test_Cell.h"

@interface ViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"ZYTextView";
    [self addSubviews];
}

- (void)addSubviews {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    if (@available(iOS 15.0, *)) {
        self.tableView.sectionHeaderTopPadding = 0;
    }
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    [self.tableView registerClass:[Test_Cell class] forCellReuseIdentifier:@"Test_Cell"];
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    __weak typeof(self) weakSelf = self;
    if (indexPath.row == 0) {
        Test_Cell *cell = [tableView dequeueReusableCellWithIdentifier:@"Test_Cell"];
        cell.textView.placeholder = @"固定高度";
        cell.textView.returnKeyType = UIReturnKeyNext;
        [cell.textView addTextDidChangeHandler:^(ZYTextView *textView) {
            NSLog(@"内容改变了:%@", textView.text);
        }];
       
        [cell.textView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(60);
        }];
        
        return cell;
    }else if (indexPath.row == 1) {
        Test_Cell *cell = [tableView dequeueReusableCellWithIdentifier:@"Test_Cell"];
        cell.textView.placeholder = @"固定高度，设置最大字符串长度为10";
        cell.textView.returnKeyType = UIReturnKeyNext;
        [cell.textView addTextDidChangeHandler:^(ZYTextView *textView) {
            NSLog(@"内容改变了:%@", textView.text);
        }];
        cell.textView.maxLength = 10;
       
        [cell.textView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(60);
        }];
        
        return cell;
    }else if (indexPath.row == 2) {
        Test_Cell *cell = [tableView dequeueReusableCellWithIdentifier:@"Test_Cell"];
        cell.textView.placeholder = @"固定高度，禁止换行，禁止空格，点击return自动关闭键盘";
        cell.textView.disableNewline = cell.textView.disableWhitespace = cell.textView.isResignFirstResponderAfterReturn = YES;
        cell.textView.returnKeyType = UIReturnKeyDone;
        [cell.textView addTextDidChangeHandler:^(ZYTextView *textView) {
            NSLog(@"内容改变了:%@", textView.text);
        }];
       
        [cell.textView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(60);
        }];
        
        return cell;
    }else if (indexPath.row == 3) {
        Test_Cell *cell = [tableView dequeueReusableCellWithIdentifier:@"Test_Cell"];
        cell.textView.placeholder = @"自动增加高度";
        cell.textView.returnKeyType = UIReturnKeyNext;
        [cell.textView addTextDidChangeHandler:^(ZYTextView *textView) {
            NSLog(@"内容改变了:%@", textView.text);
        }];
        cell.textView.textViewHeightDidChanged = ^(ZYTextView *textView, CGFloat currentTextViewHeight) {
            [textView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(currentTextViewHeight).priorityHigh();
            }];
            [weakSelf.tableView beginUpdates];
            [weakSelf.tableView endUpdates];
        };
        cell.textView.text = @"";
        return cell;
    }else if (indexPath.row == 4) {
        Test_Cell *cell = [tableView dequeueReusableCellWithIdentifier:@"Test_Cell"];
        cell.textView.placeholder = @"自动增加高度，设置最小高度和最大高度";
        cell.textView.returnKeyType = UIReturnKeyNext;
        [cell.textView addTextDidChangeHandler:^(ZYTextView *textView) {
            NSLog(@"内容改变了:%@", textView.text);
        }];
        cell.textView.textViewHeightDidChanged = ^(ZYTextView *textView, CGFloat currentTextViewHeight) {
            [textView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(currentTextViewHeight).priorityHigh();
            }];
            [weakSelf.tableView beginUpdates];
            [weakSelf.tableView endUpdates];
        };
        cell.textView.text = @"";
        cell.textView.minHeight = 60;
        cell.textView.maxHeight = 80;
        return cell;
    }
    return nil;
}

@end
