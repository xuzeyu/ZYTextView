//
//  Test_Cell.m
//  Example
//
//  Created by XUZY on 2022/10/24.
//

#import "Test_Cell.h"
#import "Masonry.h"

@implementation Test_Cell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.textView = [ZYTextView new];
        self.textView.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1];
        self.textView.layer.cornerRadius = 5;
        [self.contentView addSubview:self.textView];
        [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.right.mas_equalTo(-15);
            make.top.mas_equalTo(15);
            make.bottom.mas_equalTo(-15);
        }];
    }
    return self;
}

@end
