//
//  ChatMessViewController.m
//  ChatApp
//
//  Created by Pavlo Kytsmey on 3/17/14.
//  Copyright (c) 2014 Pavlo Kytsmey. All rights reserved.
//

#import "ChatMessViewController.h"
#import "Message.h"
#import "ChatAppDelegate.h"
#import "ChatDelegate.h"

@interface ChatMessViewController ()

@property NSArray* messages;
@property NSManagedObjectContext * context;
@property NSString* friendsNickName;

@end

@implementation ChatMessViewController

#define dateMess 15

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)setFriend:(NSString *)messFriend{
    if (messFriend != nil) {
        _friendsNickName = messFriend;
    }
    self.navigationItem.title = self.friendsNickName;
    [self fillMessagesFromDBWithConnection:self.friendsNickName];
    [self.tableView reloadData];
    if ([self.messages count] != 0) {
        NSIndexPath* ipath = [NSIndexPath indexPathForRow:[self.messages count]-1 inSection:0];
        
        [self.tableView scrollToRowAtIndexPath: ipath atScrollPosition: UITableViewScrollPositionTop animated: YES];
    }
}

- (void)fillMessagesFromDBWithConnection:(NSString*)friendNickName{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"Connection" inManagedObjectContext:self.context];
    [fetchRequest setEntity:entity];
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"nickName == %@", friendNickName];
    [fetchRequest setPredicate:predicate];
    [fetchRequest setPredicate:predicate];
    NSError *error;
    NSArray* friendConnect = [self.context executeFetchRequest:fetchRequest error:&error];
    Connection* friendConnection = [friendConnect objectAtIndex:0];
    NSSortDescriptor *sortNameDescriptor = [[NSSortDescriptor alloc] initWithKey:@"messID" ascending:YES];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortNameDescriptor, nil];
    
    _messages = [friendConnection.mess sortedArrayUsingDescriptors:sortDescriptors];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    ChatAppDelegate* delegate = [[UIApplication sharedApplication] delegate];
    _context = [delegate managedObjectContext];
    _messages = [NSArray new];

    [[ChatDelegate getChatDelegate] setViewMessage:self];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(startedTyping:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(endedTyping:) name:UIKeyboardWillHideNotification object:nil];
    
	// Do any additional setup after loading the view.
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)sendMessage:(NSNotification*)sender {
    if (![self.messgeField.text isEqualToString:@""]) {
        [[ChatDelegate getChatDelegate] sendMessageTo:self.friendsNickName withMessage:self.messgeField.text];
        self.messgeField.text = @"";
    }
}

- (IBAction)startedTyping:(NSNotification*)sender{
    NSLog(@"startedTypeing");
    NSNotification* keyboard = sender;
    NSDictionary* info = [keyboard userInfo];
    CGRect keyboardSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    NSValue* value = [info objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval duration = 0;
    [value getValue:&duration];
    [UIView animateWithDuration:duration animations:^(void){
        CGRect frame = self.viewMessage.frame;
        frame.size.height -= keyboardSize.size.height;
        self.viewMessage.frame = frame;
    }];
    if ([self.messages count] != 0) {
        NSIndexPath* ipath = [NSIndexPath indexPathForRow:[self.messages count]-1 inSection:0];
        
        [self.tableView scrollToRowAtIndexPath: ipath atScrollPosition: UITableViewScrollPositionTop animated: YES];
    }
}

- (IBAction)endedTyping:(NSNotification*)sender{
    NSLog(@"typing ended");
    NSNotification* keyboard = sender;
    NSDictionary* info = [keyboard userInfo];
    CGRect keyboardSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    NSValue* value = [info objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval duration = 0;
    [value getValue:&duration];
    [UIView animateWithDuration:duration animations:^(void){
        CGRect frame = self.viewMessage.frame;
        frame.size.height += keyboardSize.size.height;
        self.viewMessage.frame = frame;
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.messages count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    UIImageView *balloonView;
    UILabel *label;
    UILabel *dateLabel;
    UITableViewCell *cell;
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        balloonView = [[UIImageView alloc] initWithFrame:CGRectZero];
        balloonView.tag = 1;
        
        label = [[UILabel alloc] initWithFrame:CGRectZero];
        label.backgroundColor = [UIColor clearColor];
        label.tag = 2;
        label.numberOfLines = 0;
        label.lineBreakMode = NSLineBreakByWordWrapping;
        label.font = [UIFont systemFontOfSize:14.0];
        
        UIView *message = [[UIView alloc] initWithFrame:CGRectMake(0.0, dateMess, cell.frame.size.width, cell.frame.size.height)];
        message.tag = 0;
        [message addSubview:balloonView];
        [message addSubview:label];
        [cell.contentView addSubview:message];
        dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(5.0, 0.0, cell.frame.size.width - 10, dateMess)];
        UIFontDescriptor *descriptor = [UIFontDescriptor preferredFontDescriptorWithTextStyle:UIFontTextStyleHeadline];
        [dateLabel setFont:[UIFont fontWithDescriptor:descriptor size:10]];
        [cell.contentView addSubview:dateLabel];
        
    }
    else
    {
        balloonView = (UIImageView *)[[cell.contentView viewWithTag:0] viewWithTag:1];
        label = (UILabel *)[[cell.contentView viewWithTag:0] viewWithTag:2];
    }
    
    Message* thisMsg = [self.messages objectAtIndex:indexPath.row];
    
    [thisMsg setSeen:[NSNumber numberWithInt:1]];
    
    NSString *text = thisMsg.text;
    NSError*error;
    if (![self.context save:&error]){
        NSLog(@"ERROR: failed adding to DB");
    }
    
    CGSize size = [text sizeWithFont:[UIFont systemFontOfSize:14.0] constrainedToSize:CGSizeMake(240.0f, 480.0f) lineBreakMode:NSLineBreakByWordWrapping];
    
    UIImage *balloon;
    
    if (thisMsg.ownMess) {
        balloonView.frame = CGRectMake(cell.contentView.bounds.size.width - 48.0 - size.width, 2.0, size.width + 28, size.height+10);
        balloon = [[UIImage imageNamed:@"iphone-sms-3"] stretchableImageWithLeftCapWidth:25 topCapHeight:14];
        label.frame = CGRectMake(cell.contentView.bounds.size.width - 35.0 - size.width, 8, size.width + 5, size.height);
        [dateLabel setTextAlignment:NSTextAlignmentRight];
    }else{
        balloonView.frame = CGRectMake(15.0, 2.0, size.width + 28, size.height+10);
        balloon = [[UIImage imageNamed:@"iphone-sms-4"] stretchableImageWithLeftCapWidth:25 topCapHeight:14];
        label.frame = CGRectMake(36, 8, size.width + 5, size.height);
        [dateLabel setTextAlignment:NSTextAlignmentLeft];
    }
    
    balloonView.image = balloon;
    label.text = text;
    NSString * date = [NSString stringWithFormat:@"%@", thisMsg.messDate];
    dateLabel.text = [date substringToIndex:[date length]-5];
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    Message* thisMsg = [self.messages objectAtIndex:indexPath.row];
    NSString *body = thisMsg.text;
    CGSize size = [body sizeWithFont:[UIFont systemFontOfSize:14.0] constrainedToSize:CGSizeMake(240.0, 480.0) lineBreakMode:NSLineBreakByWordWrapping];
    return size.height + 15 + dateMess;
}


@end
