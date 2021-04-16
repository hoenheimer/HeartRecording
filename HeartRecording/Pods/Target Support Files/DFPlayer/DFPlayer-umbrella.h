#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "DFPlayer.h"
#import "DFPlayerModel.h"
#import "DFPlayerUIManager.h"
#import "DFPlayerFileManager.h"
#import "DFPlayerLyricsTableview.h"
#import "DFPlayerRequestManager.h"
#import "DFPlayerResourceLoader.h"
#import "DFPlayerTool.h"
#import "DFPlayer_AFNetworkReachabilityManager.h"

FOUNDATION_EXPORT double DFPlayerVersionNumber;
FOUNDATION_EXPORT const unsigned char DFPlayerVersionString[];

