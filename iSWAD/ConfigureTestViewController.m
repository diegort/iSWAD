#import "ConfigureTestViewController.h"
#import "WebCommunication.h"

@interface ConfigureTestViewController ()

@end

@implementation ConfigureTestViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void) courseSelectorCallback{
	_courseCode = [cs getSelectedCode];
	
	WebCommunication * wc =[[WebCommunication alloc] init];
	[wc getTestConfig:_courseCode];
	[wc release];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
	cs = [[CourseSelector alloc] initWithTarget:self selector:@selector(courseSelectorCallback)];
	[cs showSelector];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
