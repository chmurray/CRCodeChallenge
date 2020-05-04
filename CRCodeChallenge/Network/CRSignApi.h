//
//  CRSignApi.h
//  CRCodeChallenge
//
//  Created by Christine Harris on 5/3/20.
//  Copyright © 2020 Christine Harris. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/* This class keeps the way we obtain our sign data separate from both
   the definition of a sign and the presentation of a sign.
*/
@interface CRSignApi : NSObject

extern NSString * _Nonnull const kSignApiErrorDomain;

typedef NS_ENUM(NSInteger, CRSignAPIError) {
    CRSignApiErrorRequestFailed,
    CRSignApiErrorEmptyPayload,
};

- (void) downloadSignData: (nullable void (^)(NSError * _Nullable error, NSData * _Nullable signs)) completion;

@end

NS_ASSUME_NONNULL_END
