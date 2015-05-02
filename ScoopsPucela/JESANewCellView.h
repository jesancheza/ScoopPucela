//
//  JESANewCellView.h
//  ScoopsPucela
//
//  Created by José Enrique Sanchez on 2/5/15.
//  Copyright (c) 2015 Devappify. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JESANewCellView : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *photoView;
@property (weak, nonatomic) IBOutlet UILabel *titleView;
@property (weak, nonatomic) IBOutlet UILabel *authorView;
//@property (nonatomic) IBOutlet CGFloat *rating;


+(NSString *) cellId;
+(CGFloat) cellHeight;

@end
