//
//  CRSignBuilder.h
//  CRCodeChallenge
//
//  Created by Christine Harris on 5/3/20.
//  Copyright © 2020 Christine Harris. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CRSign.h"

NS_ASSUME_NONNULL_BEGIN

/* This class uses an NSData object to build CRSigns. It keeps the
   responsibility of knowing the format/order of the raw data separate
   from both the networking/communication/data-acquisition code and
   the presentation code.
*/
@interface CRSignBuilder : NSObject

extern NSString * _Nonnull const kSignBuilderErrorDomain;

typedef NS_ENUM(NSInteger, CRSignBuilderError) {
    CRSignBuilderErrorFailedParsingPayload,
};

- (void) buildSignsFromData:(NSData *)signData completion: (nullable void (^)(NSError * _Nullable error, NSArray<CRSign *> * _Nullable signs)) completion;

@end

NS_ASSUME_NONNULL_END
