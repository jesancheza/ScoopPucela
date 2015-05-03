//
//  JESANews.m
//  ScoopsPucela
//
//  Created by José Enrique Sanchez on 29/4/15.
//  Copyright (c) 2015 Devappify. All rights reserved.
//

#import "JESANews.h"

@implementation JESANews

+(id) newWithTitle:(NSString *) title boxNew:(NSString *) boxNew author:(NSString *) author{
    
    return [[self alloc] initWithTitle:title
                                boxNew:boxNew
                                author:author];
}

-(id) initWithTitle:(NSString *) title
             boxNew:(NSString *) boxNew
             author:(NSString *) author{
    
    return [self initWithTitle:title
                        boxNew:boxNew
                        author:author
                        estado:@""
                        rating:0.0f];
}

-(id) initWithTitle:(NSString *) title estado:(NSString *) estado rating:(float) rating{
    
    return [self initWithTitle:title
                        boxNew:@""
                        author:@""
                        estado:estado
                        rating:rating];
}

-(id) initWithTitle:(NSString *) title boxNew:(NSString *) boxNew author:(NSString *) author estado:(NSString *) estado rating:(float) rating{
    
    if (self == [super init]) {
        _title = title;
        _boxNew = boxNew;
        _author = author;
        _estado = estado;
        _rating = rating;
    }
    
    return self;
}

@end
