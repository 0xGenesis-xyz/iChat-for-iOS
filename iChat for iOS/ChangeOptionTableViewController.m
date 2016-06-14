//
//  ChangeOptionTableViewController.m
//  iChat for iOS
//
//  Created by Sylvanus on 6/9/16.
//  Copyright © 2016 Sylvanus. All rights reserved.
//

#import "ChangeOptionTableViewController.h"
#import "iChat.h"
#import <AFNetworking/AFNetworking.h>

@interface ChangeOptionTableViewController ()

@property (weak, nonatomic) IBOutlet UILabel *male;
@property (weak, nonatomic) IBOutlet UILabel *female;

@end

@implementation ChangeOptionTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if ([self.option isEqualToString:@"male"]) {
        self.male.text = @"✔️";
        self.female.text = @"";
    }
    if ([self.option isEqualToString:@"female"]) {
        self.male.text = @"";
        self.female.text = @"✔️";
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:2];
    [params setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"token"] forKey:@"token"];
    if (indexPath.item == 0) {
        [params setObject:@"male" forKey:@"gender"];
    }
    if (indexPath.item == 1) {
        [params setObject:@"female" forKey:@"gender"];
    }
    [manager POST:[NSString stringWithFormat:@"%@%@", HOST, @"/api/changeGenderByToken"] parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id _Nullable responseObject) {
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@", [error localizedDescription]);
    }];
    
    [self.navigationController popViewControllerAnimated:YES];
}

@end
