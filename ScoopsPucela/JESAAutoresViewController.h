//
//  JESAAutoresViewController.h
//  ScoopsPucela
//
//  Created by José Enrique Sanchez on 28/4/15.
//  Copyright (c) 2015 Devappify. All rights reserved.
//

@import UIKit;
@import CoreLocation;
@class JESALocation;


typedef void (^profileCompletion)(NSDictionary* profInfo);
typedef void (^completeBlock)(NSArray* results);
typedef void (^completeOnError)(NSError *error);
typedef void (^completionWithURL)(NSURL *theUrl, NSError *error);

@interface JESAAutoresViewController : UIViewController <CLLocationManagerDelegate, UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *picProfile;
@property (strong, nonatomic) NSURL *profilePicture;
@property (strong, nonatomic) NSString *profileName;

@property (weak, nonatomic) IBOutlet UITextField *titleNew;
@property (weak, nonatomic) IBOutlet UITextView *boxNews;
@property (weak, nonatomic) IBOutlet UIToolbar *bottomBar;

@property (nonatomic, readonly) BOOL hasLocation;
@property (nonatomic, strong) JESALocation *location;

- (IBAction)addNew:(id)sender;
- (IBAction)takePhoto:(id)sender;
- (IBAction)hideKeyboard:(id)sender;
@end
