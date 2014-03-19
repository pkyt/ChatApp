//
//  ChatAddFriendViewController.h
//  ChatApp
//
//  Created by Pavlo Kytsmey on 3/11/14.
//  Copyright (c) 2014 Pavlo Kytsmey. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ChatMasterViewController;

@interface ChatAddFriendViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *nickNameField;
@property (weak, nonatomic) IBOutlet UILabel *infoLabel;
- (IBAction)AddToFriendList:(id)sender;
- (void) setResponce:(NSString*)exists;
@end
