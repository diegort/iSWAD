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

static int _courseCode;
static NSString* _courseName;

int userLevel=0;
UIActionSheet *tmpAS;
UIPickerView *tmpPV;

coursesArray *filtered;

static coursesArray* courses;

@implementation CourseSelector

- (id) initWithTarget:(id)tg selector:(SEL)sel{
	self = [super init];
    if (self) {
        target = tg;
		act = sel;
		
		app = [UIApplication sharedApplication];
    }
    return self;
}

- (void) coursesListDone: (NSNotification *) n{
	//getCoursesOutput *tmp = (getCoursesOutput *) [n object];
	courses = [(getCoursesOutput *)[n object] courses];
	app.networkActivityIndicatorVisible = NO;
	[self showSelector:userLevel];
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
	
	if (_courseCode == tmpCode){
		[tmpAS dismissWithClickedButtonIndex:0 animated:YES];
	}
}

- (void) dismissActionSheet:(id) sender{

	_courseCode = ((course *) [courses objectAtIndex:[tmpPV selectedRowInComponent:0]]).courseCode;
	_courseName = ((course *) [courses objectAtIndex:[tmpPV selectedRowInComponent:0]]).courseName;	

	[tmpAS dismissWithClickedButtonIndex:0 animated:YES];
	
	[target performSelector:act];
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
		UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil 
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
		
		UISegmentedControl *closeButton = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObject:@"Cerrar"]];
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
		
		[[NSNotificationCenter defaultCenter] removeObserver:self name:@"coursesListReady" object:nil];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(coursesListDone:) name:@"coursesListReady" object:nil];
		WebCommunication * myWb = [[WebCommunication alloc] init];
		[myWb getSubjects];
	}
}

- (int) getSelectedCode{
	return _courseCode;
}

- (NSString *) getSelectedName{
	return _courseName;
}

@end
