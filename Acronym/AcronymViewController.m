//
//  AcronymViewController.m
//  Acronym
//
//  Created by Chuck Soper on 3/21/17.
//  Copyright © 2017 Vela Design Group. All rights reserved.
//

#import "AcronymViewController.h"
#import "MeaningsTableViewController.h"
#import "AFNetworking.h"
#import "MBProgressHUD.h"

static NSString *kBaseURL = @"http://www.nactem.ac.uk/software/acromine/dictionary.py";

@interface AcronymViewController ()

@property (nonatomic, strong) NSString * abbr;
@property (nonatomic, strong) NSMutableArray * meanings;

@end

@implementation AcronymViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	
	self.navigationController.delegate = self;
	
	self.title = @"Acronym";
	
	self.meanings = [[NSMutableArray alloc] init];
	
	self.acronymTextField.delegate = self;
	[self.acronymTextField becomeFirstResponder];
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
	return UIInterfaceOrientationMaskPortrait;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)showResponse:(NSArray *)responseArray forAcronym:(NSString *)acronym {
	
	if (responseArray.count == 1) {
		NSDictionary *responseDict = [responseArray objectAtIndex:0];

		self.abbr = [responseDict objectForKey:@"sf"];
		NSArray *longForms = [responseDict objectForKey:@"lfs"];
		
		[self.meanings removeAllObjects];
		
		for (NSDictionary *longForm in longForms) {
			NSString *meaning = [longForm objectForKey:@"lf"];
			[self.meanings addObject:meaning];
		}
		
		[self performSegueWithIdentifier:@"showMeaningsSegue" sender:self];
	} else {
		UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Search Results"
																	   message:[NSString stringWithFormat:@"No meanings found for \"%@.\"", acronym]
																preferredStyle:UIAlertControllerStyleAlert];
		
		UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
															  handler:^(UIAlertAction * action) {}];
		
		[alert addAction:defaultAction];
		[self presentViewController:alert animated:YES completion:nil];
	}
}

- (void)lookupAcronym:(NSString *)acronym {
	
	if (acronym.length == 0) {
		return;
	}
	
	AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
	NSString *urlString = [NSString stringWithFormat:@"%@?sf=%@", kBaseURL, acronym];
	NSURL *URL = [NSURL URLWithString:urlString];
	
	// Note: The server is returning:  "Content-Type" = "text/plain; charset=UTF-8";
	// We will fix the issue by adding "text/plain" to acceptableContentTypes.
	manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/plain"];
	// A better solution, if possible, would be to have the server return an acceptable content type
	// such as "application/json"
	
	MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
	hud.mode = MBProgressHUDModeIndeterminate;
	hud.label.text = @"Searching";

	[manager GET:URL.absoluteString parameters:nil progress:nil success:^(NSURLSessionTask *task, id responseObject) {
		[hud hideAnimated:YES];
		[self showResponse:(NSArray *)responseObject forAcronym:acronym];
	} failure:^(NSURLSessionTask *operation, NSError *error) {
		[hud hideAnimated:YES];
		
		NSString * message = [NSString stringWithFormat:@"%@ Domain: %@. Code: %ld.",
							  error.localizedDescription, error.domain, error.code];
		UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Error"
																	   message:message
																preferredStyle:UIAlertControllerStyleAlert];
		UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
															  handler:^(UIAlertAction * action) {}];
		[alert addAction:defaultAction];
		[self presentViewController:alert animated:YES completion:nil];
	}];
}

#pragma mark - UINavigationControllerDelegate

- (UIInterfaceOrientationMask)navigationControllerSupportedInterfaceOrientations:(UINavigationController *)navigationController {
	return UIInterfaceOrientationMaskPortrait;
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	[self lookupAcronym:textField.text];
	
	return YES;
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
	if ([[segue identifier] isEqualToString:@"showMeaningsSegue"]) {
		MeaningsTableViewController *controller = (MeaningsTableViewController *)segue.destinationViewController;
		controller.abbr = self.abbr;
		controller.meanings = [NSMutableArray arrayWithArray:self.meanings];
	}
}

@end
