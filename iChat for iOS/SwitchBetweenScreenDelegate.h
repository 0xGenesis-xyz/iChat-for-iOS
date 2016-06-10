//
//  SwitchBetweenScreenDelegate.h
//  iChat for iOS
//
//  Created by Sylvanus on 6/11/16.
//  Copyright © 2016 Sylvanus. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SwitchBetweenScreenDelegate <NSObject>

@optional
- (void)switchToLoginScreen;
- (void)switchToSignupScreen;

@end
