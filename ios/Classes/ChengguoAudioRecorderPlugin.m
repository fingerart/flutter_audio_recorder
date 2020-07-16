#import "ChengguoAudioRecorderPlugin.h"
#import <chengguo_audio_recorder/chengguo_audio_recorder-Swift.h>

@implementation ChengguoAudioRecorderPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftChengguoAudioRecorderPlugin registerWithRegistrar:registrar];
}
@end
