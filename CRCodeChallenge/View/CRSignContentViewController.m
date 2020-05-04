//
//  CRSignContentViewController.m
//  CRCodeChallenge
//
//  Created by Christine Harris on 5/4/20.
//  Copyright © 2020 Christine Harris. All rights reserved.
//

#import "CRSignContentViewController.h"

@interface CRSignContentViewController ()

@property (weak, nonatomic) IBOutlet UILabel *signTextLabel;

@end

@implementation CRSignContentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = NSLocalizedString(@"Sign Text", @"Title of page showing the text currently displayed on a sign");
    
    if (0 == self.text.length) {
        self.signTextLabel.text = NSLocalizedString(@"This sign has no text", @"String displayed when a sign has no text to display");
        self.signTextLabel.textColor = UIColor.grayColor;
    } else {
        self.signTextLabel.text = self.text;
    }
}

@end
