//
//  TLViewController.m
//  TLAlertView
//
//  Created by Terry Lewis II on 5/31/13.
//  Copyright (c) 2013 Terry Lewis. All rights reserved.
//

#import "TLViewController.h"
#import "TLAlertView.h"
@interface TLViewController ()

@end

@implementation TLViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)showView:(id)sender {
    TLAlertView *alertView = [TLAlertView showInView:self.view withTitle:@"Sorry, there was an error" message:@"This is some message that you might display to the user" confirmButtonTitle:@"OK" cancelButtonTitle:@"Cancel"];
    [alertView handleCancel:^{
        NSLog(@"cancel");
    } handleConfirm:^{
        NSLog(@"confirm");
    }];
    [alertView show];
}

@end
