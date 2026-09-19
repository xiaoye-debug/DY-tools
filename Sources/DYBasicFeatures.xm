#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <objc/runtime.h>
#import <objc/message.h>
#import <math.h>

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
- (CGFloat)longPressFastSpeedValue;
- (void)changeSpeed:(double)speed;
- (void)handleLongPressFastSpeed:(UILongPressGestureRecognizer *)gesture;
@end

static BOOL DYToolsHasChangedSpeed = NO;
static CGFloat DYToolsCurrentLongPressSpeed = 0.0;
static BOOL DYToolsSpeedGestureActive = NO;

%hook AWEPlayInteractionSpeedController

- (CGFloat)longPressFastSpeedValue {
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"DYYYEnableLongPressSpeedGesture"]) {
        return %orig;
    }

    float longPressSpeed = [[NSUserDefaults standardUserDefaults] floatForKey:@"DYYYLongPressSpeed"];
    if (longPressSpeed == 0.0f) {
        longPressSpeed = 2.0f;
    }
    return longPressSpeed;
}

- (void)changeSpeed:(double)speed {
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"DYYYEnableLongPressSpeedGesture"]) {
        %orig;
        return;
    }

    float longPressSpeed = [[NSUserDefaults standardUserDefaults] floatForKey:@"DYYYLongPressSpeed"];
    if (longPressSpeed == 0.0f) {
        longPressSpeed = 2.0f;
    }

    if (DYToolsSpeedGestureActive && DYToolsCurrentLongPressSpeed > 0.0) {
        %orig(DYToolsCurrentLongPressSpeed);
        return;
    }

    if (speed == 2.0) {
        if (!DYToolsHasChangedSpeed) {
            if (longPressSpeed != 2.0f) {
                DYToolsHasChangedSpeed = YES;
                %orig(longPressSpeed);
                return;
            }
        } else {
            DYToolsHasChangedSpeed = NO;
            %orig(1.0);
            return;
        }
    }

    if (longPressSpeed == 2.0f) {
        %orig(speed);
        return;
    }
}

- (void)handleLongPressFastSpeed:(UILongPressGestureRecognizer *)gesture {
    %orig;

    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"DYYYEnableLongPressSpeedGesture"]) {
        return;
    }

    CGPoint location = [gesture locationInView:gesture.view];
    static CGFloat initialTouchY = 0.0;

    if (gesture.state == UIGestureRecognizerStateBegan) {
        initialTouchY = location.y;
        DYToolsSpeedGestureActive = YES;

        float longPressSpeed = [[NSUserDefaults standardUserDefaults] floatForKey:@"DYYYLongPressSpeed"];
        if (longPressSpeed == 0.0f) {
            longPressSpeed = 2.0f;
        }
        DYToolsCurrentLongPressSpeed = longPressSpeed;
    } else if (gesture.state == UIGestureRecognizerStateChanged && DYToolsSpeedGestureActive) {
        CGFloat deltaY = location.y - initialTouchY;
        if (fabs(deltaY) > 10.0) {
            CGFloat speedChange = (deltaY > 0.0) ? 0.25 : -0.25;
            CGFloat newSpeed = DYToolsCurrentLongPressSpeed + speedChange;
            newSpeed = MAX(0.5, MIN(3.0, newSpeed));

            if (fabs(newSpeed - DYToolsCurrentLongPressSpeed) > 0.001) {
                DYToolsCurrentLongPressSpeed = newSpeed;
                initialTouchY = location.y;
                [self changeSpeed:DYToolsCurrentLongPressSpeed];
            }
        }
    } else if (gesture.state == UIGestureRecognizerStateEnded ||
               gesture.state == UIGestureRecognizerStateCancelled) {
        DYToolsSpeedGestureActive = NO;
        DYToolsCurrentLongPressSpeed = 0.0;
        initialTouchY = 0.0;
    }
}

%end

#pragma mark - 自动恢复默认倍速

@interface AWEAwemePlayVideoViewController : UIViewController
- (void)setVideoControllerPlaybackRate:(float)rate;
- (void)adjustPlaybackSpeed:(float)speed;
@end

%hook AWEAwemePlayVideoViewController

- (void)setIsAutoPlay:(BOOL)arg0 {
    %orig(arg0);

    float defaultSpeed = [[NSUserDefaults standardUserDefaults] floatForKey:@"DYYYDefaultSpeed"];
    if (defaultSpeed > 0.0f && defaultSpeed != 1.0f) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self setVideoControllerPlaybackRate:defaultSpeed];
        });
    }
}

- (void)prepareForDisplay {
    %orig;

    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"DYYYAutoRestoreSpeed"]) {
        [self setVideoControllerPlaybackRate:1.0f];
    }
}

%end

@interface AWEDPlayerFeedPlayerViewController : UIViewController
- (void)setVideoControllerPlaybackRate:(float)rate;
- (void)adjustPlaybackSpeed:(float)speed;
@end

%hook AWEDPlayerFeedPlayerViewController

- (void)setIsAutoPlay:(BOOL)arg0 {
    %orig(arg0);

    float defaultSpeed = [[NSUserDefaults standardUserDefaults] floatForKey:@"DYYYDefaultSpeed"];
    if (defaultSpeed > 0.0f && defaultSpeed != 1.0f) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self setVideoControllerPlaybackRate:defaultSpeed];
        });
    }
}

- (void)prepareForDisplay {
    %orig;

    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"DYYYAutoRestoreSpeed"]) {
        [self setVideoControllerPlaybackRate:1.0f];
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


static const void *kDYYYLiveDurationViewKey = &kDYYYLiveDurationViewKey;
static const void *kDYYYLiveDurationTimerKey = &kDYYYLiveDurationTimerKey;
static const void *kDYYYLiveDurationRoomKey = &kDYYYLiveDurationRoomKey;
static NSString *const kDYYYLiveDurationCenterXPercentKey = @"DYYYLiveDurationCenterXPercent";
static NSString *const kDYYYLiveDurationCenterYPercentKey = @"DYYYLiveDurationCenterYPercent";
static NSString *const kDYYYLiveDurationPositionLockedKey = @"DYYYLiveDurationPositionLocked";

static UIEdgeInsets DYYYLiveDurationSafeInsets(UIView *root) {
    return [root respondsToSelector:@selector(safeAreaInsets)] ? root.safeAreaInsets : UIEdgeInsetsZero;
}

static CGPoint DYYYLiveDurationClampedCenter(CGPoint center, CGSize viewSize, UIView *root) {
    if (!root) {
        return center;
    }

    UIEdgeInsets safeInsets = DYYYLiveDurationSafeInsets(root);
    CGFloat halfWidth = viewSize.width / 2.0;
    CGFloat halfHeight = viewSize.height / 2.0;
    CGFloat minX = safeInsets.left + halfWidth + 4.0;
    CGFloat maxX = fmax(minX, CGRectGetWidth(root.bounds) - safeInsets.right - halfWidth - 4.0);
    CGFloat minY = safeInsets.top + halfHeight + 4.0;
    CGFloat maxY = fmax(minY, CGRectGetHeight(root.bounds) - safeInsets.bottom - halfHeight - 4.0);
    return CGPointMake(fmin(fmax(center.x, minX), maxX), fmin(fmax(center.y, minY), maxY));
}

@interface DYYYLiveDurationWeakViewBox : NSObject
@property(nonatomic, weak) UIView *view;
@end

@implementation DYYYLiveDurationWeakViewBox
@end

@interface DYYYLiveDurationView : UIView
@property(nonatomic, strong) UILabel *durationLabel;
@property(nonatomic, assign, getter=isDragging) BOOL dragging;
@property(nonatomic, assign, getter=isMovementLocked) BOOL movementLocked;
- (CGRect)frameByApplyingSavedPositionToFrame:(CGRect)frame inRoot:(UIView *)root;
@end

@implementation DYYYLiveDurationView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = YES;
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.42];
        self.layer.cornerRadius = 7.0;
        self.layer.masksToBounds = YES;
        self.layer.borderColor = [[UIColor whiteColor] colorWithAlphaComponent:0.12].CGColor;
        self.layer.borderWidth = 0.5;
        self.accessibilityIdentifier = @"dyyy_live_duration_view";

        _durationLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _durationLabel.textColor = [UIColor whiteColor];
        _durationLabel.font = [UIFont systemFontOfSize:12.0 weight:UIFontWeightSemibold];
        _durationLabel.textAlignment = NSTextAlignmentCenter;
        _durationLabel.adjustsFontSizeToFitWidth = YES;
        _durationLabel.minimumScaleFactor = 0.75;
        _durationLabel.shadowColor = [[UIColor blackColor] colorWithAlphaComponent:0.75];
        _durationLabel.shadowOffset = CGSizeMake(0.0, 1.0);
        [self addSubview:_durationLabel];

        _movementLocked = [[NSUserDefaults standardUserDefaults] boolForKey:kDYYYLiveDurationPositionLockedKey];

        UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
        longPressGesture.minimumPressDuration = 0.5;
        [self addGestureRecognizer:longPressGesture];

        UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
        [panGesture requireGestureRecognizerToFail:longPressGesture];
        [self addGestureRecognizer:panGesture];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.durationLabel.frame = CGRectInset(self.bounds, 7.0, 2.0);
}

- (void)handlePan:(UIPanGestureRecognizer *)gesture {
    UIView *root = self.superview;
    if (self.isMovementLocked || !root) {
        return;
    }

    if (gesture.state == UIGestureRecognizerStateBegan) {
        self.dragging = YES;
        self.alpha = 0.8;
    }

    if (gesture.state == UIGestureRecognizerStateBegan || gesture.state == UIGestureRecognizerStateChanged) {
        CGPoint translation = [gesture translationInView:root];
        CGPoint newCenter = CGPointMake(self.center.x + translation.x, self.center.y + translation.y);
        self.center = DYYYLiveDurationClampedCenter(newCenter, self.bounds.size, root);
        [gesture setTranslation:CGPointZero inView:root];
    }

    if (gesture.state == UIGestureRecognizerStateEnded || gesture.state == UIGestureRecognizerStateCancelled || gesture.state == UIGestureRecognizerStateFailed) {
        self.dragging = NO;
        self.alpha = 1.0;
        [self savePosition];
    }
}

- (void)handleLongPress:(UILongPressGestureRecognizer *)gesture {
    if (gesture.state != UIGestureRecognizerStateBegan) {
        return;
    }

    self.movementLocked = !self.isMovementLocked;
    [[NSUserDefaults standardUserDefaults] setBool:self.isMovementLocked forKey:kDYYYLiveDurationPositionLockedKey];
    if (self.isMovementLocked) {
        [self savePosition];
    }

    NSLog(@"[DYTools] 开播时长位置 %@", self.isMovementLocked ? @"已锁定" : @"已解锁");
    if (@available(iOS 10.0, *)) {
        UIImpactFeedbackGenerator *generator = [[UIImpactFeedbackGenerator alloc] initWithStyle:UIImpactFeedbackStyleLight];
        [generator prepare];
        [generator impactOccurred];
    }
}

- (void)savePosition {
    UIView *root = self.superview;
    if (!root) {
        return;
    }

    CGFloat rootWidth = CGRectGetWidth(root.bounds);
    CGFloat rootHeight = CGRectGetHeight(root.bounds);
    if (rootWidth <= 0.0 || rootHeight <= 0.0) {
        return;
    }

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setDouble:self.center.x / rootWidth forKey:kDYYYLiveDurationCenterXPercentKey];
    [defaults setDouble:self.center.y / rootHeight forKey:kDYYYLiveDurationCenterYPercentKey];
}

- (CGRect)frameByApplyingSavedPositionToFrame:(CGRect)frame inRoot:(UIView *)root {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if (![defaults objectForKey:kDYYYLiveDurationCenterXPercentKey] || ![defaults objectForKey:kDYYYLiveDurationCenterYPercentKey]) {
        return frame;
    }

    CGFloat rootWidth = CGRectGetWidth(root.bounds);
    CGFloat rootHeight = CGRectGetHeight(root.bounds);
    if (rootWidth <= 0.0 || rootHeight <= 0.0) {
        return frame;
    }

    CGFloat centerXPercent = fmin(fmax([defaults doubleForKey:kDYYYLiveDurationCenterXPercentKey], 0.0), 1.0);
    CGFloat centerYPercent = fmin(fmax([defaults doubleForKey:kDYYYLiveDurationCenterYPercentKey], 0.0), 1.0);
    CGPoint center = CGPointMake(centerXPercent * rootWidth, centerYPercent * rootHeight);
    center = DYYYLiveDurationClampedCenter(center, frame.size, root);
    return CGRectIntegral(CGRectMake(center.x - frame.size.width / 2.0, center.y - frame.size.height / 2.0, frame.size.width, frame.size.height));
}

@end

static id DYYYLiveDurationSafeValue(id obj, NSString *key) {
    if (!obj || key.length == 0) {
        return nil;
    }

    @try {
        return [obj valueForKey:key];
    } @catch (__unused NSException *exception) {
        return nil;
    }
}

static long long DYYYLiveDurationLongValue(id obj, NSString *key) {
    id value = DYYYLiveDurationSafeValue(obj, key);
    return [value respondsToSelector:@selector(longLongValue)] ? [value longLongValue] : 0;
}

static BOOL DYYYLiveDurationBoolValue(id obj, NSString *key) {
    id value = DYYYLiveDurationSafeValue(obj, key);
    return [value respondsToSelector:@selector(boolValue)] ? [value boolValue] : NO;
}

static NSTimeInterval DYYYLiveDurationNowSeconds(void) {
    return [[NSDate date] timeIntervalSince1970];
}

static NSTimeInterval DYYYLiveDurationNormalizeTimestamp(long long timestamp) {
    if (timestamp <= 0) {
        return 0.0;
    }
    return timestamp > 20000000000LL ? ((NSTimeInterval)timestamp / 1000.0) : (NSTimeInterval)timestamp;
}

static long long DYYYLiveDurationFirstPositiveValue(id obj, NSArray<NSString *> *keys) {
    for (NSString *key in keys) {
        long long value = DYYYLiveDurationLongValue(obj, key);
        if (value > 0) {
            return value;
        }
    }
    return 0;
}

static BOOL DYYYLiveDurationLooksLikeRoomObject(id obj) {
    if (!obj) {
        return NO;
    }

    NSString *className = NSStringFromClass([obj class]);
    NSArray<NSString *> *excludedParts = @[ @"Cell", @"Item", @"Aisle", @"Context", @"Config", @"Controller", @"View", @"Factory" ];
    for (NSString *part in excludedParts) {
        if ([className rangeOfString:part options:NSCaseInsensitiveSearch].location != NSNotFound) {
            return NO;
        }
    }

    if ([className rangeOfString:@"LiveRoom" options:NSCaseInsensitiveSearch].location != NSNotFound ||
        [className rangeOfString:@"RoomModel" options:NSCaseInsensitiveSearch].location != NSNotFound ||
        [className rangeOfString:@"WebcastRoom" options:NSCaseInsensitiveSearch].location != NSNotFound) {
        return YES;
    }

    return DYYYLiveDurationSafeValue(obj, @"roomID") || DYYYLiveDurationSafeValue(obj, @"idStr");
}

static NSTimeInterval DYYYLiveDurationElapsedSeconds(id roomModel) {
    if (!DYYYLiveDurationLooksLikeRoomObject(roomModel)) {
        return -1.0;
    }

    id rawRoom = DYYYLiveDurationSafeValue(roomModel, @"rawRoom") ?: roomModel;
    NSArray<NSString *> *startKeys = @[ @"startTime", @"createTime", @"liveStartTime", @"start_time", @"create_time" ];
    long long startTime = DYYYLiveDurationFirstPositiveValue(rawRoom, startKeys);
    if (startTime <= 0) {
        startTime = DYYYLiveDurationFirstPositiveValue(roomModel, startKeys);
    }

    NSTimeInterval timestamp = DYYYLiveDurationNormalizeTimestamp(startTime);
    NSTimeInterval now = DYYYLiveDurationNowSeconds();
    if (timestamp > 1000000000.0 && timestamp <= now + 3600.0) {
        return fmax(0.0, now - timestamp);
    }

    NSArray<NSString *> *durationKeys = @[ @"liveDuration", @"liveTime", @"duration", @"totalDuration" ];
    long long duration = DYYYLiveDurationFirstPositiveValue(rawRoom, durationKeys);
    if (duration <= 0) {
        duration = DYYYLiveDurationFirstPositiveValue(roomModel, durationKeys);
    }
    if (duration > 0 && duration < 365LL * 24LL * 3600LL) {
        return (NSTimeInterval)duration;
    }

    return -1.0;
}

static BOOL DYYYLiveDurationHasValidLiveTime(id obj) {
    return DYYYLiveDurationElapsedSeconds(obj) >= 0.0;
}

static id DYYYLiveDurationRoomFromCarrierDepth(id obj, NSUInteger depth);

static id DYYYLiveDurationRoomFromKnownKeys(id obj, NSUInteger depth) {
    if (!obj || depth > 3) {
        return nil;
    }

    NSArray<NSString *> *keys = @[
        @"rawHTSLiveRoomModel", @"rawDataRoomModel", @"roomModel", @"rawRoom", @"liveRoom", @"room", @"currentRoom",
        @"containerContext", @"roomDI", @"roomConfig", @"roomAisle"
    ];
    for (NSString *key in keys) {
        id value = DYYYLiveDurationSafeValue(obj, key);
        if (DYYYLiveDurationHasValidLiveTime(value)) {
            return value;
        }

        id nestedRawRoom = DYYYLiveDurationSafeValue(value, @"rawRoom");
        if (DYYYLiveDurationHasValidLiveTime(nestedRawRoom)) {
            return value;
        }

        id nestedRoom = DYYYLiveDurationRoomFromCarrierDepth(value, depth + 1);
        if (nestedRoom) {
            return nestedRoom;
        }
    }
    return nil;
}

static id DYYYLiveDurationRoomFromCarrierDepth(id obj, NSUInteger depth) {
    if (!obj || depth > 3) {
        return nil;
    }

    if (DYYYLiveDurationHasValidLiveTime(obj)) {
        return obj;
    }

    id room = DYYYLiveDurationRoomFromKnownKeys(obj, depth + 1);
    if (room) {
        return room;
    }

    if ([obj respondsToSelector:@selector(liveRoomModel)]) {
        @try {
            id value = ((id (*)(id, SEL))objc_msgSend)(obj, @selector(liveRoomModel));
            if (DYYYLiveDurationHasValidLiveTime(value)) {
                return value;
            }
        } @catch (__unused NSException *exception) {
        }
    }

    NSArray<NSString *> *carrierKeys = @[ @"itemModel", @"awemeModel", @"aweme", @"model", @"item" ];
    for (NSString *key in carrierKeys) {
        id carrier = DYYYLiveDurationSafeValue(obj, key);
        room = DYYYLiveDurationRoomFromCarrierDepth(carrier, depth + 1);
        if (room) {
            return room;
        }
    }

    return nil;
}

static id DYYYLiveDurationRoomFromCarrier(id obj) {
    return DYYYLiveDurationRoomFromCarrierDepth(obj, 0);
}

static NSString *DYYYLiveDurationFormatElapsed(NSTimeInterval seconds) {
    long long totalSeconds = (long long)fmax(0.0, floor(seconds));
    long long days = totalSeconds / 86400;
    long long hours = (totalSeconds % 86400) / 3600;
    long long minutes = (totalSeconds % 3600) / 60;
    long long secs = totalSeconds % 60;

    if (days > 0) {
        return [NSString stringWithFormat:@"已开播 %lld天%02lld:%02lld:%02lld", days, hours, minutes, secs];
    }
    return [NSString stringWithFormat:@"已开播 %02lld:%02lld:%02lld", hours, minutes, secs];
}

static DYYYLiveDurationView *DYYYLiveDurationEnsureView(UIView *root) {
    DYYYLiveDurationView *durationView = objc_getAssociatedObject(root, kDYYYLiveDurationViewKey);
    if (durationView && durationView.superview == root) {
        return durationView;
    }

    durationView = [[DYYYLiveDurationView alloc] initWithFrame:CGRectZero];
    objc_setAssociatedObject(root, kDYYYLiveDurationViewKey, durationView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [root addSubview:durationView];
    return durationView;
}

static CGRect DYYYLiveDurationFrameForRoot(UIView *root, id roomModel, NSString *text) {
    UIEdgeInsets safeInsets = DYYYLiveDurationSafeInsets(root);

    CGFloat rootWidth = CGRectGetWidth(root.bounds);
    CGFloat rootHeight = CGRectGetHeight(root.bounds);
    BOOL isLandscape = rootWidth > rootHeight || DYYYLiveDurationBoolValue(roomModel, @"isLandscape");
    if (!isLandscape) {
        long long orientation = DYYYLiveDurationLongValue(roomModel, @"orientation");
        isLandscape = orientation == 2 || orientation == 90 || orientation == 270;
    }

    UIFont *font = [UIFont systemFontOfSize:12.0 weight:UIFontWeightSemibold];
    CGSize textSize = [text ?: @"已开播 00:00:00" sizeWithAttributes:@{NSFontAttributeName : font}];
    CGFloat width = fmin(ceil(fmax(textSize.width + 18.0, 118.0)), isLandscape ? 190.0 : 170.0);
    CGFloat height = 26.0;

    CGFloat minX = safeInsets.left + 4.0;
    CGFloat maxX = fmax(minX, rootWidth - safeInsets.right - width - 4.0);
    CGFloat minY = safeInsets.top + 4.0;
    CGFloat maxY = fmax(minY, rootHeight - safeInsets.bottom - height - 4.0);

    CGFloat x = fmin(fmax(safeInsets.left + 12.0, minX), maxX);
    CGFloat y = fmin(fmax(safeInsets.top + (isLandscape ? 12.0 : 86.0), minY), maxY);
    return CGRectIntegral(CGRectMake(x, y, width, height));
}

static void DYYYLiveDurationRemoveFromView(UIView *root) {
    if (!root) {
        return;
    }

    NSTimer *timer = objc_getAssociatedObject(root, kDYYYLiveDurationTimerKey);
    [timer invalidate];
    objc_setAssociatedObject(root, kDYYYLiveDurationTimerKey, nil, OBJC_ASSOCIATION_ASSIGN);

    UIView *durationView = objc_getAssociatedObject(root, kDYYYLiveDurationViewKey);
    [durationView removeFromSuperview];
    objc_setAssociatedObject(root, kDYYYLiveDurationViewKey, nil, OBJC_ASSOCIATION_ASSIGN);
    objc_setAssociatedObject(root, kDYYYLiveDurationRoomKey, nil, OBJC_ASSOCIATION_ASSIGN);
}

static void DYYYLiveDurationUpdateView(UIView *root) {
    if (!root) {
        return;
    }

    if (!DYYYGetBool(@"DYYYShowLiveDuration")) {
        DYYYLiveDurationRemoveFromView(root);
        return;
    }

    id roomModel = objc_getAssociatedObject(root, kDYYYLiveDurationRoomKey);
    NSTimeInterval elapsed = DYYYLiveDurationElapsedSeconds(roomModel);
    DYYYLiveDurationView *durationView = objc_getAssociatedObject(root, kDYYYLiveDurationViewKey);
    if (elapsed < 0.0) {
        durationView.hidden = YES;
        return;
    }

    NSString *text = DYYYLiveDurationFormatElapsed(elapsed);
    durationView = DYYYLiveDurationEnsureView(root);
    durationView.durationLabel.text = text;
    if (!durationView.isDragging) {
        CGRect defaultFrame = DYYYLiveDurationFrameForRoot(root, roomModel, text);
        durationView.frame = [durationView frameByApplyingSavedPositionToFrame:defaultFrame inRoot:root];
        durationView.alpha = 1.0;
    }
    durationView.hidden = NO;
    [root bringSubviewToFront:durationView];
}

@interface DYYYLiveDurationTicker : NSObject
+ (instancetype)sharedTicker;
- (void)tick:(NSTimer *)timer;
@end

@implementation DYYYLiveDurationTicker

+ (instancetype)sharedTicker {
    static DYYYLiveDurationTicker *ticker = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
      ticker = [DYYYLiveDurationTicker new];
    });
    return ticker;
}

- (void)tick:(NSTimer *)timer {
    DYYYLiveDurationWeakViewBox *box = (DYYYLiveDurationWeakViewBox *)timer.userInfo;
    UIView *root = box.view;
    if (![root isKindOfClass:[UIView class]]) {
        [timer invalidate];
        return;
    }
    if (!root.window) {
        DYYYLiveDurationRemoveFromView(root);
        return;
    }
    DYYYLiveDurationUpdateView(root);
}

@end

static void DYYYLiveDurationEnsureTimer(UIView *root) {
    NSTimer *timer = objc_getAssociatedObject(root, kDYYYLiveDurationTimerKey);
    if (timer && timer.isValid) {
        return;
    }

    DYYYLiveDurationWeakViewBox *box = [DYYYLiveDurationWeakViewBox new];
    box.view = root;
    timer = [NSTimer timerWithTimeInterval:1.0 target:[DYYYLiveDurationTicker sharedTicker] selector:@selector(tick:) userInfo:box repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    objc_setAssociatedObject(root, kDYYYLiveDurationTimerKey, timer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

static void DYYYLiveDurationInstallOnView(UIView *root, id carrier) {
    if (!root) {
        return;
    }

    void (^installBlock)(void) = ^{
      if (!DYYYGetBool(@"DYYYShowLiveDuration")) {
          DYYYLiveDurationRemoveFromView(root);
          return;
      }

      id room = DYYYLiveDurationRoomFromCarrier(carrier);
      if (!DYYYLiveDurationHasValidLiveTime(room)) {
          UIViewController *viewController = [DYYYUtils firstAvailableViewControllerFromView:root];
          room = DYYYLiveDurationRoomFromCarrier(viewController);
      }

      if (DYYYLiveDurationHasValidLiveTime(room)) {
          objc_setAssociatedObject(root, kDYYYLiveDurationRoomKey, room, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
      }

      DYYYLiveDurationUpdateView(root);
      if (DYYYLiveDurationHasValidLiveTime(objc_getAssociatedObject(root, kDYYYLiveDurationRoomKey))) {
          DYYYLiveDurationEnsureTimer(root);
      }
    };

    if ([NSThread isMainThread]) {
        installBlock();
    } else {
        dispatch_async(dispatch_get_main_queue(), installBlock);
    }
}

static UIViewController *DYYYLiveDurationContainerAudienceVC(id container) {
    UIViewController *viewController = DYYYLiveDurationSafeValue(container, @"audienceVC");
    if (![viewController isKindOfClass:[UIViewController class]] && [container respondsToSelector:@selector(audienceViewController)]) {
        @try {
            viewController = ((id (*)(id, SEL))objc_msgSend)(container, @selector(audienceViewController));
        } @catch (__unused NSException *exception) {
            viewController = nil;
        }
    }
    return [viewController isKindOfClass:[UIViewController class]] ? viewController : nil;
}

static void DYYYLiveDurationInstallFromContainer(id container) {
    UIViewController *viewController = DYYYLiveDurationContainerAudienceVC(container);
    if ([viewController isKindOfClass:[UIViewController class]]) {
        DYYYLiveDurationInstallOnView(viewController.view, DYYYLiveDurationSafeValue(container, @"roomModel") ?: container);
    }
}

static void DYYYLiveDurationInstallFromAudienceWrapper(id wrapper) {
    UIViewController *viewController = DYYYLiveDurationSafeValue(wrapper, @"audienceViewController");
    if ([viewController isKindOfClass:[UIViewController class]]) {
        DYYYLiveDurationInstallOnView(viewController.view, DYYYLiveDurationSafeValue(wrapper, @"roomModel") ?: wrapper);
    }
}

static void DYYYLiveDurationInstallFromInnerFeedCell(id cell) {
    UIViewController *viewController = DYYYLiveDurationSafeValue(cell, @"audienceVC");
    if ([viewController isKindOfClass:[UIViewController class]]) {
        DYYYLiveDurationInstallOnView(viewController.view, cell);
    }
}

%hook AWELiveAudienceContainerController

- (id)initWithRoomModel:(id)roomModel {
    id result = %orig;
    __weak id weakResult = result;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.35 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
      DYYYLiveDurationInstallFromContainer(weakResult);
    });
    return result;
}

- (id)initWithRoomModel:(id)roomModel config:(id)config {
    id result = %orig;
    __weak id weakResult = result;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.35 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
      DYYYLiveDurationInstallFromContainer(weakResult);
    });
    return result;
}

- (id)initWithRoomModel:(id)roomModel context:(id)context {
    id result = %orig;
    __weak id weakResult = result;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.35 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
      DYYYLiveDurationInstallFromContainer(weakResult);
    });
    return result;
}

- (id)initWithRoomModel:(id)roomModel context:(id)context player:(id)player {
    id result = %orig;
    __weak id weakResult = result;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.35 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
      DYYYLiveDurationInstallFromContainer(weakResult);
    });
    return result;
}

- (void)setAudienceVC:(UIViewController *)audienceVC {
    %orig;
    DYYYLiveDurationInstallFromContainer(self);
}

- (void)setRoomModel:(id)roomModel {
    %orig;
    DYYYLiveDurationInstallFromContainer(self);
}

- (void)createAudienceViewController:(id)arg beginTime:(double)beginTime {
    %orig;
    __weak id weakSelf = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
      DYYYLiveDurationInstallFromContainer(weakSelf);
    });
}

- (id)audienceControllerWithRoom:(id)room beginTime:(double)beginTime {
    id result = %orig;
    __weak id weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
      DYYYLiveDurationInstallFromContainer(weakSelf);
    });
    return result;
}

- (void)updateWithRoomModel:(id)roomModel config:(id)config {
    %orig;
    DYYYLiveDurationInstallFromContainer(self);
}

- (void)updateWithRoomModel:(id)roomModel context:(id)context {
    %orig;
    DYYYLiveDurationInstallFromContainer(self);
}

- (void)updateWithRoomModel:(id)roomModel context:(id)context player:(id)player {
    %orig;
    DYYYLiveDurationInstallFromContainer(self);
}

- (void)clearAudience {
    UIViewController *viewController = DYYYLiveDurationContainerAudienceVC(self);
    if ([viewController isKindOfClass:[UIViewController class]]) {
        DYYYLiveDurationRemoveFromView(viewController.view);
    }
    %orig;
}

- (void)prepareForReuse {
    UIViewController *viewController = DYYYLiveDurationContainerAudienceVC(self);
    if ([viewController isKindOfClass:[UIViewController class]]) {
        DYYYLiveDurationRemoveFromView(viewController.view);
    }
    %orig;
}

- (void)dealloc {
    UIViewController *viewController = DYYYLiveDurationContainerAudienceVC(self);
    if ([viewController isKindOfClass:[UIViewController class]]) {
        DYYYLiveDurationRemoveFromView(viewController.view);
    }
    %orig;
}

%end

%hook AWELiveAudienceViewController

- (id)initWithRoomModel:(id)roomModel {
    id result = %orig;
    __weak id weakResult = result;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.35 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
      DYYYLiveDurationInstallFromAudienceWrapper(weakResult);
    });
    return result;
}

- (void)setRoomModel:(id)roomModel {
    %orig;
    DYYYLiveDurationInstallFromAudienceWrapper(self);
}

- (void)setAudienceViewController:(UIViewController *)audienceViewController {
    %orig;
    DYYYLiveDurationInstallFromAudienceWrapper(self);
}

- (void)attachAudienceViewControllerDelegate:(id)delegate {
    %orig;
    DYYYLiveDurationInstallFromAudienceWrapper(self);
}

- (void)exitLiveRoomWithType:(unsigned long long)type {
    UIViewController *viewController = DYYYLiveDurationSafeValue(self, @"audienceViewController");
    if ([viewController isKindOfClass:[UIViewController class]]) {
        DYYYLiveDurationRemoveFromView(viewController.view);
    }
    %orig;
}

- (void)dealloc {
    UIViewController *viewController = DYYYLiveDurationSafeValue(self, @"audienceViewController");
    if ([viewController isKindOfClass:[UIViewController class]]) {
        DYYYLiveDurationRemoveFromView(viewController.view);
    }
    %orig;
}

%end

%hook IESLiveInnerFeedLiveRoomCell

- (void)setItemModel:(id)itemModel {
    %orig;
    DYYYLiveDurationInstallFromInnerFeedCell(self);
}

- (void)setRoomAisle:(id)roomAisle {
    %orig;
    DYYYLiveDurationInstallFromInnerFeedCell(self);
}

- (void)setAudienceVC:(UIViewController *)audienceVC {
    %orig;
    DYYYLiveDurationInstallFromInnerFeedCell(self);
}

- (void)updateWithItemModel:(id)itemModel {
    %orig;
    DYYYLiveDurationInstallFromInnerFeedCell(self);
}

- (void)prepareForReuse {
    UIViewController *viewController = DYYYLiveDurationSafeValue(self, @"audienceVC");
    if ([viewController isKindOfClass:[UIViewController class]]) {
        DYYYLiveDurationRemoveFromView(viewController.view);
    }
    %orig;
}

%end



#pragma mark - 显示开播时长

%hook IESLiveAudienceViewController

- (void)viewDidLoad {
    %orig;
    DYYYLiveDurationInstallOnView(self.view, self);
}

- (void)viewWillAppear:(BOOL)animated {
    %orig;
    DYYYLiveDurationInstallOnView(self.view, self);
}

- (void)viewDidLayoutSubviews {
    %orig;
    DYYYLiveDurationInstallOnView(self.view, self);
    DYYYLiveDurationUpdateView(self.view);
}

- (void)didEnterRoom:(id)room {
    %orig;
    DYYYLiveDurationInstallOnView(self.view, room ?: self);
}

- (void)didCloseRoom:(id)room closeType:(unsigned long long)type {
    DYYYLiveDurationRemoveFromView(self.view);
    %orig;
}

- (void)dealloc {
    if (self.isViewLoaded) {
        DYYYLiveDurationRemoveFromView(self.view);
    }
    %orig;
}

%end

