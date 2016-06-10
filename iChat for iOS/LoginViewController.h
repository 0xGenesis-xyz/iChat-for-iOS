//
//  LoginViewController.h
//  iChat for iOS
//
//  Created by Sylvanus on 6/10/16.
//  Copyright © 2016 Sylvanus. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SwitchBetweenScreenDelegate.h"

@interface LoginViewController : UIViewController

@property (weak, nonatomic) id <SwitchBetweenScreenDelegate> delegate;

@end
