//
//  ChatFriendListViewController.m
//  ChatApp
//
//  Created by Pavlo Kytsmey on 3/11/14.
//  Copyright (c) 2014 Pavlo Kytsmey. All rights reserved.
//

#import "ChatFriendListViewController.h"
#import "ChatAppDelegate.h"
#import "Connection.h"
#import "ChatMasterViewController.h"
#import "ChatDelegate.h"

@interface ChatFriendListViewController ()

@property (nonatomic,strong) NSManagedObjectContext* managedObjectContext;
@property NSArray* listOfFriends;

@end

@implementation ChatFriendListViewController

- (void)reload{
    [self getFriends];
    [self.tableView reloadData];
}

- (void)getFriends{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    ChatAppDelegate* delegate = [[UIApplication sharedApplication] delegate];
    _managedObjectContext = delegate.managedObjectContext;
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"Connection" inManagedObjectContext:_managedObjectContext];
    [fetchRequest setEntity:entity];
    NSError *error;
    _listOfFriends = [_managedObjectContext executeFetchRequest:fetchRequest error:&error];
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[ChatDelegate getChatDelegate] setViewFriendList:self];
    [self getFriends];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    // Return the number of rows in the section.
    return [self.listOfFriends count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    }
    
    Connection* friend = [self.listOfFriends objectAtIndex:indexPath.row];
    cell.textLabel.text = friend.nickName;
    // Configure the cell...
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    Connection* friend = [self.listOfFriends objectAtIndex:indexPath.row];
    [[ChatDelegate getChatDelegate] setFriendToViewMessage:friend.nickName];
}


@end
