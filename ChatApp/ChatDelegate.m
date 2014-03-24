//
//  ChatDelegate.m
//  ChatApp
//
//  Created by Pavlo Kytsmey on 3/17/14.
//  Copyright (c) 2014 Pavlo Kytsmey. All rights reserved.
//

#import "ChatDelegate.h"
#import "ChatClient.h"
#import "ChatMessViewController.h"
#import "ChatDownloadFriendViewController.h"
#import "ChatAddFriendViewController.h"
#import "ChatFriendListViewController.h"
#import "ChatAppDelegate.h"
#import "ChatLogInViewController.h"
#import "ChatDBOperand.h"

@implementation ChatDelegate
static ChatDelegate * me;
static ChatMessViewController * viewMessage;
static ChatDownloadFriendViewController * viewDownload;
static ChatAddFriendViewController * viewAddFriend;
static ChatFriendListViewController * viewFriendList;
static ChatLogInViewController * viewSingUp;
static NSManagedObjectContext * context;
static NSMutableArray * requstedExistance;
static NSString * messFriend;
static NSArray * possibleFriends;
static NSString* currLogedIn;

+ (ChatDelegate*)getChatDelegate{
    if (!me) {
        me = [ChatDelegate new];
        ChatAppDelegate* delegate = [[UIApplication sharedApplication] delegate];
        context = [delegate managedObjectContext];
        requstedExistance = [NSMutableArray new];
        messFriend = @"";
        currLogedIn = @"";
        possibleFriends = [NSArray new];
    }
    return me;
}

- (void)setCurrLogedIn:(NSString*)username{
    currLogedIn = username;
}

- (NSString*)getCurrLog{
    return currLogedIn;
}

- (void)setViewSingUp:(ChatLogInViewController*)view{
    viewSingUp = view;
}

- (void)setFriendToViewMessage:(NSString *)friendConnection{
    messFriend = friendConnection;
    [viewMessage reload];
}

- (void)setViewMessage:(ChatMessViewController*)view{
    viewMessage = view;
    [viewMessage reload];
}

- (void)setViewDownload:(ChatDownloadFriendViewController*)view{
    viewDownload = view;
}

- (void)setViewAddFriend:(ChatAddFriendViewController*)view{
    viewAddFriend = view;
}

- (void)setViewFriendList:(ChatFriendListViewController*)view{
    viewFriendList = view;
}

- (void)recievedExistanceOfFriend:(BOOL)exists{
    if (viewAddFriend) {
        [viewAddFriend setResponce:exists];
        if (viewFriendList) { // new friend was added, so it should appear in friend list
            [viewFriendList reload];
        }
    }
}

- (void)recievedMessageFrom:(NSString*)friendNickName withMessage:(NSString *)msg{
    ChatAppDelegate* delegate = [[UIApplication sharedApplication] delegate];
    [[ChatDBOperand getDBOperand] AddMessageEvenIfUserDoesntExists:delegate.currLoged withFriend:friendNickName withMessage:msg];
    if (viewMessage) {
        [viewMessage reload];
    }
    if (viewFriendList) {
        [viewFriendList reload];
    }
    
}

- (void)recievedListOfAllPossibleFriends:(NSArray*)listOfAllPossibleFriends{
    possibleFriends = listOfAllPossibleFriends;
    if (viewDownload) {
        [viewDownload reloadViewWithFriendList:possibleFriends];
    }
}


- (void)registerReturn:(NSString*)msg withSuccess:(BOOL)success{
    if (viewSingUp) {
        [viewSingUp registerReturn:msg withSuccess:success];
    }
}

- (void)loginReturn:(NSString*)msg withSuccess:(BOOL)success{
    if (viewSingUp) {
        [viewSingUp loginReturn:msg withSuccess:success];
    }
}

- (void)logoutReturn:(BOOL)success{
    
}

@end
