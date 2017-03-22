//
//  AcronymViewController.h
//  Acronym
//
//  Created by Chuck Soper on 3/21/17.
//  Copyright © 2017 Vela Design Group. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AcronymViewController : UIViewController <UINavigationControllerDelegate, UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *acronymTextField;

@end
