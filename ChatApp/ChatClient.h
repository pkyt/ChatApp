//
//  ChatServer.h
//  ChatServer
//
//  Created by Pavlo Kytsmey on 3/14/14.
//  Copyright (c) 2014 Pavlo Kytsmey. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ChatClient : NSObject <NSStreamDelegate>

@property NSInputStream *inputStream;
@property NSOutputStream *outputStream;
- (void)registerWithNickName:(NSString *)nn withPassword:(NSString*)pass;
- (void)doesFriendExistWithNickName:(NSString *)nickName;
- (void)sendMessageTo:(NSString*)nickName message:(NSString*)msg fromNickName:(NSString*)username;
- (void)getAllPossibleFriends;
- (void)setReturnClass:(id)theClass;
- (void)login:(NSString*)nickname withPassword:(NSString*)pass;
- (void)logout:(NSString*)nickname;
- (void)initNetworkCommunication;
@end
