//
//  FriendRequest.m
//  iChat for iOS
//
//  Created by Sylvanus on 6/9/16.
//  Copyright © 2016 Sylvanus. All rights reserved.
//

#import "FriendRequest.h"

@implementation FriendRequest

- (instancetype)initWithWho:(NSString *)who message:(NSString *)message time:(NSString *)time state:(NSString *)state {
    self = [super init];
    
    if (self) {
        self.who = [NSString stringWithString:who];
        self.message = [NSString stringWithString:message];
        self.time = [NSString stringWithString:time];
        self.state = [NSString stringWithString:state];
    }
    
    return self;
}

@end
