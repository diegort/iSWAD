//
//  MessagesViewController.h
//  iSWAD
//
//  Created by Diego Montesinos on 14/11/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomUITextView.h"

@interface MessagesViewController : UIViewController<UITextViewDelegate>{
    long _messageCode;
    NSString *_subject;
}

@property (retain, nonatomic) IBOutlet CustomUITextView *txtMessage;

@property (retain, nonatomic) IBOutlet UITextField *txtTo;

@property (retain, nonatomic) IBOutlet UITextField *txtSubject;

- (IBAction)txtEditingDidBegin:(UITextField *)sender;

- (void) setSubject:(NSString *) subject messageCode:(long)code;

@end
