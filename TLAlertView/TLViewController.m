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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)showView:(id)sender {
    TLAlertView *v = [TLAlertView showInView:self.view withTitle:@"Title" message:@"This is some message that you might display to the user" confirmButtonTitle:@"OK" cancelButtonTitle:@"Cancel"];
    [v handleCancel:^{
        NSLog(@"cancel");
    } handleConfirm:nil];
    [v show];
}

@end
