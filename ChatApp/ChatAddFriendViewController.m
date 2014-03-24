//
//  ChatAddFriendViewController.m
//  ChatApp
//
//  Created by Pavlo Kytsmey on 3/11/14.
//  Copyright (c) 2014 Pavlo Kytsmey. All rights reserved.
//

#import "ChatAddFriendViewController.h"
#import "Connection.h"
#import "ChatAppDelegate.h"
#import "ChatDelegate.h"
#import "ChatDBOperand.h"


@interface ChatAddFriendViewController ()


@property (atomic, weak) ChatMasterViewController*master;
@property (nonatomic,strong) NSManagedObjectContext* managedObjectContext;
@property NSString* requestedNickName;

@end

@implementation ChatAddFriendViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
 
- (IBAction)AddToFriendList:(id)sender {
    if ([@"" isEqualToString:self.nickNameField.text]) {
        self.infoLabel.text = @"Nickname should contain at least one character";
    }else{
        _requestedNickName = self.nickNameField.text;
        [[ChatDBOperand getDBOperand] existanceOfFriend:self.nickNameField.text];
    }
}

- (void) setResponce:(BOOL)exists{
    if (!exists) {
        self.infoLabel.text = @"NickName doesn't exist";
    }else{
        ChatAppDelegate* delegate = [[UIApplication sharedApplication] delegate];
        if ([delegate.currLoged isEqualToString:@""]){
            self.infoLabel.text = @"Log in first";
        }else{
            if ([[ChatDBOperand getDBOperand] addConnectionWithOfUser:delegate.currLoged withFriend:self.requestedNickName]) {
                self.infoLabel.text = @"Friend was successfully added";
            }else{
                self.infoLabel.text = @"Friend already exists";
            }
        }
    }
}


- (void)viewDidLoad{
    [super viewDidLoad];
    ChatAppDelegate* delegate = [[UIApplication sharedApplication] delegate];
    _managedObjectContext = [delegate managedObjectContext];
    [[ChatDelegate getChatDelegate] setViewAddFriend:self];
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}

@end
