#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <objc/runtime.h>
#import <QuartzCore/QuartzCore.h>

@interface DYToolsBasicSettingsViewController : UITableViewController
@end

@interface DYToolsControlViewController : UIViewController
- (NSArray *)dy_buildGlobalSearchEntries;
@end

@interface AWEFeedRootViewController : UIViewController
@end

#pragma mark - DY-tools 40.4.0 feature fixes
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <objc/runtime.h>
#import <QuartzCore/QuartzCore.h>

#pragma mark - DY-tools 40.4.0 feature fixes
//
// 本文件只补强当前已经存在的设置项，不改全屏核心。
// 目标：
// 1. 隐藏系统顶栏
// 2. 删除“关注二次确认”设置
// 3. 评论区毛玻璃
// 4. 通知玻璃效果
// 5. 毛玻璃透明度同时作用于评论/通知
// 6. 通知圆角半径
// 7. 去青少年弹窗
// 8. 屏蔽检测更新
// 9. 屏蔽开屏广告/广告模型
//

static BOOL DYFixBool(NSString *key) {
    return [[NSUserDefaults standardUserDefaults] boolForKey:key];
}

static CGFloat DYFixFloat(NSString *key, CGFloat fallback) {
    id value = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    CGFloat v = [value respondsToSelector:@selector(doubleValue)] ? [value doubleValue] : 0.0;
    if (v <= 0.0 || v > 1.0) return fallback;
    return v;
}

static CGFloat DYFixRadius(NSString *key, CGFloat fallback) {
    id value = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    CGFloat v = [value respondsToSelector:@selector(doubleValue)] ? [value doubleValue] : 0.0;
    if (v < 0.0 || v > 50.0) return fallback;
    if (v == 0.0) return fallback;
    return v;
}

static void DYFixClearBackgrounds(UIView *view) {
    if (!view) return;

    view.backgroundColor = UIColor.clearColor;

    for (UIView *subview in [view.subviews copy]) {
        if ([subview isKindOfClass:UIVisualEffectView.class]) continue;
        DYFixClearBackgrounds(subview);
    }
}

static UIVisualEffectView *DYFixBlurView(UIView *container,
                                         NSInteger tag,
                                         CGFloat alpha,
                                         CGFloat radius) {
    if (!container) return nil;

    UIVisualEffectView *blur = nil;
    UIView *existing = [container viewWithTag:tag];

    if ([existing isKindOfClass:UIVisualEffectView.class]) {
        blur = (UIVisualEffectView *)existing;
    } else {
        UIBlurEffect *effect =
            [UIBlurEffect effectWithStyle:UIBlurEffectStyleSystemMaterial];
        blur = [[UIVisualEffectView alloc] initWithEffect:effect];
        blur.tag = tag;
        blur.userInteractionEnabled = NO;
        blur.autoresizingMask =
            UIViewAutoresizingFlexibleWidth |
            UIViewAutoresizingFlexibleHeight;
        [container insertSubview:blur atIndex:0];
    }

    blur.frame = container.bounds;
    blur.alpha = alpha;
    blur.layer.cornerRadius = radius;
    blur.layer.masksToBounds = YES;

    container.layer.cornerRadius = radius;
    container.layer.masksToBounds = YES;

    return blur;
}

#pragma mark - 实时彩色渐变文字：视频名字/文案/顶栏

static const void *kDYToolsTextGradientLayerKey = &kDYToolsTextGradientLayerKey;
static const void *kDYToolsTextGradientMaskKey = &kDYToolsTextGradientMaskKey;

static BOOL DYToolsRealtimeTextGradientEnabled(void) {
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"DYYYEnableRealtimeTextGradient"];
}

static BOOL DYToolsGradientTextIsTopBar(UILabel *label) {
    if (!label.text.length) return NO;

    NSArray<NSString *> *topBarWords = @[
        @"推荐", @"关注", @"朋友", @"直播", @"精选", @"商城", @"同城",
        @"团购", @"热点", @"经验", @"短剧", @"看剧", @"少儿", @"游戏",
        @"首页", @"附近"
    ];

    NSString *text = [label.text stringByTrimmingCharactersInSet:
                      [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    for (NSString *word in topBarWords) {
        if ([text isEqualToString:word]) return YES;
    }

    UIResponder *r = label;
    for (NSUInteger i = 0; i < 10 && (r = [r nextResponder]); i++) {
        NSString *name = NSStringFromClass(r.class);
        if ([name containsString:@"TabBar"] ||
            [name containsString:@"TopTab"] ||
            [name containsString:@"TopBar"]) {
            return YES;
        }
    }
    return NO;
}

static BOOL DYToolsGradientTextLooksLikeVideoText(UILabel *label, UIView *root) {
    if (!label.text.length || !root) return NO;

    NSString *text = [label.text stringByTrimmingCharactersInSet:
                      [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (!text.length) return NO;

    // 排除纯数字、时间、进度等辅助文字。
    NSCharacterSet *nonDigits = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
    if ([text rangeOfCharacterFromSet:nonDigits].location == NSNotFound) return NO;
    if ([text rangeOfString:@"IP属地"].location != NSNotFound) return NO;
    if ([text rangeOfString:@"/"].location != NSNotFound && text.length < 16) return NO;

    CGRect r = [label convertRect:label.bounds toView:root];
    CGFloat w = CGRectGetWidth(root.bounds);
    CGFloat h = CGRectGetHeight(root.bounds);

    if (w <= 0 || h <= 0) return NO;

    // 视频页名字、文案通常位于视频画面的左下区域。
    if (CGRectGetMinX(r) <= w * 0.68 &&
        CGRectGetMidY(r) >= h * 0.42) {
        return YES;
    }

    NSString *className = NSStringFromClass(label.class);
    if ([className containsString:@"Title"] ||
        [className containsString:@"Caption"] ||
        [className containsString:@"Desc"] ||
        [className containsString:@"Author"] ||
        [className containsString:@"UserName"] ||
        [className containsString:@"Nick"]) {
        return YES;
    }

    return NO;
}

static void DYToolsRemoveTextGradient(UILabel *label) {
    if (!label) return;

    CAGradientLayer *gradient =
        objc_getAssociatedObject(label, kDYToolsTextGradientLayerKey);
    if ([gradient isKindOfClass:CAGradientLayer.class]) {
        [gradient removeFromSuperlayer];
    }

    objc_setAssociatedObject(label, kDYToolsTextGradientLayerKey,
                             nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(label, kDYToolsTextGradientMaskKey,
                             nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);

    label.textColor = UIColor.whiteColor;
}

static void DYToolsApplyRealtimeTextGradient(UILabel *label) {
    if (!label || !label.text.length) return;

    CAGradientLayer *gradient =
        objc_getAssociatedObject(label, kDYToolsTextGradientLayerKey);
    CATextLayer *mask =
        objc_getAssociatedObject(label, kDYToolsTextGradientMaskKey);

    if (![gradient isKindOfClass:CAGradientLayer.class] ||
        ![mask isKindOfClass:CATextLayer.class]) {

        gradient = [CAGradientLayer layer];
        gradient.name = @"DYToolsRealtimeTextGradient";
        gradient.startPoint = CGPointMake(0.0, 0.5);
        gradient.endPoint = CGPointMake(1.0, 0.5);
        gradient.colors = @[
            (id)[UIColor colorWithRed:1.0 green:0.10 blue:0.55 alpha:1.0].CGColor,
            (id)[UIColor colorWithRed:1.0 green:0.55 blue:0.05 alpha:1.0].CGColor,
            (id)[UIColor colorWithRed:0.20 green:1.0 blue:0.75 alpha:1.0].CGColor,
            (id)[UIColor colorWithRed:0.15 green:0.45 blue:1.0 alpha:1.0].CGColor,
            (id)[UIColor colorWithRed:0.75 green:0.15 blue:1.0 alpha:1.0].CGColor,
            (id)[UIColor colorWithRed:1.0 green:0.10 blue:0.55 alpha:1.0].CGColor
        ];
        gradient.locations = @[@0.0, @0.20, @0.40, @0.60, @0.80, @1.0];
        gradient.masksToBounds = YES;

        mask = [CATextLayer layer];
        mask.contentsScale = UIScreen.mainScreen.scale;
        gradient.mask = mask;

        [label.layer addSublayer:gradient];

        objc_setAssociatedObject(label, kDYToolsTextGradientLayerKey,
                                 gradient, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        objc_setAssociatedObject(label, kDYToolsTextGradientMaskKey,
                                 mask, OBJC_ASSOCIATION_RETAIN_NONATOMIC);

        CABasicAnimation *animation =
            [CABasicAnimation animationWithKeyPath:@"locations"];
        animation.fromValue = @[@(-0.8), @(-0.6), @(-0.4), @(-0.2), @0.0, @0.2];
        animation.toValue = @[@0.8, @1.0, @1.2, @1.4, @1.6, @1.8];
        animation.duration = 4.0;
        animation.repeatCount = HUGE_VALF;
        animation.timingFunction =
            [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
        [gradient addAnimation:animation forKey:@"DYToolsRealtimeTextColorFlow"];
    }

    gradient.frame = label.bounds;

    UIFont *font = label.font ?: [UIFont systemFontOfSize:12.0];
    mask.frame = label.bounds;
    mask.string = label.text;
    mask.font = (__bridge CFTypeRef)font.fontName;
    mask.fontSize = MAX(font.pointSize, 1.0);
    mask.alignmentMode =
        (label.textAlignment == NSTextAlignmentCenter)
        ? kCAAlignmentCenter
        : (label.textAlignment == NSTextAlignmentRight
           ? kCAAlignmentRight
           : kCAAlignmentLeft);
    mask.truncationMode = kCATruncationEnd;
    mask.contentsScale = UIScreen.mainScreen.scale;

    label.textColor = UIColor.clearColor;
    label.layer.masksToBounds = NO;
}

static void DYToolsScanGradientLabelsInView(UIView *root, BOOL topBarOnly) {
    if (!root || !root.window) return;

    NSMutableArray<UIView *> *queue = [NSMutableArray arrayWithObject:root];

    while (queue.count) {
        UIView *view = queue.firstObject;
        [queue removeObjectAtIndex:0];

        if ([view isKindOfClass:UILabel.class]) {
            UILabel *label = (UILabel *)view;

            BOOL shouldApply = topBarOnly
                ? DYToolsGradientTextIsTopBar(label)
                : DYToolsGradientTextLooksLikeVideoText(label, root);

            if (shouldApply) {
                DYToolsApplyRealtimeTextGradient(label);
            }
        }

        [queue addObjectsFromArray:view.subviews];
    }
}

static void DYToolsScanRealtimeGradientPages(void) {
    if (!DYToolsRealtimeTextGradientEnabled()) return;

    for (UIScene *scene in UIApplication.sharedApplication.connectedScenes) {
        if (![scene isKindOfClass:UIWindowScene.class]) continue;

        UIWindowScene *windowScene = (UIWindowScene *)scene;
        if (windowScene.activationState == UISceneActivationStateUnattached) continue;

        for (UIWindow *window in windowScene.windows) {
            if (window.hidden || window.alpha <= 0.01 || !window.rootViewController) continue;

            DYToolsScanGradientLabelsInView(window, YES);

            UIViewController *vc = window.rootViewController;
            NSMutableArray<UIViewController *> *controllers =
                [NSMutableArray arrayWithObject:vc];

            while (controllers.count) {
                UIViewController *current = controllers.firstObject;
                [controllers removeObjectAtIndex:0];

                NSString *name = NSStringFromClass(current.class);
                if ([name containsString:@"AWEPlayInteraction"] ||
                    [name containsString:@"AwemeDetail"] ||
                    [name containsString:@"PlayerViewController"]) {
                    DYToolsScanGradientLabelsInView(current.view, NO);
                }

                [controllers addObjectsFromArray:current.childViewControllers];

                if (current.presentedViewController) {
                    [controllers addObject:current.presentedViewController];
                }
            }
        }
    }
}

static void DYToolsRemoveAllRealtimeGradients(void) {
    for (UIScene *scene in UIApplication.sharedApplication.connectedScenes) {
        if (![scene isKindOfClass:UIWindowScene.class]) continue;

        UIWindowScene *windowScene = (UIWindowScene *)scene;
        for (UIWindow *window in windowScene.windows) {
            NSMutableArray<UIView *> *queue = [NSMutableArray arrayWithObject:window];

            while (queue.count) {
                UIView *view = queue.firstObject;
                [queue removeObjectAtIndex:0];

                if ([view isKindOfClass:UILabel.class]) {
                    UILabel *label = (UILabel *)view;
                    if (objc_getAssociatedObject(label, kDYToolsTextGradientLayerKey)) {
                        DYToolsRemoveTextGradient(label);
                    }
                }

                [queue addObjectsFromArray:view.subviews];
            }
        }
    }
}

static NSTimer *gDYToolsRealtimeTextGradientTimer = nil;

static void DYToolsStartRealtimeTextGradientScanner(void) {
    if (gDYToolsRealtimeTextGradientTimer) return;

    gDYToolsRealtimeTextGradientTimer =
        [NSTimer scheduledTimerWithTimeInterval:0.35
                                         repeats:YES
                                           block:^(__unused NSTimer *timer) {
        if (DYToolsRealtimeTextGradientEnabled()) {
            DYToolsScanRealtimeGradientPages();
        } else {
            DYToolsRemoveAllRealtimeGradients();
        }
    }];

    [[NSRunLoop mainRunLoop] addTimer:gDYToolsRealtimeTextGradientTimer
                              forMode:NSRunLoopCommonModes];
}

#pragma mark - 1. 隐藏系统顶栏

%hook AWEFeedRootViewController

- (BOOL)prefersStatusBarHidden {
    if (DYFixBool(@"DYYYHideStatusbar")) {
        return YES;
    }
    return %orig;
}

- (void)viewDidAppear:(BOOL)animated {
    %orig(animated);

    if (DYFixBool(@"DYYYHideStatusbar")) {
        [self setNeedsStatusBarAppearanceUpdate];
    }
}

- (void)viewDidLayoutSubviews {
    %orig;

    if (DYFixBool(@"DYYYHideStatusbar")) {
        [self setNeedsStatusBarAppearanceUpdate];
    }
}

%end

#pragma mark - 2. 删除“关注二次确认”设置

%hook DYToolsBasicSettingsViewController

- (void)viewDidLoad {
    %orig;

    // 清理旧版本遗留值。
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"DYYYFollowTips"];

    @try {
        NSArray *oldSections = [self valueForKey:@"_sections"];
        NSMutableArray *newSections = [NSMutableArray array];

        for (NSDictionary *section in oldSections) {
            NSMutableDictionary *newSection = [section mutableCopy];
            NSArray *items = section[@"items"];
            NSMutableArray *newItems = [NSMutableArray array];

            for (NSDictionary *item in items) {
                if ([item[@"key"] isEqualToString:@"DYYYFollowTips"]) {
                    continue;
                }
                [newItems addObject:item];
            }

            newSection[@"items"] = [newItems copy];
            [newSections addObject:newSection];
        }

        [self setValue:[newSections copy] forKey:@"_sections"];
        [self.tableView reloadData];
    } @catch (__unused NSException *e) {
    }
}

%end

%hook DYToolsControlViewController

- (NSArray *)dy_buildGlobalSearchEntries {
    NSArray *items = %orig;
    if (![items isKindOfClass:NSArray.class]) return items;

    NSMutableArray *filtered = [NSMutableArray array];
    for (NSDictionary *item in items) {
        if ([[item[@"key"] description] isEqualToString:@"DYYYFollowTips"]) {
            continue;
        }
        [filtered addObject:item];
    }
    return [filtered copy];
}

%end

#pragma mark - 3/5. 评论区毛玻璃 + 透明度

static UIViewController *DYFixFindCommentController(UIViewController *root) {
    if (!root) return nil;

    NSString *name = NSStringFromClass(root.class);
    if ([name containsString:@"CommentContainerInnerViewController"]) {
        return root;
    }

    for (UIViewController *child in root.childViewControllers) {
        UIViewController *found = DYFixFindCommentController(child);
        if (found) return found;
    }

    if (root.presentedViewController) {
        UIViewController *found =
            DYFixFindCommentController(root.presentedViewController);
        if (found) return found;
    }

    return nil;
}

static void DYFixApplyCommentBlur(void) {
    if (!DYFixBool(@"DYYYEnableCommentBlur")) return;

    UIWindow *window = nil;
    for (UIScene *scene in UIApplication.sharedApplication.connectedScenes) {
        if (![scene isKindOfClass:UIWindowScene.class]) continue;

        UIWindowScene *ws = (UIWindowScene *)scene;
        if (ws.activationState == UISceneActivationStateUnattached) continue;

        for (UIWindow *candidate in ws.windows) {
            if (candidate.isKeyWindow && !candidate.hidden) {
                window = candidate;
                break;
            }
        }

        if (window) break;
    }

    if (!window) return;

    UIViewController *commentVC =
        DYFixFindCommentController(window.rootViewController);
    if (!commentVC.view) return;

    CGFloat alpha = DYFixFloat(@"DYYYCommentBlurTransparent", 0.9);

    // 抖音评论容器自身通常有不透明背景；先清空背景，
    // 再把真正的 blur 放在内容下面。
    DYFixClearBackgrounds(commentVC.view);

    UIVisualEffectView *blur =
        DYFixBlurView(commentVC.view, 190721, alpha, 0.0);

    if (blur) {
        [commentVC.view bringSubviewToFront:blur];
        // blur 必须位于文字/按钮下面。
        [commentVC.view sendSubviewToBack:blur];
    }
}

%hook AWEBaseListViewController

- (void)viewDidLayoutSubviews {
    %orig;

    if (DYFixBool(@"DYYYEnableCommentBlur")) {
        dispatch_async(dispatch_get_main_queue(), ^{
            DYFixApplyCommentBlur();
        });
    }
}

%end

#pragma mark - 4/5/6. 通知玻璃 + 透明度 + 圆角

static void DYFixApplyNotificationBlur(void) {
    if (!DYFixBool(@"DYYYEnableNotificationTransparency")) return;

    CGFloat alpha =
        DYFixFloat(@"DYYYCommentBlurTransparent", 0.9);
    CGFloat radius =
        DYFixRadius(@"DYYYNotificationCornerRadius", 12.0);

    for (UIScene *scene in UIApplication.sharedApplication.connectedScenes) {
        if (![scene isKindOfClass:UIWindowScene.class]) continue;

        UIWindowScene *ws = (UIWindowScene *)scene;
        if (ws.activationState == UISceneActivationStateUnattached) continue;

        for (UIWindow *window in ws.windows) {
            NSString *windowClass = NSStringFromClass(window.class);
            BOOL isNotificationWindow =
                [windowClass containsString:@"AWEInnerNotificationWindow"];

            if (!isNotificationWindow) continue;

            NSArray *subviews = [window.subviews copy];
            for (UIView *container in subviews) {
                NSString *className = NSStringFromClass(container.class);
                if (![className containsString:@"AWEInnerNotificationContainerView"]) {
                    continue;
                }

                DYFixClearBackgrounds(container);

                UIVisualEffectView *blur =
                    DYFixBlurView(container, 190722, alpha, radius);

                if (blur) {
                    [container sendSubviewToBack:blur];
                }

                // 通知文字在毛玻璃上保持可读。
                NSMutableArray *queue = [NSMutableArray arrayWithObject:container];
                while (queue.count) {
                    UIView *view = queue.firstObject;
                    [queue removeObjectAtIndex:0];

                    for (UIView *subview in view.subviews) {
                        if (subview.tag == 190722) continue;
                        if ([subview isKindOfClass:UILabel.class]) {
                            UILabel *label = (UILabel *)subview;
                            if (label.text.length > 0) {
                                label.textColor = UIColor.whiteColor;
                            }
                        }
                        [queue addObject:subview];
                    }
                }
            }
        }
    }
}

%hook AWEInnerNotificationWindow

- (void)didMoveToWindow {
    %orig;

    if (DYFixBool(@"DYYYEnableNotificationTransparency")) {
        dispatch_async(dispatch_get_main_queue(), ^{
            DYFixApplyNotificationBlur();
        });
    }
}

- (void)layoutSubviews {
    %orig;

    if (DYFixBool(@"DYYYEnableNotificationTransparency")) {
        dispatch_async(dispatch_get_main_queue(), ^{
            DYFixApplyNotificationBlur();
        });
    }
}

%end

#pragma mark - 7. 去青少年弹窗

%hook AWETeenModeAlertView

- (BOOL)show {
    if (DYFixBool(@"DYYYHideTeenMode")) {
        return NO;
    }
    return %orig;
}

%end

#pragma mark - 8. 屏蔽检测更新

%hook AWEVersionUpdateManager

- (void)startVersionUpdateWorkflow:(id)arg1 completion:(id)arg2 {
    if (DYFixBool(@"DYYYNoUpdates")) {
        if (arg2) {
            void (^completion)(void) = arg2;
            completion();
        }
        return;
    }
    %orig(arg1, arg2);
}

- (id)workflow {
    if (DYFixBool(@"DYYYNoUpdates")) {
        return nil;
    }
    return %orig;
}

- (id)badgeModule {
    if (DYFixBool(@"DYYYNoUpdates")) {
        return nil;
    }
    return %orig;
}

%end

#pragma mark - 9. 屏蔽开屏广告 / 广告模型

%hook TTAdSplashModel

+ (id)alloc {
    if (DYFixBool(@"DYYYNoAds")) {
        return nil;
    }
    return %orig;
}

%end

%hook AWEAwemeModel

- (id)initWithDictionary:(id)dictionary error:(id *)error {
    id object = %orig(dictionary, error);

    if (!DYFixBool(@"DYYYNoAds") || !object) {
        return object;
    }

    @try {
        BOOL isAds = [[object valueForKey:@"isAds"] boolValue];
        if (isAds) {
            return nil;
        }
    } @catch (__unused NSException *e) {
    }

    return object;
}

%end

#pragma mark - 兜底扫描
//
// 某些 40.x 页面不会触发旧 Hook 的 layout 回调，
// 因此在设置开启时定时重新检查一次评论/通知窗口。
// 只扫描已知类名，不做文本识别。

static NSTimer *gDYFixTimer = nil;

static void DYFixRunScan(void) {
    if (DYFixBool(@"DYYYEnableCommentBlur")) {
        DYFixApplyCommentBlur();
    }

    if (DYFixBool(@"DYYYEnableNotificationTransparency")) {
        DYFixApplyNotificationBlur();
    }
}

%ctor {
    %init(_ungrouped);

    dispatch_async(dispatch_get_main_queue(), ^{
        if (gDYFixTimer) return;

        gDYFixTimer =
            [NSTimer scheduledTimerWithTimeInterval:0.6
                                              repeats:YES
                                                block:^(__unused NSTimer *timer) {
            DYFixRunScan();
        }];

        [[NSRunLoop mainRunLoop] addTimer:gDYFixTimer
                                  forMode:NSRunLoopCommonModes];
    });
}
