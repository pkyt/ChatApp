//
//  ChatServer.m
//  ChatServer
//
//  Created by Pavlo Kytsmey on 3/14/14.
//  Copyright (c) 2014 Pavlo Kytsmey. All rights reserved.
//

#import "ChatServer.h"
#import "ChatDelegate.h"

@interface ChatServer()

- (void)sendMessage:(NSString*)msg;
@property NSString* responce;
@property _Bool finishedResponce;
@property NSString*nickName;
@property (nonatomic)  id returnClass;

@end

@implementation ChatServer

@synthesize inputStream = _inputStream;
@synthesize outputStream = _outputStream;

- (void)sendMessage:(NSString *)msg{
    NSData *data = [[NSData alloc] initWithData:[msg dataUsingEncoding:NSASCIIStringEncoding]];
	[_outputStream write:[data bytes] maxLength:[data length]];
    NSLog(@"message sent: %@", msg);
}

- (void)doesFriendExistWithNickName:(NSString *)nickName{
    [self sendMessage:[NSString stringWithFormat:@"exs:%@", nickName]];
}

- (void) sendMessageTo:(NSString*)nickName message:(NSString*)msg{
    [self sendMessage:[NSString stringWithFormat:@"snd:%@\n%@\n%@", _nickName, nickName, msg]];
}

- (void) getAllPossibleFriends{
    [self sendMessage:@"frd:"];
}

- (void)login:(NSString*)nickname{
    [self sendMessage:[NSString stringWithFormat:@"was:%@", nickname]];
}

- (NSMutableArray*)convertStringToArray:(NSString*)string{
    NSMutableArray* connections = [NSMutableArray new];
    NSString* rest = string;
    unsigned long pos = [rest rangeOfString:@"\n"].location;
    NSString* next;
    BOOL first = TRUE;
    while ([rest length] > pos) {
        next = [rest substringToIndex:pos];
        rest = [rest substringFromIndex:pos+1];
        if (!first) {
            [connections addObject:next];

        }else{
            first = FALSE;
        }
        pos = [rest rangeOfString:@"\n"].location;
    }
    if (!first) {
        [connections addObject:rest];
    }
    return connections;
}

- (void)initNetworkCommunication {
    CFReadStreamRef readStream;
    CFWriteStreamRef writeStream;
    CFStreamCreatePairWithSocketToHost(NULL, (CFStringRef)@"localhost", 3490, &readStream, &writeStream);
    _inputStream = (__bridge NSInputStream *)readStream;
    _outputStream = (__bridge NSOutputStream *)writeStream;
    [_inputStream setDelegate:self];
    [_outputStream setDelegate:self];
    [_inputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    [_outputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    [_inputStream open];
    [_outputStream open];
    [self sendMessage:[NSString stringWithFormat:@"Iam:%@", self.nickName]];
}

- (void) hanndleResponse{
    NSLog(@"got here: %@", self.responce);
    _finishedResponce = TRUE;
    if ([self.responce length] > 4) {
        if ([self.responce isEqualToString:@"exs:true"]) {
            [[ChatDelegate getChatDelegate] recievedExistanceOfFriend:TRUE];
        }else if([self.responce isEqualToString:@"exs:false"]) {
            [[ChatDelegate getChatDelegate] recievedExistanceOfFriend:FALSE];
        }else if ([[self.responce substringToIndex:4] isEqualToString:@"snd:"]){
            long newLine = [self.responce rangeOfString:@"\n"].location;
            NSString* fromWhom = [[self.responce substringToIndex:newLine] substringFromIndex:4];
            NSString* msg = [self.responce substringFromIndex:newLine + 1];
            [[ChatDelegate getChatDelegate] recievedMessageFrom:fromWhom withMessage:msg];
        }else if ([[self.responce substringToIndex:4] isEqualToString:@"frd:"]){
            [[ChatDelegate getChatDelegate] recievedListOfAllPossibleFriends:[self convertStringToArray:self.responce]];
        }else if ([self.responce isEqualToString:@"iam:failed"]){
            [self login:@"pkyt"];
        }
    }
}


- (void)stream:(NSStream *)theStream handleEvent:(NSStreamEvent)streamEvent {
	switch (streamEvent) {
            
		case NSStreamEventOpenCompleted:
			NSLog(@"Stream opened");
			break;
            
		case NSStreamEventHasBytesAvailable:
            NSLog(@"StreamEventHasBytesAvailable");
            if (self.finishedResponce) {
                self.responce = @"";
            }
            if (theStream == _inputStream) {
                
                uint8_t buffer[1024];
                long int len;
                
                while ([_inputStream hasBytesAvailable]) {
                    len = [_inputStream read:buffer maxLength:sizeof(buffer)];
                    if (len > 0) {
                        
                        NSString *output = [[NSString alloc] initWithBytes:buffer length:len encoding:NSASCIIStringEncoding];
                        self.responce = [self.responce stringByAppendingString:output];
                    }
                }
            }
            [self hanndleResponse];
            break;
            
		case NSStreamEventErrorOccurred:
			NSLog(@"Can not connect to the host!");
			break;
            
		case NSStreamEventEndEncountered:
            NSLog(@"StreamEventEndEncountered");
			break;
            
		default:
			NSLog(@"Unknown event");
	}
}

- (void)setReturnClass:(id)theClass{
    self.returnClass = theClass;
}

- (void)connectWithNickName:(NSString *)nn{
    _nickName = nn;
    _finishedResponce = TRUE;
    [self initNetworkCommunication];
    NSLog(@"we are connecting");
}

@end
