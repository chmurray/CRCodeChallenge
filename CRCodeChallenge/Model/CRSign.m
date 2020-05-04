//
//  CRSign.m
//  CRCodeChallenge
//
//  Created by Christine Harris on 5/3/20.
//  Copyright © 2020 Christine Harris. All rights reserved.
//

#import "CRSign.h"
#import "CRSignApi.h"


@implementation CRSign

- (NSString *)description {
    NSString *desc = [NSString stringWithFormat:@"Name: %@, LastUpdated: %@, isDisplaying: %@, Text: ", self.name, self.lastUpdated, self.isDisplaying ? @"Yes" : @"No"];
    for( NSString *line in self.text ) {
        desc = [desc stringByAppendingString:[NSString stringWithFormat:@"|%@|", line]];
    }
    
    return desc;
}

@end
