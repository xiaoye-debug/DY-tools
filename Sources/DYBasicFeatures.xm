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

    // 评论时间接口传入的是 Unix 时间戳。这里必须把时间戳转换成可读日期，
    // 不能直接把数字时间戳返回给 UILabel，否则评论区会显示一串数字。
    // 同时兼容少数接口返回的毫秒级时间戳。
    NSTimeInterval seconds = timestamp;
    if (seconds > 100000000000.0) {
        seconds /= 1000.0;
    }

    NSDate *date = [NSDate dateWithTimeIntervalSince1970:seconds];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    formatter.calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    formatter.timeZone = [NSTimeZone localTimeZone];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";

    return [formatter stringFromDate:date];
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
