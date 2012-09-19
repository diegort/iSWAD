//
//  ConfigureTestViewController.h
//  iSWAD
//
//  Created by Diego Montesinos on 09/09/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class getTestConfigOutput, tagsArray, DBManager;
@interface ConfigureTestViewController : UIViewController <UITextViewDelegate, UITableViewDataSource, UITableViewDelegate>{
	getTestConfigOutput* _config;
	DBManager* myDB;
	int _courseCode;
	UIView *_numQuestionsView, *_tagsView, *_questionTypeView;
}

@property int courseCode;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil courseCode:(int)code;

@property (retain, nonatomic) IBOutlet UILabel *lblNumQuestiones;
@property (retain, nonatomic) IBOutlet UITextField *txtNumQuestions;
@property (retain, nonatomic) IBOutlet UIButton *btnOK;
- (IBAction)btnOk_click:(id)sender;

@property (retain, nonatomic) IBOutlet UIButton *btonOkTypeQuestion;
@property (retain, nonatomic) IBOutlet UILabel *lblTypeQuestion;


@property (retain, nonatomic) IBOutlet UILabel *lblQuestionsTags;
@property (retain, nonatomic) IBOutlet UIButton *btnOkQuestionTags;
@end
