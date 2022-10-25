# ZYTextView

## 介绍
一个强大的UITextView子类，三大功能，让TextView自带placeholder属性、自动高度、监听编辑状态，支持UITableViewCell内嵌

## 如何导入
```
pod 'ZYTextView', :git => 'https://github.com/xuzeyu/ZYTextView.git'
```

## 效果
![image](https://github.com/xuzeyu/ZYTextView/GIF1.gif?raw=true)

## 如何使用
```objc

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
 
```

## 更多
```objc
@interface ZYTextView : UITextView

/**
 便利构造器.
 */
+ (instancetype)textView;

/**
 设定文本开始编辑Block回调. (切记弱化引用, 以免造成内存泄露.)
 */
- (void)addTextDidBeginEditingHandler:(ZYTextViewHandler)beginEditingHandler;

/**
 设定文本改变Block回调. (切记弱化引用, 以免造成内存泄露.) 需要在setText:方法调用之前，不然获取不到setText:的改变
 */
- (void)addTextDidChangeHandler:(ZYTextViewHandler)eventHandler;

/**
 设定文本结束编辑Block回调. (切记弱化引用, 以免造成内存泄露.)
 */
- (void)addTextDidEndEditingHandler:(ZYTextViewHandler)endEditingHandler;

/**
 设定达到最大长度Block回调. (切记弱化引用, 以免造成内存泄露.)
 */
- (void)addTextLengthDidMaxHandler:(ZYTextViewHandler)maxHandler;

/**
 最大限制文本长度, 默认为无穷大, 即不限制, 如果被设为 0 也同样表示不限制字符数.
 */
@property (nonatomic, assign) NSUInteger maxLength;

/**
 圆角半径.
 */
@property (nonatomic, assign) IBInspectable CGFloat cornerRadius;

/**
 边框宽度.
 */
@property (nonatomic, assign) IBInspectable CGFloat borderWidth;

/**
 边框颜色.
 */
@property (nonatomic, strong) IBInspectable UIColor *borderColor;

/**
 placeholder, 会自适应TextView宽高以及横竖屏切换, 字体默认和TextView一致.
 */
@property (nonatomic, copy)   IBInspectable NSString *placeholder;

/**
 placeholder文本颜色, 默认为#C7C7CD.
 */
@property (nonatomic, strong) IBInspectable UIColor *placeholderColor;

/**
 placeholder文本字体, 默认为UITextView的默认字体.
 */
@property (nonatomic, strong) UIFont *placeholderFont;

/**
 placeholder文本最大行数
 */
@property (nonatomic, assign) NSInteger placeholderMaximumNumberOfLines;

/**
 placeholder文本换行模式， 默认为NSLineBreakByCharWrapping
 */
@property (nonatomic, assign) NSLineBreakMode placeholderLineBreakMode;

/**
 UITextView的text和placeholder四边间距 默认UIEdgeInsetsMake(8, 3, 8, 3)
 */
@property (nonatomic, assign) IBInspectable UIEdgeInsets zy_textContainerInset;

/**
  是否禁止换行 默认为NO
 */
@property (nonatomic, assign) BOOL disableNewline;

/**
  是否禁止空格 默认为NO
 */
@property (nonatomic, assign) BOOL disableWhitespace;

/**
  禁止第一个字符输入空格 默认为YES
 */
@property (nonatomic, assign) BOOL disableFirstWhitespace;

/**
  是否点击Return按钮自动取消编辑状态 默认为NO
 */
@property (nonatomic, assign) BOOL isResignFirstResponderAfterReturn;

/**
 是否允许长按弹出UIMenuController, 默认为YES.
 */
@property (nonatomic, assign, getter=isCanPerformAction) BOOL canPerformAction;

/**
 获取自动高度的block回调
 */
@property (nonatomic, copy) ZYTextViewHeightDidChangedBlock textViewHeightDidChanged;

/**
 最大高度，如果需要随文字改变高度的时候使用
 */
@property (nonatomic, assign) CGFloat maxHeight;

/**
 最小高度，如果需要随文字改变高度的时候使用
 */
@property (nonatomic, assign) CGFloat minHeight;

/**
 该属性返回一个经过处理的 `self.text` 的值, 去除了首位的空格和换行.
 */
@property (nonatomic, readonly) NSString *formatText;

@end
```
