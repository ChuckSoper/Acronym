//
//  MeaningsTableViewController.h
//  Acronym
//
//  Created by Chuck Soper on 3/22/17.
//  Copyright © 2017 Vela Design Group. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MeaningsTableViewController : UITableViewController

@property (nonatomic, strong) NSString * abbr;
@property (nonatomic, strong) NSMutableArray * meanings;

@end
