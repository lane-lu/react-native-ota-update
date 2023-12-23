#import "AppDelegate.h"

#import <React/RCTBundleURLProvider.h>

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
  self.moduleName = @"OtaUpdateExample";
  // You can add your custom initial props in the dictionary below.
  // They will be passed down to the ViewController used by React Native.
  self.initialProps = @{};

  return [super application:application didFinishLaunchingWithOptions:launchOptions];
}

- (NSURL *)sourceURLForBridge:(RCTBridge *)bridge
{
  NSURL *bundleURL = nil;
  NSString *version = [[NSUserDefaults standardUserDefaults] stringForKey:@"x-main-jsbundle-version"];
  if (version != nil) {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *bundle = [NSString stringWithFormat:@"%@/CodePush/%@/main.jsbundle", documentsDirectory, version];
    if ([[NSFileManager defaultManager] fileExistsAtPath:bundle]) {
      bundleURL = [NSURL fileURLWithPath:bundle];
    }
  }
  
  if (bundleURL != nil) {
    return bundleURL;
  } else {
#if DEBUG
    return [[RCTBundleURLProvider sharedSettings] jsBundleURLForBundleRoot:@"index"];
#else
    return [[NSBundle mainBundle] URLForResource:@"main" withExtension:@"jsbundle"];
#endif
  }
}

@end
