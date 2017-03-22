//
//  MeaningsTableViewController.m
//  Acronym
//
//  Created by Chuck Soper on 3/22/17.
//  Copyright © 2017 Vela Design Group. All rights reserved.
//

#import "MeaningsTableViewController.h"

@interface MeaningsTableViewController ()

@end

@implementation MeaningsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.title = self.abbr;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
	return UIInterfaceOrientationMaskPortrait;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.meanings.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"meaningsCellIdentifier" forIndexPath:indexPath];
	
	// Configure the cell...
	cell.textLabel.text = [self.meanings objectAtIndex:indexPath.row];
	
	return cell;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
