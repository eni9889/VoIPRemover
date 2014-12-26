#import "version.h"

//#define IS_IOS_OR_NEWER

@interface SBApplication : NSObject
@property (nonatomic, retain) NSString *bundleIdentifier;
@property (nonatomic, retain) NSString *displayIdentifier;
@end

static BOOL isEnabledFacebook;
static BOOL isEnabledMessenger;
static BOOL isEnabledSkype;

%hook SBApplication
- (BOOL)supportsVOIPBackgroundMode{
    if(!IS_IOS_OR_NEWER(iOS_8_0)){
    if ([self.displayIdentifier isEqualToString:@"com.facebook.Facebook"]){
        return !isEnabledFacebook;
    } else if ([self.displayIdentifier isEqualToString:@"com.facebook.Messenger"]){
        return !isEnabledMessenger;
    } else if ([self.displayIdentifier isEqualToString:@"com.skype.skype"]){
    return !isEnabledSkype;
  } else {
    return %orig;
    }
     } else {
        if ([self.bundleIdentifier isEqualToString:@"com.facebook.Facebook"]){
        return !isEnabledFacebook;
    } else if ([self.bundleIdentifier isEqualToString:@"com.facebook.Messenger"]){
        return !isEnabledMessenger;
    } else if ([self.bundleIdentifier isEqualToString:@"com.skype.skype"]){
    return !isEnabledSkype;
  } else {
    return %orig;
        }
    }
}
%end

static void loadPreferences() {
    CFPreferencesAppSynchronize(CFSTR("com.greeny.voipremover"));

    isEnabledFacebook = [(id)CFPreferencesCopyAppValue(CFSTR("isEnabledFacebook"), CFSTR("com.greeny.voipremover")) boolValue];
    isEnabledMessenger = [(id)CFPreferencesCopyAppValue(CFSTR("isEnabledMessenger"), CFSTR("com.greeny.voipremover")) boolValue];
    isEnabledSkype = [(id)CFPreferencesCopyAppValue(CFSTR("isEnabledSkype"), CFSTR("com.greeny.voipremover")) boolValue];
}

%ctor {
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(),
                                NULL,
                                (CFNotificationCallback)loadPreferences,
                                CFSTR("com.greeny.voipremover/prefsChanged"),
                                NULL,
                                CFNotificationSuspensionBehaviorDeliverImmediately);
    loadPreferences();
}