//
//  ChatTableViewController.m
//  iChat for iOS
//
//  Created by Sylvanus on 6/6/16.
//  Copyright © 2016 Sylvanus. All rights reserved.
//

#import "ChatTableViewController.h"
#import "iChat.h"
#import <AFNetworking/AFNetworking.h>
#import "TableViewCell.h"
#import "ChatViewController.h"

@interface ChatTableViewController ()

@property (strong, nonatomic) NSMutableArray *chatList;

@end

@implementation ChatTableViewController

static NSString * const ReuseIdentifier = @"ChatCell";
static NSString * const ChatSegueIdentifier = @"ShowChat";
static NSString * const RequestSegueIdentifier = @"ShowRequest";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:NewMessageNotification object:nil queue:nil usingBlock:^(NSNotification *note) {
        [self fetchChatListData];
    }];
    [[NSNotificationCenter defaultCenter] addObserverForName:NewRequestNotification object:nil queue:nil usingBlock:^(NSNotification *note) {
        [self fetchChatListData];
    }];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self fetchChatListData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)fetchChatListData {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSDictionary *params = @{ @"token": @"sylvanuszhy@gmail.com" };
    [manager GET:[NSString stringWithFormat:@"%@%@", HOST, @"/api/getChatlistByToken"] parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id _Nullable responseObject) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers | NSJSONReadingMutableLeaves error:nil];
        self.chatList = [NSMutableArray arrayWithArray:[dict valueForKey:@"chats"]];
        [self.tableView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@", [error localizedDescription]);
    }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.chatList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ReuseIdentifier forIndexPath:indexPath];
    
    NSString *chatID = [self.chatList objectAtIndex:indexPath.row];
    cell.uid = [NSString stringWithString:chatID];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSDictionary *params = @{ @"token": @"sylvanuszhy@gmail.com", @"uid": chatID };
    [manager GET:[NSString stringWithFormat:@"%@%@", HOST, @"/api/getUserInfo"] parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id _Nullable responseObject) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers | NSJSONReadingMutableLeaves error:nil];
        cell.avatarURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", AVATARROOT, [dict valueForKey:@"avatar"]]];
        cell.name.text = [NSString stringWithFormat:@"%@", [dict valueForKey:@"username"]];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@", [error localizedDescription]);
    }];
    [manager GET:[NSString stringWithFormat:@"%@%@", HOST, @"/api/getChatInfo"] parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id _Nullable responseObject) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers | NSJSONReadingMutableLeaves error:nil];
        cell.detail.text = [dict objectForKey:@"message"];
        cell.time.text = [dict objectForKey:@"time"];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@", [error localizedDescription]);
    }];
    
    return cell;
}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [self.chatList removeObjectAtIndex:indexPath.item];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        
        TableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
        NSDictionary *params = @{ @"token": @"sylvanuszhy@gmail.com", @"uid": cell.uid };
        [manager POST:[NSString stringWithFormat:@"%@%@", HOST, @"/api/removeChat"] parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"%@", [error localizedDescription]);
        }];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}

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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *chatID = [self.chatList objectAtIndex:indexPath.row];
    if ([chatID isEqualToString:FriendRequestFromSystem]) {
        [self performSegueWithIdentifier:RequestSegueIdentifier sender:[self.tableView cellForRowAtIndexPath:indexPath]];
    } else {
        [self performSegueWithIdentifier:ChatSegueIdentifier sender:[self.tableView cellForRowAtIndexPath:indexPath]];
    }
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:ChatSegueIdentifier]) {
        ChatViewController *chatViewController = segue.destinationViewController;
        TableViewCell *cell = sender;
        chatViewController.friendID = [NSString stringWithString:cell.uid];
        chatViewController.friendName = cell.name.text;
        chatViewController.friendAvatarImage = cell.avatar.image;
        chatViewController.socket = self.socket;
        chatViewController.title = cell.name.text;
        chatViewController.hidesBottomBarWhenPushed = YES;
    }
}

@end
