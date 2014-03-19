//
//  ChatServer.h
//  ChatServer
//
//  Created by Pavlo Kytsmey on 3/14/14.
//  Copyright (c) 2014 Pavlo Kytsmey. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ChatServer : NSObject <NSStreamDelegate>

@property NSInputStream *inputStream;
@property NSOutputStream *outputStream;
- (void)connectWithNickName:(NSString *)nn;
- (void)doesFriendExistWithNickName:(NSString *)nickName;
- (void)sendMessageTo:(NSString*)nickName message:(NSString*)msg;
- (void)getAllPossibleFriends;
- (void)setReturnClass:(id)theClass;
@end
