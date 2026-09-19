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


#pragma mark - 提高视频画质

@interface AWEVideoBSModel : NSObject
- (NSNumber *)bitrate;
- (id)playAddr;
@end

@interface AWEVideoModel : NSObject
- (NSArray *)bitrateModels;
- (id)playURL;
@end

%hook AWEVideoModel

- (id)playURL {
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"DYYYEnableVideoHighestQuality"]) {
        return %orig;
    }

    NSArray *models = nil;
    @try {
        models = [self bitrateModels];
    } @catch (__unused NSException *e) {
        models = nil;
    }

    if (![models isKindOfClass:[NSArray class]] || models.count == 0) {
        return %orig;
    }

    id highestModel = nil;
    NSInteger highestBitrate = 0;

    for (id model in models) {
        if (![model isKindOfClass:NSClassFromString(@"AWEVideoBSModel")]) {
            continue;
        }

        NSNumber *bitrate = nil;
        @try {
            bitrate = [model bitrate];
        } @catch (__unused NSException *e) {
            bitrate = nil;
        }

        NSInteger value = [bitrate respondsToSelector:@selector(integerValue)] ? [bitrate integerValue] : 0;
        if (value > highestBitrate) {
            highestBitrate = value;
            highestModel = model;
        }
    }

    if (highestModel) {
        id playAddr = nil;
        @try {
            playAddr = [highestModel playAddr];
        } @catch (__unused NSException *e) {
            playAddr = nil;
        }

        if (playAddr) {
            return playAddr;
        }
    }

    return %orig;
}

- (NSArray *)bitrateModels {
    NSArray *originalModels = %orig;

    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"DYYYEnableVideoHighestQuality"]) {
        return originalModels;
    }

    if (![originalModels isKindOfClass:[NSArray class]] || originalModels.count == 0) {
        return originalModels;
    }

    id highestModel = nil;
    NSInteger highestBitrate = 0;

    for (id model in originalModels) {
        if (![model isKindOfClass:NSClassFromString(@"AWEVideoBSModel")]) {
            continue;
        }

        NSNumber *bitrate = nil;
        @try {
            bitrate = [model bitrate];
        } @catch (__unused NSException *e) {
            bitrate = nil;
        }

        NSInteger value = [bitrate respondsToSelector:@selector(integerValue)] ? [bitrate integerValue] : 0;
        if (value > highestBitrate) {
            highestBitrate = value;
            highestModel = model;
        }
    }

    if (highestModel) {
        return @[highestModel];
    }

    return originalModels;
}

%end


#pragma mark - 自动播放

/*
 * DYYY 原版通过 AutoPlay group 动态启用以下几个入口。
 * 这里改成独立文件内按开关判断，避免跨 Logos 文件调用 %init(group)。
 */
@interface AWEAwemeDetailTableViewController : UIViewController
- (BOOL)hasIphoneAutoPlaySwitch;
@end

%hook AWEAwemeDetailTableViewController

- (BOOL)hasIphoneAutoPlaySwitch {
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"DYYYEnableAutoPlay"]) {
        return YES;
    }
    return %orig;
}

%end

@interface AWEAwemeDetailContainerPlayControlConfig : NSObject
- (BOOL)enableUserProfilePostAutoPlay;
@end

%hook AWEAwemeDetailContainerPlayControlConfig

- (BOOL)enableUserProfilePostAutoPlay {
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"DYYYEnableAutoPlay"]) {
        return YES;
    }
    return %orig;
}

%end

@interface AWEFeedIPhoneAutoPlayManager : NSObject
- (BOOL)isAutoPlayOpen;
- (BOOL)getFeedIphoneAutoPlayState;
@end

%hook AWEFeedIPhoneAutoPlayManager

- (BOOL)isAutoPlayOpen {
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"DYYYEnableAutoPlay"]) {
        return YES;
    }
    return %orig;
}

- (BOOL)getFeedIphoneAutoPlayState {
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"DYYYEnableAutoPlay"]) {
        return YES;
    }
    return %orig;
}

%end

@interface AWEFeedModuleService : NSObject
- (BOOL)getFeedIphoneAutoPlayState;
@end

%hook AWEFeedModuleService

- (BOOL)getFeedIphoneAutoPlayState {
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"DYYYEnableAutoPlay"]) {
        return YES;
    }
    return %orig;
}

%end

#pragma mark - 屏蔽广告

@interface AWEAwemeModel : NSObject
@property(nonatomic, assign) BOOL isAds;
@end

%hook AWEAwemeModel

- (id)initWithDictionary:(id)arg1 error:(id *)arg2 {
    id result = %orig;

    if (result &&
        [[NSUserDefaults standardUserDefaults] boolForKey:@"DYYYNoAds"]) {
        BOOL isAd = NO;

        @try {
            isAd = [(AWEAwemeModel *)result isAds];
        } @catch (__unused NSException *e) {
            isAd = NO;
        }

        if (isAd) {
            return nil;
        }
    }

    return result;
}

%end


#pragma mark - 倍速与首页交互补充

@interface AWEPlayInteractionSpeedController : NSObject
- (void)changeSpeed:(double)speed;
- (void)handleLongPressFastSpeed:(UILongPressGestureRecognizer *)gesture;
@end

static BOOL DYToolsSpeedGestureActive = NO;
static CGFloat DYToolsGestureSpeed = 2.0;
static CGFloat DYToolsInitialTouchY = 0.0;

%hook AWEPlayInteractionSpeedController

- (void)handleLongPressFastSpeed:(UILongPressGestureRecognizer *)gesture {
    %orig;

    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"DYYYEnableLongPressSpeedGesture"]) {
        return;
    }

    CGPoint point = [gesture locationInView:gesture.view];

    if (gesture.state == UIGestureRecognizerStateBegan) {
        DYToolsInitialTouchY = point.y;
        DYToolsSpeedGestureActive = YES;

        CGFloat configured = [[NSUserDefaults standardUserDefaults] floatForKey:@"DYYYLongPressSpeed"];
        DYToolsGestureSpeed = configured > 0.0 ? configured : 2.0;
        [self changeSpeed:DYToolsGestureSpeed];
        return;
    }

    if (gesture.state == UIGestureRecognizerStateChanged && DYToolsSpeedGestureActive) {
        CGFloat deltaY = point.y - DYToolsInitialTouchY;
        if (fabs(deltaY) >= 10.0) {
            CGFloat nextSpeed = DYToolsGestureSpeed + (deltaY > 0.0 ? -0.25 : 0.25);
            nextSpeed = MAX(0.5, MIN(3.0, nextSpeed));

            if (fabs(nextSpeed - DYToolsGestureSpeed) > 0.001) {
                DYToolsGestureSpeed = nextSpeed;
                DYToolsInitialTouchY = point.y;
                [self changeSpeed:DYToolsGestureSpeed];
            }
        }
        return;
    }

    if (gesture.state == UIGestureRecognizerStateEnded ||
        gesture.state == UIGestureRecognizerStateCancelled ||
        gesture.state == UIGestureRecognizerStateFailed) {
        DYToolsSpeedGestureActive = NO;
        DYToolsInitialTouchY = 0.0;
    }
}

%end

#pragma mark - 自动恢复默认倍速

@interface AWEAwemePlayVideoViewController : UIViewController
- (void)setVideoControllerPlaybackRate:(float)rate;
@end

%hook AWEAwemePlayVideoViewController

- (void)prepareForDisplay {
    %orig;

    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"DYYYAutoRestoreSpeed"]) {
        return;
    }

    @try {
        [self setVideoControllerPlaybackRate:1.0f];
    } @catch (__unused NSException *e) {
    }
}

%end

@interface AWEDPlayerFeedPlayerViewController : UIViewController
- (void)setVideoControllerPlaybackRate:(float)rate;
@end

%hook AWEDPlayerFeedPlayerViewController

- (void)prepareForDisplay {
    %orig;

    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"DYYYAutoRestoreSpeed"]) {
        return;
    }

    @try {
        [self setVideoControllerPlaybackRate:1.0f];
    } @catch (__unused NSException *e) {
    }
}

%end

#pragma mark - 禁用双击视频点赞

@interface AFDPureModePageTapController : NSObject
- (void)onVideoPlayerViewDoubleClicked:(id)arg1;
@end

%hook AFDPureModePageTapController

- (void)onVideoPlayerViewDoubleClicked:(id)arg1 {
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"DYYYDisableDoubleTapLike"]) {
        return;
    }
    %orig;
}

%end

@interface AWEPlayInteractionViewController : UIViewController
- (void)onVideoPlayerViewDoubleClicked:(id)arg1;
@end

%hook AWEPlayInteractionViewController

- (void)onVideoPlayerViewDoubleClicked:(id)arg1 {
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"DYYYDisableDoubleTapLike"]) {
        return;
    }
    %orig;
}

%end


#pragma mark - 显示视频进度时长

@interface AWEFeedProgressSlider : UIView
- (void)dyyy_updateScheduleLabelsLegacyWithCurrentTime:(CGFloat)currentTime totalDuration:(CGFloat)totalDuration model:(id)model;
@end

%hook AWEFeedProgressSlider

- (void)setAlpha:(CGFloat)alpha {
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"DYYYShowScheduleDisplay"] &&
        ![[NSUserDefaults standardUserDefaults] boolForKey:@"DYYYHideVideoProgress"]) {
        %orig(1.0);
        return;
    }
    %orig(alpha);
}

- (void)layoutSubviews {
    %orig;

    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"DYYYShowScheduleDisplay"]) {
        return;
    }

    id model = nil;
    @try { model = [self valueForKey:@"model"]; } @catch (__unused NSException *e) {}

    CGFloat duration = 0.0;
    @try { duration = [[model valueForKey:@"videoDuration"] doubleValue] / 1000.0; } @catch (__unused NSException *e) {}

    // 初次布局时至少建立时间标签；播放进度更新由原控制器调用时继续刷新。
    [self dyyy_updateScheduleLabelsLegacyWithCurrentTime:0.0 totalDuration:duration model:model];
}

%end
