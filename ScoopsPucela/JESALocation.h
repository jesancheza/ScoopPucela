//
//  JESALocation.h
//  ScoopsPucela
//
//  Created by José Enrique Sanchez on 2/5/15.
//  Copyright (c) 2015 Devappify. All rights reserved.
//

@import Foundation;
@import CoreLocation;

@interface JESALocation : NSObject

+(instancetype) locationWithCLLocation:(CLLocation*)location;

@property (nonatomic) double longitudeValue;
@property (nonatomic) double latitudeValue;
@property (nonatomic, copy) NSString *address;

@end
