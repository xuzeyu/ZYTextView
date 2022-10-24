//
//  ZYTextView.h
//  Example
//
//  Created by XUZY on 2022/10/24.
//

#import <UIKit/UIKit.h>
@class ZYTextView;

typedef void(^ZYTextViewHandler)(ZYTextView *textView);
typedef void(^ZYTextViewHeightDidChangedBlock)(ZYTextView *textView, CGFloat currentTextViewHeight);

IB_DESIGNABLE

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

