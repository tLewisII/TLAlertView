//
//  TLAlertView.m
//  TLAlertView
//
//  Created by Terry Lewis II on 5/31/13.
//  Copyright (c) 2013 Terry Lewis. All rights reserved.
//
#define kPresentationAnimationDuration .4
#define kDismissAnimationDuration .4
#define degToRadians(x) (x * M_PI / 180.0f)

#import "TLAlertView.h"
#import <QuartzCore/QuartzCore.h>

//tag the buttons to perform the correct completion block
typedef NS_ENUM(NSUInteger, buttonTags) {
    kCancelButtonTag = 100,
    kConfirmButtonTag = 101,
};

@interface TLAlertView () {
    TLCompletionBlock cancelCompletionBlock;
    TLCompletionBlock confirmCompletionBlock;
}

@property(strong, nonatomic) UILabel *titleLabel;
@property(strong, nonatomic) UILabel *messageLabel;
@property(strong, nonatomic) UIView *viewToShowIn;
@property(strong, nonatomic) UIButton *confirmButton;
@property(strong, nonatomic) UIButton *cancelButton;

@end

@implementation TLAlertView
#pragma mark - Initializer
- (TLAlertView *)initWithTitle:(NSString *)title message:(NSString *)message inView:(UIView *)view cancelButtonTitle:(NSString *)cancelButton confirmButton:(NSString *)confirmButton {
    self = [super init];
    if (!self) {
        return nil;
    }
    self.translatesAutoresizingMaskIntoConstraints = NO;
    _titleColor = [UIColor whiteColor];
    _messageColor = [UIColor whiteColor];
    _confirmTextColor = [UIColor whiteColor];
    _cancelTextColor = [UIColor whiteColor];
    _buttonColor = [UIColor colorWithRed:0.000 green:0.502 blue:1.000 alpha:1.000];
    _viewColor = [UIColor colorWithRed:0.174 green:0.182 blue:0.173 alpha:1.000];
    _borderColor = [UIColor whiteColor];
    
    [self addConstraints:@[
     [NSLayoutConstraint
      constraintWithItem:self
      attribute:NSLayoutAttributeWidth
      relatedBy:NSLayoutRelationEqual
      toItem:nil
      attribute:NSLayoutAttributeNotAnAttribute
      multiplier:1.0
      constant:280],
     [NSLayoutConstraint
      constraintWithItem:self
      attribute:NSLayoutAttributeHeight
      relatedBy:NSLayoutRelationGreaterThanOrEqual
      toItem:nil
      attribute:NSLayoutAttributeNotAnAttribute
      multiplier:1.0
      constant:150]
     ]];
    _titleLabel = ({
        UILabel *label = [[UILabel alloc]init];
        label.text = title;
        label.numberOfLines = 1;
        label.preferredMaxLayoutWidth = 260;
        label.translatesAutoresizingMaskIntoConstraints = NO;
        label.adjustsFontSizeToFitWidth = YES;
        label.font = [UIFont fontWithName:@"Helvetica-Bold" size:24];
        label.textAlignment = NSTextAlignmentCenter;
        label.backgroundColor = [UIColor clearColor];
        label.textColor = _titleColor;
        [self addSubview:label];
        [self addConstraints:@[
         [NSLayoutConstraint
          constraintWithItem:label
          attribute:NSLayoutAttributeTop
          relatedBy:NSLayoutRelationEqual
          toItem:self
          attribute:NSLayoutAttributeTop
          multiplier:1.0
          constant:10],
         [NSLayoutConstraint
          constraintWithItem:label
          attribute:NSLayoutAttributeCenterX
          relatedBy:NSLayoutRelationEqual
          toItem:self
          attribute:NSLayoutAttributeCenterX
          multiplier:1.0
          constant:0]
         ]];
        [label addConstraints:@[
         [NSLayoutConstraint
          constraintWithItem:label
          attribute:NSLayoutAttributeWidth
          relatedBy:NSLayoutRelationEqual
          toItem:nil
          attribute:NSLayoutAttributeNotAnAttribute
          multiplier:1.0
          constant:260],
         [NSLayoutConstraint
          constraintWithItem:label
          attribute:NSLayoutAttributeHeight
          relatedBy:NSLayoutRelationLessThanOrEqual
          toItem:nil
          attribute:NSLayoutAttributeNotAnAttribute
          multiplier:1.0
          constant:30]
         ]];
        label;
    });
    
    _messageLabel = ({
        UILabel *label = [[UILabel alloc]init];
        label.text = message;
        label.translatesAutoresizingMaskIntoConstraints = NO;
        label.preferredMaxLayoutWidth = 260;
        label.font = [UIFont fontWithName:@"Helvetica Neue" size:18];
        label.textAlignment = NSTextAlignmentCenter;
        label.backgroundColor = [UIColor clearColor];
        label.numberOfLines = 0;
        label.textColor = _messageColor;
        [self addSubview:label];
        [self addConstraints:@[
         [NSLayoutConstraint
          constraintWithItem:label
          attribute:NSLayoutAttributeTop
          relatedBy:NSLayoutRelationEqual
          toItem:_titleLabel
          attribute:NSLayoutAttributeBottom
          multiplier:1.0
          constant:5],
         [NSLayoutConstraint
          constraintWithItem:label
          attribute:NSLayoutAttributeCenterX
          relatedBy:NSLayoutRelationEqual
          toItem:self
          attribute:NSLayoutAttributeCenterX
          multiplier:1.0
          constant:0],
         [NSLayoutConstraint
          constraintWithItem:label
          attribute:NSLayoutAttributeBottom
          relatedBy:NSLayoutRelationEqual
          toItem:self
          attribute:NSLayoutAttributeBottom
          multiplier:1.0
          constant:-64]
         ]];
        [label addConstraints:@[
         [NSLayoutConstraint
          constraintWithItem:label
          attribute:NSLayoutAttributeWidth
          relatedBy:NSLayoutRelationEqual
          toItem:nil
          attribute:NSLayoutAttributeNotAnAttribute
          multiplier:1.0
          constant:260],
         [NSLayoutConstraint
          constraintWithItem:label
          attribute:NSLayoutAttributeHeight
          relatedBy:NSLayoutRelationLessThanOrEqual
          toItem:nil
          attribute:NSLayoutAttributeNotAnAttribute
          multiplier:1.0
          constant:75]
         ]];
        label;
    });
    
    if(cancelButton && confirmButton) {
        _cancelButton = ({
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.translatesAutoresizingMaskIntoConstraints = NO;
            button.backgroundColor = _buttonColor;
            [button setTitle:cancelButton forState:UIControlStateNormal];
            button.tag = kCancelButtonTag;
            button.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-BoldItalic" size:20];
            button.titleLabel.adjustsFontSizeToFitWidth = YES;
            button.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 5);
            [button addTarget:self action:@selector(executeCompletionBlock:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:button];
            [self addConstraints:@[
             [NSLayoutConstraint
              constraintWithItem:button
              attribute:NSLayoutAttributeBottom
              relatedBy:NSLayoutRelationEqual
              toItem:self
              attribute:NSLayoutAttributeBottom
              multiplier:1.0
              constant:-10],
             [NSLayoutConstraint
              constraintWithItem:button
              attribute:NSLayoutAttributeLeft
              relatedBy:NSLayoutRelationEqual
              toItem:self
              attribute:NSLayoutAttributeLeft
              multiplier:1.0
              constant:10]
             ]];
            [button addConstraints:@[
             [NSLayoutConstraint
              constraintWithItem:button
              attribute:NSLayoutAttributeWidth
              relatedBy:NSLayoutRelationEqual
              toItem:nil
              attribute:NSLayoutAttributeNotAnAttribute
              multiplier:1.0 constant:(260 / 2) - 10],
             [NSLayoutConstraint
              constraintWithItem:button
              attribute:NSLayoutAttributeHeight
              relatedBy:NSLayoutRelationEqual
              toItem:nil
              attribute:NSLayoutAttributeNotAnAttribute
              multiplier:1.0
              constant:44]
             ]];
            button;
        });
        
        _confirmButton = ({
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.translatesAutoresizingMaskIntoConstraints = NO;
            button.backgroundColor = _buttonColor;
            button.tag = kConfirmButtonTag;
            button.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-BoldItalic" size:20];
            button.titleLabel.adjustsFontSizeToFitWidth = YES;
            button.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 5);
            [button setTitle:confirmButton forState:UIControlStateNormal];
            [button addTarget:self action:@selector(executeCompletionBlock:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:button];
            [self addConstraints:@[
             [NSLayoutConstraint
              constraintWithItem:button
              attribute:NSLayoutAttributeBottom
              relatedBy:NSLayoutRelationEqual
              toItem:self
              attribute:NSLayoutAttributeBottom
              multiplier:1.0
              constant:-10],
             [NSLayoutConstraint
              constraintWithItem:button
              attribute:NSLayoutAttributeRight
              relatedBy:NSLayoutRelationEqual
              toItem:self
              attribute:NSLayoutAttributeRight
              multiplier:1.0
              constant:-10]
             ]];
            [button addConstraints:@[
             [NSLayoutConstraint
              constraintWithItem:button
              attribute:NSLayoutAttributeWidth
              relatedBy:NSLayoutRelationEqual
              toItem:nil
              attribute:NSLayoutAttributeNotAnAttribute
              multiplier:1.0
              constant:(260 / 2) - 10],
             [NSLayoutConstraint
              constraintWithItem:button
              attribute:NSLayoutAttributeHeight
              relatedBy:NSLayoutRelationEqual
              toItem:nil
              attribute:NSLayoutAttributeNotAnAttribute
              multiplier:1.0
              constant:44]
             ]];
            button;
        });
    }
    else {
        _cancelButton = ({
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.translatesAutoresizingMaskIntoConstraints = NO;
            button.backgroundColor = _buttonColor;
            [button setTitle:cancelButton forState:UIControlStateNormal];
            button.tag = kCancelButtonTag;
            button.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-BoldItalic" size:20];
            button.titleLabel.adjustsFontSizeToFitWidth = YES;
            button.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 5);
            [button addTarget:self action:@selector(executeCompletionBlock:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:button];
            [self addConstraints:@[
             [NSLayoutConstraint
              constraintWithItem:button
              attribute:NSLayoutAttributeTop
              relatedBy:NSLayoutRelationEqual
              toItem:_messageLabel
              attribute:NSLayoutAttributeBottom
              multiplier:1.0
              constant:5],
             [NSLayoutConstraint
              constraintWithItem:button
              attribute:NSLayoutAttributeCenterX
              relatedBy:NSLayoutRelationEqual
              toItem:self
              attribute:NSLayoutAttributeCenterX
              multiplier:1.0
              constant:0],
             [NSLayoutConstraint
              constraintWithItem:button
              attribute:NSLayoutAttributeBottom
              relatedBy:NSLayoutRelationEqual
              toItem:self
              attribute:NSLayoutAttributeBottom
              multiplier:1.0
              constant:-10]
             ]];
            [button addConstraints:@[
             [NSLayoutConstraint
              constraintWithItem:button
              attribute:NSLayoutAttributeWidth
              relatedBy:NSLayoutRelationEqual
              toItem:nil
              attribute:NSLayoutAttributeNotAnAttribute
              multiplier:1.0
              constant:260],
             [NSLayoutConstraint
              constraintWithItem:button
              attribute:NSLayoutAttributeHeight
              relatedBy:NSLayoutRelationEqual
              toItem:nil
              attribute:NSLayoutAttributeNotAnAttribute
              multiplier:1.0
              constant:44]
             ]];
            button;
        });
    }
    
    self.layer.edgeAntialiasingMask = kCALayerLeftEdge | kCALayerRightEdge;
    self.backgroundColor = [UIColor clearColor];
    _viewToShowIn = view;
    
    return self;
}

+ (TLAlertView *)showInView:(UIView *)view withTitle:(NSString *)title message:(NSString *)message confirmButtonTitle:(NSString *)confim cancelButtonTitle:(NSString *)cancel {
    return [[TLAlertView alloc]initWithTitle:title message:message inView:view cancelButtonTitle:cancel confirmButton:confim];
}
#pragma mark - show in view
//Shows the view and also disables user interaction for the all the subviews that are in the presenting view, thus preserving a modal presentation
- (void)show {
    [self.viewToShowIn.subviews enumerateObjectsUsingBlock:^(UIView *obj, NSUInteger idx, BOOL *stop) {
        obj.userInteractionEnabled = NO;
    }];
    [self.viewToShowIn addSubview:self];
    NSLayoutConstraint *top = [NSLayoutConstraint
                               constraintWithItem:self
                               attribute:NSLayoutAttributeTop
                               relatedBy:NSLayoutRelationGreaterThanOrEqual
                               toItem:self.viewToShowIn
                               attribute:NSLayoutAttributeTop
                               multiplier:1.0
                               constant:-250];
    [self.viewToShowIn addConstraints:@[
     [NSLayoutConstraint
      constraintWithItem:self
      attribute:NSLayoutAttributeCenterX
      relatedBy:NSLayoutRelationEqual
      toItem:self.viewToShowIn
      attribute:NSLayoutAttributeCenterX
      multiplier:1.0
      constant:0],
     top
     ]];
    
    [self.viewToShowIn layoutSubviews];
    [self.viewToShowIn removeConstraint:top];
    [self.viewToShowIn addConstraint:[NSLayoutConstraint
                                      constraintWithItem:self
                                      attribute:NSLayoutAttributeCenterY
                                      relatedBy:NSLayoutRelationEqual
                                      toItem:self.viewToShowIn
                                      attribute:NSLayoutAttributeCenterY
                                      multiplier:1.0
                                      constant:0]];
    
    [UIView animateWithDuration:kPresentationAnimationDuration animations:^{
        self.center = self.viewToShowIn.center;
    }];
}

#pragma mark - dismiss
- (void)executeCompletionBlock:(UIButton *)sender {
    CGFloat degree = (self.TLAnimationType == TLAnimationType3D) ? 180.0 : 0.0;

    CATransform3D final = ({
        CATransform3D transformation = CATransform3DIdentity;
        CATransform3D xRotation = CATransform3DMakeRotation(degToRadians(degree), 1.0, 0, 0);
        CATransform3D yRotation = CATransform3DMakeRotation(degToRadians(0), 0.0, 1.0, 0);
        CATransform3D zRotation = CATransform3DMakeRotation(degToRadians(-130), 0.0, 0, 1.0);
        CATransform3D xYRotation = CATransform3DConcat(xRotation, yRotation);
        CATransform3D xyZRotation = CATransform3DConcat(xYRotation, zRotation);
        CATransform3D translation = CATransform3DMakeTranslation(0, CGRectGetMaxY(self.viewToShowIn.bounds), 1.0);

        CATransform3D concatenatedTransformation = CATransform3DConcat(xyZRotation, translation);
        CATransform3DConcat(concatenatedTransformation, transformation);
    });
    if(self.TLAnimationType == TLAnimationType3D)
        final.m34 = -.0045;

    [UIView animateWithDuration:kDismissAnimationDuration delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.layer.transform = final;
    }                completion:^(BOOL finished) {
        if(sender.tag == kCancelButtonTag && cancelCompletionBlock) {
            cancelCompletionBlock();
        }
        else if(sender.tag == kConfirmButtonTag && confirmCompletionBlock) {
            confirmCompletionBlock();
        }
        [self.viewToShowIn.subviews enumerateObjectsUsingBlock:^(UIView *obj, NSUInteger idx, BOOL *stop) {
            obj.userInteractionEnabled = YES;
        }];
        [self removeFromSuperview];
    }];
}
#pragma mark - set completion blocks
- (void)handleCancel:(TLCompletionBlock)cancelBlock handleConfirm:(TLCompletionBlock)confirmBlock {
    cancelCompletionBlock = [cancelBlock copy];
    confirmCompletionBlock = [confirmBlock copy];
}
#pragma mark - drawing
CGRect rectFor1PxStroke(CGRect rect) {
    return CGRectMake(rect.origin.x + 0.5, rect.origin.y + 0.5, rect.size.width - 1, rect.size.height - 1);
}

- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGRect inset = CGRectInset(self.bounds, 2, 2);

    CGContextSaveGState(context);
    CGContextSetFillColorWithColor(context, self.viewColor.CGColor);
    CGContextFillRect(context, self.bounds);
    CGContextRestoreGState(context);

    CGContextSetStrokeColorWithColor(context, self.borderColor.CGColor);
    CGContextStrokeRect(context, rectFor1PxStroke(inset));
}
#pragma mark - layout subviews
- (void)layoutSubviews {
    [super layoutSubviews];
    self.confirmButton.backgroundColor = self.buttonColor;
    self.cancelButton.backgroundColor = self.buttonColor;
    self.titleLabel.textColor = self.titleColor;
    self.messageLabel.textColor = self.messageColor;
    [self.cancelButton setTitleColor:self.cancelTextColor forState:UIControlStateNormal];
    [self.confirmButton setTitleColor:self.confirmTextColor forState:UIControlStateNormal];
}
@end
