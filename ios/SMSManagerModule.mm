#import "SMSManagerModule.h"
#import <React/RCTUtils.h>

@interface SMSManagerModule ()

@property (nonatomic, copy) RCTPromiseResolveBlock resolve;
@property (nonatomic, copy) RCTPromiseRejectBlock reject;

@end

@implementation SMSManagerModule

RCT_EXPORT_MODULE(SMSManager)

- (void)sendSMS:(NSString *)phoneNumber message:(NSString *)message resolve:(RCTPromiseResolveBlock)resolve reject:(RCTPromiseRejectBlock)reject {
    if (![MFMessageComposeViewController canSendText]) {
        reject(@"SMS_UNAVAILABLE", @"This device cannot send text messages", nil);
        return;
    }

    self.resolve = resolve;
    self.reject = reject;

    dispatch_async(dispatch_get_main_queue(), ^{
        MFMessageComposeViewController *composeVC = [[MFMessageComposeViewController alloc] init];
        composeVC.messageComposeDelegate = self;
        if (phoneNumber && phoneNumber.length > 0) {
            composeVC.recipients = @[phoneNumber];
        }
        composeVC.body = message;

        UIViewController *rootVC = [self topViewController];
        if (rootVC) {
            [rootVC presentViewController:composeVC animated:YES completion:nil];
        } else {
            reject(@"NO_VIEW_CONTROLLER", @"Could not find a view controller to present composer", nil);
        }
    });
}

- (void)isSMSAvailable:(RCTPromiseResolveBlock)resolve reject:(RCTPromiseRejectBlock)reject {
    resolve(@([MFMessageComposeViewController canSendText]));
}

- (void)checkSMSPermission:(RCTPromiseResolveBlock)resolve reject:(RCTPromiseRejectBlock)reject {
    // iOS doesn't have a background SMS permission for apps.
    // Opening the composer is always user-authorized.
    resolve(@"granted");
}

- (void)requestSMSPermission:(RCTPromiseResolveBlock)resolve reject:(RCTPromiseRejectBlock)reject {
    resolve(@"granted");
}

#pragma mark - MFMessageComposeViewControllerDelegate

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result {
    [controller dismissViewControllerAnimated:YES completion:^{
        if (self.resolve) {
            switch (result) {
                case MessageComposeResultCancelled:
                    self.resolve(@"cancelled");
                    break;
                case MessageComposeResultSent:
                    self.resolve(@"sent");
                    break;
                case MessageComposeResultFailed:
                    if (self.reject) {
                        self.reject(@"SMS_FAILED", @"SMS sending failed", nil);
                    }
                    break;
                default:
                    self.resolve(@"unknown");
                    break;
            }
            self.resolve = nil;
            self.reject = nil;
        }
    }];
}

#pragma mark - Helpers

- (UIViewController *)topViewController {
    UIViewController *rootViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    UIViewController *topViewController = rootViewController;
    while (topViewController.presentedViewController) {
        topViewController = topViewController.presentedViewController;
    }
    return topViewController;
}

#ifdef RCT_NEW_ARCH_ENABLED
- (std::shared_ptr<facebook::react::TurboModule>)getTurboModule:(const facebook::react::ObjCTurboModule::InitParams &)params {
    return std::make_shared<facebook::react::NativeSMSManagerSpecJSI>(params);
}
#endif

@end
