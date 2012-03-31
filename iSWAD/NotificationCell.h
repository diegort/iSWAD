//
//  NotificationCell.h
//  iSWAD
//
//  Created by Diego Montesinos on 02/12/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "notification.h"

@interface NotificationCell : UITableViewCell{
    notification *data;
}

@property (retain, nonatomic) IBOutlet UIImageView *typeImage;

@property (retain, nonatomic) IBOutlet UIImageView *actionImage;

@property (retain, nonatomic) IBOutlet UILabel *titleLabel;

@property (retain, nonatomic) IBOutlet UILabel *detailText;

@property (retain, nonatomic) IBOutlet UILabel *gradeLabel;

@property (retain, nonatomic) IBOutlet UILabel *subjectLabel;

@property (retain, nonatomic) IBOutlet UILabel *dateLabel;

@property (retain, nonatomic) IBOutlet UILabel *senderLabel;

-(void) setData:(notification *)notif selected:(BOOL)sel;

-(void) userTouched;

@end
