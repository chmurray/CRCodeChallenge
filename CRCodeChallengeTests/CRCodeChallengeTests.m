//
//  CRCodeChallengeTests.m
//  CRCodeChallengeTests
//
//  Created by Christine Harris on 5/3/20.
//  Copyright © 2020 Christine Harris. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "CRSignBuilder.h"

/* This is just an initial proof-of-life test.
 */
@interface CRCodeChallengeTests : XCTestCase

@property (nonatomic, strong)  NSData * _Nullable validData;

@end

@implementation CRCodeChallengeTests

- (void)setUp {
    [super setUp];

    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    NSString *path = [bundle pathForResource:@"ValidData" ofType:@"json"];
    self.validData = [NSData dataWithContentsOfFile:path];
}

- (void)tearDown {
    self.validData = nil;

    [super tearDown];
}

- (void)testValidData {
    XCTestExpectation *expectation = [self expectationWithDescription:@"Expecting validData result"];
    
    CRSignBuilder *signBuilder = [[CRSignBuilder alloc] init];
    [signBuilder buildSignsFromData:self.validData completion:^(NSError * _Nullable error, NSArray<CRSign *> * _Nullable signs) {
        XCTAssert(nil == error, @"Valid JSON produced an error");
        XCTAssert(3 == signs.count, @"Parsed the wrong number of signs");
        [expectation fulfill];
    }];

    [self waitForExpectationsWithTimeout:10.0 handler:^(NSError * _Nullable error) {
        if (error != nil) {
            NSLog(@"Error: %@", error.localizedDescription);
        }
    }];
}

@end
