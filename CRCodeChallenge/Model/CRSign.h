//
//  CRSign.h
//  CRCodeChallenge
//
//  Created by Christine Harris on 5/3/20.
//  Copyright © 2020 Christine Harris. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CRSign : NSObject

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSArray<NSString*> *text;
@property (assign, nonatomic) BOOL isDisplaying;
@property (strong, nonatomic) NSDate *lastUpdated;

@end

NS_ASSUME_NONNULL_END
