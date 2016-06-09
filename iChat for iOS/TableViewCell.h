//
//  TableViewCell.h
//  iChat for iOS
//
//  Created by Sylvanus on 6/7/16.
//  Copyright © 2016 Sylvanus. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TableViewCell : UITableViewCell

@property (strong, nonatomic) NSString *gid;
@property (strong, nonatomic) NSString *uid;
@property (strong, nonatomic) NSURL *avatarURL;
@property (strong, nonatomic) IBOutlet UIImageView *avatar;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *detail;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UIButton *button;

@end
