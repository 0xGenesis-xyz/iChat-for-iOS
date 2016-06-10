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
#import "LoginViewController.h"
#import "SignupViewController.h"
#import "SwitchBetweenScreenDelegate.h"

@interface ViewController () <SwitchBetweenScreenDelegate>

@property (strong, nonatomic) LoginViewController *loginViewController;
@property (strong, nonatomic) SignupViewController *signupViewController;
@property (strong, nonatomic) UIViewController *currentViewController;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.loginViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"LoginVC"];
    self.signupViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"SignupVC"];
    self.loginViewController.delegate = self;
    self.signupViewController.delegate = self;

    [self addChildViewController:self.loginViewController];
    [self.view addSubview:self.loginViewController.view];
    self.currentViewController = self.loginViewController;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - SwitchBetweenScreenDelegate

- (void)switchToLoginScreen {
    [self replaceViewController:self.currentViewController withViewController:self.loginViewController];
}

- (void)switchToSignupScreen {
    [self replaceViewController:self.currentViewController withViewController:self.signupViewController];
}

- (void)replaceViewController:(UIViewController *)oldViewController withViewController:(UIViewController *)newViewController {
    [self addChildViewController:newViewController];
    [self transitionFromViewController:oldViewController toViewController:newViewController duration:0.2 options:UIViewAnimationOptionTransitionCrossDissolve animations:nil completion:^(BOOL finished) {
        if (finished) {
            [newViewController didMoveToParentViewController:self];
            [oldViewController willMoveToParentViewController:nil];
            [oldViewController removeFromParentViewController];
            self.currentViewController = newViewController;
        } else {
            self.currentViewController = oldViewController;
        }
    }];
}

@end
