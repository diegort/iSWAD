//
//  DBManager.m
//  iSWAD
//
//  Created by Diego Montesinos on 03/12/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "DBManager.h"
#import "notification.h"

@implementation DBManager

- (id) init{
    if(self = [super init])
    {
        app = [[UIApplication sharedApplication] delegate];
    
        context = [app managedObjectContext];        
    }
    return self;
}

-(NSArray *) getNotifications{
    NSError *error;
    NSFetchRequest *fetchRequest;
    fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription 
                                   entityForName:@"Notifications" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    //[fetchRequest setPredicate:predicate];
    NSSortDescriptor *sort = [[NSSortDescriptor alloc] 
                              initWithKey:@"eventTime" ascending:NO];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObject:sort]];
    
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    NSMutableArray *data = [[NSMutableArray alloc] init];
    notification *notif;
    for (NSManagedObject *info in fetchedObjects) {
        
        notif = [[notification alloc] init];
        notif.notificationCode = [(NSString *)[info valueForKey:@"notificationCode"] intValue];
        notif.eventType = [info valueForKey:@"eventType"];
        notif.eventTime = [(NSString *)[info valueForKey:@"eventTime"] longLongValue];
        notif.userNickname = [info valueForKey:@"userNickname"];
        notif.userSurname1 = [info valueForKey:@"userSurname1"];
        notif.userSurname2 = [info valueForKey:@"userSurname2"];
        notif.userFirstname = [info valueForKey:@"userFirstname"];
        notif.location = [info valueForKey:@"location"];
        notif.status = [(NSString *)[info valueForKey:@"status"] intValue];
        notif.summary = [info valueForKey:@"summary"];
        notif.content = [info valueForKey:@"content"];

        [data addObject:notif];
        [notif release];
    }  
    
    [fetchRequest release];
    
    NSArray *result = [[NSArray alloc] initWithArray:data];
    [data release];
    [result retain];
    return  result;
}

-(BOOL) saveNotifications:(NSArray *)notifcations{
    if (notifcations.count > 0){
        NSManagedObject *notif;
    
        for (notification *n in notifcations){
            notif = [NSEntityDescription insertNewObjectForEntityForName:@"Notifications" inManagedObjectContext:context];
            [notif setValue:[NSNumber numberWithInt:n.notificationCode] forKey:@"notificationCode"];
            [notif setValue:n.eventType forKey:@"eventType"];
            [notif setValue:[NSNumber numberWithLong:n.eventTime] forKey:@"eventTime"];
            [notif setValue:n.userNickname forKey:@"userNickname"];
            [notif setValue:n.userSurname1 forKey:@"userSurname1"];
            [notif setValue:n.userSurname2 forKey:@"userSurname2"];
            [notif setValue:n.userFirstname forKey:@"userFirstname"];
            [notif setValue:n.location forKey:@"location"];
            [notif setValue:[NSNumber numberWithInt:n.status] forKey:@"status"];
            [notif setValue:n.content forKey:@"content"];
            [notif setValue:n.summary forKey:@"summary"];
        }
        NSError *error;
        if (![context save:&error]) {
            NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
            return NO;
        }
    }
    return YES;
}

- (BOOL) markNotificationAsRead:(int)notCode{
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:@"Notifications" inManagedObjectContext:context]];
    [request setPredicate:[NSPredicate predicateWithFormat:@"notificationCode == %d", notCode]];
        
    NSError *error = nil;
    NSArray *objects = [context executeFetchRequest:request error:&error];
    NSAssert1(error == nil, @"Error fetching object: %@", [error localizedDescription]);
        
    id entity = [objects lastObject];

    NSInteger value = [[entity valueForKey:@"status"] integerValue];
    value += 4;
    [entity setValue:[NSNumber numberWithInteger:value] forKey:@"status"];
    if (![context save:&error]) {
        NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
        return NO;
    }
    return YES;
}

@end
