//
//  JESANewCellView.m
//  ScoopsPucela
//
//  Created by José Enrique Sanchez on 2/5/15.
//  Copyright (c) 2015 Devappify. All rights reserved.
//

#import "JESANewCellView.h"

@implementation JESANewCellView

#pragma mark - Class methods
+(NSString *) cellId{
    return NSStringFromClass(self);
}

+(CGFloat) cellHeight{
    return 60.0f;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
