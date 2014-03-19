//
//  ChatMasterViewController.h
//  ChatApp
//
//  Created by Pavlo Kytsmey on 3/5/14.
//  Copyright (c) 2014 Pavlo Kytsmey. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChatAddFriendViewController.h"
#import "ChatFriendListViewController.h"
#import "Connection.h"
#import "Message.h"

@interface ChatMasterViewController : UITableViewController <NSStreamDelegate>

@property (nonatomic,strong) NSManagedObjectContext* managedObjectContext;

@end
