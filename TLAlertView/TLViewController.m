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

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (IBAction)showView:(id)sender {
    TLAlertView *alertView = [TLAlertView showInView:self.view withTitle:@"Sorry, there was an error" message:@"This is some message that you might display to the user" confirmButtonTitle:@"OK" cancelButtonTitle:@"Cancel"];
    
    [alertView handleCancel:^{
        NSLog(@"cancel");
    }         handleConfirm:^{
        NSLog(@"confirm");
    }];
    
    alertView.TLAnimationType = (arc4random_uniform(10) % 2 == 0) ? TLAnimationType3D : tLAnimationTypeHinge;
    [alertView show];
}

@end
