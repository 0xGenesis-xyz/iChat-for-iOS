//
//  ChatTableViewController.h
//  iChat for iOS
//
//  Created by Sylvanus on 6/6/16.
//  Copyright © 2016 Sylvanus. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SocketIOClientSwift/SocketIOClientSwift-Swift.h>

@interface ChatTableViewController : UITableViewController

@property (strong, nonatomic) SocketIOClient *socket;

@end
