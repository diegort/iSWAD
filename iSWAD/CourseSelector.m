//
//  CourseSelector.m
//  iSWAD
//
//  Created by Diego Montesinos on 10/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CourseSelector.h"
#import "WebCommunication.h"
#import "getCoursesOutput.h"
#import "course.h"
#import "Literals.h"

static int _courseCode;
static NSString* _courseName;

int userLevel=0;
UIActionSheet *tmpAS;
UIPickerView *tmpPV;

coursesArray *filtered;

static coursesArray* courses;

@implementation CourseSelector
@synthesize target = _target;
@synthesize act = _act;

- (id) initWithTarget:(id)tg selector:(SEL)sel{
	self = [super init];
    if (self) {
        _target = tg;
		_act = sel;
		
		[self init];
    }
    return self;
}

- (id) init{
	self = [super init];
    if (self) {		
		app = [UIApplication sharedApplication];
		
		[[NSNotificationCenter defaultCenter] removeObserver:self name:Common object:nil];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(coursesListDone:) name:Common object:nil];
		
		[[NSNotificationCenter defaultCenter] removeObserver:self name:CoursesListReady object:nil];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(coursesListDone:) name:CoursesListReady object:nil];
    }
    return self;
}

- (void) coursesListDone: (NSNotification *) n{
	//getCoursesOutput *tmp = (getCoursesOutput *) [n object];
	app.networkActivityIndicatorVisible = NO;
	if ([[n object] isKindOfClass:[getCoursesOutput class]]) {
		courses = [(getCoursesOutput *)[n object] courses];		
		[self showSelector:userLevel];
	}else{
		NSNumber* res = [n object];
		switch ([res intValue]) {
			case -1:
			{
				UIAlertView *alert = [[UIAlertView alloc]
									  initWithTitle: NSLocalizedString(@"getCoursesErrorAlertTitle", nil)
									  message: NSLocalizedString(@"getCoursesErrorAlertMessage", nil)
									  delegate: nil
									  cancelButtonTitle:NSLocalizedString(@"Accept", nil)
									  otherButtonTitles:nil];
				[alert show];
				[alert release];
			}
				break;
			case 400:
			{
				UIAlertView *alert = [[UIAlertView alloc]
									  initWithTitle: NSLocalizedString(@"noConnectionAlertTitle", nil)
									  message: NSLocalizedString(@"noConnectionAlertMessage", nil)
									  delegate: nil
									  cancelButtonTitle:NSLocalizedString(@"Accept", nil)
									  otherButtonTitles:nil];
				[alert show];
				[alert release];
			}
			default:
				break;
		}
		[_target performSelector:_act withObject:[[[NSNumber alloc] initWithInt:-1] autorelease]];
	}
	
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
	return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
	return [filtered count];
}

- (NSString *)pickerView:(UIPickerView *)thePickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
	return ((course *) [filtered objectAtIndex:row]).courseName;
}

- (void)pickerView:(UIPickerView *)thePickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
	
	int tmpCode = _courseCode;
	
	_courseCode = ((course *) [courses objectAtIndex:row]).courseCode;
	_courseName = ((course *) [courses objectAtIndex:row]).courseName;
	
	/*if (_courseCode == tmpCode){
		[tmpAS dismissWithClickedButtonIndex:0 animated:YES];
	}*/
}

- (void) dismissActionSheet:(id) sender{

	_courseCode = ((course *) [courses objectAtIndex:[tmpPV selectedRowInComponent:0]]).courseCode;
	_courseName = ((course *) [courses objectAtIndex:[tmpPV selectedRowInComponent:0]]).courseName;	

	[tmpAS dismissWithClickedButtonIndex:0 animated:YES];
	
	[_target performSelector:_act withObject:[[[NSNumber alloc] initWithInt:0] autorelease]];

}

- (void) filterCourses{
	filtered = [[coursesArray alloc] init];
	course *aux;
	for (int i = 0; i<courses.count; i++) {
		aux = [courses objectAtIndex:i];
		if ([aux userRole] >= userLevel) {
			[filtered addObject:aux];
		}
	}
	
}

- (void) showSelector{
	[self showSelector:1];
}

- (void) showSelector:(int) level{
	userLevel = level;
	if (courses) {
		[self filterCourses];
		UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:NSLocalizedString(@"courseSelect",nil)
																 delegate:nil
														cancelButtonTitle:nil
												   destructiveButtonTitle:nil
														otherButtonTitles:nil];
		
		[actionSheet setActionSheetStyle:UIActionSheetStyleBlackTranslucent];
		
		CGRect pickerFrame = CGRectMake(0, 40, 0, 0);
		
		UIPickerView *pickerView = [[UIPickerView alloc] initWithFrame:pickerFrame];
		pickerView.showsSelectionIndicator = YES;
		pickerView.dataSource = self;
		pickerView.delegate = self;
		
		[actionSheet addSubview:pickerView];
		tmpPV = pickerView;
		[pickerView release];
		
		UISegmentedControl *closeButton = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObject:NSLocalizedString(@"Close",nil)]];
		closeButton.momentary = YES; 
		closeButton.frame = CGRectMake(260, 7.0f, 50.0f, 30.0f);
		closeButton.segmentedControlStyle = UISegmentedControlStyleBar;
		closeButton.tintColor = [UIColor blackColor];
		[closeButton addTarget:self action:@selector(dismissActionSheet:) forControlEvents:UIControlEventValueChanged];
		[actionSheet addSubview:closeButton];
		[closeButton release];
		
		[actionSheet showInView:[[UIApplication sharedApplication] keyWindow]];
		
		[actionSheet setBounds:CGRectMake(0, 0, 320, 485)];
		tmpAS = actionSheet;
	}else{
		app.networkActivityIndicatorVisible = YES;
		
		WebCommunication * myWb = [[WebCommunication alloc] init];
		[myWb getSubjects];
		[myWb release];
	}
}

- (int) getSelectedCode{
	return _courseCode;
}

- (NSString *) getSelectedName{
	return _courseName;
}

@end
