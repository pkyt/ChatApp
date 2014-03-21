//
//  ChatLogInViewController.m
//  ChatApp
//
//  Created by Pavlo Kytsmey on 3/20/14.
//  Copyright (c) 2014 Pavlo Kytsmey. All rights reserved.
//

#import "ChatLogInViewController.h"
#import "ChatDelegate.h"

@interface ChatLogInViewController ()
@property NSString* requestedNickName;
@property int needsLogIn; // 0 - don't need log in or reg
                          // 1 - needs registering
                          // 2 - needs log in
@end

@implementation ChatLogInViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _needsLogIn = 0;
    [[ChatDelegate getChatDelegate] setViewSingUp:self];
    self.logedInUserName.text = [[ChatDelegate getChatDelegate] getCurrLog];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)logIn:(id)sender {
    NSLog(@"login");
    if ([self.usernameField.text isEqualToString:@""]) {
        self.info.text = @"username is nessesary for log in";
    }else if ([self.passwordField.text isEqualToString:@""]){
        self.info.text = @"password is nessesary for log in";
    }else{
        _requestedNickName = self.usernameField.text;
        if (![@"" isEqualToString:self.logedInUserName.text]){
            self.needsLogIn = 2;
            [self logout:nil];
        }else{
                    [[ChatDelegate getChatDelegate] login:self.usernameField.text withPassword:self.passwordField.text];
        }
    }
}

- (IBAction)registerMe:(id)sender {
    if ([self.usernameField.text isEqualToString:@""]) {
        self.info.text = @"username is nessesary for registration";
    }else if ([self.passwordField.text isEqualToString:@""]){
        self.info.text = @"password is nessesary for registration";
    }else{
        _requestedNickName = self.usernameField.text;
        if (![@"" isEqualToString:self.logedInUserName.text]){
            self.needsLogIn = 1;
            [self logout:nil];
            
        }else{
            [[ChatDelegate getChatDelegate] registerMe:self.usernameField.text withPassword:self.passwordField.text];
        }
    }
}


- (IBAction)logout:(id)sender {
    if (![@"" isEqualToString:self.logedInUserName.text]) {
        NSString*logOutNickName = self.logedInUserName.text;
        self.logedInUserName.text = @"";
        [[ChatDelegate getChatDelegate] setCurrLogedIn:self.logedInUserName.text];
        [[ChatDelegate getChatDelegate] logout:logOutNickName];
    }else{
        self.info.text = @"You're not loged into any username";
    }
}

- (void)registerReturn:(NSString*)msg withSuccess:(BOOL)success{
    self.info.text = msg;
    if (success) {
        self.logedInUserName.text = self.requestedNickName;
        [[ChatDelegate getChatDelegate] setCurrLogedIn:self.logedInUserName.text];
    }
}

- (void)loginReturn:(NSString*)msg withSuccess:(BOOL)success{
    self.info.text = msg;
    if (success) {
        self.logedInUserName.text = self.requestedNickName;
        [[ChatDelegate getChatDelegate] setCurrLogedIn:self.logedInUserName.text];
    }
}

- (void)logoutReturn:(BOOL)success{
    if (success) {
        self.info.text = @"you have been successfully loged out";
        if (self.needsLogIn == 1) {
            self.needsLogIn = 0;
            [self registerMe:nil];
        }else if (self.needsLogIn == 2){
            self.needsLogIn = 0;
            [self logIn:nil];
        }
    }
}


@end
