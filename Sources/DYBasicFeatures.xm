#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

#pragma mark - DYYY migrated basic features

/*
 * 这部分单独拆文件，避免继续改动已经稳定的 DYFullScreen.xm。
 * 所有逻辑均按 DYYY 当前源码中的真实 Hook 迁移。
 */

#pragma mark 评论具体时间

@interface AWEDateTimeFormatter : NSObject
+ (id)formattedDateForTimestamp:(double)timestamp;
@end

%hook AWEDateTimeFormatter

+ (id)formattedDateForTimestamp:(double)timestamp {
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"DYYYCommentExactTime"]) {
        return %orig(timestamp);
    }

    // DYYY 原逻辑：返回 Unix 时间戳字符串，随后由评论时间显示链路处理。
    return [NSString stringWithFormat:@"%.0f ", timestamp];
}

%end

#pragma mark 直播真实人数

@interface IESLiveUserSeqlistFragment : NSObject
- (void)refreshVerticalUserCount:(id)arg1
             horizontalUserCount:(id)arg2
                       trueValue:(NSInteger)trueValue;
@end

%hook IESLiveUserSeqlistFragment

- (void)refreshVerticalUserCount:(id)arg1
             horizontalUserCount:(id)arg2
                       trueValue:(NSInteger)trueValue {
    if (trueValue > 0 &&
        [[NSUserDefaults standardUserDefaults] boolForKey:@"DYYYEnableLiveRealCount"]) {

        NSString *realStr = [NSString stringWithFormat:@"%ld", (long)trueValue];
        %orig(realStr, realStr, trueValue);
        return;
    }

    %orig;
}

%end

#pragma mark 隐藏系统状态栏

@interface AWEAwemeHotSpotTableViewController : UIViewController
@end

%hook AWEAwemeHotSpotTableViewController

- (BOOL)prefersStatusBarHidden {
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"DYYYHideStatusbar"]) {
        return YES;
    }
    return %orig;
}

%end


#pragma mark 后台播放

@interface AWEAwemeStatusModel : NSObject
- (void)setListenVideoStatus:(NSInteger)status;
@end

%hook AWEAwemeStatusModel

- (void)setListenVideoStatus:(NSInteger)status {
    if (status == 1 &&
        [[NSUserDefaults standardUserDefaults] boolForKey:@"DYYYEnableBackgroundListen"]) {
        status = 2;
    }
    %orig(status);
}

%end

#pragma mark 屏蔽直播 PCDN

@interface HTSLiveStreamPcdnManager : NSObject
+ (void)start;
+ (void)configAndStartLiveIO;
@end

%hook HTSLiveStreamPcdnManager

+ (void)start {
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"DYYYDisableLivePCDN"]) {
        %orig;
    }
}

+ (void)configAndStartLiveIO {
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"DYYYDisableLivePCDN"]) {
        %orig;
    }
}

%end
