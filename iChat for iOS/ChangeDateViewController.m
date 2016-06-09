//
//  ChangeDateViewController.m
//  iChat for iOS
//
//  Created by Sylvanus on 6/9/16.
//  Copyright © 2016 Sylvanus. All rights reserved.
//

#import "ChangeDateViewController.h"
#import "iChat.h"
#import <AFNetworking/AFNetworking.h>

@implementation ChangeDateViewController

- (IBAction)ClickDone:(UIBarButtonItem *)sender {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM/dd/yyyy"];
    NSDictionary *params = @{ @"token": @"sylvanuszhy@gmail.com", @"birthday": [dateFormatter stringFromDate:self.datePicker.date] };
    [manager POST:[NSString stringWithFormat:@"%@%@", HOST, @"/api/changeBirthdayByToken"] parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id _Nullable responseObject) {
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@", [error localizedDescription]);
    }];
    
    [self.navigationController popViewControllerAnimated:YES];
}

@end
