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
        [[ChatDelegate getChatDelegate] existanceOfFriend:self.nickNameField.text];
    }
}

- (void) setResponce:(NSString*)exists{
    self.infoLabel.text = exists;
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
