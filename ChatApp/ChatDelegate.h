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
@class ChatLogInViewController;

@interface ChatDelegate : NSObject


+ (ChatDelegate*)getChatDelegate;
- (void)setViewMessage:(ChatMessViewController*)view;
- (void)setViewDownload:(ChatDownloadFriendViewController*)view;
- (void)setViewAddFriend:(ChatAddFriendViewController*)view;
- (void)setViewFriendList:(ChatFriendListViewController*)view;
- (void)setViewSingUp:(ChatLogInViewController*)view;
- (void)registerReturn:(NSString*)msg withSuccess:(BOOL)success;
- (void)loginReturn:(NSString*)msg withSuccess:(BOOL)success;
- (void)logoutReturn:(BOOL)success;
- (void)setCurrLogedIn:(NSString*)username;

- (void)recievedExistanceOfFriend:(BOOL)exists;
- (void)recievedMessageFrom:(NSString*)friendNickName withMessage:(NSString *)msg;
- (void)recievedListOfAllPossibleFriends:(NSArray*)listOfAllPossibleFriends;

@end
