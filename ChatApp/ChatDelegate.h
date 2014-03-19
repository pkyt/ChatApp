//
//  ChatDelegate.h
//  ChatApp
//
//  Created by Pavlo Kytsmey on 3/17/14.
//  Copyright (c) 2014 Pavlo Kytsmey. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Connection.h"
#import "Message.h"

@class ChatMessViewController;
@class ChatDownloadFriendViewController;
@class ChatAddFriendViewController;
@class ChatFriendListViewController;

@interface ChatDelegate : NSObject

+ (ChatDelegate*)getChatDelegate;
- (void)setViewMessage:(ChatMessViewController*)view;
- (void)setViewDownload:(ChatDownloadFriendViewController*)view;
- (void)setViewAddFriend:(ChatAddFriendViewController*)view;
- (void)setViewFriendList:(ChatFriendListViewController*)view;
- (void)existanceOfFriend:(NSString*)nickName;
- (void)sendMessageTo:(NSString*)frdNickName withMessage:(NSString*)msg;
- (void)allFriends;
- (void)setFriendToViewMessage:(NSString*)friendConnection;

- (void)recievedExistanceOfFriend:(BOOL)exists;
- (void)recievedMessageFrom:(NSString*)friendNickName withMessage:(NSString *)msg;
- (void)recievedListOfAllPossibleFriends:(NSArray*)listOfAllPossibleFriends;

@end
