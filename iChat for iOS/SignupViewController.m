//
//  SignupViewController.m
//  iChat for iOS
//
//  Created by Sylvanus on 6/10/16.
//  Copyright © 2016 Sylvanus. All rights reserved.
//

#import "SignupViewController.h"
#import "iChat.h"
#import <AFNetworking/AFNetworking.h>

@interface SignupViewController ()

@property (weak, nonatomic) IBOutlet UITextField *email;
@property (weak, nonatomic) IBOutlet UITextField *username;
@property (weak, nonatomic) IBOutlet UITextField *password1;
@property (weak, nonatomic) IBOutlet UITextField *password2;

@end

@implementation SignupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)signup:(UIButton *)sender {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSDictionary *params = @{ @"email": self.email.text,  @"username": self.username.text, @"pwd1": self.password1.text, @"pwd2": self.password2.text };
    [manager POST:[NSString stringWithFormat:@"%@%@", HOST, @"/api/signup"] parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers | NSJSONReadingMutableLeaves error:nil];
        NSString *state = [NSString stringWithFormat:@"%@", [dict valueForKey:@"state"]];
        if ([state isEqualToString:@"success"]) {
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@", [error localizedDescription]);
    }];
}

- (IBAction)switchToLogin:(UIButton *)sender {
    if ([_delegate respondsToSelector:@selector(switchToLoginScreen)])
        [_delegate switchToLoginScreen];
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
