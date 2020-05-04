//
//  CRSignManager.m
//  CRCodeChallenge
//
//  Created by Christine Harris on 5/3/20.
//  Copyright © 2020 Christine Harris. All rights reserved.
//

#import "CRSignManager.h"
#import "CRSignApi.h"
#import "CRSignBuilder.h"

@implementation CRSignManager


- (void) fetchSigns {
    
    CRSignApi *signApi = [[CRSignApi alloc] init];
    
    [signApi downloadSignData:^(NSError * _Nullable error, NSData * _Nullable signData) {
        
        if (error) {
            [self.delegate didReceiveSigns:nil error:error];
        } else {
            CRSignBuilder *signBuilder = [[CRSignBuilder alloc] init];
            [signBuilder buildSignsFromData:signData completion:^(NSError * _Nullable error, NSArray<CRSign *> * _Nullable signs) {
                [self.delegate didReceiveSigns:signs error:error];
            }];
        }
    }];
}

@end
