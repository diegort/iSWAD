//
//  ConfigureTestViewController.h
//  iSWAD
//
//  Created by Diego Montesinos on 09/09/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CourseSelector.h"

@interface ConfigureTestViewController : UIViewController{
	int _courseCode;
	CourseSelector *cs;
}

@end
