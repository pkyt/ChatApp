//
//  ChatDBOperand.m
//  ChatApp
//
//  Created by Pavlo Kytsmey on 3/21/14.
//  Copyright (c) 2014 Pavlo Kytsmey. All rights reserved.
//

#import "ChatDBOperand.h"
#import "ChatAppDelegate.h"
#import "ChatDelegate.h"
#import "ChatClient.h"

@implementation ChatDBOperand
static ChatDBOperand * me;
+ (ChatDBOperand*)getDBOperand{
    if (!me) {
        me = [ChatDBOperand new];
    }
    return me;
}

- (void)allFriends{
    [[ChatClient getChatClient]  getAllPossibleFriends];
}

- (void)logout:(NSString *)nickname{
    NSLog(@"asdfadsfsd: %@", nickname);
    [[ChatClient getChatClient] logout:nickname];
}

- (void)login:(NSString*)nickname withPassword:(NSString*)pass{
    [[ChatClient getChatClient] login:nickname withPassword:pass];
}

- (void)registerMe:(NSString*)nickname withPassword:(NSString*)pass{
    [[ChatClient getChatClient]  registerWithNickName:nickname withPassword:pass];
}

- (void)existanceOfFriend:(NSString*)nickName{
    // [requstedExistance addObject:nickName];
    [[ChatClient getChatClient] doesFriendExistWithNickName:nickName];
}

- (void)sendMessageTo:(NSString*)frdNickName withMessage:(NSString*)msg{
    ChatAppDelegate* delegate = [[UIApplication sharedApplication] delegate];
    if (![@"" isEqualToString:delegate.currLoged]) {
        
        ChatAppDelegate* delegate = [[UIApplication sharedApplication] delegate];
        NSManagedObjectContext * context = [delegate managedObjectContext];
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
        [[ChatClient getChatClient] sendMessageTo:frdNickName message:msg fromNickName:delegate.currLoged];
    }
}

- (BOOL)checkIfFriendAlreadyExist:(NSString *)friendNickName{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    ChatAppDelegate* delegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext * context = delegate.managedObjectContext;
    if (![delegate.currLoged isEqualToString:@""]) {
        NSEntityDescription *entity = [NSEntityDescription
                                       entityForName:@"Connection" inManagedObjectContext:context];
        [fetchRequest setEntity:entity];
        NSPredicate* predicate = [NSPredicate predicateWithFormat:@"(nickName == %@) AND (myNickName == %@)", friendNickName, delegate.currLoged];
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

- (BOOL)addConnectionWithOfUser:(NSString*)username withFriend:(NSString*)frdnickname{
    ChatAppDelegate* delegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext * context = delegate.managedObjectContext;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"Connection" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    NSString * nickNameLastRequested = frdnickname;
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"(nickName == %@) AND (myNickName == %@)", nickNameLastRequested, username];
    [fetchRequest setPredicate:predicate];
    NSError *error;
    NSArray* existSameNickName = [context executeFetchRequest:fetchRequest error:&error];
    
    if ((existSameNickName) && ([existSameNickName count] == 0)) {
        if (![username isEqualToString:@""]) {
            Connection* newFriend = [NSEntityDescription
                                     insertNewObjectForEntityForName:@"Connection"
                                     inManagedObjectContext:context];
            [newFriend setNickName:nickNameLastRequested];
            [newFriend setMyNickName:username];
            if (![context save:&error]) {
                return FALSE;
            }else{
                return TRUE;
            }
        }
        
    }else{
        return FALSE;
    }
    return FALSE;
}

- (NSArray*)getFriends{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    ChatAppDelegate* delegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext * context = delegate.managedObjectContext;
    NSString* currLog = delegate.currLoged;
    if ([currLog isEqualToString:@""]) {
        return [NSArray new];
    }else{
        NSEntityDescription *entity = [NSEntityDescription
                                       entityForName:@"Connection" inManagedObjectContext:context];
        NSPredicate* predicate = [NSPredicate predicateWithFormat:@"myNickName == %@", currLog];
        [fetchRequest setEntity:entity];
        [fetchRequest setPredicate:predicate];
        NSError *error;
        return [context executeFetchRequest:fetchRequest error:&error];
    }
}

- (void)AddMessageEvenIfUserDoesntExists:(NSString*)username withFriend:(NSString*)frdnickname withMessage:(NSString*)msg{
    ChatAppDelegate* delegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext * context = delegate.managedObjectContext;
    if (![@"" isEqualToString:username]) {
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        NSEntityDescription *entity = [NSEntityDescription
                                       entityForName:@"Connection" inManagedObjectContext:context];
        [fetchRequest setEntity:entity];
        NSPredicate* predicate = [NSPredicate predicateWithFormat:@"(nickName == %@) AND (myNickName == %@)", frdnickname, username];
        [fetchRequest setPredicate:predicate];
        NSError *error;
        NSArray* existSameNickName = [context executeFetchRequest:fetchRequest error:&error];
        BOOL existsFriend = ((existSameNickName) && ([existSameNickName count] == 0));
        Connection * friend;
        if (existsFriend) {
            Connection* newFriend = [NSEntityDescription insertNewObjectForEntityForName:@"Connection"
                                                                  inManagedObjectContext:context];
            [newFriend setNickName:frdnickname];
            [newFriend setMyNickName:username];
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
        [newMessage setOwnMess:[NSNumber numberWithInt:1]];
        [newMessage setText:msg];
        [newMessage setSeen:FALSE];
        [newMessage setFromWhom:friend];
        [newMessage setMessDate:[NSDate date]];
        [newMessage setMessID:[NSNumber numberWithLong:[friend.mess count]]];
        if (![context save:&error]){
            NSLog(@"ERROR: failed adding to DB");
        }
    }
}


@end
