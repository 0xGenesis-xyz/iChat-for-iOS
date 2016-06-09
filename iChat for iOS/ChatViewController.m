//
//  ChatViewController.m
//  iChat for iOS
//
//  Created by Sylvanus on 6/7/16.
//  Copyright © 2016 Sylvanus. All rights reserved.
//

#import "ChatViewController.h"
#import "iChat.h"
#import <AFNetworking/AFNetworking.h>
#import <JSQMessagesViewController/JSQMessage.h>
#import <JSQMessagesViewController/JSQMessagesBubbleImageFactory.h>
#import <JSQMessagesViewController/JSQMessagesAvatarImageFactory.h>

@interface ChatViewController ()

@property (strong, nonatomic) NSMutableArray *messages;
@property (strong, nonatomic) JSQMessagesAvatarImage *friendAvatar;
@property (strong, nonatomic) JSQMessagesBubbleImage *incomingBubbleImageData;
@property (strong, nonatomic) JSQMessagesBubbleImage *outgoingBubbleImageData;

@end

@implementation ChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    JSQMessagesBubbleImageFactory *bubbleFactory = [[JSQMessagesBubbleImageFactory alloc] init];
    self.incomingBubbleImageData = [bubbleFactory incomingMessagesBubbleImageWithColor:[UIColor blueColor]];
    self.outgoingBubbleImageData = [bubbleFactory outgoingMessagesBubbleImageWithColor:[UIColor lightGrayColor]];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:NewMessageNotification object:nil queue:nil usingBlock:^(NSNotification *note) {
        if ([self.friendID isEqualToString:[NSString stringWithFormat:@"%@", [note.userInfo objectForKey:@"uid"]]]) {
            [self fetchMessageData];
        }
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self fetchMessageData];
    self.friendAvatar = [JSQMessagesAvatarImageFactory avatarImageWithImage:self.friendAvatarImage diameter:AvatarImageDiameter];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)fetchMessageData {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSDictionary *params = @{ @"token": @"sylvanuszhy@gmail.com", @"uid": self.friendID };
    [manager GET:[NSString stringWithFormat:@"%@%@", HOST, @"/api/getChatMessage"] parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id _Nullable responseObject) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers | NSJSONReadingMutableLeaves error:nil];
        NSArray *messageArray = [NSArray arrayWithArray:[dict valueForKey:@"messages"]];
        self.messages = [NSMutableArray arrayWithCapacity:[messageArray count]];
        for (NSDictionary *message in messageArray) {
            [self.messages addObject:[JSQMessage messageWithSenderId:[message objectForKey:@"from"]
                                                         displayName:[message objectForKey:@"from"]
                                                                text:[message objectForKey:@"message"]]];
        }
        [self.collectionView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@", [error localizedDescription]);
    }];
    
    [manager POST:[NSString stringWithFormat:@"%@%@", HOST, @"/api/checkMessage"] parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@", [error localizedDescription]);
    }];
}

#pragma mark - Data Source

- (NSString *)senderId {
    return @"sylvanuszhy@gmail.com";
}

- (NSString *)senderDisplayName {
    return @"sylvanuszhy@gmail.com";
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.messages count];
}

- (id<JSQMessageData>)collectionView:(JSQMessagesCollectionView *)collectionView messageDataForItemAtIndexPath:(NSIndexPath *)indexPath {
    return [self.messages objectAtIndex:indexPath.row];
}

- (id<JSQMessageBubbleImageDataSource>)collectionView:(JSQMessagesCollectionView *)collectionView messageBubbleImageDataForItemAtIndexPath:(NSIndexPath *)indexPath {
    JSQMessage *message = [self.messages objectAtIndex:indexPath.row];
    if ([message.senderId isEqualToString:self.friendID]) {
        return self.incomingBubbleImageData;
    } else {
        return self.outgoingBubbleImageData;
    }
}

- (id<JSQMessageAvatarImageDataSource>)collectionView:(JSQMessagesCollectionView *)collectionView avatarImageDataForItemAtIndexPath:(NSIndexPath *)indexPath {
    JSQMessage *message = [self.messages objectAtIndex:indexPath.row];
    if ([message.senderId isEqualToString:self.friendID]) {
        return self.friendAvatar;
    } else {
        return nil;
    }
}

- (void)collectionView:(JSQMessagesCollectionView *)collectionView didDeleteMessageAtIndexPath:(NSIndexPath *)indexPath {
    [self.messages removeObjectAtIndex:indexPath.row];
}

#pragma mark - Message Bar

- (void)didPressSendButton:(UIButton *)button withMessageText:(NSString *)text senderId:(NSString *)senderId senderDisplayName:(NSString *)senderDisplayName date:(NSDate *)date {
    [self.socket emit:@"send" withItems:@[ @{@"to": self.friendID, @"message": text} ]];
    [self.messages addObject:[JSQMessage messageWithSenderId:senderId
                                                 displayName:senderDisplayName
                                                        text:text]];
    [self finishSendingMessage];
}

- (void)didPressAccessoryButton:(UIButton *)sender {
    // do something
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
