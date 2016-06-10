//
//  ProfileTableViewController.m
//  iChat for iOS
//
//  Created by Sylvanus on 6/6/16.
//  Copyright © 2016 Sylvanus. All rights reserved.
//

#import "ProfileTableViewController.h"
#import "iChat.h"
#import <AFNetworking/AFNetworking.h>
#import <AFNetworking/UIImageView+AFNetworking.h>
#import "ChangeTextViewController.h"
#import "ChangeOptionTableViewController.h"
#import "PickImageViewController.h"

@interface ProfileTableViewController ()

@property (strong, nonatomic) NSURL *avatarURL;
@property (strong, nonatomic) IBOutlet UIImageView *avatar;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *email;
@property (weak, nonatomic) IBOutlet UILabel *gender;
@property (weak, nonatomic) IBOutlet UILabel *birthday;
@property (weak, nonatomic) IBOutlet UILabel *location;
@property (weak, nonatomic) IBOutlet UILabel *whatsup;

@end

@implementation ProfileTableViewController

static NSString * const AvatarSegueIdentifier = @"ChangeAvatar";
static NSString * const NameSegueIdentifier = @"ChangeNickname";
static NSString * const GenderSegueIdentifier = @"ChangeGender";
static NSString * const LocationSegueIdentifier = @"ChangeLocation";
static NSString * const WhatsupSegueIdentifier = @"ChangeWhatsup";
static NSString * const PasswordSegueIdentifier = @"ChangePassword";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self fetchProfileData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)fetchProfileData {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSDictionary *params = @{ @"uid": @"sylvanuszhy@gmail.com" };
    [manager GET:[NSString stringWithFormat:@"%@%@", HOST, @"/api/getUserInfo"] parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id _Nullable responseObject) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers | NSJSONReadingMutableLeaves error:nil];
        self.avatarURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", AVATARROOT, [dict valueForKey:@"avatar"]]];
        self.name.text = [NSString stringWithFormat:@"%@", [dict valueForKey:@"username"]];
        self.email.text = [NSString stringWithFormat:@"%@", [dict valueForKey:@"email"]];
        self.gender.text = [NSString stringWithFormat:@"%@", [dict valueForKey:@"gender"]];
        self.birthday.text = [NSString stringWithFormat:@"%@", [dict valueForKey:@"birthday"]];
        self.location.text = [NSString stringWithFormat:@"%@", [dict valueForKey:@"location"]];
        self.whatsup.text = [NSString stringWithFormat:@"%@", [dict valueForKey:@"whatsup"]];
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 2) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Password" message:@"Enter current password" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
            manager.responseSerializer = [AFHTTPResponseSerializer serializer];
            
            NSDictionary *params = @{ @"token": @"sylvanuszhy@gmail.com", @"password": alertController.textFields[0].text };
            [manager POST:[NSString stringWithFormat:@"%@%@", HOST, @"/api/checkPasswordByToken"] parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id _Nullable responseObject) {
                NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers | NSJSONReadingMutableLeaves error:nil];
                NSString *state = [dict valueForKey:@"state"];
                if ([state isEqualToString:@"success"]) {
                    [self performSegueWithIdentifier:PasswordSegueIdentifier sender:self];
                }
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                NSLog(@"%@", [error localizedDescription]);
            }];
        }];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:nil];
        
        [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
            textField.secureTextEntry = YES;
        }];
        [alertController addAction:cancelAction];
        [alertController addAction:okAction];
        
        [self presentViewController:alertController animated:YES completion:nil];
    }
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:AvatarSegueIdentifier]) {
        PickImageViewController *pickImageViewController = segue.destinationViewController;
        pickImageViewController.avatar = self.avatar;
    }
    if ([segue.identifier isEqualToString:NameSegueIdentifier]) {
        ChangeTextViewController *changeTextViewController = segue.destinationViewController;
        changeTextViewController.title = @"Name";
        changeTextViewController.textField.text = self.name.text;
    }
    if ([segue.identifier isEqualToString:GenderSegueIdentifier]) {
        ChangeOptionTableViewController *changeOptionTableViewController = segue.destinationViewController;
        changeOptionTableViewController.title = @"Gender";
        if ([self.gender.text isEqualToString:@"male"]) {
            changeOptionTableViewController.male.text = @"✔️";
            changeOptionTableViewController.female.text = @"";
        } else {
            changeOptionTableViewController.male.text = @"";
            changeOptionTableViewController.female.text = @"✔️";
        }
    }
    if ([segue.identifier isEqualToString:LocationSegueIdentifier]) {
        ChangeTextViewController *changeTextViewController = segue.destinationViewController;
        changeTextViewController.title = @"Location";
        changeTextViewController.textField.text = self.location.text;
    }
    if ([segue.identifier isEqualToString:WhatsupSegueIdentifier]) {
        ChangeTextViewController *changeTextViewController = segue.destinationViewController;
        changeTextViewController.title = @"What's up";
        changeTextViewController.textField.text = self.whatsup.text;
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
    NSLog(@"%@", avatarURL);
    [self.avatar setImageWithURL:_avatarURL];
}

@end
