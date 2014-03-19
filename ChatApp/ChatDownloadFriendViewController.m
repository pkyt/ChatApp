//
//  ChatDownloadFriendViewController.m
//  ChatApp
//
//  Created by Pavlo Kytsmey on 3/13/14.
//  Copyright (c) 2014 Pavlo Kytsmey. All rights reserved.
//

#import "ChatDownloadFriendViewController.h"
#import "ChatAppDelegate.h"
#import "Connection.h"
#import "ChatDelegate.h"

@interface ChatDownloadFriendViewController ()
@property NSArray* connections;
@property NSMutableArray* connectionsAdded;
@property NSManagedObjectContext* context;
@end

@implementation ChatDownloadFriendViewController

- (void)reloadViewWithFriendList:(NSArray *)friendsNickNames withExistance:(NSMutableArray *)existance{
    _connections = friendsNickNames;
    _connectionsAdded = existance;
    [self.tableView reloadData];
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
    _connections = [NSArray new];
    _connectionsAdded = [NSMutableArray new];
    ChatAppDelegate* delegate = [[UIApplication sharedApplication] delegate];
    _context = [delegate managedObjectContext];
    [[ChatDelegate getChatDelegate] setViewDownload:self];
    [[ChatDelegate getChatDelegate] allFriends];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    return [_connections count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    }
    
   
    cell.textLabel.text = [_connections objectAtIndex:indexPath.row];
    if ([[NSNumber numberWithInt:1] isEqualToNumber:[_connectionsAdded objectAtIndex:indexPath.row]]) {
        cell.detailTextLabel.text = @"added";
    }else{
        cell.detailTextLabel.text = @"add";
    }
    
    // Configure the cell...
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([[NSNumber numberWithInt:0] isEqualToNumber:[_connectionsAdded objectAtIndex:indexPath.row]]) {
        Connection* newFriend = [NSEntityDescription
                                 insertNewObjectForEntityForName:@"Connection"
                                 inManagedObjectContext:self.context];
        [newFriend setNickName:[self.connections objectAtIndex:indexPath.row]];
        NSError* error;
        if (![self.context save:&error]){
            NSLog(@"ERROR: failed adding to DB");
        }
        [self.connectionsAdded replaceObjectAtIndex:indexPath.row withObject:[NSNumber numberWithInt:1]];
        [tableView reloadData];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */

@end
