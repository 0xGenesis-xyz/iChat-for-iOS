//
//  ChatViewController.h
//  iChat for iOS
//
//  Created by Sylvanus on 6/7/16.
//  Copyright © 2016 Sylvanus. All rights reserved.
//

#import <JSQMessagesViewController/JSQMessagesViewController.h>
#import <SocketIOClientSwift/SocketIOClientSwift-Swift.h>

@interface ChatViewController : JSQMessagesViewController

@property (strong, nonatomic) NSString *friendID;
@property (strong, nonatomic) NSString *friendName;
@property (strong, nonatomic) UIImage *friendAvatarImage;
@property (strong, nonatomic) SocketIOClient *socket;

@end
