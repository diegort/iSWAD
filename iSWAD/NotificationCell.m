//
//  NotificationCell.m
//  iSWAD
//
//  Created by Diego Montesinos on 02/12/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "NotificationCell.h"
#import "DBManager.h"

@implementation NotificationCell

@synthesize typeImage;
@synthesize actionImage;
@synthesize titleLabel;
@synthesize detailText;
@synthesize gradeLabel;
@synthesize subjectLabel;
@synthesize dateLabel;
@synthesize senderLabel;

-(NSString *) formatText:(NSString *) text{
    NSString * tmp;
    tmp = [text stringByReplacingOccurrencesOfString:@"<br/>" withString:@"\n"];
    tmp = [tmp stringByReplacingOccurrencesOfString:@"<br />" withString:@"\n"];
    return tmp;
}



- (void) setData:(notification *)notif selected:(BOOL) sel{
    data = notif;
    
    titleLabel.text = NSLocalizedString(notif.eventType, nil);
    if((notif.status & 0b100) == 0){
        titleLabel.font = [UIFont boldSystemFontOfSize:18];
    } else {
        titleLabel.font = [UIFont systemFontOfSize:18];
    }
    
    //[detailText loadHTMLString:[self cleanNotificationContent:notif.content] baseURL:nil];
    /*detailText.text = [self formatText:[self cleanNotificationContent:notif.content]];
    detailText.hidden = !sel | ([notif.eventType isEqualToString:@"marksFile"]);*/
    detailText.hidden = true;
    gradeLabel.text = data.location;
    
    subjectLabel.text = data.summary;
    
    NSString *sender = @"";
    
    sender = [[[sender stringByAppendingString:data.userFirstname] stringByAppendingString:@" "] stringByAppendingString:data.userSurname1];
    
    if (data.userSurname2 != nil) {
        sender = [[sender stringByAppendingString:@" "] stringByAppendingString:data.userSurname2];
    }
    
    senderLabel.text = sender;
    [senderLabel sizeToFit];
    senderLabel.frame = CGRectMake(2, 90, 78, senderLabel.frame.size.height);
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:notif.eventTime];
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"dd-MM-yyyy"];
    
    NSDateFormatter *timeFormat = [[NSDateFormatter alloc] init];
    [timeFormat setDateFormat:@"HH:mm:ss"];
    
    NSString *theDate = [dateFormat stringFromDate:date];
    NSString *theTime = [timeFormat stringFromDate:date];
    
    NSString *dateString = [[theDate stringByAppendingString:@"\n"] stringByAppendingString:theTime];
    
    dateLabel.text = dateString;
    [dateFormat release];
    [timeFormat release];
    //[date release];
    
    NSString *imageTypePath;
    UIImage *imageType;
    if ([notif.eventType isEqualToString:@"assignment"]) {
        imageTypePath = [[NSBundle mainBundle] pathForResource:@"desk" ofType:@"png"];
        imageType = [UIImage imageWithContentsOfFile:imageTypePath];
    } else if ([notif.eventType isEqualToString:@"examAnnouncement"]) {
        imageTypePath = [[NSBundle mainBundle] pathForResource:@"announce" ofType:@"png"];
        imageType = [UIImage imageWithContentsOfFile:imageTypePath];
    } else if ([notif.eventType isEqualToString:@"marksFile"]) {
        imageTypePath = [[NSBundle mainBundle] pathForResource:@"grades" ofType:@"png"];
        imageType = [UIImage imageWithContentsOfFile:imageTypePath];
    } else if ([notif.eventType isEqualToString:@"notice"]) {
        imageTypePath = [[NSBundle mainBundle] pathForResource:@"note" ofType:@"png"];
        imageType = [UIImage imageWithContentsOfFile:imageTypePath];
    } else if ([notif.eventType isEqualToString:@"message"]) {
        imageTypePath = [[NSBundle mainBundle] pathForResource:@"recmsg" ofType:@"png"];
        imageType = [UIImage imageWithContentsOfFile:imageTypePath];
    } else if ([notif.eventType isEqualToString:@"forumReply"]) {
        imageTypePath = [[NSBundle mainBundle] pathForResource:@"forum" ofType:@"png"];
        imageType = [UIImage imageWithContentsOfFile:imageTypePath];
    } else if ([notif.eventType isEqualToString:@"survey"]) {
        imageTypePath = [[NSBundle mainBundle] pathForResource:@"survey" ofType:@"png"];
        imageType = [UIImage imageWithContentsOfFile:imageTypePath];
    }
    
    typeImage.image = imageType;
    
}

- (void)dealloc {
    [typeImage release];
    [actionImage release];
    [titleLabel release];
    [detailText release];
    //[data dealloc];
    [gradeLabel release];
    [subjectLabel release];
    [dateLabel release];
    [senderLabel release];
    [super dealloc];
}

-(void) userTouched{
    //detailText.hidden = ! detailText.hidden;
    if((data.status & 0b100) == 0){
        titleLabel.font = [UIFont systemFontOfSize:18];
        
        DBManager *myDB = [[DBManager alloc] init];
        if ([myDB markNotificationAsRead:data.notificationCode]){
            data.status |= 0b100;
        }
		[myDB release];
    }
    /*if ([data.eventType isEqualToString:@"marksFile"]) {
        //Mostrar WebView
    } else {
        
    }*/
}
@end
