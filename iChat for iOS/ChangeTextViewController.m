//
//  ChangeTextViewController.m
//  iChat for iOS
//
//  Created by Sylvanus on 6/8/16.
//  Copyright © 2016 Sylvanus. All rights reserved.
//

#import "ChangeTextViewController.h"
#import "iChat.h"
#import <AFNetworking/AFNetworking.h>

@interface ChangeTextViewController ()

@end

@implementation ChangeTextViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)ClickDone:(UIBarButtonItem *)sender {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSString *url;
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:2];
    [params setObject:@"sylvanuszhy@gmail.com" forKey:@"token"];
    if ([self.title isEqualToString:@"Name"]) {
        url = [NSString stringWithFormat:@"%@%@", HOST, @"/api/changeNicknameByToken"];
        [params setObject:self.textField.text forKey:@"name"];
    }
    if ([self.title isEqualToString:@"Location"]) {
        url = [NSString stringWithFormat:@"%@%@", HOST, @"/api/changeLocationByToken"];
        [params setObject:self.textField.text forKey:@"location"];
    }
    if ([self.title isEqualToString:@"What's up"]) {
        url = [NSString stringWithFormat:@"%@%@", HOST, @"/api/changeWhatsupByToken"];
        [params setObject:self.textField.text forKey:@"whatsup"];
    }
    [manager POST:url parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id _Nullable responseObject) {
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@", [error localizedDescription]);
    }];
    
    [self.navigationController popViewControllerAnimated:YES];
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
