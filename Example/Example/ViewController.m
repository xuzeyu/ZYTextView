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

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.tableView endEditing:YES];
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    __weak typeof(self) weakSelf = self;
    Test_Cell *cell = [tableView dequeueReusableCellWithIdentifier:@"Test_Cell"];
    cell.textView.placeholder = @"请输入内容请输入内容请输入内容请输入内容请输入内容请输入内容请输入内容请输入内容请输入内容请输入内容请输入内容请输入内容请输入内容请输入内容请输入内容请输入内容请输入内容请输入内容请输入内容请输入内容请输入内容请输入内容请输入内容请输入内容";
    cell.textView.disableNewline = cell.textView.disableWhitespace = cell.textView.isResignFirstResponderAfterReturn = YES;
    cell.textView.returnKeyType = UIReturnKeyDone;
    
    cell.textView.text = @"当时发生的当时发生的当时发生的当时发生的当时发生的当时发生的当时发生的当时发生的当时发生的当时发生的当时发生的";
    cell.textView.textViewHeightDidChanged = ^(ZYTextView *textView, CGFloat currentTextViewHeight) {
        [textView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(currentTextViewHeight);
        }];
        [weakSelf.tableView beginUpdates];
        [weakSelf.tableView endUpdates];
    };
    
   
    return cell;
}


@end
