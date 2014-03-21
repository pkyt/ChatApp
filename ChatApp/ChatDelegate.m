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

@implementation ChatDelegate
static ChatDelegate * me;
static ChatClient * server;
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
        server = [ChatClient new];
        [server initNetworkCommunication];
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
    [viewMessage setFriend:messFriend];
}

- (void)setViewMessage:(ChatMessViewController*)view{
    viewMessage = view;
    [viewMessage setFriend:messFriend];
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

- (void)existanceOfFriend:(NSString*)nickName{
    [requstedExistance addObject:nickName];
    [server doesFriendExistWithNickName:nickName];
}

- (void)sendMessageTo:(NSString*)frdNickName withMessage:(NSString*)msg{
    if (![@"" isEqualToString:currLogedIn]) {
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        NSEntityDescription *entity = [NSEntityDescription
                                       entityForName:@"Connection" inManagedObjectContext:context];
        [fetchRequest setEntity:entity];
        NSPredicate* predicate = [NSPredicate predicateWithFormat:@"nickName == %@", frdNickName];
        [fetchRequest setPredicate:predicate];
        NSError *error;
        NSArray* existSameNickName = [context executeFetchRequest:fetchRequest error:&error];
        BOOL existsFriend = ((existSameNickName) && ([existSameNickName count] == 0));
        Connection * friend;
        if (existsFriend) {
            Connection* newFriend = [NSEntityDescription insertNewObjectForEntityForName:@"Connection"
                                                                  inManagedObjectContext:context];
            [newFriend setNickName:frdNickName];
            if (![context save:&error]){
                NSLog(@"ERROR: failed adding to DB");
            }
            friend = newFriend;
        }else{
            friend = [existSameNickName objectAtIndex:0];
        }
        Message* newMessage = [NSEntityDescription
                               insertNewObjectForEntityForName:@"Message"
                               inManagedObjectContext:context];
        [newMessage setOwnMess:FALSE];
        [newMessage setText:msg];
        [newMessage setFromWhom:friend];
        [newMessage setMessDate:[NSDate date]];
        [newMessage setSeen:[NSNumber numberWithInt:1]];
        [newMessage setMessID:[NSNumber numberWithLong:[friend.mess count]]];
        if (![context save:&error]){
            NSLog(@"ERROR: failed adding to DB");
        }
        if (viewMessage) {
            [viewMessage setFriend:frdNickName];
        }
        [server sendMessageTo:frdNickName message:msg fromNickName:currLogedIn];
    }
}

- (void)allFriends{
    [server getAllPossibleFriends];
}

- (void)recievedExistanceOfFriend:(BOOL)exists{
    if (viewAddFriend) {
        if (!exists) {
            [viewAddFriend setResponce:@"User by this nickName doesn't exist"];
        }else{
            if (![currLogedIn isEqualToString:@""]) {
                NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
                NSEntityDescription *entity = [NSEntityDescription
                                               entityForName:@"Connection" inManagedObjectContext:context];
                [fetchRequest setEntity:entity];
                NSString * nickNameLastRequested = [requstedExistance objectAtIndex:0];
                [requstedExistance removeObjectAtIndex:0];
                NSPredicate* predicate = [NSPredicate predicateWithFormat:@"(nickName == %@) AND (myNickName == %@)", nickNameLastRequested, currLogedIn];
                [fetchRequest setPredicate:predicate];
                NSError *error;
                NSArray* existSameNickName = [context executeFetchRequest:fetchRequest error:&error];
                
                if ((existSameNickName) && ([existSameNickName count] == 0)) {
                    if (![currLogedIn isEqualToString:@""]) {
                        Connection* newFriend = [NSEntityDescription
                                                 insertNewObjectForEntityForName:@"Connection"
                                                 inManagedObjectContext:context];
                        [newFriend setNickName:nickNameLastRequested];
                        [newFriend setMyNickName:currLogedIn];
                        if (![context save:&error]) {
                            [viewAddFriend setResponce: @"ERROR: failed adding to database"];
                        }else{
                            [viewAddFriend setResponce: @"User was successfully added"];
                            if (viewFriendList) { // new friend was added, so it should appear in friend list
                                [viewFriendList reload];
                            }
                        }
                    }
                    
                }else{
                    [viewAddFriend setResponce: @"friend alredy exist"];
                }
            }else{
                [viewAddFriend setResponce: @"you have to log in first before adding a friend"];
            }
            
         }
    }
}

- (void)recievedMessageFrom:(NSString*)friendNickName withMessage:(NSString *)msg{
    
    if (![@"" isEqualToString:currLogedIn]) {
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        NSEntityDescription *entity = [NSEntityDescription
                                       entityForName:@"Connection" inManagedObjectContext:context];
        [fetchRequest setEntity:entity];
        NSPredicate* predicate = [NSPredicate predicateWithFormat:@"(nickName == %@) AND (myNickName == %@)", friendNickName, currLogedIn];
        [fetchRequest setPredicate:predicate];
        NSError *error;
        NSArray* existSameNickName = [context executeFetchRequest:fetchRequest error:&error];
        BOOL existsFriend = ((existSameNickName) && ([existSameNickName count] == 0));
        Connection * friend;
        if (existsFriend) {
            Connection* newFriend = [NSEntityDescription insertNewObjectForEntityForName:@"Connection"
                                                                  inManagedObjectContext:context];
            [newFriend setNickName:friendNickName];
            [newFriend setMyNickName:currLogedIn];
            if (![context save:&error]){
                NSLog(@"ERROR: failed adding to DB");
            }
            friend = newFriend;
            if (viewDownload) {
                NSMutableArray * existsFriend = [self getExistsFriends:possibleFriends];
                [viewDownload reloadViewWithFriendList:possibleFriends withExistance:existsFriend];
            }
        }else{
            friend = [existSameNickName objectAtIndex:0];
        }
        Message* newMessage = [NSEntityDescription
                               insertNewObjectForEntityForName:@"Message"
                               inManagedObjectContext:context];
        [newMessage setOwnMess:[NSNumber numberWithInt:1]];
        [newMessage setText:msg];
        [newMessage setSeen:FALSE];
        [newMessage setFromWhom:friend];
        [newMessage setMessDate:[NSDate date]];
        [newMessage setMessID:[NSNumber numberWithLong:[friend.mess count]]];
        if (![context save:&error]){
            NSLog(@"ERROR: failed adding to DB");
        }
        if (viewMessage) {
            [viewMessage setFriend:nil];
        }
        if (viewFriendList) {
            [viewFriendList reload];
        }
    }
}

- (BOOL)checkIfFriendAlreadyExist:(NSString *)friendNickName{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    if (![currLogedIn isEqualToString:@""]) {
        NSEntityDescription *entity = [NSEntityDescription
                                       entityForName:@"Connection" inManagedObjectContext:context];
        [fetchRequest setEntity:entity];
        NSPredicate* predicate = [NSPredicate predicateWithFormat:@"(nickName == %@) AND (myNickName == %@)", friendNickName, currLogedIn];
        [fetchRequest setPredicate:predicate];
        NSError *error;
        NSArray* existSameNickName = [context executeFetchRequest:fetchRequest error:&error];
        return ((existSameNickName) && ([existSameNickName count] > 0));
    }
    return FALSE;
}

- (NSMutableArray*)getExistsFriends:(NSArray*)listOfAllPossibleFriends{
    NSMutableArray * existsFriend = [NSMutableArray new];
    for (int i = 0; i < [listOfAllPossibleFriends count]; i++) {
        if ([self checkIfFriendAlreadyExist:[listOfAllPossibleFriends objectAtIndex:i]]) {
            [existsFriend addObject:[NSNumber numberWithInt:1]];
        }else{
            [existsFriend addObject:[NSNumber numberWithInt:0]];
        }
    }
    return existsFriend;
}

- (void)recievedListOfAllPossibleFriends:(NSArray*)listOfAllPossibleFriends{
    possibleFriends = listOfAllPossibleFriends;
    if (viewDownload) {
        NSMutableArray * existsFriend = [self getExistsFriends:possibleFriends];
        [viewDownload reloadViewWithFriendList:possibleFriends withExistance:existsFriend];
    }
}

- (void)registerMe:(NSString*)nickname withPassword:(NSString*)pass{
    [server registerWithNickName:nickname withPassword:pass];
}

- (void)logout:(NSString *)nickname{
    NSLog(@"asdfadsfsd: %@", nickname);
    [server logout:nickname];
}

- (void)login:(NSString*)nickname withPassword:(NSString*)pass{
    [server login:nickname withPassword:pass];
}

- (void)registerReturn:(NSString*)msg withSuccess:(BOOL)success{
    // add new user
    
    if (viewSingUp) {
        [viewSingUp registerReturn:msg withSuccess:success];
    }
}

- (void)loginReturn:(NSString*)msg withSuccess:(BOOL)success{
    // add new user if he doen't exist
    
    if (viewSingUp) {
        [viewSingUp loginReturn:msg withSuccess:success];
    }
}

- (void)logoutReturn:(BOOL)success{
    
}

@end
