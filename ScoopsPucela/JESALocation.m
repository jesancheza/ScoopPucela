//
//  JESALocation.m
//  ScoopsPucela
//
//  Created by José Enrique Sanchez on 2/5/15.
//  Copyright (c) 2015 Devappify. All rights reserved.
//

#import "JESALocation.h"
@import AddressBookUI;

@implementation JESALocation

+(instancetype) locationWithCLLocation:(CLLocation*)location{
    JESALocation *loc = [[JESALocation alloc] init];
    loc.latitudeValue = location.coordinate.latitude;
    loc.longitudeValue = location.coordinate.longitude;
    
    CLGeocoder *coder = [[CLGeocoder alloc]init];
    [coder reverseGeocodeLocation:location
                completionHandler:^(NSArray *placemarks, NSError *error) {
                    
                    if (error) {
                        NSLog(@"Error while obtaining address!\n%@", error);
                    }else{
                        /*loc.address = ABCreateStringWithAddressDictionary([[placemarks lastObject] addressDictionary], YES);
                        NSLog(@"Address is %@", loc.address);*/
                        CLPlacemark *placeMark = [placemarks objectAtIndex:0];
                        NSLog(@"%@ ", placeMark.addressDictionary);
                        // preparamos el diccionario
                        // no sabemos si tiene dirección - tenemos que decir
                        NSString *addressString;
                        if ([placeMark.addressDictionary valueForKey:@"Street"]) {
                            addressString = [placeMark.addressDictionary valueForKey:@"Street"];
                        } else {
                            addressString = placeMark.administrativeArea;
                        }
                        //[placeMark.addressDictionary valueForKey:@"Street"]
                        /*addressDic = @{@"location": @{@"address": addressString,
                                                      @"cc": placeMark.ISOcountryCode,
                                                      @"city": placeMark.locality,
                                                      @"country": placeMark.country,
                                                      @"distance": @0,
                                                      @"lat": [NSNumber numberWithDouble:self.positionPlace.coordinate.latitude] ,
                                                      @"lng": [NSNumber numberWithDouble:self.positionPlace.coordinate.longitude],
                                                      @"state": placeMark.administrativeArea}};*/
                        loc.address = placeMark.locality;
                    }
                }];
    return loc;
}

@end
