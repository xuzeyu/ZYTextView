//
//  ZYTextView.m
//  Example
//
//  Created by XUZY on 2022/10/24.
//

#import "ZYTextView.h"

@interface ZYTextView () <UITextViewDelegate>
@property (nonatomic, copy) ZYTextViewHandler beginEditingHandler; ///< 文本开始编辑Block
@property (nonatomic, copy) ZYTextViewHandler changeHandler; ///< 文本改变Block
@property (nonatomic, copy) ZYTextViewHandler endEditingHandler; ///< 文本结束编辑Block
@property (nonatomic, copy) ZYTextViewHandler maxHandler; ///< 达到最大限制字符数Block
@property (nonatomic, strong) UITextView *placeholderTextView; ///< placeholderTextView

@property (nonatomic, strong) NSMutableArray *placeholderTextViewConstraints; ///<placeholderLabel的约束
@property (nonatomic, assign) CGFloat lastHeight;///< 存储最后一次改变高度后的值
@property (nonatomic, assign) BOOL needTextViewHeightChanged; ///<需要计算一次TextViewHeight
@end

@implementation ZYTextView

#pragma mark - Override

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    _beginEditingHandler = NULL;
    _changeHandler = NULL;
    _endEditingHandler = NULL;
    _maxHandler = NULL;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (!(self = [super initWithCoder:aDecoder])) return nil;
    
    if ([[[UIDevice currentDevice] systemVersion] compare:@"10.0" options:NSNumericSearch] != NSOrderedAscending) {
        
        [self layoutIfNeeded];
    }
    
    [self initialize];
    
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (!(self = [super initWithFrame:frame])) return nil;
    
    [self initialize];
    
    return self;
}

- (BOOL)becomeFirstResponder
{
    // 成为第一响应者时注册通知监听文本变化
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidBeginEditing:) name:UITextViewTextDidBeginEditingNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChange:) name:UITextViewTextDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidEndEditing:) name:UITextViewTextDidEndEditingNotification object:nil];
    
    BOOL become = [super becomeFirstResponder];
    
    return become;
}

- (BOOL)resignFirstResponder
{
    BOOL resign = [super resignFirstResponder];
    
    // 注销第一响应者时移除文本变化的通知, 以免影响其它的`UITextView`对象.
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextViewTextDidBeginEditingNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextViewTextDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextViewTextDidEndEditingNotification object:nil];
    
    return resign;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.placeholderTextView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    if (self.needTextViewHeightChanged) {
        self.needTextViewHeightChanged = NO;
        [self textViewHeightDidChangedCalculate];
    }
}

#pragma mark - UITextViewDelegate
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    if (textView == self.placeholderTextView) {
        [self becomeFirstResponder];
        return NO;
    }
    return YES;
}

#pragma mark - Private

- (void)initialize
{
    _disableFirstWhitespace = YES;
    _zy_textContainerInset = UIEdgeInsetsMake(8, 3, 8, 3);
    
    if (_maxLength == 0 || _maxLength == NSNotFound) {
        _maxLength = NSUIntegerMax;
    }
    
    if (!_placeholderColor) {
        _placeholderColor = [UIColor colorWithRed:0.780 green:0.780 blue:0.804 alpha:1.000];
    }
    
    // 基本设定 (需判断是否在Storyboard中设置了值)
    if (!self.backgroundColor) {
        self.backgroundColor = [UIColor whiteColor];
    }
    
    if (!self.font) {
        self.font = [UIFont systemFontOfSize:15.f];
    }
    
    // placeholderTextView
    self.placeholderTextView = [UITextView new];
    self.placeholderTextView.font = self.font;
    self.placeholderTextView.text = _placeholder;
    self.placeholderTextView.textColor = _placeholderColor;
    self.placeholderTextView.delegate = self;
    self.placeholderTextView.backgroundColor = [UIColor clearColor];
    self.placeholderTextView.textContainer.lineBreakMode =  NSLineBreakByTruncatingTail;
    [self addSubview:self.placeholderTextView];
    
    self.zy_textContainerInset = _zy_textContainerInset;
    self.placeholderTextView.textContainer.lineBreakMode =  NSLineBreakByTruncatingTail;
}

- (void)setZy_textContainerInset:(UIEdgeInsets)zy_textContainerInset {
    _zy_textContainerInset = zy_textContainerInset;
    [self setTextContainerInset:zy_textContainerInset];
    [self.placeholderTextView setTextContainerInset:zy_textContainerInset];
}

- (void)textViewHeightDidChangedCalculate {
    if (self.textViewHeightDidChanged && self.bounds.size.width > 0 && (self.maxHeight >= self.bounds.size.height || self.maxHeight == 0)) {
        if (self.maxHeight == 0) {
            self.maxHeight = MAXFLOAT;
        }
        
        // 计算高度
        NSInteger currentHeight = ceil([self sizeThatFits:CGSizeMake(self.bounds.size.width, MAXFLOAT)].height);
        
        // 如果高度有变化，调用block
        if (currentHeight != self.lastHeight) {
            // 是否可以滚动
            self.scrollEnabled = currentHeight >= self.maxHeight;
            CGFloat currentTextViewHeight = currentHeight >= self.maxHeight ? self.maxHeight : currentHeight;
            // 改变textView的高度
            if (currentTextViewHeight < self.minHeight) currentTextViewHeight = self.minHeight;
            
            CGRect frame = self.frame;
            frame.size.height = currentTextViewHeight;
            self.frame = frame;
            // 调用block
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [UIView performWithoutAnimation:^{
                    if (self.textViewHeightDidChanged) self.textViewHeightDidChanged(self, currentTextViewHeight);
                }];
            });
            // 记录当前高度
            self.lastHeight = currentTextViewHeight;
        }
    }else {
        self.needTextViewHeightChanged = YES;
    }
}

#pragma mark - Getter
/// 返回一个经过处理的 `self.text` 的值, 去除了首位的空格和换行.
- (NSString *)formatText
{
    return [[super text] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]; // 去除首尾的空格和换行.
}

#pragma mark - Setter

- (void)setText:(NSString *)text
{
    [super setText:text];
    
    self.placeholderTextView.hidden = [@(text.length) boolValue];
    // 手动模拟触发通知
    NSNotification *notification = [NSNotification notificationWithName:UITextViewTextDidChangeNotification object:self];
    [self textDidChange:notification];
}

- (void)setFont:(UIFont *)font
{
    [super setFont:font];
    
    self.placeholderTextView.font = font;
}

- (void)setMaxLength:(NSUInteger)maxLength
{
    _maxLength = fmax(0, maxLength);
    self.text = self.text;
}

- (void)setCornerRadius:(CGFloat)cornerRadius
{
    _cornerRadius = cornerRadius;
    self.layer.cornerRadius = _cornerRadius;
}

- (void)setBorderColor:(UIColor *)borderColor
{
    if (!borderColor) return;
    
    _borderColor = borderColor;
    self.layer.borderColor = _borderColor.CGColor;
}

- (void)setBorderWidth:(CGFloat)borderWidth
{
    _borderWidth = borderWidth;
    self.layer.borderWidth = _borderWidth;
}

- (void)setPlaceholder:(NSString *)placeholder
{
    if (!placeholder) return;
    
    _placeholder = [placeholder copy];
    
    if (_placeholder.length > 0) {
        
        self.placeholderTextView.text = _placeholder;
    }
}

- (void)setPlaceholderColor:(UIColor *)placeholderColor
{
    if (!placeholderColor) return;
    
    _placeholderColor = placeholderColor;
    
    self.placeholderTextView.textColor = _placeholderColor;
}

- (void)setPlaceholderFont:(UIFont *)placeholderFont
{
    if (!placeholderFont) return;
    
    _placeholderFont = placeholderFont;
    
    self.placeholderTextView.font = _placeholderFont;
}

- (void)setPlaceholderMaximumNumberOfLines:(NSInteger)placeholderMaximumNumberOfLines {
    _placeholderMaximumNumberOfLines = placeholderMaximumNumberOfLines;
    self.placeholderTextView.textContainer.maximumNumberOfLines = placeholderMaximumNumberOfLines;
}

- (void)setPlaceholderLineBreakMode:(NSLineBreakMode)placeholderLineBreakMode {
    _placeholderLineBreakMode = placeholderLineBreakMode;
    self.placeholderTextView.textContainer.lineBreakMode = placeholderLineBreakMode;
}

#pragma mark - NSNotification
- (void)textDidBeginEditing:(NSNotification *)notification {
    if (!CGPointEqualToPoint(self.placeholderTextView.contentOffset, CGPointZero)) {
        CGSize contentSize = self.placeholderTextView.contentSize;
        self.placeholderTextView.contentSize = CGSizeZero;
        self.placeholderTextView.contentOffset = CGPointZero;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.placeholderTextView.contentSize = contentSize;
        });
    }
    !_beginEditingHandler ?: _beginEditingHandler(self);
}

- (void)textDidChange:(NSNotification *)notification
{
    // 通知回调的实例的不是当前实例的话直接返回
    if (notification.object != self) return;
    
    // 根据字符数量显示或者隐藏 `placeholderLabel`
    self.placeholderTextView.hidden = [@(self.text.length) boolValue];
    self.placeholderTextView.contentOffset = CGPointZero;
    
    // 禁止第一个字符输入换行
    while ([self.text hasPrefix:@"\n"]) {
        self.text = [self.text substringFromIndex:1];
    }
    
    // 禁止第一个字符输入空格
    while (self.disableFirstWhitespace && [self.text hasPrefix:@" "]) {
        self.text = [self.text substringFromIndex:1];
    }
    
    if (self.disableWhitespace && [self.text containsString:@" "]) {
        self.text = [self.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    }
    
    if ([self.text containsString:@"\n"]) {
        if (self.disableNewline) {
            self.text = [self.text stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        }
        
        if (self.isResignFirstResponderAfterReturn) {
            [self resignFirstResponder];
        }
    }
    
    // 只有当maxLength字段的值不为无穷大整型也不为0时才计算限制字符数.
    if (_maxLength != NSUIntegerMax && _maxLength != 0 && self.text.length > 0) {
        
        if (!self.markedTextRange && self.text.length > _maxLength) {
            
            !_maxHandler ?: _maxHandler(self); // 回调达到最大限制的Block.
            self.text = [self.text substringToIndex:_maxLength]; // 截取最大限制字符数.
            [self.undoManager removeAllActions]; // 达到最大字符数后清空所有 undoaction, 以免 undo 操作造成crash.
        }
    }
    
    // 回调文本改变的Block.
    !_changeHandler ?: _changeHandler(self);
    
    [self textViewHeightDidChangedCalculate];
}

- (void)textDidEndEditing:(NSNotification *)notification {
    !_endEditingHandler ?: _endEditingHandler(self);
}

#pragma mark - Public

+ (instancetype)textView
{
    return [[self alloc] init];
}

- (void)addTextDidBeginEditingHandler:(ZYTextViewHandler)beginEditingHandler
{
    _beginEditingHandler = [beginEditingHandler copy];
}

- (void)addTextDidChangeHandler:(ZYTextViewHandler)changeHandler
{
    _changeHandler = [changeHandler copy];
}

- (void)addTextDidEndEditingHandler:(ZYTextViewHandler)endEditingHandler
{
    _endEditingHandler = [endEditingHandler copy];
}

- (void)addTextLengthDidMaxHandler:(ZYTextViewHandler)maxHandler
{
    _maxHandler = [maxHandler copy];
}

@end
