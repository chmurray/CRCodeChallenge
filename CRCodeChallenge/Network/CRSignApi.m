//
//  CRSignApi.m
//  CRCodeChallenge
//
//  Created by Christine Harris on 5/3/20.
//  Copyright © 2020 Christine Harris. All rights reserved.
//

#import "CRSignApi.h"

NSString * const kSignApiErrorDomain = @"com.cr.codechallenge.signapi";

static NSString * const kSignApiUrl = @"https://iatg.carsprogram.org/signs_v1/api/signs";

@implementation CRSignApi

- (NSMutableURLRequest *) getSignRequest {
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    NSString * language = [[NSLocale preferredLanguages] objectAtIndex:0];
    [request setValue:language forHTTPHeaderField:@"Accept-Language"];
    
    return request;
}

- (void) downloadSignData: (nullable void (^)(NSError * _Nullable error, NSData * _Nullable signs)) completion {
    
    NSURL *requestUrl = [NSURL URLWithString:kSignApiUrl];
    NSMutableURLRequest *request = [self getSignRequest];

    [request setURL:requestUrl];
    [request setHTTPMethod:@"GET"];
    
    [[[NSURLSession sharedSession] dataTaskWithRequest:request
                                     completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
             if (error) {
                 if (completion) {
                     completion(error, nil);
                 }
             } else {
                 NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
                 if ([httpResponse statusCode] == 200 || [httpResponse statusCode] == 201) {
                     if ([data length] > 0) {
                         if (completion) {
                             completion(nil, data);
                         }
                     } else {
                         if (completion) {
                             completion([NSError errorWithDomain:kSignApiErrorDomain code:CRSignApiErrorRequestFailed userInfo:@{ NSLocalizedDescriptionKey: @"API returned 0 bytes for sign data request"}],nil);
                         }
                     }
                 } else {
                     [self handleError:httpResponse completion:^(NSError *error) {
                         if (completion) {
                             completion(error, nil);
                         }
                     }];
                 }
             }
           }] resume];
}

- (void) handleError: (NSHTTPURLResponse *) response completion: (nullable void (^)(NSError *error)) completion {
    
    // This should be where we handle any known server response issues, expired tokens, etc.
    //  There aren't any right now, so the function appears wasted...
    if (completion) {
        completion([NSError errorWithDomain:kSignApiErrorDomain code:CRSignApiErrorRequestFailed userInfo:@{ NSLocalizedDescriptionKey: [NSString stringWithFormat:@"HTTP statusCode: %ld", (long)[response statusCode]]}]);
    }
}

@end
