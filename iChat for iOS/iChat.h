//
//  iChat.h
//  iChat for iOS
//
//  Created by Sylvanus on 6/8/16.
//  Copyright © 2016 Sylvanus. All rights reserved.
//

#ifndef iChat_h
#define iChat_h

#define HOST @"http://localhost:3000"
#define AVATARROOT [NSString stringWithFormat:@"%@%@/", HOST, @"/avatars"]

#define FriendRequestFromSystem @"Validation@System"

#define NewMessageNotification @"NewMessageNotification"
#define NewRequestNotification @"NewRequestNotification"

#define LoginNotification @"LoginNotification"
#define LogoutNotification @"LogoutNotification"

#define AvatarImageDiameter 40

#endif /* iChat_h */
