//
//  GHRootViewController.h
//  GHSidebarNav
//
//  Created by Greg Haines on 11/20/11.
//

#import <Foundation/Foundation.h>
#import <MessageUI/MessageUI.h>

enum {
    SVWebViewControllerAvailableActionsNone             = 0,
    SVWebViewControllerAvailableActionsOpenInSafari     = 1 << 0,
    SVWebViewControllerAvailableActionsMailLink         = 1 << 1,
    SVWebViewControllerAvailableActionsCopyLink         = 1 << 2
};

typedef NSUInteger SVWebViewControllerAvailableActions;


typedef void (^RevealBlock)();
//UIViewController
@interface GHRootViewController : UIViewController <UIWebViewDelegate,UIGestureRecognizerDelegate>{
    
    NSURL *webURL;
    UIActivityIndicatorView *activityIndicator;
@private
	RevealBlock _revealBlock;
}

@property (nonatomic, strong) NSURL *webURL;
@property (nonatomic, strong) UIActivityIndicatorView *activityIndicator;
@property (nonatomic, readwrite) SVWebViewControllerAvailableActions availableActions;

- (id)initWithTitle:(NSString *)title withUrl:(NSString *)url withRevealBlock:(RevealBlock)revealBlock;

@end
