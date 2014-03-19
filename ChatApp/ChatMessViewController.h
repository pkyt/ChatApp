//
//  ChatMessViewController.h
//  ChatApp
//
//  Created by Pavlo Kytsmey on 3/17/14.
//  Copyright (c) 2014 Pavlo Kytsmey. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Connection.h"

@interface ChatMessViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UIView *viewMessage;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *sendButton;
@property (weak, nonatomic) IBOutlet UITextField *messgeField;
- (IBAction)sendMessage:(id)sender;
- (IBAction)startedTyping:(NSNotification*)sender;
- (IBAction)endedTyping:(NSNotification*)sender;
- (void)setFriend:(NSString*)messFriend;
@end
