//
//  TLAlertView.h
//  TLAlertView
//
//  Created by Terry Lewis II on 5/31/13.
//  Copyright (c) 2013 Terry Lewis. All rights reserved.
//

#import <UIKit/UIKit.h>

///Animation styles
typedef NS_ENUM(NSUInteger, TLAnimationType) {
    TLAnimationType3D,
    tLAnimationTypeHinge
};

@interface TLAlertView : UIView

///Used as the completion block
typedef void ((^TLCompletionBlock)()); 

///Convenience initializer, must have a non null cancel button title,, but null confirm is ok.
+ (TLAlertView *)__attribute__((nonnull(1, 2, 3, 5))) showInView:(UIView *)view withTitle:(NSString *)title message:(NSString *)message confirmButtonTitle:(NSString *)confirm cancelButtonTitle:(NSString *)cancel;

///Normal initializer
- (TLAlertView *)__attribute__((nonnull(1, 2, 3, 4))) initWithTitle:(NSString *)title message:(NSString *)message inView:(UIView *)view cancelButtonTitle:(NSString *)cancelButton confirmButton:(NSString *)confirmButton;

///easy one shot call to handle both confirm or cancel buttons, either can be nil;
- (void)handleCancel:(TLCompletionBlock)cancelBlock handleConfirm:(TLCompletionBlock)confirmBlock;

///Presents the alert in the view that was passed in
- (void)show;

///The background color of the view
@property(strong,nonatomic)UIColor *viewColor UI_APPEARANCE_SELECTOR;

///The color of the border
@property(strong,nonatomic)UIColor *borderColor; UI_APPEARANCE_SELECTOR

///The color of the buttons
@property(strong,nonatomic)UIColor *buttonColor; UI_APPEARANCE_SELECTOR

///The color of the title label
@property(strong,nonatomic)UIColor *titleColor; UI_APPEARANCE_SELECTOR

///The color of the message label
@property(strong,nonatomic)UIColor *messageColor; UI_APPEARANCE_SELECTOR

///The color of the confirm button text
@property(strong,nonatomic)UIColor *confirmTextColor; UI_APPEARANCE_SELECTOR

///The color of the cancel button text
@property(strong,nonatomic)UIColor *cancelTextColor; UI_APPEARANCE_SELECTOR

///Choose which animation type, a 3D effect or a simple 2D hinge effect
@property(nonatomic)NSUInteger TLAnimationType;

@end
