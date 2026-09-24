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

#pragma mark - 视频页合集栏去除

static BOOL DYToolsHideVideoCollectionEnabled(void) {
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"DYYYHideVideoCollectionBar"];
}

static BOOL DYToolsIsVideoCollectionPageView(UIView *view) {
    if (!view) return NO;
    UIResponder *r = view;
    for (NSUInteger i = 0; i < 30 && (r = [r nextResponder]); i++) {
        NSString *name = NSStringFromClass(r.class);
        if ([name containsString:@"AWEPlayInteraction"] ||
            [name containsString:@"AwemeDetail"] ||
            [name containsString:@"PlayerViewController"]) {
            return YES;
        }
    }
    return NO;
}

static BOOL DYToolsLooksLikeCollectionBarView(UIView *view) {
    if (!view) return NO;
    NSString *className = NSStringFromClass(view.class);
    NSArray<NSString *> *classWords = @[
        @"Mix", @"Collection", @"Playlist", @"Series", @"Chapter"
    ];
    for (NSString *word in classWords) {
        if ([className localizedCaseInsensitiveContainsString:word]) return YES;
    }
    NSString *accessibility = view.accessibilityLabel ?: @"";
    return [accessibility isEqualToString:@"合集"] ||
           [accessibility containsString:@"合集"]; 
}

static void DYToolsHideVideoCollectionBarsInView(UIView *root) {
    if (!root || !root.window || !DYToolsHideVideoCollectionEnabled()) return;

    CGFloat screenW = CGRectGetWidth(root.bounds);
    CGFloat screenH = CGRectGetHeight(root.bounds);

    NSMutableArray<UIView *> *queue = [NSMutableArray arrayWithObject:root];
    while (queue.count) {
        UIView *view = queue.firstObject;
        [queue removeObjectAtIndex:0];

        BOOL hide = DYToolsLooksLikeCollectionBarView(view);

        if ([view isKindOfClass:UILabel.class]) {
            UILabel *label = (UILabel *)view;
            NSString *text = [label.text stringByTrimmingCharactersInSet:
                              [NSCharacterSet whitespaceAndNewlineCharacterSet]];

            BOOL collectionText =
                [text isEqualToString:@"合集"] ||
                [text containsString:@"合集"] ||
                [text isEqualToString:@"下一集"] ||
                [text containsString:@"下一集"] ||
                [text hasPrefix:@"第"] && [text containsString:@"集"];

            if (collectionText) {
                hide = YES;

                // 关键：不只隐藏文字，而是向上找到“合集控制条”本身。
                // 截图中的整条半透明横栏包含“合集图标 + 下一集”按钮，
                // 所以必须隐藏它的父容器。
                UIView *candidate = label;
                for (NSUInteger level = 0; level < 5; level++) {
                    UIView *parent = candidate.superview;
                    if (!parent) break;

                    CGRect rect = [parent convertRect:parent.bounds toView:root];
                    CGFloat w = CGRectGetWidth(rect);
                    CGFloat h = CGRectGetHeight(rect);

                    if (w >= screenW * 0.65 &&
                        h >= 35.0 &&
                        h <= MIN(150.0, screenH * 0.16) &&
                        CGRectGetMidY(rect) > screenH * 0.70) {
                        candidate = parent;
                    } else {
                        break;
                    }
                }

                if (candidate != label) {
                    candidate.hidden = YES;
                    candidate.alpha = 0.0;
                    candidate.userInteractionEnabled = NO;
                }
            }
        }

        if (hide) {
            view.hidden = YES;
            view.alpha = 0.0;
            view.userInteractionEnabled = NO;
            continue;
        }

        [queue addObjectsFromArray:view.subviews];
    }
}

static void DYToolsRestoreVideoCollectionBarsInView(UIView *root) {
    if (!root) return;
    NSMutableArray<UIView *> *queue = [NSMutableArray arrayWithObject:root];
    while (queue.count) {
        UIView *view = queue.firstObject;
        [queue removeObjectAtIndex:0];

        if (view.hidden && view.alpha <= 0.001 && DYToolsLooksLikeCollectionBarView(view)) {
            view.hidden = NO;
            view.alpha = 1.0;
            view.userInteractionEnabled = YES;
        }
        [queue addObjectsFromArray:view.subviews];
    }
}

static void DYToolsScanVideoCollectionBars(void) {
    for (UIScene *scene in UIApplication.sharedApplication.connectedScenes) {
        if (![scene isKindOfClass:UIWindowScene.class]) continue;
        UIWindowScene *windowScene = (UIWindowScene *)scene;
        if (windowScene.activationState == UISceneActivationStateUnattached) continue;

        for (UIWindow *window in windowScene.windows) {
            if (window.hidden || window.alpha <= 0.01 || !window.rootViewController) continue;
            if (DYToolsHideVideoCollectionEnabled()) {
                NSMutableArray<UIViewController *> *controllers = [NSMutableArray arrayWithObject:window.rootViewController];
                while (controllers.count) {
                    UIViewController *vc = controllers.firstObject;
                    [controllers removeObjectAtIndex:0];
                    NSString *name = NSStringFromClass(vc.class);
                    if ([name containsString:@"AWEPlayInteraction"] ||
                        [name containsString:@"AwemeDetail"] ||
                        [name containsString:@"PlayerViewController"]) {
                        DYToolsHideVideoCollectionBarsInView(vc.view);
                    }
                    [controllers addObjectsFromArray:vc.childViewControllers];
                    if (vc.presentedViewController) [controllers addObject:vc.presentedViewController];
                }
            }
        }
    }
}

#pragma mark - 视频页去除弹窗

static BOOL DYToolsRemovePopupEnabled(void) {
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"DYYYRemoveSoftwarePopups"];
}

static BOOL DYToolsPopupKeyword(NSString *text) {
    if (!text.length) return NO;

    NSArray<NSString *> *keywords = @[
        @"剪映", @"CapCut", @"快影", @"必剪", @"秒剪",
        @"醒图", @"美图秀秀", @"轻颜", @"一甜", @"映剪",
        @"万兴喵影", @"来画",
        @"推广", @"广告", @"广告内容", @"广告详情",
        @"立即使用", @"打开应用", @"使用模板", @"拍同款",
        @"去看看", @"查看详情", @"立即体验", @"立即打开"
    ];

    for (NSString *keyword in keywords) {
        if ([text localizedCaseInsensitiveContainsString:keyword]) return YES;
    }
    return NO;
}

static BOOL DYToolsPopupClassName(UIView *view) {
    if (!view) return NO;
    NSString *name = NSStringFromClass(view.class);
    return [name localizedCaseInsensitiveContainsString:@"popup"] ||
           [name localizedCaseInsensitiveContainsString:@"popview"] ||
           [name localizedCaseInsensitiveContainsString:@"popover"] ||
           [name localizedCaseInsensitiveContainsString:@"promotion"] ||
           [name localizedCaseInsensitiveContainsString:@"marketing"] ||
           [name localizedCaseInsensitiveContainsString:@"adcontainer"];
}

static BOOL DYToolsIsVideoPageView(UIView *view) {
    if (!view) return NO;
    UIResponder *r = view;
    for (NSUInteger i = 0; i < 45 && (r = [r nextResponder]); i++) {
        if (![r isKindOfClass:UIViewController.class]) continue;
        NSString *name = NSStringFromClass([r class]);
        if ([name containsString:@"AWEPlayInteraction"] ||
            [name containsString:@"AwemeDetail"] ||
            [name containsString:@"PlayerViewController"] ||
            [name containsString:@"AWEAwemeDetail"] ||
            [name containsString:@"AwemePlay"]) {
            return YES;
        }
    }
    return NO;
}

static void DYToolsHidePopupContainer(UIView *view) {
    if (!view || !view.window) return;

    CGRect rect = [view convertRect:view.bounds toView:view.window];
    CGFloat screenW = CGRectGetWidth(view.window.bounds);
    CGFloat screenH = CGRectGetHeight(view.window.bounds);

    if (screenW <= 0 || screenH <= 0) return;

    if (CGRectGetWidth(rect) < 20.0 ||
        CGRectGetHeight(rect) < 12.0 ||
        CGRectGetWidth(rect) > screenW * 0.88 ||
        CGRectGetHeight(rect) > screenH * 0.28) {
        return;
    }

    view.hidden = YES;
    view.alpha = 0.0;
    view.userInteractionEnabled = NO;
}

static void DYToolsScanPopupView(UIView *root) {
    if (!root || !root.window || !DYToolsRemovePopupEnabled()) return;
    if (!DYToolsIsVideoPageView(root)) return;

    NSMutableArray<UIView *> *queue = [NSMutableArray arrayWithObject:root];

    while (queue.count) {
        UIView *view = queue.firstObject;
        [queue removeObjectAtIndex:0];

        BOOL keyword = NO;
        if ([view isKindOfClass:UILabel.class]) {
            keyword = DYToolsPopupKeyword(((UILabel *)view).text);
        } else if ([view isKindOfClass:UIButton.class]) {
            keyword = DYToolsPopupKeyword([(UIButton *)view titleForState:UIControlStateNormal]);
        }

        if (keyword || DYToolsPopupClassName(view)) {
            UIView *candidate = view;

            for (NSUInteger i = 0; i < 4; i++) {
                UIView *parent = candidate.superview;
                if (!parent) break;

                CGRect r = [parent convertRect:parent.bounds toView:root.window];
                CGFloat w = CGRectGetWidth(root.window.bounds);
                CGFloat h = CGRectGetHeight(root.window.bounds);

                if (CGRectGetWidth(r) >= 20.0 &&
                    CGRectGetHeight(r) >= 12.0 &&
                    CGRectGetWidth(r) <= w * 0.88 &&
                    CGRectGetHeight(r) <= h * 0.28) {
                    candidate = parent;
                } else {
                    break;
                }
            }

            DYToolsHidePopupContainer(candidate);
        }

        [queue addObjectsFromArray:view.subviews];
    }
}

static void DYToolsScanAllPopupWindows(void) {
    if (!DYToolsRemovePopupEnabled()) return;

    for (UIScene *scene in UIApplication.sharedApplication.connectedScenes) {
        if (![scene isKindOfClass:UIWindowScene.class]) continue;

        UIWindowScene *windowScene = (UIWindowScene *)scene;
        if (windowScene.activationState == UISceneActivationStateUnattached) continue;

        for (UIWindow *window in windowScene.windows) {
            if (window.hidden || window.alpha <= 0.01 || !window.rootViewController) continue;

            NSMutableArray<UIViewController *> *controllers =
                [NSMutableArray arrayWithObject:window.rootViewController];

            while (controllers.count) {
                UIViewController *vc = controllers.firstObject;
                [controllers removeObjectAtIndex:0];

                if (DYToolsIsVideoPageView(vc.view)) {
                    DYToolsScanPopupView(vc.view);
                }

                [controllers addObjectsFromArray:vc.childViewControllers];
                if (vc.presentedViewController) {
                    [controllers addObject:vc.presentedViewController];
                }
            }
        }
    }
}

static NSTimer *gDYToolsPopupTimer = nil;

static void DYToolsStartPopupScanner(void) {
    if (gDYToolsPopupTimer) return;

    gDYToolsPopupTimer =
        [NSTimer scheduledTimerWithTimeInterval:0.25
                                         repeats:YES
                                           block:^(__unused NSTimer *timer) {
        if (DYToolsRemovePopupEnabled()) {
            DYToolsScanAllPopupWindows();
        }
    }];

    [[NSRunLoop mainRunLoop] addTimer:gDYToolsPopupTimer
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

#pragma mark - 9. DYYY 屏蔽广告

%hook AWEAwemeModel

- (id)initWithDictionary:(id)dictionary error:(id *)error {
    id object = %orig(dictionary, error);

    if (!DYFixBool(@"DYYYNoAds") || !object) {
        return object;
    }

    @try {
        if ([[object valueForKey:@"isAds"] boolValue]) {
            return nil;
        }
    } @catch (__unused NSException *e) {
    }

    return object;
}

%end

%hook TTAdSplashModel

+ (id)alloc {
    if (DYFixBool(@"DYYYNoAds")) {
        return nil;
    }
    return %orig;
}

%end

%hook AWEOriginalAdModel

- (instancetype)init {
    if (DYFixBool(@"DYYYNoAds")) {
        return nil;
    }
    return %orig;
}

- (instancetype)initWithDictionary:(id)dictionary error:(NSError **)error {
    if (DYFixBool(@"DYYYNoAds")) {
        return nil;
    }
    return %orig;
}

%end

%hook AWEGeneralSearchModel

- (instancetype)initWithDictionary:(id)dictionary error:(NSError **)error {
    id object = %orig;

    if (!DYFixBool(@"DYYYNoAds") || !object) {
        return object;
    }

    @try {
        if ([[object valueForKeyPath:@"commonDynamicPatchModel.is_ad"] integerValue] == 1) {
            return nil;
        }
    } @catch (__unused NSException *e) {
    }

    return object;
}

%end

%hook AWEAwesomeSplashFeedCellOldAccessoryView

- (id)ddExtraView {
    if (DYFixBool(@"DYYYNoAds")) {
        return nil;
    }
    return %orig;
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
        DYToolsScanVideoCollectionBars();
        DYToolsStartPopupScanner();

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