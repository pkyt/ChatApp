//
//  Connection.h
//  ChatApp
//
//  Created by Pavlo Kytsmey on 3/21/14.
//  Copyright (c) 2014 Pavlo Kytsmey. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Message;

@interface Connection : NSManagedObject

@property (nonatomic, retain) NSString * nickName;
@property (nonatomic, retain) NSString * myNickName;
@property (nonatomic, retain) NSSet *mess;
@end

@interface Connection (CoreDataGeneratedAccessors)

- (void)addMessObject:(Message *)value;
- (void)removeMessObject:(Message *)value;
- (void)addMess:(NSSet *)values;
- (void)removeMess:(NSSet *)values;

@end
