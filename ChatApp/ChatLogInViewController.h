//
//  ChatLogInViewController.h
//  ChatApp
//
//  Created by Pavlo Kytsmey on 3/20/14.
//  Copyright (c) 2014 Pavlo Kytsmey. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChatLogInViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *logedInUserName;
@property (weak, nonatomic) IBOutlet UITextField *usernameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UILabel *info;
- (IBAction)logIn:(id)sender;
- (IBAction)registerMe:(id)sender;
- (IBAction)logout:(id)sender;
- (void)registerReturn:(NSString*)msg withSuccess:(BOOL)success;
- (void)loginReturn:(NSString*)msg withSuccess:(BOOL)success;
- (void)logoutReturn:(BOOL)success;


@end
