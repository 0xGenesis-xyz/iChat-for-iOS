//
//  ViewController.m
//  iChat for iOS
//
//  Created by Sylvanus on 6/5/16.
//  Copyright © 2016 Sylvanus. All rights reserved.
//

#import "ViewController.h"
#import <JSQMessagesViewController/JSQMessagesViewController.h>
#import <AFNetworking/AFNetworking.h>
#import <SocketIOClientSwift/SocketIOClientSwift-Swift.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    NSURL* url = [[NSURL alloc] initWithString:@"http://localhost:3000"];
    SocketIOClient* socket = [[SocketIOClient alloc] initWithSocketURL:url options:@{ @"connectParams": @{@"token": @"sylvanuszhy@gmail.com"} }];
    
    [socket on:@"connect" callback:^(NSArray* data, SocketAckEmitter* ack) {
        NSLog(@"socket connected");
    }];
    
    [socket on:@"currentAmount" callback:^(NSArray* data, SocketAckEmitter* ack) {
        double cur = [[data objectAtIndex:0] floatValue];
        
        [socket emitWithAck:@"canUpdate" withItems:@[@(cur)]](0, ^(NSArray* data) {
            [socket emit:@"update" withItems:@[@{@"amount": @(cur + 2.50)}]];
        });
        
        [ack with:@[@"Got your currentAmount, ", @"dude"]];
    }];
    
    [socket connect];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
