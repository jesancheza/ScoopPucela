//
//  JESAAuthorNewCellView.m
//  ScoopsPucela
//
//  Created by José Enrique Sanchez on 4/5/15.
//  Copyright (c) 2015 Devappify. All rights reserved.
//

#import "JESAAuthorNewCellView.h"

@implementation JESAAuthorNewCellView

#pragma mark - Class methods
+(NSString *) cellId{
    return NSStringFromClass(self);
}

+(CGFloat) cellHeight{
    return 60.0f;
}

- (IBAction)publicNew:(id)sender {
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
