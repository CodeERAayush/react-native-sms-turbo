#import <Foundation/Foundation.h>
#import <MessageUI/MessageUI.h>

#ifdef RCT_NEW_ARCH_ENABLED
#import "SMSManagerSpec.h"
#endif

NS_ASSUME_NONNULL_BEGIN

@interface SMSManagerModule : NSObject <
#ifdef RCT_NEW_ARCH_ENABLED
  NativeSMSManagerSpec,
#endif
  MFMessageComposeViewControllerDelegate
>

@end

NS_ASSUME_NONNULL_END
