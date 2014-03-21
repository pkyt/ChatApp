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

- (void) sendMessageTo:(NSString*)nickName message:(NSString*)msg fromNickName:(NSString*)username{
    [self sendMessage:[NSString stringWithFormat:@"snd:%@\n%@\n%@", username, nickName, msg]];
}

- (void) getAllPossibleFriends{
    [self sendMessage:@"frd:"];
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
    _finishedResponce = TRUE;
}

#define COMMANDLENGTH 4

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
        }else if ([[self.responce substringToIndex:4] isEqualToString:@"lin:"]){
            NSString* rest = [self.responce substringFromIndex:4];
            if ([rest isEqualToString:@"success login"]) {
                [[ChatDelegate getChatDelegate] registerReturn:@"You've been successfully loged in" withSuccess:YES];
            }else{
                [[ChatDelegate getChatDelegate] registerReturn:rest withSuccess:NO];
            }
        }else if ([[self.responce substringToIndex:4] isEqualToString:@"reg:"]){
            NSString* rest = [self.responce substringFromIndex:4];
            if ([rest isEqualToString:@"success registation"]) {
                [[ChatDelegate getChatDelegate] registerReturn:@"You've been successfully registred" withSuccess:YES];
            }else{
                [[ChatDelegate getChatDelegate] registerReturn:rest withSuccess:NO];
            }
        }else if([self.responce isEqualToString:@"done"]) {
            [[ChatDelegate getChatDelegate] logoutReturn:YES];
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
                        if (output != NULL) {
                            self.responce = [self.responce stringByAppendingString:output];
                        }
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

- (void)registerWithNickName:(NSString *)nn withPassword:(NSString *)pass{
    NSLog(@"we are connecting");
    [self sendMessage:[NSString stringWithFormat:@"Iam:%@\n%@", nn, pass]];
}


- (void)login:(NSString*)nickname withPassword:(NSString *)pass{

    [self sendMessage:[NSString stringWithFormat:@"was:%@\n%@", nickname, pass]];
}

- (void)logout:(NSString*)nickname{
    NSLog(@"asdfadsfsd: %@", nickname);
    [self sendMessage:[NSString stringWithFormat:@"out:%@", nickname]];
}

@end
