//
//  LoginViewController.m
//  iChat for iOS
//
//  Created by Sylvanus on 6/10/16.
//  Copyright © 2016 Sylvanus. All rights reserved.
//

#import "LoginViewController.h"
#import "iChat.h"
#import <AFNetworking/AFNetworking.h>

@interface LoginViewController ()

@property (weak, nonatomic) IBOutlet UITextField *uid;
@property (weak, nonatomic) IBOutlet UITextField *password;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)login:(UIButton *)sender {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSDictionary *params = @{ @"uid": self.uid.text, @"password": self.password.text };
    [manager POST:[NSString stringWithFormat:@"%@%@", HOST, @"/api/login"] parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers | NSJSONReadingMutableLeaves error:nil];
        NSString *state = [NSString stringWithFormat:@"%@", [dict valueForKey:@"state"]];
        if ([state isEqualToString:@"success"]) {
            NSString *token = [NSString stringWithFormat:@"%@", [dict valueForKey:@"token"]];
            NSString *avatar = [NSString stringWithFormat:@"%@", [dict valueForKey:@"avatar"]];
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            [userDefaults setObject:token forKey:@"token"];
            [userDefaults setObject:self.uid.text forKey:@"name"];
            [userDefaults setObject:self.password.text forKey:@"password"];
            [userDefaults setObject:avatar forKey:@"avatar"];
            [userDefaults synchronize];
            [[NSNotificationCenter defaultCenter] postNotificationName:LoginNotification object:self userInfo:nil];
        } else {
            NSString *alert = [NSString stringWithFormat:@"%@", [dict valueForKey:@"error"]];
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Log in" message:alert preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
            [alertController addAction:okAction];
            [self presentViewController:alertController animated:YES completion:nil];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@", [error localizedDescription]);
    }];
}

- (IBAction)switchToSignup:(UIButton *)sender {
    if ([_delegate respondsToSelector:@selector(switchToSignupScreen)])
        [_delegate switchToSignupScreen];
}

- (IBAction)forgetPassword:(UIButton *)sender {
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
