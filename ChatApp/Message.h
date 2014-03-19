//
//  Message.h
//  ChatApp
//
//  Created by Pavlo Kytsmey on 3/19/14.
//  Copyright (c) 2014 Pavlo Kytsmey. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Connection;

@interface Message : NSManagedObject

@property (nonatomic, retain) NSDate * messDate;
@property (nonatomic, retain) NSNumber * messID;
@property (nonatomic, retain) NSNumber * ownMess;
@property (nonatomic, retain) NSString * text;
@property (nonatomic, retain) NSNumber * seen;
@property (nonatomic, retain) Connection *fromWhom;

@end
