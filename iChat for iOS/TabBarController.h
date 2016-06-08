//
//  TabBarController.h
//  iChat for iOS
//
//  Created by Sylvanus on 6/8/16.
//  Copyright © 2016 Sylvanus. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SocketIOClientSwift/SocketIOClientSwift-Swift.h>

@interface TabBarController : UITabBarController

@property (strong, nonatomic) SocketIOClient *socket;

@end
