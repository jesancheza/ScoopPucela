//
//  JESAAuthorNewCellView.h
//  ScoopsPucela
//
//  Created by José Enrique Sanchez on 4/5/15.
//  Copyright (c) 2015 Devappify. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JESAAuthorNewCellView : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *photoView;
@property (weak, nonatomic) IBOutlet UILabel *titleView;
@property (weak, nonatomic) IBOutlet UILabel *ratingView;


+(NSString *) cellId;
+(CGFloat) cellHeight;

- (IBAction)publicNew:(id)sender;
@end
