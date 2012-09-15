#import <UIKit/UIKit.h>

@class CourseSelector, WebCommunication, DBManager;
@interface TestsViewController : UIViewController{
	int _courseCode;
	CourseSelector* cs;
	WebCommunication *wc;
	DBManager* myDB;
	
	UIApplication* app;
	UIActivityIndicatorView* activityIndicatorView;
}
@property (retain, nonatomic) IBOutlet UIButton *btnDownload;
@property (retain, nonatomic) IBOutlet UIButton *btnMake;

@end
