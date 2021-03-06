//
//  NoticesViewController.h
//  iSWAD
//
//  Created by Diego Montesinos on 22/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomUITextView.h"
#import "CourseSelector.h"
#import "WebCommunication.h"

@interface NoticesViewController : UIViewController<UITextViewDelegate>{
    NSString *_courseName;
	int _courseCode;
	
    UIApplication* app;
	UIActivityIndicatorView* activityIndicatorView;
	
	CourseSelector *cs;
	WebCommunication *myWB;
}

@property (retain, nonatomic) IBOutlet CustomUITextView *txtMessage;

@property (retain, nonatomic) IBOutlet UITextField *txtCourse;

- (IBAction)txtEditingDidBegin:(UITextField *)sender;

@end
