//
//  JESANews.h
//  ScoopsPucela
//
//  Created by José Enrique Sanchez on 29/4/15.
//  Copyright (c) 2015 Devappify. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JESANews : NSObject

+(id) newWithTitle:(NSString *) title boxNew:(NSString *) boxNew author:(NSString *) author;

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *boxNew;
@property (nonatomic, strong) NSString *author;
@property (nonatomic) float rating;
@property (nonatomic, strong) NSString *estado;

-(id) initWithTitle:(NSString *) title boxNew:(NSString *) boxNew author:(NSString *) author;
-(id) initWithTitle:(NSString *) title estado:(NSString *) estado rating:(float) rating;
-(id) initWithTitle:(NSString *) title boxNew:(NSString *) boxNew author:(NSString *) author estado:(NSString *) estado rating:(float) rating;

@end
