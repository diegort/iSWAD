//
//  DBManager.m
//  iSWAD
//
//  Created by Diego Montesinos on 03/12/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "DBManager.h"
#import "notification.h"
#import "question.h"
#import "tag.h"
#import "answer.h"
#import "questionTag.h"
#import "tag.h"

@implementation DBManager

- (id) init{
    if(self = [super init])
    {
        app = [[UIApplication sharedApplication] delegate];
    
        context = [app managedObjectContext];        
    }
    return self;
}

/***********************
 **** Notifications ****
 ***********************/

-(NSArray *) getNotifications{
    NSError *error = nil;
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
	//[fetchedObjects release];
    
    NSArray *result = [[NSArray alloc] initWithArray:data];
    [data release];
    //[result retain];
	[sort release];
	
	if (error!=nil)
		[error release];
    return  result;
}

-(BOOL) saveNotifications:(NSArray *)notifcations{
    if (notifcations.count > 0){
        NSManagedObject *notif;
		NSEntityDescription* entity = [NSEntityDescription entityForName:@"Notifications" inManagedObjectContext:context];
        NSError *error = nil;
        for (notification *n in notifcations){
			NSFetchRequest *request = [[NSFetchRequest alloc] init];
			[request setEntity:entity];
			[request setPredicate:[NSPredicate predicateWithFormat:@"notificationCode == %d", n.notificationCode]];

			NSArray *objects = [context executeFetchRequest:request error:&error];
			
			[request release];
			
			if ([objects count] == 0){
				notif = [NSEntityDescription insertNewObjectForEntityForName:@"Notifications" inManagedObjectContext:context];
				[notif setValue:[NSNumber numberWithInt:n.notificationCode] forKey:@"notificationCode"];
				
			}else{
				notif = [objects objectAtIndex:0];
			}
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
        if (![context save:&error]) {
            NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
            return NO;
        }
		
		if (error!=nil)
			[error release];
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
	
	
	[request release];
	
    if (![context save:&error]) {
        NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
        return NO;
    }
	if (error!=nil)
		[error release];
	//[objects release];
    return YES;
}

/************************
 ***** Tests Config *****
 ************************/

- (getTestConfigOutput *)getTestConfig:(int)courseCode{
	NSError *error = nil;
    NSFetchRequest *fetchRequest;
    fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription 
                                   entityForName:@"TestsConfig" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
	
	[fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"courseCode == %d", courseCode]];
    
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];

    getTestConfigOutput *config;
	NSManagedObject *info = [fetchedObjects lastObject];
	config = [[getTestConfigOutput alloc] init];
	
	config.pluggable = [(NSString *)[info valueForKey:@"pluggable"] intValue];
	config.numQuestions = [(NSString *)[info valueForKey:@"numQuestions"] intValue];
	config.minQuestions = [(NSString *)[info valueForKey:@"minQuestions"] intValue];
	config.defQuestions = [(NSString *)[info valueForKey:@"defQuestions"] intValue];
	config.maxQuestions = [(NSString *)[info valueForKey:@"maxQuestions"] intValue];
	config.feedback = [info valueForKey:@"feedback"];
    
    [fetchRequest release];
	//[fetchedObjects release];
	if (error!=nil)
		[error release];
    //[config retain];
    return  config;
}

- (BOOL)saveTestConfig:(getTestConfigOutput *)config courseCode:(int)courseCode{
	NSError *error = nil;
    NSFetchRequest *fetchRequest;
	NSManagedObject *tc;
    fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription 
                                   entityForName:@"TestsConfig" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
	
	[fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"courseCode == %d", courseCode]];
    
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];

	if ([fetchedObjects count] > 0){ //There is data for this course. Retrieve it.
        tc = [fetchedObjects lastObject];
    }
	else{ //There isn't data config for this course. Insert it.		
		tc = [NSEntityDescription insertNewObjectForEntityForName:@"TestsConfig" inManagedObjectContext:context];
        [tc setValue:[NSNumber numberWithInt:courseCode] forKey:@"courseCode"];        
	}
	
	[tc setValue:[NSNumber numberWithInt:config.pluggable] forKey:@"pluggable"];
	[tc setValue:[NSNumber numberWithInt:config.numQuestions] forKey:@"numQuestions"];
	[tc setValue:[NSNumber numberWithInt:config.minQuestions] forKey:@"minQuestions"];
	[tc setValue:[NSNumber numberWithInt:config.defQuestions] forKey:@"defQuestions"];
	[tc setValue:[NSNumber numberWithInt:config.maxQuestions] forKey:@"maxQuestions"];
	[tc setValue:[NSNumber numberWithInt:0] forKey:@"beginTime"];
	[tc setValue:config.feedback forKey:@"feedback"];
	
	[fetchRequest release];
	if (![context save:&error]) {
		NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
		return NO;
	}
	if (error!=nil)
		[error release];
	//[fetchedObjects release];
    return YES;
}

- (long) getLastTestDownload: (int) courseCode{
	NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:@"TestsConfig" inManagedObjectContext:context]];
    [request setPredicate:[NSPredicate predicateWithFormat:@"courseCode == %d", courseCode]];
	
    NSError *error = nil;
    NSArray *objects = [context executeFetchRequest:request error:&error];
    NSAssert1(error == nil, @"Error fetching object: %@", [error localizedDescription]);
	
    NSManagedObject* entity = [objects lastObject];
	
    long time = 0;
	
	time = [(NSString *)[entity valueForKey:@"beginTime"] intValue];
	[request release];
	//[entity release];
	if (error!=nil)
		[error release];
	//[objects release];
    return time;
}

- (BOOL) setLastTestDownload: (int) courseCode time: (long)beginTime{
	NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:@"TestsConfig" inManagedObjectContext:context]];
    [request setPredicate:[NSPredicate predicateWithFormat:@"courseCode == %d", courseCode]];
	
    NSError *error = nil;
    NSArray *objects = [context executeFetchRequest:request error:&error];
    NSAssert1(error == nil, @"Error fetching object: %@", [error localizedDescription]);
	
    id entity = [objects lastObject];
	
    [entity setValue:[NSNumber numberWithLong:beginTime] forKey:@"beginTime"];
	[request release];
    if (![context save:&error]) {
        NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
        return NO;
    }
	
	if (error!=nil)
		[error release];
	//[objects release];
    return YES;
}

- (BOOL) saveQuestions:(questionsArray *) questions courseCode:(int)courseCode{
	NSError *error = nil;
    NSFetchRequest *fetchRequest, *tagsRequest, *answersRequest;
	NSArray *fetchedObjects, *fetchedAnswers, *fetchedTags;
	NSEntityDescription *entity = [NSEntityDescription entityForName:@"Questions" inManagedObjectContext:context];
	NSManagedObject *tmp;
	
	if (questions.count > 0){
		for (question* q in questions){
			fetchRequest = [[NSFetchRequest alloc] init];
			
			[fetchRequest setEntity:entity];
			
			[fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"questionCode == %d", q.questionCode]];
			
			fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
			
			if ([fetchedObjects count] > 0){ //There is data for this course. Retrieve it.
				tmp = (NSManagedObject *)[fetchedObjects lastObject];				
			}
			else{ //There isn't data config for this course. Insert it.			
				tmp = [NSEntityDescription insertNewObjectForEntityForName:@"Questions" inManagedObjectContext:context];
				[tmp setValue:[NSNumber numberWithInt:courseCode] forKey:@"courseCode"];
				[tmp setValue:[NSNumber numberWithInt:q.questionCode] forKey:@"questionCode"];
			}		
			
			[tmp setValue:[NSNumber numberWithInt:q.shuffle] forKey:@"shuffle"];
			[tmp setValue:q.stem forKey:@"stem"];
			[tmp setValue:q.answerType forKey:@"answerType"];
			
			//Delete any tag and answer of this question
			answersRequest = [[NSFetchRequest alloc] init];
			[answersRequest setEntity:[NSEntityDescription entityForName:@"Answers" inManagedObjectContext:context]];
			[answersRequest setPredicate:[NSPredicate predicateWithFormat:@"questionCode == %d", q.questionCode]];
			
			fetchedAnswers = [context executeFetchRequest:answersRequest error:&error];
			for (NSManagedObject *ans in fetchedAnswers) {
				[context deleteObject:ans];
			}
			
			tagsRequest = [[NSFetchRequest alloc] init];
			[tagsRequest setEntity:[NSEntityDescription entityForName:@"QuestionTags" inManagedObjectContext:context]];
			[tagsRequest setPredicate:[NSPredicate predicateWithFormat:@"questionCode == %d", q.questionCode]];
			
			fetchedTags = [context executeFetchRequest:tagsRequest error:&error];
			for (NSManagedObject *ans in fetchedTags) {
				[context deleteObject:ans];
			}
			
			[answersRequest release];
			//[fetchedAnswers release];
			
			[tagsRequest release];
			//[fetchedTags release];
			
			[fetchRequest release];
			//[fetchedObjects release];
		}
	}
	if (![context save:&error]) {
		NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
		return NO;
	}
	if (error!=nil)
		[error release];
    return YES;
}

- (BOOL) saveTags:(tagsArray *) tags courseCode:(int)courseCode{
	NSError *error = nil;
    NSFetchRequest *fetchRequest;
	NSArray *fetchedObjects;
	NSEntityDescription *entity = [NSEntityDescription entityForName:@"Tags" inManagedObjectContext:context];
	NSManagedObject *tmp;
	
	if (tags.count > 0){
		for (tag* t in tags){
			fetchRequest = [[NSFetchRequest alloc] init];
			
			[fetchRequest setEntity:entity];
			
			[fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"tagCode == %d", t.tagCode]];
			
			fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
			
			if ([fetchedObjects count] > 0){ //There is data for this course. Retrieve it.
				tmp = (NSManagedObject *)[fetchedObjects lastObject];				
			}
			else{ //There isn't data config for this course. Insert it.			
				tmp = [NSEntityDescription insertNewObjectForEntityForName:@"Tags" inManagedObjectContext:context];
				[tmp setValue:[NSNumber numberWithInt:courseCode] forKey:@"courseCode"];
				[tmp setValue:[NSNumber numberWithInt:t.tagCode] forKey:@"tagCode"];
			}
			
			[tmp setValue:t.tagText forKey:@"tagText"];
			
			[fetchRequest release];
			//[fetchedObjects release];
		}
	}
	if (![context save:&error]) {
		NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
		return NO;
	}
	if (error!=nil)
		[error release];
    return YES;
}

- (BOOL) saveAnswers:(answersArray *) answers{
	NSError *error = nil;
    NSFetchRequest *fetchRequest;
	NSArray *fetchedObjects;
	NSEntityDescription *entity = [NSEntityDescription entityForName:@"Answers" inManagedObjectContext:context];
	NSManagedObject *tmp;
	
	if (answers.count > 0){
		for (answer* a in answers){
			fetchRequest = [[NSFetchRequest alloc] init];
			
			[fetchRequest setEntity:entity];
			
			[fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"(answerIndex == %d) AND (questionCode == %d)", a.answerIndex, a.questionCode]];
			
			fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
			
			if ([fetchedObjects count] > 0){ //There is data for this course. Retrieve it.
				tmp = (NSManagedObject *)[fetchedObjects lastObject];				
			}
			else{ //There isn't data config for this course. Insert it.			
				tmp = [NSEntityDescription insertNewObjectForEntityForName:@"Answers" inManagedObjectContext:context];
				[tmp setValue:[NSNumber numberWithInt:a.questionCode] forKey:@"questionCode"];
				[tmp setValue:[NSNumber numberWithInt:a.answerIndex] forKey:@"answerIndex"];
			}
			
			[tmp setValue:a.answerText forKey:@"answerText"];
			[tmp setValue:[NSNumber numberWithInt:a.correct] forKey:@"correct"];
			
			[fetchRequest release];
			//[fetchedObjects release];
		}
	}
	if (![context save:&error]) {
		NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
		return NO;
	}
	if (error!=nil)
		[error release];
    return YES;
}

- (BOOL) saveQuestionTags:(questionTagsArray *) qts{
	NSError *error = nil;
    NSFetchRequest *fetchRequest;
	NSArray *fetchedObjects;
	NSEntityDescription *entity = [NSEntityDescription entityForName:@"QuestionTags" inManagedObjectContext:context];
	NSManagedObject *tmp;
	
	if (qts.count > 0){
		for (questionTag* qt in qts){
			fetchRequest = [[NSFetchRequest alloc] init];
			
			[fetchRequest setEntity:entity];
			
			[fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"(tagCode == %d) AND (questionCode == %d)", qt.tagCode, qt.questionCode]];
			
			fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
			
			if ([fetchedObjects count] > 0){ //There is data for this course. Retrieve it.
				tmp = (NSManagedObject *)[fetchedObjects lastObject];				
			}
			else{ //There isn't data config for this course. Insert it.			
				tmp = [NSEntityDescription insertNewObjectForEntityForName:@"QuestionTags" inManagedObjectContext:context];
				[tmp setValue:[NSNumber numberWithInt:qt.questionCode] forKey:@"questionCode"];
				[tmp setValue:[NSNumber numberWithInt:qt.tagCode] forKey:@"tagCode"];
			}
			
			[tmp setValue:[NSNumber numberWithInt:qt.tagIndex] forKey:@"tagIndex"];
			
			[fetchRequest release];
		}
	}
	if (![context save:&error]) {
		NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
		return NO;
	}
	if (error!=nil)
		[error release];
    return YES;
}

- (BOOL) saveTest:(getTestOutput *)test courseCode:(int)courseCode{
	BOOL result=YES;
	
	result &= [self saveQuestions:test.questions courseCode:courseCode];
	
	if (result)
		result &= [self saveTags:test.tags courseCode:courseCode];
	
	if (result)
		result &= [self saveAnswers:test.answers];
	
	if (result)
		result &= [self saveQuestionTags:test.questionTags];
	
	return result;
}

- (tagsArray*) courseTags:(int)courseCode{
	NSError *error = nil;
    NSFetchRequest *fetchRequest;
    fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"Tags" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"courseCode == %d", courseCode]];
    
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    NSMutableArray *data = [[NSMutableArray alloc] init];
    tag *t;
    for (NSManagedObject *info in fetchedObjects) {
        
        t = [[tag alloc] init];
		t.tagCode = [(NSString *)[info valueForKey:@"tagCode"] intValue];
		t.tagText = [info valueForKey:@"tagText"];
		
        [data addObject:t];
        [t release];
    }
    
    [fetchRequest release];
	//[fetchedObjects release];
    
    NSArray *result = [[NSArray alloc] initWithArray:data];
    [data release];
    //[result retain];
	//[sort release];
	
	if (error!=nil)
		[error release];
	
    return  (tagsArray*)result;
}

@end
