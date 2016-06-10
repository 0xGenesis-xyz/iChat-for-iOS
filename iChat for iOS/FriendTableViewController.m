//
//  FriendTableViewController.m
//  iChat for iOS
//
//  Created by Sylvanus on 6/8/16.
//  Copyright © 2016 Sylvanus. All rights reserved.
//

#import "FriendTableViewController.h"
#import "iChat.h"
#import <AFNetworking/AFNetworking.h>
#import <AFNetworking/UIImageView+AFNetworking.h>
#import "GroupTableViewController.h"
#import "ChatViewController.h"

@interface FriendTableViewController ()

@property (strong, nonatomic) NSURL *avatarURL;
@property (strong, nonatomic) IBOutlet UIImageView *avatar;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *email;
@property (weak, nonatomic) IBOutlet UILabel *Gender;
@property (weak, nonatomic) IBOutlet UILabel *birthday;
@property (weak, nonatomic) IBOutlet UILabel *location;
@property (weak, nonatomic) IBOutlet UILabel *whatsup;

@end

@implementation FriendTableViewController

static NSString * const GroupSegueIdentifier = @"ShowGroup";
static NSString * const NewChatSegueIdentifier = @"ShowNewChat";

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Profile";
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self fetchFriendInfoData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)fetchFriendInfoData {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSDictionary *params = @{ @"uid": self.friendID };
    [manager GET:[NSString stringWithFormat:@"%@%@", HOST, @"/api/getUserInfo"] parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id _Nullable responseObject) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers | NSJSONReadingMutableLeaves error:nil];
        self.avatarURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", AVATARROOT, [dict valueForKey:@"avatar"]]];
        self.name.text = [NSString stringWithFormat:@"%@", [dict valueForKey:@"username"]];
        self.email.text = [NSString stringWithFormat:@"%@", [dict valueForKey:@"email"]];
        self.birthday.text = [NSString stringWithFormat:@"%@", [dict valueForKey:@"birthday"]];
        self.location.text = [NSString stringWithFormat:@"%@", [dict valueForKey:@"location"]];
        self.whatsup.text = [NSString stringWithFormat:@"%@", [dict valueForKey:@"whatsup"]];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@", [error localizedDescription]);
    }];
}

- (IBAction)deleteContact:(UIButton *)sender {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSDictionary *params = @{ @"token": @"sylvanuszhy@gmail.com", @"uid": self.friendID, @"gid": self.groupID };
    [manager POST:[NSString stringWithFormat:@"%@%@", HOST, @"/api/deleteFriend"] parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self.navigationController popViewControllerAnimated:YES];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@", [error localizedDescription]);
    }];
}

#pragma mark - Table view data source
/*
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Incomplete implementation, return the number of sections
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
    return 0;
}
*/
/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:GroupSegueIdentifier]) {
        GroupTableViewController *groupTableViewController = segue.destinationViewController;
        groupTableViewController.groupID = [NSString stringWithString:self.groupID];
        groupTableViewController.friendID = [NSString stringWithString:self.friendID];
    }
    if ([segue.identifier isEqualToString:NewChatSegueIdentifier]) {
        ChatViewController *chatViewController = segue.destinationViewController;
        chatViewController.friendID = [NSString stringWithString:self.friendID];
        chatViewController.friendName = [NSString stringWithString:self.name.text];
        chatViewController.friendAvatarImage = self.avatar.image;
        chatViewController.socket = self.socket;
        
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        
        NSDictionary *params = @{ @"token": @"sylvanuszhy@gmail.com", @"uid": self.friendID };
        [manager POST:[NSString stringWithFormat:@"%@%@", HOST, @"/api/newChat"] parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"%@", [error localizedDescription]);
        }];
    }
}

#pragma mark - Getter Setter

- (UIImageView *)avatar {
    if (!_avatar) {
        _avatar = [[UIImageView alloc] init];
    }
    return _avatar;
}

- (void)setAvatarURL:(NSURL *)avatarURL {
    _avatarURL = avatarURL;
    [self.avatar setImageWithURL:_avatarURL];
}

@end
