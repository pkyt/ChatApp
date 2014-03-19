//
//  ChatAppDelegate.h
//  ChatApp
//
//  Created by Pavlo Kytsmey on 3/5/14.
//  Copyright (c) 2014 Pavlo Kytsmey. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChatAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end
