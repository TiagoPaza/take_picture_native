#import "TakePictureNativePlugin.h"
#if __has_include(<take_picture_native/take_picture_native-Swift.h>)
#import <take_picture_native/take_picture_native-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "take_picture_native-Swift.h"
#endif

@implementation TakePictureNativePlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftTakePictureNativePlugin registerWithRegistrar:registrar];
}
@end
