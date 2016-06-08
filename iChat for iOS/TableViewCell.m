//
//  TableViewCell.m
//  iChat for iOS
//
//  Created by Sylvanus on 6/7/16.
//  Copyright © 2016 Sylvanus. All rights reserved.
//

#import "TableViewCell.h"

@implementation TableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (UIImageView *)avatar {
    if (!_avatar) {
        _avatar = [[UIImageView alloc] init];
    }
    return _avatar;
}

@end
