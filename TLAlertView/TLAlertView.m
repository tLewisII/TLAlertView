//
//  TLAlertView.m
//  TLAlertView
//
//  Created by Terry Lewis II on 5/31/13.
//  Copyright (c) 2013 Terry Lewis. All rights reserved.
//
#define kPresentationAnimationDuration .5
#define kDismissAnimationDuration .4
#import "TLAlertView.h"
#import <QuartzCore/QuartzCore.h>
//tag the buttons to perform the correct completion block
typedef enum {
    kCancelButtonTag = 100,
    kConfirmbuttomTag = 101,
}buttonTags;

@interface TLAlertView () {
    TLCompletionBlock cancelCompletionBlock;
    TLCompletionBlock confirmCompletionBlock;
}

@property(strong,nonatomic)UILabel *titleLabel;
@property(strong,nonatomic)UILabel *messageLabel;
@property(strong,nonatomic)UIView *viewToShowIn;
@property(strong,nonatomic)UIView *centralView;
@property(strong,nonatomic)UIButton *confirmButton;
@property(strong,nonatomic)UIButton *cancelButton;

@end
@implementation TLAlertView

-(id)initWithTitle:(NSString *)title message:(NSString *)message inView:(UIView *)view cancelButtonTitle:(NSString *)cancelButton confirmButton:(NSString *)confirmButton {
    if(self = [super initWithFrame:CGRectMake(CGRectGetMinX(view.frame) + 20, CGRectGetMinY(view.frame) - 175, CGRectGetWidth(view.frame) - 40, 150)]) {
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(self.bounds) + 10, CGRectGetMinY(self.bounds) + 10, CGRectGetWidth(self.bounds) - 20, 21)];
        _titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:24];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.textColor = [UIColor whiteColor];
        
        _messageLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(self.bounds) + 10, CGRectGetMaxY(_titleLabel.frame) + 10, CGRectGetWidth(self.bounds) - 20, 42)];
        _messageLabel.font = [UIFont fontWithName:@"Helvetica Neue" size:18];
        _messageLabel.textAlignment = NSTextAlignmentCenter;
        _messageLabel.backgroundColor = [UIColor clearColor];
        _messageLabel.numberOfLines = 0;
        _messageLabel.textColor = [UIColor whiteColor];
        
        if(cancelButton && confirmButton) {
            _cancelButton = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMinX(self.bounds) + 10, CGRectGetMaxY(self.bounds) - 54,  (CGRectGetWidth(self.bounds) /2) - 20, 44)];
            _cancelButton.backgroundColor = [UIColor colorWithRed:0.000 green:0.502 blue:1.000 alpha:1.000];
            _cancelButton.tag = kCancelButtonTag;
            _cancelButton.titleLabel.font = [UIFont fontWithName:@"Helvetica-BoldOblique" size:20];
            
            _confirmButton = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.bounds) - (CGRectGetWidth(self.bounds) /2) + 10, CGRectGetMaxY(self.bounds) - 54, (CGRectGetWidth(self.bounds) /2) - 20, 44)];
            _confirmButton.backgroundColor = [UIColor colorWithRed:0.000 green:0.502 blue:1.000 alpha:1.000];
            _confirmButton.tag = kConfirmbuttomTag;
            _confirmButton.titleLabel.font = [UIFont fontWithName:@"Helvetica-BoldOblique" size:20];
        }
        else {
            _cancelButton = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMinX(self.bounds) + 10, CGRectGetMaxY(self.bounds) - 54,  CGRectGetWidth(self.bounds) - 20, 44)];
            _cancelButton.backgroundColor = [UIColor colorWithRed:0.000 green:0.502 blue:1.000 alpha:1.000];
            _cancelButton.tag = kCancelButtonTag;
            _cancelButton.titleLabel.font = [UIFont fontWithName:@"Helvetica-BoldOblique" size:20];
        }
        
        self.layer.edgeAntialiasingMask = kCALayerLeftEdge | kCALayerRightEdge;
        self.backgroundColor = [UIColor clearColor];
    
        _viewToShowIn = view;
        _titleLabel.text = title;
        _messageLabel.text = message;
        [_confirmButton setTitle:confirmButton forState:UIControlStateNormal];
        [_cancelButton setTitle:cancelButton forState:UIControlStateNormal];
        [_confirmButton addTarget:self action:@selector(executeCompletionBlock:) forControlEvents:UIControlEventTouchUpInside];
        [_cancelButton addTarget:self action:@selector(executeCompletionBlock:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:_titleLabel];
        [self addSubview:_messageLabel];
        if(_confirmButton)
            [self addSubview:_confirmButton];
        [self addSubview:_cancelButton];
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGRect inset = CGRectInset(self.bounds, 2, 2);
    UIColor *rectColor = [UIColor colorWithRed:0.174 green:0.182 blue:0.173 alpha:1.000];
    CGContextSaveGState(context);
    
    CGContextSetFillColorWithColor(context, rectColor.CGColor);
    CGContextFillRect(context, self.bounds);
    CGContextRestoreGState(context);
    CGContextSetStrokeColorWithColor(context, [UIColor whiteColor].CGColor);
    CGContextStrokeRect(context, rectFor1PxStroke(inset));
    
    
}

+(TLAlertView *)showInView:(UIView *)view withTitle:(NSString *)title message:(NSString *)message confirmButtonTitle:(NSString *)confim cancelButtonTitle:(NSString *)cancel {
    return [[TLAlertView alloc]initWithTitle:title message:message inView:view cancelButtonTitle:cancel confirmButton:confim];
}
//Shows the view and also disables user interaction for the all the subviews that are in the presenting view, thus preserving a modal presentation
-(void)show {
    [self.viewToShowIn.subviews enumerateObjectsUsingBlock:^(UIView *obj, NSUInteger idx, BOOL *stop) {
        obj.userInteractionEnabled = NO;
    }];
    [self.viewToShowIn addSubview:self];
    [UIView animateWithDuration:kPresentationAnimationDuration delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.frame = CGRectMake(CGRectGetMinX(self.viewToShowIn.frame) + 20, CGRectGetMidY(self.viewToShowIn.frame) - 75, CGRectGetWidth(self.viewToShowIn.frame) - 40, 150);
    } completion:nil];
    
}
-(void)executeCompletionBlock:(UIButton *)sender {
    CATransform3D transformation = CATransform3DIdentity;
    CATransform3D xRotation = CATransform3DMakeRotation(180*M_PI/180.0, 1.0, 0, 0);
    CATransform3D yRotation = CATransform3DMakeRotation(0*M_PI/180.0, 0.0, 1.0, 0);
    CATransform3D zRotation = CATransform3DMakeRotation(-130*M_PI/180.0, 0.0, 0, 1.0);
    CATransform3D xYRotation = CATransform3DConcat(xRotation, yRotation);
    CATransform3D xyZRotation = CATransform3DConcat(xYRotation, zRotation);
    CATransform3D translation = CATransform3DMakeTranslation(0, CGRectGetMaxY(self.viewToShowIn.bounds), 1.0);
    
    CATransform3D concatenatedTransformation = CATransform3DConcat(xyZRotation, translation);
    CATransform3D final = CATransform3DConcat(concatenatedTransformation, transformation);
    final.m34 = -.0045;
    
    [UIView animateWithDuration:kDismissAnimationDuration delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.layer.transform = final;
    }completion:^(BOOL finished) {
        if(sender.tag == kCancelButtonTag && cancelCompletionBlock) {
            cancelCompletionBlock();
        }
        else if(sender.tag == kConfirmbuttomTag && confirmCompletionBlock) {
            confirmCompletionBlock();
        }
        [self.viewToShowIn.subviews enumerateObjectsUsingBlock:^(UIView *obj, NSUInteger idx, BOOL *stop) {
            obj.userInteractionEnabled = YES;
        }];
        [self removeFromSuperview];
    }];
    
}

-(void)handleCancel:(TLCompletionBlock)cancelBlock handleConfirm:(TLCompletionBlock)confirmBlock {
    cancelCompletionBlock = cancelBlock;
    confirmCompletionBlock = confirmBlock;
}

CGRect rectFor1PxStroke(CGRect rect) {
    return CGRectMake(rect.origin.x + 0.5, rect.origin.y + 0.5, rect.size.width - 1, rect.size.height - 1);
}
@end
