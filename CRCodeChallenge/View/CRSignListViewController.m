//
//  CRSignListViewController.m
//  CRCodeChallenge
//
//  Created by Christine Harris on 5/3/20.
//  Copyright © 2020 Christine Harris. All rights reserved.
//

#import "CRSignListViewController.h"
#import "CRSignContentViewController.h"
#import "CRSignManager.h"

@interface CRSignListViewController () <CRSignManagerDelegate, UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) NSArray<CRSign *> *signs;
@property (strong, nonatomic) CRSignManager *signManager;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *progressIndicator;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation CRSignListViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.signManager = [[CRSignManager alloc] init];
    self.signManager.delegate = self;
    
    [self refreshSigns];
}

- (void)refreshSigns {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.progressIndicator startAnimating];
    });
    
    [self.signManager fetchSigns];
}

#pragma mark - CRSignDelegate

- (void) didReceiveSigns:(nullable NSArray<CRSign *> *) signs error:(nullable NSError *) error {

    dispatch_async(dispatch_get_main_queue(), ^{
        [self.progressIndicator stopAnimating];
    });

    if (error) {
        [self displayError:error];
    } else {
        self.signs = [self getSortedSigns:signs];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    }
}

#pragma mark - UITableViewDataSource

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CRSignTableViewCell" forIndexPath:indexPath];
    CRSign *sign = self.signs[indexPath.row];
    
    cell.textLabel.text = sign.name;
    
    if (sign.isDisplaying) {
        cell.textLabel.textColor = UIColor.blackColor;
    } else {
        cell.textLabel.textColor = UIColor.lightGrayColor;
    }
    
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.signs.count;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    CRSignContentViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"CRSignContentViewController"];
    vc.text = [self.signs[indexPath.row].text componentsJoinedByString:@" "];
    [self.navigationController pushViewController:vc animated:YES];

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - UI Handlers

- (IBAction)didTouchUpInsideRefreshButton:(id)sender {
    [self refreshSigns];
}

#pragma mark - Utility

- (NSArray<CRSign *> *)getSortedSigns:(NSArray<CRSign *> *)signs {
    NSArray *sortedArray;
    sortedArray = [signs sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
        NSDate *first = [(CRSign*)a lastUpdated];
        NSDate *second = [(CRSign*)b lastUpdated];
        return [second compare:first];
    }];
    return sortedArray;
}

- (void)displayError:(NSError *)error {
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Error", @"Modal dialog title to let the user know that an error has occurred")
                                                                                 message:[error.userInfo objectForKey:NSLocalizedDescriptionKey]
                                                                          preferredStyle:UIAlertControllerStyleAlert];
            [alertController addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"Cancel", @"Button caption")
                                                                style:UIAlertActionStyleCancel
                                                              handler:^(UIAlertAction * _Nonnull action) {}]];
        [self presentViewController:alertController animated:YES completion:nil];
    });
}

@end
