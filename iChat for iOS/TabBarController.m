//
//  TabBarController.m
//  iChat for iOS
//
//  Created by Sylvanus on 6/8/16.
//  Copyright © 2016 Sylvanus. All rights reserved.
//

#import "TabBarController.h"
#import "iChat.h"
#import "ChatTableViewController.h"
#import "ContactTableViewController.h"

@implementation TabBarController

- (void)awakeFromNib {
    NSURL* url = [[NSURL alloc] initWithString:@"http://localhost:3000"];
    self.socket = [[SocketIOClient alloc] initWithSocketURL:url options:@{ @"connectParams": @{@"token": @"sylvanuszhy@gmail.com"}, @"log": @NO }];
    
    [self.socket on:@"connect" callback:^(NSArray* data, SocketAckEmitter* ack) {
        NSLog(@"socket connected");
    }];
    
    [self.socket on:@"unread" callback:^(NSArray* data, SocketAckEmitter* ack) {
        NSString *unread = [NSString stringWithFormat:@"%@", [data objectAtIndex:0]];
        UINavigationController *chatNavigationController = [self.viewControllers objectAtIndex:0];
        ChatTableViewController *chatTableViewController = (ChatTableViewController *)chatNavigationController.topViewController;
        chatTableViewController.tabBarItem.badgeValue = unread;
    }];
    
    [self.socket on:@"newMessage" callback:^(NSArray* data, SocketAckEmitter* ack) {
        NSDictionary *userInfo = [data objectAtIndex:0];
        [[NSNotificationCenter defaultCenter] postNotificationName:NewMessageNotification object:self userInfo:userInfo];
    }];
    
    [self.socket on:@"newRequest" callback:^(NSArray* data, SocketAckEmitter* ack) {
        NSDictionary *userInfo = [data objectAtIndex:0];
        [[NSNotificationCenter defaultCenter] postNotificationName:NewRequestNotification object:self userInfo:userInfo];
    }];
    
    [self.socket connect];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UINavigationController *chatNavigationController = [self.viewControllers objectAtIndex:0];
    UINavigationController *contactNavigationController = [self.viewControllers objectAtIndex:1];
    ChatTableViewController *chatTableViewController = (ChatTableViewController *)chatNavigationController.topViewController;
    ContactTableViewController *contactTableViewController = (ContactTableViewController *)contactNavigationController.topViewController;
    chatTableViewController.socket = self.socket;
    contactTableViewController.socket = self.socket;
}

@end
