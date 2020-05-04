//
//  CRSignManager.h
//  CRCodeChallenge
//
//  Created by Christine Harris on 5/3/20.
//  Copyright © 2020 Christine Harris. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CRSign.h"

NS_ASSUME_NONNULL_BEGIN

@protocol CRSignManagerDelegate;

/* This class is a thin facade over the top of our data aquisition.
   It allows us to swap out the way we obtain our data without
   having to change anything in our presentation layer.  Also, it
   allows us to pop off our presentation layer without having to
   cut/paste/rewrite any of our data acquisition code.
*/
@interface CRSignManager : NSObject

@property (weak, nonatomic) id<CRSignManagerDelegate> delegate;

- (void) fetchSigns;

@end

@protocol CRSignManagerDelegate

- (void) didReceiveSigns:(nullable NSArray<CRSign *> *) signs error:(nullable NSError *) error;

@end

NS_ASSUME_NONNULL_END
