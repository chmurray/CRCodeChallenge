//
//  CRSignBuilder.m
//  CRCodeChallenge
//
//  Created by Christine Harris on 5/3/20.
//  Copyright © 2020 Christine Harris. All rights reserved.
//

#import "CRSignBuilder.h"

NSString * const kSignBuilderErrorDomain = @"com.cr.codechallenge.signbuilder";

@implementation CRSignBuilder

static NSString * const kNameField = @"name";
static NSString * const kIsDisplayingField = @"status";
static NSString * const kLastUpdatedField = @"lastUpdated";
static NSString * const kTextTopField = @"display";
static NSString * const kTextPageArrayField = @"pages";
static NSString * const kTextLinesField = @"lines";
static NSString * const kDisplayingMessage = @"DISPLAYING_MESSAGE";

- (void) buildSignsFromData:(NSData *)signData completion: (nullable void (^)(NSError * _Nullable error, NSArray<CRSign *> * _Nullable signs)) completion {
    
    NSError *error = nil;
    NSMutableArray<CRSign *> *signs = [[NSMutableArray alloc] init];
    NSArray *dictionaries = [NSJSONSerialization JSONObjectWithData:signData options:0 error:&error];
    for (int i=0; i<dictionaries.count && nil==error; i++) {
        CRSign *sign = [[CRSign alloc] init];
        
        error = [self setName:sign fromDictionary:dictionaries[i]];
        
        if( !error ) {
            [self setIsDisplaying:sign fromDictionary:dictionaries[i]];
        }
        
        if( !error ) {
            [self setTimestamp:sign fromDictionary:dictionaries[i]];
        }
            
        if( !error ) {
            [self setText:sign fromDictionary:dictionaries[i]];
        }
        
        if( !error ) {
            [signs addObject:sign];
        }
    }
    
    completion(error, signs);
}

- (NSError *)setName:(CRSign *)sign fromDictionary:(NSDictionary *)dictionary {
    
    NSError *error = nil;
    NSString *name = dictionary[kNameField];
    if (name) {
        sign.name = name;
    } else {
        error = [NSError errorWithDomain:kSignBuilderErrorDomain code:CRSignBuilderErrorFailedParsingPayload userInfo:@{ NSLocalizedDescriptionKey: @"Name field not found"}];
    }

    return error;
}

- (NSError *)setIsDisplaying:(CRSign *)sign fromDictionary:(NSDictionary *)dictionary {
    
    NSError *error = nil;
    NSString *isDisplayingString = dictionary[kIsDisplayingField];
    if (isDisplayingString) {
        sign.isDisplaying = [isDisplayingString isEqualToString:kDisplayingMessage];
    } else {
        error = [NSError errorWithDomain:kSignBuilderErrorDomain code:CRSignBuilderErrorFailedParsingPayload userInfo:@{ NSLocalizedDescriptionKey: @"isDisplaying field not found"}];
    }
    
    return error;
}

- (NSError *)setTimestamp:(CRSign *)sign fromDictionary:(NSDictionary *)dictionary {
    
    NSError *error = nil;
    NSString *lastUpdatedTimestamp = dictionary[kLastUpdatedField];
    if (lastUpdatedTimestamp) {
        sign.lastUpdated = [[NSDate alloc] initWithTimeIntervalSince1970:(lastUpdatedTimestamp.doubleValue/1000)];
    } else {
        error = [NSError errorWithDomain:kSignBuilderErrorDomain code:CRSignBuilderErrorFailedParsingPayload userInfo:@{ NSLocalizedDescriptionKey: @"timestamp field not found"}];
    }
    
    return error;
}

- (NSError *)setText:(CRSign *)sign fromDictionary:(NSDictionary *)dictionary {
    
    NSError *error = nil;
    NSError *failure = [NSError errorWithDomain:kSignBuilderErrorDomain code:CRSignBuilderErrorFailedParsingPayload userInfo:@{ NSLocalizedDescriptionKey: @"problem with text"}];

    NSMutableArray<NSString *> *text = [[NSMutableArray alloc] init];
    // The text field is optional
    if (dictionary[kTextTopField]) {
        
        // There must be an array of pages if the text field exists
        if (dictionary[kTextTopField][kTextPageArrayField]) {
            for (NSDictionary *lineDictionary in dictionary[kTextTopField][kTextPageArrayField]) {
                
                // Each page must contain an array of text
                if (nil == error  &&  lineDictionary[kTextLinesField]) {
                    for (NSString *line in lineDictionary[kTextLinesField]) {
                        NSCharacterSet *quoteCharset = [NSCharacterSet characterSetWithCharactersInString:@"\""];
                        NSString *trimmedLine = [line stringByTrimmingCharactersInSet:quoteCharset];

                        [text addObject:trimmedLine];
                    }
                } else {
                    error = failure;
                }
            }
        } else {
            error = failure;
        }
    }
    
    if( !error ) {
        sign.text = text;
    }
    
    return error;
}

@end
