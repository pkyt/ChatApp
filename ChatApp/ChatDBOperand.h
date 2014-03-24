//
//  ChatDBOperand.h
//  ChatApp
//
//  Created by Pavlo Kytsmey on 3/21/14.
//  Copyright (c) 2014 Pavlo Kytsmey. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ChatDBOperand : NSObject
+ (ChatDBOperand*)getDBOperand;
- (void)existanceOfFriend:(NSString*)nickName;
- (void)sendMessageTo:(NSString*)frdNickName withMessage:(NSString*)msg;
- (void)allFriends;
- (void)registerMe:(NSString*)nickname withPassword:(NSString*)pass;
- (void)logout:(NSString*)nickname;
- (void)login:(NSString*)nickname withPassword:(NSString*)pass;

- (BOOL)addConnectionWithOfUser:(NSString*)username withFriend:(NSString*)frdnickname;
- (NSMutableArray*)getExistsFriends:(NSArray*)listOfAllPossibleFriends;
- (void)AddMessageEvenIfUserDoesntExists:(NSString*)username withFriend:(NSString*)frdnickname withMessage:(NSString*)msg;
- (NSArray*)getFriends;

@end
