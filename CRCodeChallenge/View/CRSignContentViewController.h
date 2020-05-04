//
//  CRSignContentViewController.h
//  CRCodeChallenge
//
//  Created by Christine Harris on 5/4/20.
//  Copyright © 2020 Christine Harris. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/* CRSignContentViewController displays the message displayed
   by a sign. If the sign is not currently displaying any
   message, it just displays some canned text.
*/
@interface CRSignContentViewController : UIViewController

@property (strong, nonatomic) NSString *text;

@end

NS_ASSUME_NONNULL_END
