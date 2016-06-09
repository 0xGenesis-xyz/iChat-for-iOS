//
//  FriendRequest.h
//  iChat for iOS
//
//  Created by Sylvanus on 6/9/16.
//  Copyright © 2016 Sylvanus. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FriendRequest : NSObject

@property (strong, nonatomic) NSString *who;
@property (strong, nonatomic) NSString *message;
@property (strong, nonatomic) NSString *time;
@property (strong, nonatomic) NSString *state;

- (instancetype)initWithWho:(NSString *)who message:(NSString *)message time:(NSString *)time state:(NSString *)state;

@end
