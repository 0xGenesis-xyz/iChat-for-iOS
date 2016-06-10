//
//  ContactTableViewController.m
//  iChat for iOS
//
//  Created by Sylvanus on 6/6/16.
//  Copyright © 2016 Sylvanus. All rights reserved.
//

#import "ContactTableViewController.h"
#import "iChat.h"
#import <AFNetworking/AFNetworking.h>
#import "TableViewCell.h"
#import "FriendTableViewController.h"

@interface ContactTableViewController ()

@property (strong, nonatomic) NSArray *friendList;

@end

@implementation ContactTableViewController

static NSString * const ReuseIdentifier = @"ContactCell";
static NSString * const ShowSegueIdentifier = @"ShowContact";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self fetchFriendListData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)fetchFriendListData {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSDictionary *params = @{ @"token": @"sylvanuszhy@gmail.com" };
    [manager GET:[NSString stringWithFormat:@"%@%@", HOST, @"/api/getFriendlistByToken"] parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id _Nullable responseObject) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers | NSJSONReadingMutableLeaves error:nil];
        self.friendList = [NSArray arrayWithArray:[dict valueForKey:@"friends"]];
        [self.tableView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@", [error localizedDescription]);
    }];
}

- (IBAction)addFriend:(UIBarButtonItem *)sender {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Add a Friend" message:@"Add a friend by name or email, with a message" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        NSString *newFriend = alertController.textFields[0].text;
        NSString *message = alertController.textFields[1].text;
        [self.socket emit:@"request" withItems:@[ @{@"uid": newFriend, @"message": message} ]];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:nil];
    
    [alertController addTextFieldWithConfigurationHandler:nil];
    [alertController addTextFieldWithConfigurationHandler:nil];
    [alertController addAction:cancelAction];
    [alertController addAction:okAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.friendList count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSDictionary *group = [self.friendList objectAtIndex:section];
    NSArray *friends = [group valueForKey:@"items"];
    return [friends count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSDictionary *group = [self.friendList objectAtIndex:section];
    return [group valueForKey:@"group"];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ReuseIdentifier forIndexPath:indexPath];
    
    NSDictionary *group = [self.friendList objectAtIndex:indexPath.section];
    NSString *groupID = [group valueForKey:@"group"];
    NSArray *friends = [group valueForKey:@"items"];
    NSString *friendID = [friends objectAtIndex:indexPath.row];
    cell.gid = [NSString stringWithString:groupID];
    cell.uid = [NSString stringWithString:friendID];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSDictionary *params = @{ @"uid": friendID };
    [manager GET:[NSString stringWithFormat:@"%@%@", HOST, @"/api/getUserInfo"] parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id _Nullable responseObject) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers | NSJSONReadingMutableLeaves error:nil];
        cell.avatarURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", AVATARROOT, [dict valueForKey:@"avatar"]]];
        cell.name.text = [dict objectForKey:@"username"];
        cell.detail.text = [dict objectForKey:@"whatsup"];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@", [error localizedDescription]);
    }];
    
    return cell;
}

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
    if ([segue.identifier isEqualToString:ShowSegueIdentifier]) {
        FriendTableViewController *friendTableViewController = segue.destinationViewController;
        TableViewCell *cell = sender;
        friendTableViewController.groupID = [NSString stringWithString:cell.gid];
        friendTableViewController.friendID = [NSString stringWithString:cell.uid];
        friendTableViewController.socket = self.socket;
        friendTableViewController.hidesBottomBarWhenPushed = YES;
    }
}

@end
