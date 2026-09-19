#import <UIKit/UIKit.h>

#pragma mark - DYYY UIView class declarations

@interface AWEIncentiveSwiftImplDOUYINLite_IncentivePendantContainerView : UIView
@end

@interface ACCStickerContainerView : UIView
@end

@interface BDXWebView : UIView
@end

@interface IESLiveFeedDrawerEntranceView : UIView
@end

@interface IESLiveButton : UIView
@end

@interface AWELiveFlowAlertView : UIView
@end

@interface AWEPlayInteractionUserAvatarView : UIView
@end

@interface AWENormalModeTabBarBadgeContainerView : UIView
@end

@interface AWENormalModeTabBarFeedView : UIView
@end

@interface AWEFeedLiveTabRevisitControlView : UIView
@end

@interface IESLiveKTVSongIndicatorView : UIView
@end

@interface AWEFeedMultiTabSelectedContainerView : UIView
@end

@interface AFDRecommendToFriendEntranceLabel : UIView
@end

@interface AWEProfileMixItemCollectionViewCell : UIView
@end

@interface AWELiveAutoEnterStyleAView : UIView
@end

@interface AWECorrelationItemTag : UIView
@end

@interface AWEHPDiscoverFeedEntranceView : UIView
@end

@interface AWELiveStatusIndicatorView : UIView
@end

@interface AWELiveFeedLabelTagView : UIView
@end

@interface AWEPlayInteractionLiveExtendGuideView : UIView
@end

@interface AWEHPTopTabItemBadgeContentView : UIView
@end

@interface AWEIMFansGroupTopDynamicDomainTemplateView : UIView
@end

@interface AWEIMInputActionBarInteractor : UIView
@end

@interface AWETemplateCommonView : UIView
@end

@interface AWEHPTopBarCTAItemView : UIView
@end

@interface AWEFamiliarNavView : UIView
@end

@interface AWEPlayInteractionStrongifyShareContentView : UIView
@end

@interface AWELeftSideBarEntranceView : UIView
@end

@interface AWEFeedVideoButton : UIView
@end

@interface AWEHPSearchBubbleEntranceView : UIView
@end

@interface AWEPlayInteractionFollowPromptView : UIView
@end

@interface AWEHotSearchInnerBottomView : UIView
@end

@interface AWESearchEntranceView : UIView
@end

@interface AWEStoryProgressSlideView : UIView
@end

@interface AFDNewFastReplyView : UIView
@end

#import <Foundation/Foundation.h>
#import <objc/runtime.h>
#import <objc/message.h>
#import <math.h>
#import <QuartzCore/QuartzCore.h>

#pragma mark - Standalone fullscreen state

static NSString *const kDYFSFullScreenEnabledKey = @"DYYYEnableFullScreen";

static NSString *const kDYToolsRemoveShuiTingKey = @"DYToolsRemoveShuiTing";
static NSString *const kDYToolsRemoveRelatedSearchKey = @"DYToolsRemoveRelatedSearch";
static NSString *const kDYToolsRemoveHotspotKey = @"DYToolsRemoveHotspot";
static NSString *const kDYToolsHideEnterLiveKey = @"DYToolsHideEnterLive";
static NSString *const kDYToolsDisableAutoEnterLiveKey = @"DYToolsDisableAutoEnterLive";
static NSString *const kDYToolsHideMusicButtonKey = @"DYToolsHideMusicButton";
static NSString *const kDYToolsHideLocationKey = @"DYToolsHideLocation";


BOOL DYFSIsEnabled(void) {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults objectForKey:kDYFSFullScreenEnabledKey] == nil) {
        [defaults setBool:NO forKey:kDYFSFullScreenEnabledKey];
        [defaults synchronize];
    }
    if ([defaults objectForKey:kDYToolsRemoveShuiTingKey] == nil) {
        [defaults setBool:NO forKey:kDYToolsRemoveShuiTingKey];
    }
    if ([defaults objectForKey:kDYToolsRemoveRelatedSearchKey] == nil) {
        [defaults setBool:NO forKey:kDYToolsRemoveRelatedSearchKey];
    }
    if ([defaults objectForKey:kDYToolsRemoveHotspotKey] == nil) {
        [defaults setBool:NO forKey:kDYToolsRemoveHotspotKey];
    }
    if ([defaults objectForKey:kDYToolsHideEnterLiveKey] == nil) {
        [defaults setBool:NO forKey:kDYToolsHideEnterLiveKey];
    }
    if ([defaults objectForKey:kDYToolsDisableAutoEnterLiveKey] == nil) {
        [defaults setBool:NO forKey:kDYToolsDisableAutoEnterLiveKey];
    }
    // Migrate the old temporary key once, so existing installations keep their setting.
    if ([defaults objectForKey:kDYToolsHideMusicButtonKey] == nil) {
        BOOL oldValue = [defaults boolForKey:@"DYToolsHideSearchSame"];
        [defaults setBool:oldValue forKey:kDYToolsHideMusicButtonKey];
    }
    if ([defaults objectForKey:@"DYYYHideLocation"] == nil) {
        BOOL oldLocationValue = [defaults boolForKey:kDYToolsHideLocationKey];
        [defaults setBool:oldLocationValue forKey:@"DYYYHideLocation"];
    }
    NSArray *dyTopBarRemovalKeys = @[
        @"DYYYHideHotContainer",
        @"DYYYHideFriend",
        @"DYYYHideFollow",
        @"DYYYHideMediumVideo",
        @"DYYYHideMall",
        @"DYYYHideNearby",
        @"DYYYHideGroupon",
        @"DYYYHideTabLive",
        @"DYYYHidePadHot",
        @"DYYYHideHangout",
        @"DYYYHidePlaylet",
        @"DYYYHideCinema",
        @"DYYYHideKidsV2",
        @"DYYYHideGame"
    ];
    for (NSString *key in dyTopBarRemovalKeys) {
        if ([defaults objectForKey:key] == nil) [defaults setBool:NO forKey:key];
    }

    NSArray *dyTopBarKeys = @[
        @"DYYYHideEntry",
        @"DYYYHideShopButton",
        @"DYYYHideDoubleColumnEntry",
        @"DYYYHideMessageButton",
        @"DYYYHideFriendsButton",
        @"DYYYHideMyButton",
        @"DYYYHidePlusButton",
        @"DYYYHideHotSearch",
        @"DYYYHideComment",
        @"DYYYHideBottomDot",
        @"DYYYHideBottomBg",
        @"DYYYHidePadTabBarElements",
        @"DYYYHideSidebarRecentApps",
        @"DYYYHideSidebarRecentUsers",
        @"DYYYHideSidebarDot",
        @"DYYYHidePostView",
        @"DYYYHideLOTAnimationView",
        @"DYYYHideFollowPromptView",
        @"DYYYHideLikeLabel",
        @"DYYYHideCommentLabel",
        @"DYYYHideCollectLabel",
        @"DYYYHideShareLabel",
        @"DYYYHideLikeButton",
        @"DYYYHideCommentButton",
        @"DYYYHideCollectButton",
        @"DYYYHideAvatarButton",
        @"DYYYHideMusicButton",
        @"DYYYHideShareButton",
        @"DYYYHideLocation",
        @"DYYYHideDiscover",
        @"DYYYHideInteractionSearch",
        @"DYYYHideSearchBubble",
        @"DYYYHideSearchSame",
        @"DYYYHideSearchEntrance",
        @"DYYYHideEnterLive",
        @"DYYYHideCommentViews",
        @"DYYYHidePushBanner",
        @"DYYYHideMessageTabRedPacket",
        @"DYYYHideAvatarList",
        @"DYYYHideAvatarBubble",
        @"DYYYHideLeftSideBar",
        @"DYYYHideNearbyCapsuleView",
        @"DYYYHideDanmuButton",
        @"DYYYHideCancelMute",
        @"DYYYHideQuqishuiting",
        @"DYYYHideGongChuang",
        @"DYYYHideHotspot",
        @"DYYYHideRecommendTips",
        @"DYYYHideShareContentView",
        @"DYYYHideAntiAddictedNotice",
        @"DYYYHideBottomRelated",
        @"DYYYHideFeedAnchorContainer",
        @"DYYYHideChallengeStickers",
        @"DYYYHideEditTags",
        @"DYYYHideTemplateTags",
        @"DYYYHideHisShop",
        @"DYYYHideTopBarLine",
        @"DYYYHideTemplateVideo",
        @"DYYYHideTemplatePlaylet",
        @"DYYYHideLiveGIF",
        @"DYYYHideItemTag",
        @"DYYYHideTemplateGroup",
        @"DYYYHideCameraLocation",
        @"DYYYHideStoryProgressSlide",
        @"DYYYHideDotsIndicator",
        @"DYYYHidePrivateMessages",
        @"DYYYHideRightLabel",
        @"DYYYHideGroupShop",
        @"DYYYHideLiveCapsuleView",
        @"DYYYHideLiveView",
        @"DYYYHideConcernCapsuleView",
        @"DYYYHideMenuView",
        @"DYYYHideGroupLiveIndicator",
        @"DYYYHideGroupInputActionBar",
        @"DYYYHideButton",
        @"DYYYHideFamiliar",
        @"DYYYHideLivePlayground",
        @"DYYYHideGiftPavilion",
        @"DYYYHideTopBarBadge",
        @"DYYYHideLiveRoomClear",
        @"DYYYHideLiveRoomMirroring",
        @"DYYYHideLiveDiscovery",
        @"DYYYHideKTVSongIndicator",
        @"DYYYHideCellularAlert",
        @"DYYYHidePendantGroup",
        @"DYYYHideChapterProgress",
        @"DYYYHideKeyboardAI",
        @"DYYYHidePopover"
    ];
    for (NSString *key in dyTopBarKeys) {
        if ([defaults objectForKey:key] == nil) [defaults setBool:NO forKey:key];
    }

    NSArray *dyBottomBarKeys = @[
        @"DYYYHideShopButton",
        @"DYYYHideDoubleColumnEntry",
        @"DYYYHideMessageButton",
        @"DYYYHideFriendsButton",
        @"DYYYHideMyButton",
        @"DYYYHidePlusButton",
        @"DYYYHideComment",
        @"DYYYHideBottomDot",
        @"DYYYHideBottomBg",
        @"DYYYHidePadTabBarElements"
    ];
    for (NSString *key in dyBottomBarKeys) {
        if ([defaults objectForKey:key] == nil) [defaults setBool:NO forKey:key];
    }

    [defaults synchronize];
    return [defaults boolForKey:kDYFSFullScreenEnabledKey];
}

static CGFloat gDYFSOriginalTabBarHeight = 0.0;
static CGFloat gDYFSCurrentTabBarHeight = 0.0;

static char kDYFSFeedTableOriginalHeightKey;
static char kDYFSAuthorOriginalFrameKey;
static char kDYFSLiveAppliedKey;

static void (*gDYFSRestoreHooks[8])(void);
static NSUInteger gDYFSRestoreCount = 0;
static NSHashTable<UITableView *> *gDYFSStretchedTables;

static BOOL DYFSShouldAdjustMetalView(UIView *view);
static BOOL DYFSIsAuthorWorkDetailContext(UIView *view);

static UIViewController *DYFSFirstViewControllerFromView(UIView *view) {
    if (!view) return nil;
    UIResponder *r = view;
    while ((r = [r nextResponder])) {
        if ([r isKindOfClass:UIViewController.class]) return (UIViewController *)r;
    }
    return nil;
}

NSArray<UIView *> *DYFSFindAllSubviewsOfClass(Class cls, UIView *container) {
    if (!cls || !container) return @[];
    NSMutableArray *result = [NSMutableArray array];
    NSMutableArray *queue = [NSMutableArray arrayWithObject:container];
    while (queue.count) {
        UIView *view = queue.firstObject;
        [queue removeObjectAtIndex:0];
        if ([view isKindOfClass:cls] && view != container) [result addObject:view];
        [queue addObjectsFromArray:view.subviews];
    }
    return result;
}

BOOL DYFSContainsSubviewOfClass(Class cls, UIView *container) {
    if (!cls || !container) return NO;
    if ([container isKindOfClass:cls]) return YES;
    for (UIView *sub in container.subviews) {
        if (DYFSContainsSubviewOfClass(cls, sub)) return YES;
    }
    return NO;
}

static BOOL DYFSIsAuthorProfileContext(UIView *view) {
    if (!view) return NO;
    UIResponder *r = view;
    NSInteger depth = 0;
    while ((r = [r nextResponder]) && depth++ < 20) {
        NSString *name = NSStringFromClass([r class]);
        if ([name containsString:@"UserHomeViewController"] ||
            [name containsString:@"UserProfileViewController"] ||
            [name containsString:@"ProfileViewController"] ||
            [name containsString:@"UserHome"]) {
            return YES;
        }
    }
    return NO;
}

static void DYFSRegisterRestore(void (*restore)(void)) {
    if (!restore || gDYFSRestoreCount >= 8) return;
    gDYFSRestoreHooks[gDYFSRestoreCount++] = restore;
}

static void DYFSRunRestoreHooks(void) {
    for (NSUInteger i = 0; i < gDYFSRestoreCount; i++) {
        if (gDYFSRestoreHooks[i]) gDYFSRestoreHooks[i]();
    }
}

static UIWindow *DYFSActiveWindow(void) {
    for (UIScene *scene in UIApplication.sharedApplication.connectedScenes) {
        if (![scene isKindOfClass:UIWindowScene.class]) continue;
        UIWindowScene *ws = (UIWindowScene *)scene;
        if (ws.activationState == UISceneActivationStateUnattached) continue;
        for (UIWindow *w in ws.windows) {
            if (w.isKeyWindow && !w.hidden) return w;
        }
        for (UIWindow *w in ws.windows) {
            if (!w.hidden && w.alpha > 0.01 && w.rootViewController) return w;
        }
    }
    return nil;
}

#pragma mark - Tab bar

@interface AWENormalModeTabBar : UIView
@property(nonatomic,strong) UIView *skinContainerView;
- (void)initializeOriginalTabBarHeight;
@end

%hook AWENormalModeTabBar

- (void)didMoveToWindow {
    %orig;
    if (self.window && gDYFSOriginalTabBarHeight <= 0.0) {
        CGFloat h = self.bounds.size.height;
        if (h < 30.0) h = 49.0 + self.window.safeAreaInsets.bottom;
        gDYFSOriginalTabBarHeight = h;
        gDYFSCurrentTabBarHeight = h;
    }
}

- (void)layoutSubviews {
    %orig;

    if (gDYFSOriginalTabBarHeight <= 0.0) {
        CGFloat h = self.bounds.size.height;
        if (h >= 30.0) {
            gDYFSOriginalTabBarHeight = h;
            gDYFSCurrentTabBarHeight = h;
        }
    }
    if (gDYFSCurrentTabBarHeight <= 0.0) gDYFSCurrentTabBarHeight = gDYFSOriginalTabBarHeight;

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

    BOOL hideShop = [defaults boolForKey:@"DYYYHideShopButton"];
    BOOL hideMsg = [defaults boolForKey:@"DYYYHideMessageButton"];
    BOOL hideFriends = [defaults boolForKey:@"DYYYHideFriendsButton"];
    BOOL hideMy = [defaults boolForKey:@"DYYYHideMyButton"];

    NSMutableArray<UIView *> *visibleButtons = [NSMutableArray array];
    for (UIView *sub in [self.subviews copy]) {
        NSString *label = sub.accessibilityLabel ?: @"";
        NSString *className = NSStringFromClass(sub.class);
        BOOL isGeneralButton =
            [className isEqualToString:@"AWENormalModeTabBarGeneralButton"] ||
            [className isEqualToString:@"AWENormalModeTabBarGeneralPlusButton"];

        BOOL shouldHide =
            (hideShop && [label containsString:@"商城"]) ||
            (hideMsg && [label containsString:@"消息"]) ||
            (hideFriends && [label containsString:@"朋友"]) ||
            (hideMy && [label isEqualToString:@"我"]);

        if (shouldHide) {
            sub.hidden = YES;
            sub.userInteractionEnabled = NO;
        } else if (isGeneralButton) {
            sub.hidden = NO;
            [visibleButtons addObject:sub];
        }
    }

    if (visibleButtons.count > 0 && (hideShop || hideMsg || hideFriends || hideMy)) {
        CGFloat width = self.bounds.size.width / visibleButtons.count;
        for (NSUInteger i = 0; i < visibleButtons.count; i++) {
            UIView *button = visibleButtons[i];
            CGRect frame = button.frame;
            frame.origin.x = i * width;
            frame.size.width = width;
            button.frame = frame;
        }
    }

    if (!DYFSIsEnabled()) return;

    Class bgClass = NSClassFromString(@"_UIBarBackground");
    for (UIView *sub in self.subviews) {
        if ([sub isKindOfClass:bgClass] ||
            ([sub isMemberOfClass:UIView.class] && gDYFSOriginalTabBarHeight > 0.0 &&
             fabs(sub.frame.size.height - gDYFSCurrentTabBarHeight) < 0.5)) {
            sub.hidden = YES;
        }
        if (sub.frame.size.height > 0 && sub.frame.size.height < 1.0 &&
            sub.frame.size.width > 300.0) {
            sub.hidden = YES;
        }
    }
    if (self.skinContainerView) self.skinContainerView.hidden = YES;
}

%end

#pragma mark - Main feed/detail height

@interface AWEPlayInteractionViewController : UIViewController
@property(nonatomic,copy) NSString *referString;
@property(nonatomic,strong) id model;
@end

static CGFloat DYFSFeedTableOriginalHeight(UIView *view);

%hook AWEPlayInteractionViewController

- (void)viewDidLayoutSubviews {
    %orig;

    if (!DYFSIsEnabled()) return;

    UIView *view = self.viewIfLoaded;
    if (!view) return;

    CGFloat original = DYFSFeedTableOriginalHeight(view);
    if (original <= 0.0) return;

    CGRect frame = view.frame;
    if (fabs(frame.origin.y) <= 0.5 &&
        frame.size.height <= original + 0.5) {
        return;
    }

    frame.origin.y = 0.0;
    frame.size.height = original;
    view.frame = frame;
}

%end

@interface AWEDPlayerFeedPlayerViewController : UIViewController
@property(nonatomic,strong) UIView *contentView;
@end

%hook AWEDPlayerFeedPlayerViewController
- (void)viewDidLayoutSubviews {
    // Keep Douyin's original contentView geometry.
    // Expanding this view to the stretched feed height pushes the title/caption down.
    %orig;
}
%end

@interface AWEDPlayerViewController_Merge : UIViewController
@property(nonatomic,strong) UIView *contentView;
@end

@interface AWEFeedDataSafeTableView : UITableView
@end

static void DYFSAdjustFeedTableFrame(UITableView *table, CGRect *frame) {
    if (!DYFSIsEnabled()) return;

    UIView *parent = table.superview;
    CGFloat target = parent ? parent.bounds.size.height : 0.0;
    CGFloat current = frame->size.height;

    if (target <= 0.0 || current >= target - 0.5 || current < target * 0.5) return;

    if (!objc_getAssociatedObject(table, &kDYFSFeedTableOriginalHeightKey)) {
        objc_setAssociatedObject(table, &kDYFSFeedTableOriginalHeightKey,
                                 @(current), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        if (!gDYFSStretchedTables) gDYFSStretchedTables = [NSHashTable weakObjectsHashTable];
        [gDYFSStretchedTables addObject:table];
    }

    frame->size.height = target;
}

static UIView *DYFSFeedTableForView(UIView *view) {
    if (!view) return nil;
    Class tableClass = NSClassFromString(@"AWEFeedDataSafeTableView");
    if (!tableClass) return nil;

    UIView *ancestor = view.superview;
    for (NSUInteger i = 0; ancestor && i < 8; i++, ancestor = ancestor.superview) {
        if ([ancestor isKindOfClass:tableClass]) return ancestor;
    }
    return nil;
}

static CGFloat DYFSFeedTableOriginalHeight(UIView *view) {
    UIView *table = DYFSFeedTableForView(view);
    if (!table) return 0.0;
    NSNumber *n = objc_getAssociatedObject(table, &kDYFSFeedTableOriginalHeightKey);
    return n.doubleValue;
}

static NSNumber *DYFSFeedTableOriginalHeightNumber(UIView *view) {
    UIView *table = DYFSFeedTableForView(view);
    return table ? objc_getAssociatedObject(table, &kDYFSFeedTableOriginalHeightKey) : nil;
}

static void DYFSRestoreFeedTables(void) {
    for (UITableView *table in gDYFSStretchedTables.allObjects) {
        NSNumber *original = objc_getAssociatedObject(table, &kDYFSFeedTableOriginalHeightKey);
        if (!original) continue;

        objc_setAssociatedObject(table, &kDYFSFeedTableOriginalHeightKey, nil,
                                 OBJC_ASSOCIATION_RETAIN_NONATOMIC);

        CGRect f = table.frame;
        f.size.height = original.doubleValue;
        table.frame = f;
    }    [gDYFSStretchedTables removeAllObjects];
}

%hook AWEFeedDataSafeTableView
- (void)setFrame:(CGRect)frame {
    DYFSAdjustFeedTableFrame(self, &frame);
    %orig(frame);
}
%end

// AWEFeedTableView 在部分版本会自己实现 setFrame:，因此基类 hook 不够。
@interface AWEFeedTableView : UITableView
@end
%hook AWEFeedTableView
- (void)setFrame:(CGRect)frame {
    DYFSAdjustFeedTableFrame(self, &frame);
    %orig(frame);
}
%end

@interface AWEStoryContainerCollectionView : UIView
@end
#pragma mark - Author profile / image works

%hook AWEStoryContainerCollectionView
- (void)layoutSubviews {
    %orig;
    if (!DYFSIsEnabled()) return;
    if (self.subviews.count == 2) return;

    id enableEnterProfile = nil;
    @try { enableEnterProfile = [self valueForKey:@"enableEnterProfile"]; } @catch (__unused NSException *e) {}
    BOOL isHome = [enableEnterProfile respondsToSelector:@selector(boolValue)] && [enableEnterProfile boolValue];

    BOOL isAuthor = DYFSIsAuthorProfileContext(self);
    if (!isHome && !isAuthor) return;

    for (UIView *subview in [self.subviews copy]) {
        UIView *next = (UIView *)subview.nextResponder;

        if (isHome && [next isKindOfClass:NSClassFromString(@"AWEPlayInteractionViewController")]) {
            UIViewController *base = nil;
            @try { base = [next valueForKey:@"awemeBaseViewController"]; } @catch (__unused NSException *e) {}
            if (base && ![base isKindOfClass:NSClassFromString(@"AWEFeedCellViewController")]) continue;

            CGRect f = subview.frame;
            f.size.height = subview.superview.bounds.size.height - gDYFSCurrentTabBarHeight;
            subview.frame = f;
        } else if (isAuthor) {
            BOOL isWorkImage = NO;
            for (UIView *child in subview.subviews) {
                NSString *name = NSStringFromClass(child.class);
                if ([name containsString:@"ImageView"] || [name containsString:@"ThumbnailView"]) {
                    isWorkImage = YES;
                    break;
                }
            }
            if (!isWorkImage) continue;

            CGRect original = subview.frame;
            NSValue *stored = objc_getAssociatedObject(subview, &kDYFSAuthorOriginalFrameKey);
            if (stored) original = stored.CGRectValue;
            else objc_setAssociatedObject(subview, &kDYFSAuthorOriginalFrameKey,
                                           [NSValue valueWithCGRect:original],
                                           OBJC_ASSOCIATION_RETAIN_NONATOMIC);

            CGRect adjusted = original;
            adjusted.origin.y += MAX(gDYFSCurrentTabBarHeight, 0.0);
            if (!CGRectEqualToRect(subview.frame, adjusted)) subview.frame = adjusted;
        }
    }
}
%end

@interface AWEAwemeDetailTableView : UITableView
@end

%hook AWEAwemeDetailTableView
- (void)setFrame:(CGRect)frame {
    DYFSAdjustFeedTableFrame(self, &frame);
    %orig(frame);
}
%end

#pragma mark - Live preview chrome

@interface AWELivePreStream4LayerContainerView : UIView
@property(nonatomic,strong) UIImageView *bottomDarkWatermark;
@property(nonatomic,strong) UIView *controlContainer;
@end

static BOOL DYFSIsLivePreviewController(UIView *view) {
    UIViewController *vc = DYFSFirstViewControllerFromView(view);
    if (!vc) return NO;
    NSString *name = NSStringFromClass(vc.class);
    return [name containsString:@"AWELiveNewPreStreamViewController"] ||
           [name containsString:@"AWELivePreStream"];
}

static void DYFSApplyLivePreviewLift(AWELivePreStream4LayerContainerView *container) {
    if (!container || !DYFSIsEnabled() || !container.window) return;
    if (!DYFSIsLivePreviewController(container)) return;

    UIView *control = container.controlContainer;
    if (control && !objc_getAssociatedObject(control, &kDYFSLiveAppliedKey)) {
        CGFloat lift = MAX(gDYFSCurrentTabBarHeight, gDYFSOriginalTabBarHeight);
        if (lift > 0.5) {
            CGAffineTransform base = control.transform;
            objc_setAssociatedObject(control, &kDYFSLiveAppliedKey,
                                     [NSValue valueWithCGAffineTransform:base],
                                     OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            control.transform = CGAffineTransformTranslate(base, 0.0, -lift);
        }
    }

    UIView *watermark = container.bottomDarkWatermark;
    if (watermark && !objc_getAssociatedObject(watermark, &kDYFSLiveAppliedKey)) {
        CGFloat lift = MAX(gDYFSCurrentTabBarHeight, gDYFSOriginalTabBarHeight);
        CGAffineTransform base = watermark.transform;
        objc_setAssociatedObject(watermark, &kDYFSLiveAppliedKey,
                                 [NSValue valueWithCGAffineTransform:base],
                                 OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        watermark.transform = CGAffineTransformTranslate(base, 0.0, -lift);
    }
}

%hook AWELivePreStream4LayerContainerView
- (void)layoutSubviews {
    %orig;
    if (!DYFSIsEnabled()) return;
    if (!self.window) return;
    dispatch_async(dispatch_get_main_queue(), ^{
        DYFSApplyLivePreviewLift(self);
    });
}
%end

#pragma mark - Visual cleanup needed by fullscreen

@interface AWEPlayInteractionProgressContainerView : UIView @end
%hook AWEPlayInteractionProgressContainerView
- (void)layoutSubviews {
    %orig;
    if (!DYFSIsEnabled()) return;
    for (UIView *v in self.subviews) if ([v isMemberOfClass:UIView.class]) v.backgroundColor = UIColor.clearColor;
}
%end

@interface AWEDPlayerProgressContainerView : UIView @end
%hook AWEDPlayerProgressContainerView
- (void)layoutSubviews {
    %orig;
    if (!DYFSIsEnabled()) return;
    for (UIView *v in self.subviews) {
        if (![v isMemberOfClass:UIView.class]) continue;
        UIColor *c=v.backgroundColor;
        CGFloat h,s,b,a;
        if (c && [c getHue:&h saturation:&s brightness:&b alpha:&a] && b < 0.2) v.backgroundColor=UIColor.clearColor;
    }
}
%end

@interface AFDFastSpeedView : UIView @end
%hook AFDFastSpeedView
- (void)layoutSubviews {
    %orig;
    if (!DYFSIsEnabled()) return;
    for (UIView *v in self.subviews) if ([v isMemberOfClass:UIView.class]) v.backgroundColor=UIColor.clearColor;
}
%end

@interface AFDViewedBottomView : UIView
@property(nonatomic,strong) UIView *effectView;
@end
%hook AFDViewedBottomView
- (void)layoutSubviews {
    %orig;
    if (!DYFSIsEnabled()) return;
    self.backgroundColor=UIColor.clearColor;
    self.effectView.hidden=YES;
}
%end

#pragma mark - Landscape / image album positioning

@interface TTMetalView : UIView @end
%hook TTMetalView
- (void)setCenter:(CGPoint)center {
    if (DYFSShouldAdjustMetalView(self)) center.y -= (gDYFSCurrentTabBarHeight > 0 ? gDYFSCurrentTabBarHeight : gDYFSOriginalTabBarHeight) * 0.5;
    %orig(center);
}
%end

@interface TTMetalViewNew : UIView @end
%hook TTMetalViewNew
- (void)setCenter:(CGPoint)center {
    if (DYFSShouldAdjustMetalView(self)) center.y -= (gDYFSCurrentTabBarHeight > 0 ? gDYFSCurrentTabBarHeight : gDYFSOriginalTabBarHeight) * 0.5;
    %orig(center);
}
%end

@interface TTMetalViewVP : UIView @end
%hook TTMetalViewVP
- (void)setCenter:(CGPoint)center {
    if (DYFSShouldAdjustMetalView(self)) center.y -= (gDYFSCurrentTabBarHeight > 0 ? gDYFSCurrentTabBarHeight : gDYFSOriginalTabBarHeight) * 0.5;
    %orig(center);
}
%end

static BOOL DYFSShouldAdjustMetalView(UIView *view) {
    if (!view || !DYFSIsEnabled()) return NO;
    if (view.bounds.size.width + 0.5 < UIScreen.mainScreen.bounds.size.width) return NO;
    UIViewController *vc = DYFSFirstViewControllerFromView(view);
    Class playClass = NSClassFromString(@"AWEPlayVideoViewController");
    if (!playClass || ![vc isKindOfClass:playClass]) return NO;
    id model = nil;
    @try { model = [vc valueForKey:@"model"]; } @catch (__unused NSException *e) {}
    if (![model respondsToSelector:@selector(isShowLandscapeEntryView)]) return NO;
    return ((BOOL (*)(id, SEL))objc_msgSend)(model, @selector(isShowLandscapeEntryView));
}

@interface AWEStoryProgressContainerView : UIView @end
%hook AWEStoryProgressContainerView
- (void)setCenter:(CGPoint)center {
    if (!DYFSIsEnabled()) {
        %orig(center);
        return;
    }
    UIViewController *vc=DYFSFirstViewControllerFromView(self);
    BOOL pure=[vc isKindOfClass:NSClassFromString(@"AWEFeedPlayControlImpl.PureModePageCellViewController")];
    NSString *version=NSBundle.mainBundle.infoDictionary[@"CFBundleShortVersionString"];
    BOOL legacy=version.length==0 || [version compare:@"37.2.0" options:NSNumericSearch] == NSOrderedAscending;
    if (pure && legacy && gDYFSCurrentTabBarHeight>0) center.y -= gDYFSCurrentTabBarHeight;
    %orig(center);
}
%end

#pragma mark - Other fullscreen layout compensation

@interface AWEMixVideoPanelMoreView : UIView @end
%hook AWEMixVideoPanelMoreView
- (void)setFrame:(CGRect)frame {
    if (!DYFSIsEnabled()) {
        %orig(frame);
        return;
    }
    CGFloat targetY=frame.origin.y-gDYFSCurrentTabBarHeight;
    CGFloat expected=UIScreen.mainScreen.bounds.size.height-gDYFSCurrentTabBarHeight;
    if (fabs(targetY-expected)<=10.0) frame.origin.y=targetY;
    %orig(frame);
}
- (void)layoutSubviews {
    %orig;
    self.backgroundColor=UIColor.clearColor;
}
%end

@interface CommentInputContainerView : UIView @end
%hook CommentInputContainerView
- (void)layoutSubviews {
    %orig;
    if (!DYFSIsEnabled()) return;
    if (DYFSIsAuthorWorkDetailContext(self) || DYFSIsAuthorProfileContext(self)) {
        self.hidden = YES;
        self.alpha = 0.0;
        return;
    }
    UIViewController *parent=nil;
    if ([self respondsToSelector:@selector(viewController)]) {
        id vc=[self performSelector:@selector(viewController)];
        if ([vc respondsToSelector:@selector(parentViewController)]) parent=[vc parentViewController];
    }
    if (parent && ([parent isKindOfClass:NSClassFromString(@"AWEAwemeDetailTableViewController")] ||
                   [parent isKindOfClass:NSClassFromString(@"AWEAwemeDetailCellViewController")])) {
        UIView *target=nil;
        static char kTarget;
        target=objc_getAssociatedObject(self,&kTarget);
        if (!target) {
            for (UIView *v in self.subviews) if ([v isMemberOfClass:UIView.class]) { target=v; objc_setAssociatedObject(self,&kTarget,target,OBJC_ASSOCIATION_ASSIGN); break; }
        }
        if (target) target.hidden=(self.frame.size.height <= gDYFSCurrentTabBarHeight+0.5);
    }
}
%end

@interface AWEIMFeedBottomQuickEmojiInputBar : UIView @end
%hook AWEIMFeedBottomQuickEmojiInputBar
- (void)layoutSubviews {
    %orig;
    if (!DYFSIsEnabled()) return;
    UIView *p=self.superview;
    while (p && ![NSStringFromClass(p.class) isEqualToString:@"UIView"]) p=p.superview;
    if (p) { p.backgroundColor=UIColor.clearColor; p.layer.backgroundColor=UIColor.clearColor.CGColor; p.opaque=NO; }
}
%end

@interface AWEConcernCellLastView : UIView @end
%hook AWEConcernCellLastView
- (void)layoutSubviews {
    %orig;
    if (!DYFSIsEnabled() || gDYFSCurrentTabBarHeight<=0) return;

    static char kDYFSConcernOriginalFramesKey;
    NSArray *frames = objc_getAssociatedObject(self, &kDYFSConcernOriginalFramesKey);
    if (!frames) {
        NSMutableArray *saved = [NSMutableArray array];
        for (UIView *v in self.subviews) [saved addObject:[NSValue valueWithCGRect:v.frame]];
        frames = [saved copy];
        objc_setAssociatedObject(self, &kDYFSConcernOriginalFramesKey, frames, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    NSUInteger count = MIN(frames.count, self.subviews.count);
    for (NSUInteger i = 0; i < count; i++) {
        UIView *v = self.subviews[i];
        CGRect f = [frames[i] CGRectValue];
        f.origin.y -= gDYFSCurrentTabBarHeight;
        v.frame = f;
    }
}
%end

@interface AWECommentInputBackgroundView : UIView @end
%hook AWECommentInputBackgroundView
- (void)layoutSubviews {
    %orig;

    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"DYYYHideComment"]) {
        [self removeFromSuperview];
        return;
    }

    if (!DYFSIsEnabled()) return;

    if (DYFSIsAuthorWorkDetailContext(self) || DYFSIsAuthorProfileContext(self)) {
        self.hidden = YES;
        self.alpha = 0.0;
        return;
    }

    self.transform = CGAffineTransformMakeTranslation(0, gDYFSOriginalTabBarHeight - gDYFSCurrentTabBarHeight);
}
%end

#pragma mark - Global video geometry guard

// 40.4.0 writes the actual video container and the interaction HUD through
// UIView setFrame:. Intercept the write itself so search-page extra content
// cannot move the video down or leave a black strip below it.

static Class DYFSMergeClass(void) {
    static Class cls;
    static dispatch_once_t once;
    dispatch_once(&once, ^{ cls = NSClassFromString(@"AWEDPlayerViewController_Merge"); });
    return cls;
}

static Class DYFSHUDClass(void) {
    static Class cls;
    static dispatch_once_t once;
    dispatch_once(&once, ^{ cls = NSClassFromString(@"AWEPlayInteractionViewController"); });
    return cls;
}

static UIView *DYFSCellContentView(UIView *view) {
    Class cls = NSClassFromString(@"UITableViewCellContentView");
    if (!cls) return nil;
    for (NSUInteger i = 0; view && i < 12; i++, view = view.superview) {
        if ([view isKindOfClass:cls]) return view;
    }
    return nil;
}

static CGFloat DYFSFullCellHeightForView(UIView *view) {
    UIView *content = DYFSCellContentView(view ? view.superview : nil);
    return content ? CGRectGetHeight(content.bounds) : 0.0;
}

static BOOL DYFSCanFullscreenMerge(UIViewController *merge) {
    if (!merge || ![merge isKindOfClass:DYFSMergeClass()]) return NO;

    id model = nil;
    @try { model = [merge valueForKey:@"model"]; } @catch (__unused NSException *e) {}

    NSNumber *type = nil;
    @try { type = [model valueForKey:@"awemeType"]; } @catch (__unused NSException *e) {}
    if (type && type.longLongValue == 68) return NO;

    NSNumber *landscape = nil;
    @try { landscape = [merge valueForKey:@"hasInlandscape"]; } @catch (__unused NSException *e) {}
    if (landscape.boolValue) return NO;

    if ([merge respondsToSelector:@selector(isInLandscapeFeedStatus)]) {
        BOOL inLandscape = NO;
        @try { inLandscape = ((BOOL (*)(id, SEL))objc_msgSend)(merge, @selector(isInLandscapeFeedStatus)); }
        @catch (__unused NSException *e) {}
        if (inLandscape) return NO;
    }

    id video = nil;
    @try { video = [model valueForKey:@"video"]; } @catch (__unused NSException *e) {}
    NSNumber *w = nil;
    NSNumber *h = nil;
    @try { w = [video valueForKey:@"width"]; h = [video valueForKey:@"height"]; }
    @catch (__unused NSException *e) {}

    double width = w.doubleValue;
    double height = h.doubleValue;
    return width <= 0.0 || height <= 0.0 || (height / width) >= 1.70;
}

static CGRect DYFSAdjustMergeFrame(UIView *view, CGRect frame) {
    if (!DYFSIsEnabled() || !view) return CGRectNull;

    UIWindow *window = view.window;
    if (window && window.windowLevel != UIWindowLevelNormal) return CGRectNull;

    UIViewController *owner = (UIViewController *)view.nextResponder;
    if (![owner isKindOfClass:DYFSMergeClass()]) return CGRectNull;
    if (!DYFSCanFullscreenMerge(owner)) return CGRectNull;

    UIView *parent = view.superview;
    if (!parent) return CGRectNull;

    CGFloat width = CGRectGetWidth(parent.bounds);
    CGFloat height = CGRectGetHeight(parent.bounds);
    if (width <= 0.0 || height <= 0.0) return CGRectNull;

    CGFloat full = DYFSFullCellHeightForView(view);
    if (full > height) height = full;

    CGRect target = CGRectMake(0.0, 0.0, width, height);
    if (fabs(frame.origin.x - target.origin.x) <= 0.5 &&
        fabs(frame.origin.y - target.origin.y) <= 0.5 &&
        fabs(frame.size.width - target.size.width) <= 0.5 &&
        fabs(frame.size.height - target.size.height) <= 0.5) return CGRectNull;
    return target;
}

static CGRect DYFSAdjustHUDFrame(UIView *view, CGRect frame) {
    if (!DYFSIsEnabled() || !view) return CGRectNull;

    UIResponder *owner = view.nextResponder;
    if (![owner isKindOfClass:DYFSHUDClass()]) return CGRectNull;

    NSNumber *originalNumber = DYFSFeedTableOriginalHeightNumber(view);
    if (!originalNumber) return CGRectNull;

    CGFloat original = originalNumber.doubleValue;
    if (original <= 0.0) return CGRectNull;

    // Only suppress the stretched-height write. Smaller/normal frames are native
    // states (comments, animations, reuse) and must pass through unchanged.
    if (CGRectGetHeight(frame) <= original + 0.5) return CGRectNull;

    frame.size.height = original;
    return frame;
}

%hook AWEDPlayerViewController_Merge
- (void)willDisplay {
    %orig;
    if (!DYFSIsEnabled()) return;

    // At willDisplay the reused cell has its final model and hierarchy.
    // Recompute once after binding; this removes the alternating-cell effect.
    UIView *view = self.viewIfLoaded;
    if (!view) return;

    CGRect target = DYFSAdjustMergeFrame(view, view.frame);
    if (!CGRectIsNull(target)) view.frame = target;
}

- (void)viewDidLayoutSubviews {
    %orig;
    if (!DYFSIsEnabled()) return;

    UIView *view = self.viewIfLoaded;
    if (!view) return;

    CGRect target = DYFSAdjustMergeFrame(view, view.frame);
    if (!CGRectIsNull(target)) view.frame = target;
}
%end

%hook UIView
- (void)setFrame:(CGRect)frame {
    CGRect adjusted = DYFSAdjustMergeFrame(self, frame);
    if (!CGRectIsNull(adjusted)) {
        %orig(adjusted);
        return;
    }
    adjusted = DYFSAdjustHUDFrame(self, frame);
    if (!CGRectIsNull(adjusted)) {
        %orig(adjusted);
        return;
    }
    %orig(frame);
}
%end

#pragma mark - Fullscreen bottom backdrop

// Search/detail pages can have a player background view whose color is the only
// thing covering the area exposed when the player is pinned to the full cell.
// Copy that actual background color to the first ancestor that exposes the
// area below the player. This is the same strategy used by DYKiller.
static char kDYFSBackdropAppliedKey;
static char kDYFSCellBackdropKey;

static Class DYFSRichContentContainerClass(void) {
    static Class cls;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        cls = NSClassFromString(@"RichContentContainerViewController");
    });
    return cls;
}

static BOOL DYFSIsUnderRichContent(UIViewController *controller) {
    Class richCls = DYFSRichContentContainerClass();
    if (!richCls) return NO;

    for (NSUInteger i = 0; controller && i < 12; i++) {
        if ([controller isKindOfClass:richCls]) return YES;
        controller = controller.parentViewController;
    }
    return NO;
}

static UIView *DYFSBackdropCanvas(UIView *anchor) {
    UIView *content = DYFSCellContentView(anchor);
    if (!content) return nil;

    for (UIView *ancestor = anchor.superview; ancestor; ancestor = ancestor.superview) {
        CGRect rect = [anchor convertRect:anchor.bounds toView:ancestor];
        if (CGRectGetHeight(ancestor.bounds) > CGRectGetMaxY(rect) + 0.5) {
            return ancestor;
        }
        if (ancestor == content) break;
    }
    return nil;
}

static void DYFSRestoreBackdrop(UIView *anchor, UIView *except) {
    UIView *ancestor = anchor.superview;
    for (NSUInteger i = 0; ancestor && i < 12; i++, ancestor = ancestor.superview) {
        if (ancestor == except) continue;

        id baseline = objc_getAssociatedObject(ancestor, &kDYFSCellBackdropKey);
        if (!baseline) continue;

        ancestor.backgroundColor =
            baseline == [NSNull null] ? nil : (UIColor *)baseline;
        objc_setAssociatedObject(ancestor, &kDYFSCellBackdropKey, nil,
                                 OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
}

static void DYFSApplyBackdrop(id owner, UIView *anchor, UIColor *color) {
    BOOL applied = objc_getAssociatedObject(owner, &kDYFSBackdropAppliedKey) != nil;

    if (!anchor || (!color && !applied)) return;

    UIView *canvas = (color && DYFSIsEnabled()) ? DYFSBackdropCanvas(anchor) : nil;
    DYFSRestoreBackdrop(anchor, canvas);

    if (!canvas) {
        objc_setAssociatedObject(owner, &kDYFSBackdropAppliedKey, nil,
                                 OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        return;
    }

    if (!objc_getAssociatedObject(canvas, &kDYFSCellBackdropKey)) {
        objc_setAssociatedObject(canvas, &kDYFSCellBackdropKey,
                                 canvas.backgroundColor ?: (id)[NSNull null],
                                 OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }

    if (![canvas.backgroundColor isEqual:color]) {
        canvas.backgroundColor = color;
    }

    objc_setAssociatedObject(owner, &kDYFSBackdropAppliedKey, @YES,
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@interface AWEPlayVideoViewController : UIViewController
@property(nonatomic,strong) UIView *playerBackgroundView;
@end

%hook AWEPlayVideoViewController

- (void)setPlayerBackgroundView:(UIView *)backgroundView {
    %orig(backgroundView);
    if (!DYFSIsEnabled()) return;
    if (DYFSIsUnderRichContent(self)) return;

    UIColor *color = backgroundView.superview && !backgroundView.hidden
        ? backgroundView.backgroundColor : nil;
    DYFSApplyBackdrop(self, self.viewIfLoaded, color);
}

- (void)viewDidLayoutSubviews {
    %orig;

    if (!self.viewIfLoaded) return;
    if (DYFSIsUnderRichContent(self)) return;

    UIView *background = self.playerBackgroundView;
    UIColor *color = (background.superview && !background.hidden)
        ? background.backgroundColor : nil;

    DYFSApplyBackdrop(self, self.viewIfLoaded, color);
}

%end

#pragma mark - Rich content / article fullscreen

@interface RichContentContainerViewController : UIViewController
@property(nonatomic,strong) UIViewController *contentListViewController;
- (void)updateShrinkState:(BOOL)shrink insets:(UIEdgeInsets)insets animated:(BOOL)animated;
- (void)updateShrinkState:(BOOL)shrink insets:(UIEdgeInsets)insets animated:(BOOL)animated animationDuration:(double)duration;
@end

@interface AWEKnowledgeGradientView : UIView
@end


static char kDYFSRichClipKey;
static char kDYFSKnowledgeTransformKey;
static char kDYFSRichGradientTransformKey;
static NSHashTable<UIView *> *gDYFSRichManagedViews;

static CGRect DYFSRichIdentityFrame(UIView *view) {
    CGFloat w = CGRectGetWidth(view.bounds);
    CGFloat h = CGRectGetHeight(view.bounds);
    return CGRectMake(view.center.x - w * view.layer.anchorPoint.x,
                      view.center.y - h * view.layer.anchorPoint.y,
                      w, h);
}

static void DYFSRestoreRichTransform(UIView *view, const void *key) {
    NSValue *v = objc_getAssociatedObject(view, key);
    if (!v) return;
    view.transform = v.CGAffineTransformValue;
    objc_setAssociatedObject(view, key, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

static BOOL DYFSApplyRichStretch(UIView *view, const void *key, CGFloat top, CGFloat bottom) {
    if (!view) return NO;
    CGFloat h = CGRectGetHeight(view.bounds);
    if (h <= 0.0 || bottom <= top + h + 0.5) return NO;

    NSValue *baseline = objc_getAssociatedObject(view, key);
    if (!baseline) {
        if (!CGAffineTransformIsIdentity(view.transform)) return NO;
        baseline = [NSValue valueWithCGAffineTransform:view.transform];
        objc_setAssociatedObject(view, key, baseline, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }

    CGFloat scaleY = (bottom - top) / h;
    CGAffineTransform t = CGAffineTransformMake(1.0, 0.0, 0.0, scaleY,
                                                  0.0, (h * 0.5) * (scaleY - 1.0));
    if (!CGAffineTransformEqualToTransform(view.transform, t)) view.transform = t;
    return YES;
}

static void DYFSAllowRichOverflow(UIView *view) {
    if (!view) return;
    if (!objc_getAssociatedObject(view, &kDYFSRichClipKey)) {
        if (!view.clipsToBounds) return;
        objc_setAssociatedObject(view, &kDYFSRichClipKey, @YES, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        [gDYFSRichManagedViews addObject:view];
    }
    view.clipsToBounds = NO;
}

static void DYFSRestoreRichOverflow(UIView *view) {
    if (!objc_getAssociatedObject(view, &kDYFSRichClipKey)) return;
    view.clipsToBounds = YES;
    objc_setAssociatedObject(view, &kDYFSRichClipKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

static UIView *DYFSRichCellContent(UIView *view) {
    return DYFSCellContentView(view ? view.superview : nil);
}

static CGFloat DYFSRichFullHeight(UIView *view) {
    UIView *content = DYFSRichCellContent(view);
    return content ? CGRectGetHeight(content.bounds) : 0.0;
}

static void DYFSRestoreRichManaged(void) {
    for (UIView *view in gDYFSRichManagedViews.allObjects) {
        DYFSRestoreRichTransform(view, &kDYFSKnowledgeTransformKey);
        DYFSRestoreRichTransform(view, &kDYFSRichGradientTransformKey);
        DYFSRestoreRichOverflow(view);
    }
    [gDYFSRichManagedViews removeAllObjects];
}

static void DYFSSyncKnowledgeGradient(UIView *gradient) {
    if (!gradient) return;
    CGFloat full = DYFSIsEnabled() ? DYFSRichFullHeight(gradient) : 0.0;
    CGFloat h = CGRectGetHeight(gradient.bounds);

    if (full > h + 0.5 &&
        DYFSApplyRichStretch(gradient, &kDYFSKnowledgeTransformKey, 0.0, full)) {
        [gDYFSRichManagedViews addObject:gradient];
        return;
    }
    DYFSRestoreRichTransform(gradient, &kDYFSKnowledgeTransformKey);
}

%hook RichContentContainerViewController

- (void)updateShrinkState:(BOOL)shrink insets:(UIEdgeInsets)insets animated:(BOOL)animated {
    if (shrink && DYFSIsEnabled()) return;
    %orig;
}

- (void)updateShrinkState:(BOOL)shrink insets:(UIEdgeInsets)insets animated:(BOOL)animated animationDuration:(double)duration {
    if (shrink && DYFSIsEnabled()) return;
    %orig;
}

- (void)viewDidLayoutSubviews {
    %orig;
    if (DYFSIsEnabled()) {
        UIView *root = self.viewIfLoaded;
        if (root) {
            UIView *content = DYFSCellContentView(root);
            if (content && CGRectGetHeight(content.bounds) > CGRectGetHeight(root.bounds) + 0.5) {
                DYFSAllowRichOverflow(root);
            }
        }
    }
}

%end

%hook AWEKnowledgeGradientView

- (void)layoutSubviews {
    %orig;
    DYFSSyncKnowledgeGradient(self);
}

%end

%ctor {
    gDYFSRichManagedViews = [NSHashTable weakObjectsHashTable];
    DYFSRegisterRestore(DYFSRestoreRichManaged);
}

#pragma mark - DY-tools UI features

// 直接迁移 DYYY / DYKiller 中已经验证过的业务 Hook，不做文字扫描。

static BOOL DYToolsBool(NSString *key) {
    return [[NSUserDefaults standardUserDefaults] boolForKey:key];
}

#pragma mark - 去汽水听

@interface AWEPlayInteractionViewController (DYToolsMusicInfo)
@property(nonatomic,assign) BOOL hideMusicInfo;
@end

%hook AWEPlayInteractionViewController

- (BOOL)hideMusicInfo {
    if (DYToolsBool(kDYToolsRemoveShuiTingKey)) {
        return YES;
    }
    return %orig;
}

%end

#pragma mark - 文案下方相关搜索

// DYYY 的实际实现是直接处理 AWEPlayInteractionSearchAnchorView。
// 这比之前错误迁移的暂停相关词组件更准确，对应视频文案下方的搜索入口。

@interface AWEPlayInteractionSearchAnchorView : UIView
@end

%hook AWEPlayInteractionSearchAnchorView

- (id)init {
    if (DYToolsBool(kDYToolsRemoveRelatedSearchKey)) {
        return nil;
    }
    return %orig;
}

- (void)layoutSubviews {
    if (DYToolsBool(kDYToolsRemoveRelatedSearchKey)) {
        [self removeFromSuperview];
        return;
    }
    %orig;
}

%end

#pragma mark - 视频页热点提示

// DYYY 使用以下热点视图/底部热点提示视图参与热点 UI。
// 同时处理数据入口和实际 View，避免只隐藏其中一层导致空白占位。

@interface AWEHotSpotBlurView : UIView
@end

@interface AWETemplateHotspotView : UIView
@end

@interface AWENewHotSpotBottomBarView : UIView
@end

%hook AWEHotSpotBlurView

- (void)layoutSubviews {
    %orig;
    if (DYToolsBool(kDYToolsRemoveHotspotKey)) {
        self.hidden = YES;
    }
}

%end

%hook AWETemplateHotspotView

- (void)layoutSubviews {
    %orig;
    if (DYToolsBool(kDYToolsRemoveHotspotKey)) {
        [self removeFromSuperview];
        return;
    }
}

%end

%hook AWENewHotSpotBottomBarView

- (void)layoutSubviews {
    %orig;
    if (DYToolsBool(kDYToolsRemoveHotspotKey)) {
        [self removeFromSuperview];
        return;
    }
}

%end

#pragma mark - 直播间 / 音乐入口 / 位置栏

// DYYY 已验证：隐藏视频流中的“点击进入直播间”提示。
@interface AWELiveFeedStatusLabel : UILabel
@end

%hook AWELiveFeedStatusLabel

- (void)layoutSubviews {
    %orig;

    if (!DYToolsBool(kDYToolsHideEnterLiveKey)) {
        return;
    }

    UIView *parentView = self.superview;
    UIView *grandparentView = parentView.superview;
    if (grandparentView) {
        grandparentView.hidden = YES;
        grandparentView.userInteractionEnabled = NO;
    } else if (parentView) {
        parentView.hidden = YES;
        parentView.userInteractionEnabled = NO;
    }
}

%end

// DYYY 已验证：禁止顶栏直播自动进入直播间。
@interface AWELiveGuideElement : UIView
@end

%hook AWELiveGuideElement

- (BOOL)enableAutoEnterRoom {
    if (DYToolsBool(kDYToolsDisableAutoEnterLiveKey)) {
        return NO;
    }
    return %orig;
}

%end

// DYYY 的“隐藏音乐按钮”实际处理这两个业务 View：
// 1. AWEMusicCoverButton：视频原声/音乐入口
// 2. AWEPlayInteractionListenFeedView：拍同款相关入口
@interface AWEMusicCoverButton : UIView
@end

%hook AWEMusicCoverButton

- (void)layoutSubviews {
    %orig;

    if (!DYToolsBool(kDYToolsHideMusicButtonKey)) {
        return;
    }

    NSString *accessibilityLabel = self.accessibilityLabel;
    if ([accessibilityLabel isEqualToString:@"音乐详情"]) {
        UIView *parent = self.superview;
        if (parent) {
            [parent removeFromSuperview];
        } else {
            [self removeFromSuperview];
        }
        return;
    }
}

%end

@interface AWEPlayInteractionListenFeedView : UIView
@end

%hook AWEPlayInteractionListenFeedView

- (void)layoutSubviews {
    %orig;

    if (DYToolsBool(kDYToolsHideMusicButtonKey)) {
        [self removeFromSuperview];
        return;
    }
}

%end

// DYYY 的“隐藏视频定位”实际处理 AWEMarkView。
// 保持与 DYYY 相同的业务 Hook：AWEMarkView + layoutSubviews。
@interface AWEMarkView : UIView
@property(nonatomic,readonly) UILabel *markLabel;
@end

%hook AWEMarkView

- (void)didMoveToWindow {
    %orig;
    if (!DYToolsBool(@"DYYYHideLocation")) return;

    self.hidden = YES;
    self.alpha = 0.0;
    self.userInteractionEnabled = NO;

    UILabel *label = nil;
    @try { label = self.markLabel; } @catch (__unused NSException *e) {}
    if (label) {
        label.hidden = YES;
        label.alpha = 0.0;
    }
}

- (void)layoutSubviews {
    %orig;

    if (!DYToolsBool(@"DYYYHideLocation")) return;

    // DYYY 原始逻辑就是 AWEMarkView + layoutSubviews。
    // 这里额外锁定 alpha/交互，并隐藏 markLabel，防止 40.x
    // 在二次布局时把位置标签重新显示出来。
    self.hidden = YES;
    self.alpha = 0.0;
    self.userInteractionEnabled = NO;

    UILabel *label = nil;
    @try { label = self.markLabel; } @catch (__unused NSException *e) {}
    if (label) {
        label.hidden = YES;
        label.alpha = 0.0;
    }
}

- (void)setHidden:(BOOL)hidden {
    if (DYToolsBool(@"DYYYHideLocation")) {
        %orig(YES);
        return;
    }
    %orig(hidden);
}

%end


@interface LOTAnimationView : UIView
@end
@interface AWEAdAvatarView : UIView
@end
@interface AWENearbySkyLightCapsuleView : UIView
@end
@interface AFDCancelMuteAwemeView : UIView
@end
@interface AWEPlayDanmakuInputContainView : UIView
@end
@interface AWEShowPlayletCommentHeaderView : UIView
@end
@interface AWECommentPanelHeaderSwiftImpl_CommentHeaderGeneralView : UIView
@end
@interface AWECommentPanelHeaderSwiftImpl_CommentHeaderGoodsView : UIView
@end
@interface AWECommentPanelHeaderSwiftImpl_CommentHeaderTemplateAnchorView : UIView
@end
@interface AWETemplateTagsCommonView : UIView
@end
@interface AFDSkylightCellBubble : UIView
@end
@interface AWEIMMessageTabSideBarView : UIView
@end
@interface AWEFeedUnfollowFamiliarFollowAndDislikeView : UIView
@end

#pragma mark - DYYY topbar removal hooks
%hook AWEFeedLiveMarkView
- (void)setHidden:(BOOL)hidden {
    if (DYToolsBool(@"DYYYHideAvatarButton")) {
        hidden = YES;
    }

    %orig(hidden);
}
%end

%hook LOTAnimationView
- (void)layoutSubviews {
    %orig;    // 确保只有头像的LOTAnimationView才则执行该逻辑, 防止误杀
    if ([self.superview isKindOfClass:%c(AWEPlayInteractionFollowPromptView)]) {
        // 检查是否需要隐藏加号
        if (DYToolsBool(@"DYYYHideLOTAnimationView") || DYToolsBool(@"DYYYHideFollowPromptView")) {
            [self removeFromSuperview];
            return;
        }
        // 应用透明度设置
        NSString *transparencyValue = [[NSUserDefaults standardUserDefaults] objectForKey:@"DYYYAvatarViewTransparency"];
        if (transparencyValue && transparencyValue.length > 0) {
            CGFloat alphaValue = [transparencyValue floatValue];
            self.alpha = alphaValue;
        }
    }
}
%end

%hook AWEAdAvatarView
- (void)layoutSubviews {
    %orig;

    // 检查是否需要隐藏头像
    if (DYToolsBool(@"DYYYHideAvatarButton")) {
        self.hidden = YES;
        return;
    }

    // 应用透明度设置
    NSString *transparencyValue = [[NSUserDefaults standardUserDefaults] objectForKey:@"DYYYAvatarViewTransparency"];
    if (transparencyValue && transparencyValue.length > 0) {
        CGFloat alphaValue = [transparencyValue floatValue];
        if (alphaValue >= 0.0 && alphaValue <= 1.0) {
            self.alpha = alphaValue;
        }
    }
}
%end

%hook AWENearbySkyLightCapsuleView
- (void)layoutSubviews {
    if (DYToolsBool(@"DYYYHideNearbyCapsuleView")) {
        [self removeFromSuperview];
        return;
    }
    %orig;
}
%end

%hook AFDCancelMuteAwemeView
- (void)layoutSubviews {
    %orig;

    UIView *superview = self.superview;

    if ([superview isKindOfClass:NSClassFromString(@"AWEBaseElementView")]) {
        if (DYToolsBool(@"DYYYHideCancelMute")) {
            self.hidden = YES;
            return;
        }
    }
}
%end

%hook AWEPlayDanmakuInputContainView

- (void)layoutSubviews {
    %orig;

    if (DYToolsBool(@"DYYYHideDanmuButton")) {
        self.hidden = YES;
        return;
    }
}

%end

%hook AWEShowPlayletCommentHeaderView
- (void)layoutSubviews {
    %orig;
    if (DYToolsBool(@"DYYYHideCommentViews")) {
        self.hidden = YES;
        return;
    }
}

%end

%hook AWEPOIEntryAnchorView

- (void)p_addViews {
    if (DYToolsBool(@"DYYYHideCommentViews")) {
        return;
    }
    %orig;
}

%end

%hook AWECommentPanelHeaderSwiftImpl_CommentHeaderGeneralView
- (void)layoutSubviews {
    %orig;

    if (DYToolsBool(@"DYYYHideCommentViews")) {
        [self setHidden:YES];
    }
}
%end

%hook AWECommentPanelHeaderSwiftImpl_CommentHeaderGoodsView
- (void)layoutSubviews {
    %orig;

    if (DYToolsBool(@"DYYYHideCommentViews")) {
        [self setHidden:YES];
    }
}
%end

%hook AWECommentPanelHeaderSwiftImpl_CommentHeaderTemplateAnchorView
- (void)layoutSubviews {
    %orig;

    if (DYToolsBool(@"DYYYHideCommentViews")) {
        [self setHidden:YES];
    }
}
%end

%hook AWECommentPanelListSwiftImpl_CommentBottomTipsContainerViewController
- (void)viewWillAppear:(BOOL)animated {
    %orig(animated);
    if (DYToolsBool(@"DYYYHideCommentTips")) {
        ((UIViewController *)self).view.hidden = YES;
    }
}
%end

%hook AWESearchAnchorListModel

- (BOOL)hideWords {
    return DYToolsBool(@"DYYYHideCommentViews");
}

%end

%hook AWEDiscoverFeedEntranceView
- (id)init {
    if (DYToolsBool(@"DYYYHideInteractionSearch")) {
        return nil;
    }
    return %orig;
}
%end

%hook AWETemplateTagsCommonView

- (void)layoutSubviews {
    %orig;

    if (DYToolsBool(@"DYYYHideTemplateTags")) {
        UIView *parentView = self.superview;
        if (parentView) {
            parentView.hidden = YES;
        } else {
            self.hidden = YES;
        }
    }
}

%end

%hook AFDSkylightCellBubble
- (void)layoutSubviews {
    if (DYToolsBool(@"DYYYHideAvatarBubble")) {
        [self removeFromSuperview];
    }
    %orig;
}
%end

%hook AWEIMMessageTabOptPushBannerView

- (instancetype)initWithFrame:(CGRect)frame {
    if (DYToolsBool(@"DYYYHidePushBanner")) {
        return %orig(CGRectMake(frame.origin.x, frame.origin.y, 0, 0));
    }
    return %orig;
}

%end

%hook AWEIMMessageTabSideBarView
- (void)layoutSubviews {
    %orig;

    if (!DYToolsBool(@"DYYYHideMessageTabRedPacket")) {
        return;
    }

    UIView *parentView = self.superview;
    if (!parentView) {
        return;
    }

    NSArray<UIView *> *siblings = [parentView.subviews copy];
    if (siblings.count <= 1) {
        return;
    }

    for (UIView *subview in siblings) {
        if (subview != self) {
            [subview removeFromSuperview];
        }
    }
}
%end

%hook AWEProfileNavigationButton
- (void)setupUI {

    if (DYToolsBool(@"DYYYHideButton")) {
        return;
    }
    %orig;
}
%end

%hook AWEFeedUnfollowFamiliarFollowAndDislikeView
- (void)showUnfollowFamiliarView {
    if (DYToolsBool(@"DYYYHideFamiliar")) {
        self.hidden = YES;
        return;
    }
    %orig;
}
%end

%hook AWEFamiliarNavView
- (void)layoutSubviews {
    if (DYToolsBool(@"DYYYHideFamiliar")) {
        self.hidden = YES;
    }
    %orig;
}
%end

%hook AWEPlayInteractionStrongifyShareContentView

- (void)layoutSubviews {
    %orig;
    if (DYToolsBool(@"DYYYHideShareContentView")) {
        UIView *parentView = self.superview;
        if (parentView) {
            parentView.hidden = YES;
        } else {
            self.hidden = YES;
        }
    }
}

%end

%hook AWELeftSideBarEntranceView

- (void)setRedDot:(id)redDot {
    %orig(nil);
}

- (void)setNumericalRedDot:(id)numericalRedDot {
    %orig(nil);
}

- (void)layoutSubviews {
    %orig;

    // 隐藏左侧边栏的 badge
    for (UIView *subview in self.subviews) {
        if ([subview isKindOfClass:%c(DUXBadge)]) {
            subview.hidden = YES;
            break;
        }
    }

    UIResponder *responder = self;
    UIViewController *parentVC = nil;
    while ((responder = [responder nextResponder])) {
        if ([responder isKindOfClass:%c(AWEFeedContainerViewController)]) {
            parentVC = (UIViewController *)responder;
            break;
        }
    }

    if (!(parentVC && [[NSUserDefaults standardUserDefaults] boolForKey:@"DYYYHideLeftSideBar"])) {
        return;
    }

    static char kDYLeftSideViewCacheKey;
    NSArray *cachedViews = objc_getAssociatedObject(self, &kDYLeftSideViewCacheKey);
    if (!cachedViews) {
        NSMutableArray *views = [NSMutableArray array];
        for (UIView *subview in self.subviews) {
            if ([subview isKindOfClass:%c(DUXBaseImageView)]) {
                [views addObject:subview];
            }
        }
        cachedViews = [views copy];
        objc_setAssociatedObject(self, &kDYLeftSideViewCacheKey, cachedViews, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }

    for (UIView *v in cachedViews) {
        v.hidden = YES;
    }
}

%end

%hook AWEFeedVideoButton

- (void)layoutSubviews {
    %orig;

    NSString *accessibilityLabel = self.accessibilityLabel;

    BOOL hideBtn = NO;
    BOOL hideLabel = NO;

    if ([accessibilityLabel isEqualToString:@"点赞"]) {
        hideBtn = [[NSUserDefaults standardUserDefaults] boolForKey:@"DYYYHideLikeButton"];
        hideLabel = [[NSUserDefaults standardUserDefaults] boolForKey:@"DYYYHideLikeLabel"];
    } else if ([accessibilityLabel isEqualToString:@"评论"]) {
        hideBtn = [[NSUserDefaults standardUserDefaults] boolForKey:@"DYYYHideCommentButton"];
        hideLabel = [[NSUserDefaults standardUserDefaults] boolForKey:@"DYYYHideCommentLabel"];
    } else if ([accessibilityLabel isEqualToString:@"分享"]) {
        hideBtn = [[NSUserDefaults standardUserDefaults] boolForKey:@"DYYYHideShareButton"];
        hideLabel = [[NSUserDefaults standardUserDefaults] boolForKey:@"DYYYHideShareLabel"];
    } else if ([accessibilityLabel isEqualToString:@"收藏"]) {
        hideBtn = [[NSUserDefaults standardUserDefaults] boolForKey:@"DYYYHideCollectButton"];
        hideLabel = [[NSUserDefaults standardUserDefaults] boolForKey:@"DYYYHideCollectLabel"];
    }

    if (!hideBtn && !hideLabel) {
        return; // 设置未启用，无需额外处理
    }

    if (hideBtn) {
        [self removeFromSuperview];
        return;
    }

    static char kDYLabelCacheKey;
    NSArray *cachedLabels = objc_getAssociatedObject(self, &kDYLabelCacheKey);
    if (!cachedLabels) {
        NSMutableArray *labels = [NSMutableArray array];
        for (UIView *subview in self.subviews) {
            if ([subview isKindOfClass:[UILabel class]]) {
                [labels addObject:subview];
            }
        }
        cachedLabels = [labels copy];
        objc_setAssociatedObject(self, &kDYLabelCacheKey, cachedLabels, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }

    for (UILabel *label in cachedLabels) {
        label.hidden = hideLabel;
    }
}

%end

%hook AWEHPSearchBubbleEntranceView
- (void)layoutSubviews {
    %orig;

    if (DYToolsBool(@"DYYYHideSearchBubble")) {
        [self removeFromSuperview];
        return;
    }
}

%end

%hook AWEPlayInteractionFollowPromptView

- (void)layoutSubviews {
    %orig;

    NSString *accessibilityLabel = self.accessibilityLabel;

    if ([accessibilityLabel isEqualToString:@"关注"]) {
        if (DYToolsBool(@"DYYYHideAvatarButton") || DYToolsBool(@"DYYYHideFollowPromptView")) {
            self.userInteractionEnabled = NO;
            self.hidden = YES;
            return;
        }
    }
}

%end

%hook AWEHotSearchInnerBottomView
- (void)layoutSubviews {
    if (DYToolsBool(@"DYYYHideHotSearch")) {
        [self removeFromSuperview];
        return;
    }
    %orig;
}
%end

%hook AWESearchEntranceView

- (void)layoutSubviews {

    if (DYToolsBool(@"DYYYHideSearchEntrance")) {
        self.hidden = YES;
        return;
    }
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"DYYYHideSearchEntranceIndicator"]) {
        static char kDYSearchIndicatorKey;
        NSArray *indicatorViews = objc_getAssociatedObject(self, &kDYSearchIndicatorKey);
        if (!indicatorViews) {
            NSMutableArray *tmp = [NSMutableArray array];
            for (UIView *subviews in self.subviews) {
                if ([subviews isKindOfClass:%c(UIImageView)] && [NSStringFromClass([((UIImageView *)subviews).image class]) isEqualToString:@"_UIResizableImage"]) {
                    [tmp addObject:subviews];
                }
            }
            indicatorViews = [tmp copy];
            objc_setAssociatedObject(self, &kDYSearchIndicatorKey, indicatorViews, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }

        for (UIImageView *imgView in indicatorViews) {
            imgView.hidden = YES;
        }
    }

    %orig;
}

%end

%hook AWEStoryProgressSlideView

- (void)layoutSubviews {
    %orig;

    BOOL shouldHide = [[NSUserDefaults standardUserDefaults] boolForKey:@"DYYYHideStoryProgressSlide"];
    if (!shouldHide)
        return;

    static char kDYStoryProgressCacheKey;
    UIView *targetView = objc_getAssociatedObject(self, &kDYStoryProgressCacheKey);
    if (!targetView) {
        for (UIView *obj in self.subviews) {
            if ([obj isKindOfClass:NSClassFromString(@"UISlider")] || obj.frame.size.height < 5) {
                targetView = obj.superview;
                break;
            }
        }
        if (targetView) {
            objc_setAssociatedObject(self, &kDYStoryProgressCacheKey, targetView, OBJC_ASSOCIATION_ASSIGN);
        }
    }

    if (targetView) {
        targetView.hidden = YES;
    }
}

%end

%hook AFDNewFastReplyView

- (void)layoutSubviews {
    %orig;

    if (DYToolsBool(@"DYYYHidePrivateMessages")) {
        UIView *parentView = self.superview;
        if (parentView) {
            parentView.hidden = YES;
        } else {
            self.hidden = YES;
        }
    }
}

%end

%hook AWEFeedLiveTabRevisitControlView

- (void)layoutSubviews {
    %orig;

    if (DYToolsBool(@"DYYYHideLiveDiscovery")) {
        self.hidden = YES;
        return;
    }
}
%end
%hook IESLiveKTVSongIndicatorView
- (void)layoutSubviews {
    %orig;
    if (DYToolsBool(@"DYYYHideKTVSongIndicator")) {
        self.hidden = YES;
        return;
    }
}
%end

%hook UILabel

static NSHashTable *processedParentViews = nil;

+ (void)load {
    %orig;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
      processedParentViews = [NSHashTable weakObjectsHashTable];
    });
}

- (void)layoutSubviews {
    %orig;

    BOOL hideRightLabel = DYToolsBool(@"DYYYHideRightLabel");
    if (!hideRightLabel)
        return;

    NSString *accessibilityLabel = self.accessibilityLabel;
    if (!accessibilityLabel || accessibilityLabel.length == 0)
        return;

    // 避免重复处理同一个父视图
    UIView *parentView = self.superview;
    if (!parentView)
        return;

    @synchronized(processedParentViews) {
        if ([processedParentViews containsObject:parentView]) {
            return;
        }
    }

    NSString *trimmedLabel = [accessibilityLabel stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    BOOL shouldRemove = NO;

    if ([trimmedLabel hasSuffix:@"人共创"] && trimmedLabel.length > 3) {
        NSString *prefix = [trimmedLabel substringToIndex:trimmedLabel.length - 3];
        NSCharacterSet *nonDigits = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
        shouldRemove = ([prefix rangeOfCharacterFromSet:nonDigits].location == NSNotFound);
    }

    if (!shouldRemove) {
        shouldRemove = [trimmedLabel isEqualToString:@"章节要点"] || [trimmedLabel isEqualToString:@"图集"] || [trimmedLabel isEqualToString:@"下一章"];
    }

    if (shouldRemove) {
        @synchronized(processedParentViews) {
            [processedParentViews addObject:parentView];
        }

        UIView *grandparentView = parentView.superview; // 爷爷视图

        if (grandparentView) {

            dispatch_async(dispatch_get_main_queue(), ^{
              if ([grandparentView isKindOfClass:[UIStackView class]]) {
                  UIStackView *stackView = (UIStackView *)grandparentView;
                  [stackView removeArrangedSubview:parentView];
              }

              [parentView removeFromSuperview];

              // 强制刷新爷爷视图布局
              [grandparentView setNeedsLayout];
              [grandparentView layoutIfNeeded];
            });
        }
    }
}

%end

%hook AWEFeedMultiTabSelectedContainerView

- (void)layoutSubviews {
    %orig;
    if (DYToolsBool(@"DYYYHideTopBarLine")) {
        self.hidden = YES;
    }
}

%end

%hook AFDRecommendToFriendEntranceLabel
- (void)layoutSubviews {
    %orig;
    if (DYToolsBool(@"DYYYHideRecommendTips")) {
        if (self.accessibilityLabel) {
            [self removeFromSuperview];
        }
    }
}

%end

%hook AWEProfileMixItemCollectionViewCell
- (void)layoutSubviews {
    %orig;
    if (DYToolsBool(@"DYYYHidePostView")) {
        if ([self.accessibilityLabel isEqualToString:@"私密作品"]) {
            self.hidden = YES;
            return;
        }
    }
}
%end

%hook AWEProfilePostEmptyPublishGuideCollectionViewCell

- (void)didMoveToSuperview {
    %orig;
    if (DYToolsBool(@"DYYYHidePostView")) {
        if ([(UIView *)self superview]) {
            [(UIView *)self setHidden:YES];
        }
    }
}

%end

%hook AWEProfileTaskCardStyleListCollectionViewCell
- (BOOL)shouldShowPublishGuide {
    if (DYToolsBool(@"DYYYHidePostView")) {
        return NO;
    }
    return %orig;
}
%end

%hook AWEProfileRichEmptyView

- (void)setTitle:(id)title {
    if (DYToolsBool(@"DYYYHidePostView")) {
        return;
    }
    %orig(title);
}

- (void)setDetail:(id)detail {
    if (DYToolsBool(@"DYYYHidePostView")) {
        return;
    }
    %orig(detail);
}
%end

%hook AWENewLiveSkylightViewController

- (void)showSkylight:(BOOL)arg0 animated:(BOOL)arg1 actionMethod:(unsigned long long)arg2 {
    if (DYToolsBool(@"DYYYHideLiveView")) {
        return;
    }
    %orig(arg0, arg1, arg2);
}

- (void)updateIsSkylightShowing:(BOOL)arg0 {
    if (DYToolsBool(@"DYYYHideLiveView")) {
        %orig(NO);
    } else {
        %orig(arg0);
    }
}

%end

%hook AWELiveSkylightViewModel

- (id)dataSource {
	BOOL DYYYHideConcernCapsuleView = DYToolsBool(@"DYYYHideConcernCapsuleView");
	if (DYYYHideConcernCapsuleView) {
		return nil;
	}
	return %orig;
}

- (void)setDataSource:(id)dataSource {
	BOOL DYYYHideConcernCapsuleView = DYToolsBool(@"DYYYHideConcernCapsuleView");
	if (DYYYHideConcernCapsuleView) {
		%orig(nil);
		return;
	}
	%orig;
}

%end

%hook AWELiveAutoEnterStyleAView

- (void)layoutSubviews {
    %orig;

    if (DYToolsBool(@"DYYYHideLiveView")) {
        self.hidden = YES;
        return;
    }
}

%end

%hook AWENearbyFullScreenViewModel

- (void)setShowSkyLight:(id)arg1 {
    if (DYToolsBool(@"DYYYHideMenuView")) {
        arg1 = nil;
    }
    %orig(arg1);
}

- (void)setHaveSkyLight:(id)arg1 {
    if (DYToolsBool(@"DYYYHideMenuView")) {
        arg1 = nil;
    }
    %orig(arg1);
}

%end

%hook AWECorrelationItemTag

- (void)layoutSubviews {
    %orig;
    if (DYToolsBool(@"DYYYHideItemTag")) {
        self.hidden = YES;
        return;
    }
}

%end

%hook AWEHPDiscoverFeedEntranceView

- (void)layoutSubviews {
    %orig;

    if (DYToolsBool(@"DYYYHideDiscover")) {
        UIView *firstSubview = self.subviews.firstObject;
        if ([firstSubview isKindOfClass:[UIImageView class]]) {
            ((UIImageView *)firstSubview).image = nil;
        }
    }
}

%end

%hook AWEIMCellLiveStatusContainerView

- (void)p_initUI {
    if (![[NSUserDefaults standardUserDefaults] objectForKey:@"DYYYHideGroupLiveIndicator"])
        %orig;
}
%end

%hook AWELiveStatusIndicatorView

- (void)layoutSubviews {
    if (DYToolsBool(@"DYYYHideGroupLiveIndicator")) {
        self.hidden = YES;
        return;
    }
    %orig;
}
%end

%hook AWELiveFeedLabelTagView
- (void)layoutSubviews {

    if (DYToolsBool(@"DYYYHideLiveCapsuleView")) {
        UIView *parentView = self.superview;
        if (parentView) {
            parentView.hidden = YES;
            return;
        } else {
            self.hidden = YES;
            return;
        }
    }
    %orig;
}

%end

%hook AWEPlayInteractionLiveExtendGuideView
- (void)layoutSubviews {
    if (DYToolsBool(@"DYYYHideLiveCapsuleView")) {
        [self removeFromSuperview];
        return;
    }
    %orig;
}
%end

%hook AWEHPTopTabItemBadgeContentView
- (void)layoutSubviews {
    if (DYToolsBool(@"DYYYHideConcernCapsuleView")) {
        self.hidden = YES;
        return;
    }
    %orig;
}
%end

%hook AWEIMFansGroupTopDynamicDomainTemplateView
- (void)layoutSubviews {
    if (DYToolsBool(@"DYYYHideGroupShop")) {
        self.hidden = YES;
        return;
    }
    %orig;
}
%end

%hook AWEIMInputActionBarInteractor

- (void)p_setupUI {
    if (DYToolsBool(@"DYYYHideGroupInputActionBar")) {
        self.hidden = YES;
        return;
    }
    %orig;
}
%end

%hook AWETemplateCommonView
- (void)layoutSubviews {
    %orig;
    if (DYToolsBool(@"DYYYHideCameraLocation")) {
        [self removeFromSuperview];
    }
}
%end

%hook AWEHPTopBarCTAItemView

- (void)showRedDot {
    if (![[NSUserDefaults standardUserDefaults] objectForKey:@"DYYYHideSidebarDot"])
        %orig;
}

- (void)hideCountRedDot {
    if (![[NSUserDefaults standardUserDefaults] objectForKey:@"DYYYHideSidebarDot"])
        %orig;
}

- (void)layoutSubviews {
    %orig;

    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"DYYYHideSidebarDot"]) {
        return;
    }

    static char kDYSidebarBadgeCacheKey;
    NSArray *cachedBadges = objc_getAssociatedObject(self, &kDYSidebarBadgeCacheKey);
    if (!cachedBadges) {
        NSMutableArray *badges = [NSMutableArray array];
        for (UIView *subview in self.subviews) {
            if ([subview isKindOfClass:%c(DUXBadge)]) {
                [badges addObject:subview];
            }
        }
        cachedBadges = [badges copy];
        objc_setAssociatedObject(self, &kDYSidebarBadgeCacheKey, cachedBadges, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }

    for (UIView *badge in cachedBadges) {
        badge.hidden = YES;
    }
}
%end

%hook ACCStickerContainerView
- (void)layoutSubviews {
    %orig;
    if (DYToolsBool(@"DYYYHideSearchSame")) {
        [self removeFromSuperview];
    }
}
%end

%hook BDXWebView
- (void)layoutSubviews {
    %orig;

    BOOL enabled = DYToolsBool(@"DYYYHideGiftPavilion");
    if (!enabled)
        return;

    NSString *title = [self valueForKey:@"title"];

    if ([title containsString:@"任务Banner"] || [title containsString:@"活动Banner"]) {
        self.hidden = YES;
    }
}
%end

%hook AWEVideoTypeTagView

- (void)setupUI {
    if (![[NSUserDefaults standardUserDefaults] objectForKey:@"DYYYHideLiveGIF"])
        %orig;
}
%end

%hook IESLiveFeedDrawerEntranceView
- (void)layoutSubviews {
    %orig;

    if (DYToolsBool(@"DYYYHideLivePlayground")) {
        self.hidden = YES;
    }
}

%end

%hook IESLiveButton

- (void)layoutSubviews {
    %orig;
    BOOL hideClear = [[NSUserDefaults standardUserDefaults] boolForKey:@"DYYYHideLiveRoomClear"];
    BOOL hideMirror = [[NSUserDefaults standardUserDefaults] boolForKey:@"DYYYHideLiveRoomMirroring"];
    BOOL hideFull = [[NSUserDefaults standardUserDefaults] boolForKey:@"DYYYHideLiveRoomFullscreen"];
    BOOL hideClose = [[NSUserDefaults standardUserDefaults] boolForKey:@"DYYYHideLiveRoomClose"];

    if (!(hideClear || hideMirror || hideFull)) {
        return;
    }

    NSString *label = self.accessibilityLabel;
    if (hideClear && [label isEqualToString:@"退出清屏"] && self.superview) {
        [self.superview removeFromSuperview];
        return;
    } else if (hideMirror && [label isEqualToString:@"投屏"] && self.superview) {
        self.superview.hidden = YES;
        return;
    } else if (hideFull && [label isEqualToString:@"横屏"] && self.superview) {
        static char kDYLiveButtonCacheKey;
        NSArray *cached = objc_getAssociatedObject(self, &kDYLiveButtonCacheKey);
        if (!cached) {
            cached = [self.subviews copy];
            objc_setAssociatedObject(self, &kDYLiveButtonCacheKey, cached, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }
        for (UIView *subview in cached) {
            subview.hidden = YES;
        }
        return;
    } else if (hideClose && [self.superview isKindOfClass:%c(HTSLive4LayerContainerView)]) {
        self.hidden = YES;
        return;
    }
}

%end

%hook AWELiveFlowAlertView
- (void)layoutSubviews {
    %orig;
    if (DYToolsBool(@"DYYYHideCellularAlert")) {
        self.hidden = YES;
        return;
    }
}
%end

%hook AWEInteractionHashtagStickerModel

- (id)hashtagInfo {
	BOOL DYYYHideChallengeStickers = DYToolsBool(@"DYYYHideChallengeStickers");
	if (DYYYHideChallengeStickers) {
		return nil;
	}
	return %orig;
}

- (void)setHashtagInfo:(id)info {
	BOOL DYYYHideChallengeStickers = DYToolsBool(@"DYYYHideChallengeStickers");
	if (DYYYHideChallengeStickers) {
		%orig(nil);
		return;
	}
	%orig;
}

- (id)hashtagId {
	BOOL DYYYHideChallengeStickers = DYToolsBool(@"DYYYHideChallengeStickers");
	if (DYYYHideChallengeStickers) {
		return nil;
	}
	return %orig;
}
- (id)hashtagName {
	BOOL DYYYHideChallengeStickers = DYToolsBool(@"DYYYHideChallengeStickers");
	if (DYYYHideChallengeStickers) {
		return nil;
	}
	return %orig;
}

%end

%hook AWEHotSpotListModel

- (BOOL)disableDisplay {
	BOOL DYYYHideHotspot = DYToolsBool(@"DYYYHideHotspot");
	if (DYYYHideHotspot) {
		return YES;
	}
	return %orig;
}

- (BOOL)disableDisplayInner {
	BOOL DYYYHideHotspot = DYToolsBool(@"DYYYHideHotspot");
	if (DYYYHideHotspot) {
		return YES;
	}
	return %orig;
}

- (NSString *)hotSpotTipTitleHeader {
	BOOL DYYYHideHotspot = DYToolsBool(@"DYYYHideHotspot");
	if (DYYYHideHotspot) {
		return @"";
	}
	return %orig;
}

- (NSString *)hotSpotTipTitle {
	BOOL DYYYHideHotspot = DYToolsBool(@"DYYYHideHotspot");
	if (DYYYHideHotspot) {
		return @"";
	}
	return %orig;
}

- (NSString *)hotSpotTipTitleFooter {
	BOOL DYYYHideHotspot = DYToolsBool(@"DYYYHideHotspot");
	if (DYYYHideHotspot) {
		return @"";
	}
	return %orig;
}

- (NSString *)hotInfoWord {
	BOOL DYYYHideHotspot = DYToolsBool(@"DYYYHideHotspot");
	if (DYYYHideHotspot) {
		return @"";
	}
	return %orig;
}

- (NSString *)i18NTipTitle {
	BOOL DYYYHideHotspot = DYToolsBool(@"DYYYHideHotspot");
	if (DYYYHideHotspot) {
		return @"";
	}
	return %orig;
}

- (NSString *)tipSchema {
	BOOL DYYYHideHotspot = DYToolsBool(@"DYYYHideHotspot");
	if (DYYYHideHotspot) {
		return nil;
	}
	return %orig;
}

- (NSDictionary *)extraDictionary {
	BOOL DYYYHideHotspot = DYToolsBool(@"DYYYHideHotspot");
	if (DYYYHideHotspot) {
		return @{};
	}
	return %orig;
}

- (NSDictionary *)relativityExtra {
	BOOL DYYYHideHotspot = DYToolsBool(@"DYYYHideHotspot");
	if (DYYYHideHotspot) {
		return @{};
	}
	return %orig;
}

%end

%hook AWERelatedMusicAnchorModel

- (instancetype)init {
	BOOL DYYYHideQuqishuiting = DYToolsBool(@"DYYYHideQuqishuiting");
	if (DYYYHideQuqishuiting) {
		return nil;
	}
	return %orig;
}

- (instancetype)initWithDictionary:(id)dict error:(NSError **)error {
	BOOL DYYYHideQuqishuiting = DYToolsBool(@"DYYYHideQuqishuiting");
	if (DYYYHideQuqishuiting) {
		return nil;
	}
	return %orig;
}

%end

%hook AWEMusicExtraModel

- (id)commentTopBarInfo {
	BOOL DYYYHideQuqishuiting = DYToolsBool(@"DYYYHideQuqishuiting");
	if (DYYYHideQuqishuiting) {
		return nil;
	}
	return %orig;
}

- (void)setCommentTopBarInfo:(id)info {
	BOOL DYYYHideQuqishuiting = DYToolsBool(@"DYYYHideQuqishuiting");
	if (DYYYHideQuqishuiting) {
		%orig(nil);
		return;
	}
	%orig;
}

%end

%hook AWEPlayInteractionUserAvatarView
- (void)layoutSubviews {
    %orig;

    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"DYYYHideFollowPromptView"]) {
        return;
    }

    static char kDYAvatarCacheKey;
    NSArray *viewCache = objc_getAssociatedObject(self, &kDYAvatarCacheKey);
    if (!viewCache) {
        NSMutableArray *tmp = [NSMutableArray array];
        for (UIView *subview in self.subviews) {
            if ([subview isMemberOfClass:[UIView class]]) {
                [tmp addObject:subview];
            }
        }
        viewCache = [tmp copy];
        objc_setAssociatedObject(self, &kDYAvatarCacheKey, viewCache, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }

    for (UIView *container in viewCache) {
        for (UIView *child in container.subviews) {
            child.alpha = 0.0;
        }
    }
}
%end

%hook AWETabBarElementContainerView

- (void)setHidden:(BOOL)hidden {
    if (DYToolsBool(@"DYYYHidePadTabBarElements")) {
        %orig(YES);
        return;
    }

    %orig(hidden);
}

%end

%hook AWENormalModeTabBarBadgeContainerView

- (void)layoutSubviews {
    %orig;
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"DYYYHideBottomDot"]) {
        return;
    }

    static char kDYBadgeCacheKey;
    NSArray *badges = objc_getAssociatedObject(self, &kDYBadgeCacheKey);
    if (!badges) {
        NSMutableArray *tmp = [NSMutableArray array];
        for (UIView *subview in [self subviews]) {
            if ([subview isKindOfClass:NSClassFromString(@"DUXBadge")]) {
                [tmp addObject:subview];
            }
        }
        badges = [tmp copy];
        objc_setAssociatedObject(self, &kDYBadgeCacheKey, badges, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }

    for (UIView *badge in badges) {
        badge.hidden = YES;
    }
}

%end

%hook AWENormalModeTabBarGeneralPlusButton
+ (id)button {
    BOOL isHidePlusButton = DYToolsBool(@"DYYYHidePlusButton");
    if (isHidePlusButton) {
        return nil;
    }
    return %orig;
}
%end

%hook AWENormalModeTabBarGeneralPlusInnerButton
+ (id)buttonWithParams:(id)arg1 {
    if (DYToolsBool(@"DYYYHidePlusButton")) {
        return nil;
    }
    return %orig;
}
%end

%hook AWENormalModeTabBarFeedView

- (void)layoutSubviews {
    %orig;
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"DYYYHideDoubleColumnEntry"]) return;

    NSMutableArray<UIView *> *queue = [NSMutableArray arrayWithArray:self.subviews];
    while (queue.count) {
        UIView *view = queue.firstObject;
        [queue removeObjectAtIndex:0];

        NSString *name = NSStringFromClass(view.class).lowercaseString;
        NSString *label = (view.accessibilityLabel ?: @"").lowercaseString;
        NSString *text = [view isKindOfClass:[UILabel class]]
            ? (((UILabel *)view).text ?: @"").lowercaseString
            : @"";

        BOOL match =
            [name containsString:@"doublecolumn"] ||
            [name containsString:@"multicolumn"] ||
            [name containsString:@"twocolumn"] ||
            [label containsString:@"双列"] ||
            [label containsString:@"两列"] ||
            [label containsString:@"多列"] ||
            [text containsString:@"双列"] ||
            [text containsString:@"两列"] ||
            [text containsString:@"多列"];

        if (match) {
            view.hidden = YES;
            view.userInteractionEnabled = NO;
        }

        [queue addObjectsFromArray:view.subviews];
    }
}
%end


%hook AWEIMSkylightListView
- (void)setFrame:(CGRect)frame {
    if (DYToolsBool(@"DYYYHideAvatarList")) {
        CGFloat scale = [UIScreen mainScreen].scale ?: 2.0;
        CGFloat minH = MAX(1.0 / scale, 0.5);
        frame.size.height = minH;
    }
    %orig(frame);
}
%end

%hook UIImageView
- (void)layoutSubviews {
    %orig;
    if (DYToolsBool(@"DYYYHideCommentDiscover")) {
        if (!self.accessibilityLabel) {
            UIView *parentView = self.superview;

            if (parentView && [parentView class] == [UIView class] && [parentView.accessibilityLabel isEqualToString:@"搜索"]) {
                self.hidden = YES;
            }

            else if (parentView && [NSStringFromClass([parentView class]) isEqualToString:@"AWESearchEntryHalfScreenElement"] && [parentView.accessibilityLabel isEqualToString:@"搜索"]) {
                self.hidden = YES;
            }
        }
    }
    return;
}
%end

%hook AWEIncentiveSwiftImplDOUYINLite_IncentivePendantContainerView
- (void)layoutSubviews {
    %orig;
    if (DYToolsBool(@"DYYYHidePendantGroup")) {
        [self removeFromSuperview];
    }
}
%end

#pragma mark - DYYY top-bar removal

/*
 * DYYY 的“顶栏移除”并不是“隐藏设置”。
 * 原实现 Hook AWEFeedChannelManager，根据 channelID 过滤顶部频道。
 * 这里按 6c3dfbd911822b4d0f758f184c196566e8142291 的实际逻辑迁移。
 */
@interface AWEFeedChannelManager : NSObject
@end

%hook AWEFeedChannelManager

- (void)reloadChannelWithChannelModels:(id)arg1
              currentChannelIDList:(id)arg2
                         reloadType:(id)arg3
                    selectedChannelID:(id)arg4 {

    NSArray *channelModels = arg1;
    NSMutableArray *newChannelModels = [NSMutableArray array];

    NSArray *currentChannelIDList =
        [arg2 isKindOfClass:NSArray.class] ? arg2 : @[];

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

    for (id tabItemModel in channelModels) {
        NSString *channelID = nil;

        @try {
            channelID = [tabItemModel valueForKey:@"channelID"];
        } @catch (__unused NSException *e) {
            channelID = nil;
        }

        BOOL remove = NO;

        if ([channelID isEqualToString:@"homepage_hot_container"]) {
            remove = [defaults boolForKey:@"DYYYHideHotContainer"];
        } else if ([channelID isEqualToString:@"homepage_familiar"]) {
            remove = [defaults boolForKey:@"DYYYHideFriend"];
        } else if ([channelID isEqualToString:@"homepage_follow"]) {
            remove = [defaults boolForKey:@"DYYYHideFollow"];
        } else if ([channelID isEqualToString:@"homepage_mediumvideo"]) {
            remove = [defaults boolForKey:@"DYYYHideMediumVideo"];
        } else if ([channelID isEqualToString:@"homepage_mall"]) {
            remove = [defaults boolForKey:@"DYYYHideMall"];
        } else if ([channelID isEqualToString:@"homepage_nearby"]) {
            remove = [defaults boolForKey:@"DYYYHideNearby"];
        } else if ([channelID isEqualToString:@"homepage_groupon"]) {
            remove = [defaults boolForKey:@"DYYYHideGroupon"];
        } else if ([channelID isEqualToString:@"homepage_tablive"]) {
            remove = [defaults boolForKey:@"DYYYHideTabLive"];
        } else if ([channelID isEqualToString:@"homepage_pad_hot"]) {
            remove = [defaults boolForKey:@"DYYYHidePadHot"];
        } else if ([channelID isEqualToString:@"homepage_hangout"]) {
            remove = [defaults boolForKey:@"DYYYHideHangout"];
        } else if ([channelID isEqualToString:@"homepage_playlet_stream"]) {
            remove = [defaults boolForKey:@"DYYYHidePlaylet"];
        } else if ([channelID isEqualToString:@"homepage_pad_cinema"]) {
            remove = [defaults boolForKey:@"DYYYHideCinema"];
        } else if ([channelID isEqualToString:@"homepage_pad_kids_v2"]) {
            remove = [defaults boolForKey:@"DYYYHideKidsV2"];
        } else if ([channelID isEqualToString:@"homepage_pad_game"]) {
            remove = [defaults boolForKey:@"DYYYHideGame"];
        }

        if (!remove) {
            [newChannelModels addObject:tabItemModel];
        }
    }

    NSMutableArray *newCurrentChannelIDList =
        [NSMutableArray arrayWithCapacity:currentChannelIDList.count];

    for (id channelID in currentChannelIDList) {
        BOOL remove = NO;

        if ([channelID isEqualToString:@"homepage_hot_container"]) {
            remove = [defaults boolForKey:@"DYYYHideHotContainer"];
        } else if ([channelID isEqualToString:@"homepage_familiar"]) {
            remove = [defaults boolForKey:@"DYYYHideFriend"];
        } else if ([channelID isEqualToString:@"homepage_follow"]) {
            remove = [defaults boolForKey:@"DYYYHideFollow"];
        } else if ([channelID isEqualToString:@"homepage_mediumvideo"]) {
            remove = [defaults boolForKey:@"DYYYHideMediumVideo"];
        } else if ([channelID isEqualToString:@"homepage_mall"]) {
            remove = [defaults boolForKey:@"DYYYHideMall"];
        } else if ([channelID isEqualToString:@"homepage_nearby"]) {
            remove = [defaults boolForKey:@"DYYYHideNearby"];
        } else if ([channelID isEqualToString:@"homepage_groupon"]) {
            remove = [defaults boolForKey:@"DYYYHideGroupon"];
        } else if ([channelID isEqualToString:@"homepage_tablive"]) {
            remove = [defaults boolForKey:@"DYYYHideTabLive"];
        } else if ([channelID isEqualToString:@"homepage_pad_hot"]) {
            remove = [defaults boolForKey:@"DYYYHidePadHot"];
        } else if ([channelID isEqualToString:@"homepage_hangout"]) {
            remove = [defaults boolForKey:@"DYYYHideHangout"];
        } else if ([channelID isEqualToString:@"homepage_playlet_stream"]) {
            remove = [defaults boolForKey:@"DYYYHidePlaylet"];
        } else if ([channelID isEqualToString:@"homepage_pad_cinema"]) {
            remove = [defaults boolForKey:@"DYYYHideCinema"];
        } else if ([channelID isEqualToString:@"homepage_pad_kids_v2"]) {
            remove = [defaults boolForKey:@"DYYYHideKidsV2"];
        } else if ([channelID isEqualToString:@"homepage_pad_game"]) {
            remove = [defaults boolForKey:@"DYYYHideGame"];
        }

        if (!remove) {
            [newCurrentChannelIDList addObject:channelID];
        }
    }

    %orig(newChannelModels, newCurrentChannelIDList, arg3, arg4);
}

%end

#pragma mark - DY-tools control panel

@interface AWESettingItemModel : NSObject
@property(nonatomic,copy) NSString *identifier;
@property(nonatomic,copy) NSString *title;
@property(nonatomic,copy) NSString *subTitle;
@property(nonatomic,copy) NSString *detail;
@property(nonatomic,copy) NSString *svgIconImageName;
@property(nonatomic,copy) NSString *iconImageName;
@property(nonatomic,assign) NSInteger cellType;
@property(nonatomic,assign) NSInteger colorStyle;
@property(nonatomic,assign) BOOL isEnable;
@property(nonatomic,assign) BOOL isSwitchOn;
@property(nonatomic,copy) void (^cellTappedBlock)(void);
@property(nonatomic,copy) void (^switchChangedBlock)(void);
@end

@interface AWESettingSectionModel : NSObject
@property(nonatomic,copy) NSString *sectionHeaderTitle;
@property(nonatomic,assign) CGFloat sectionHeaderHeight;
@property(nonatomic,copy) NSString *sectionFooterTitle;
@property(nonatomic,assign) NSInteger type;
@property(nonatomic,strong) NSArray *itemArray;
@end

@interface AWESettingsViewModel : NSObject
@property(nonatomic,strong) NSArray *sectionDataArray;
@property(nonatomic,assign) NSInteger colorStyle;
@end

static UIViewController *DYToolsTopViewController(void) {
    UIWindow *window = DYFSActiveWindow();
    UIViewController *vc = window.rootViewController;
    while (vc.presentedViewController) vc = vc.presentedViewController;
    return vc;
}

@interface DYToolsTopBarViewController : UITableViewController
@property(nonatomic,copy) NSString *focusKey;
- (instancetype)initWithFocusKey:(NSString *)focusKey;
@end

@implementation DYToolsTopBarViewController {
    NSArray<NSDictionary *> *_items;
}

- (instancetype)initWithFocusKey:(NSString *)focusKey {
    self = [super initWithStyle:UITableViewStyleInsetGrouped];
    if (self) _focusKey = [focusKey copy];
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"顶栏移除";
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero
                                                 style:UITableViewStyleInsetGrouped];
    self.tableView.backgroundColor = UIColor.systemGroupedBackgroundColor;
    self.tableView.rowHeight = 52.0;
    self.tableView.showsVerticalScrollIndicator = NO;

    /*
     * 第一行是操作项，和下面的功能按钮保持完全相同的列表风格。
     * “一键全选”开启全部顶栏移除功能；
     * “一键取消”关闭全部顶栏移除功能。
     */
    _items = @[
        @{@"title":@"一键全选", @"action":@"selectAll"},
        @{@"title":@"移除推荐",   @"key":@"DYYYHideHotContainer"},
        @{@"title":@"移除朋友",   @"key":@"DYYYHideFriend"},
        @{@"title":@"移除关注",   @"key":@"DYYYHideFollow"},
        @{@"title":@"移除精选",   @"key":@"DYYYHideMediumVideo"},
        @{@"title":@"移除商城",   @"key":@"DYYYHideMall"},
        @{@"title":@"移除同城",   @"key":@"DYYYHideNearby"},
        @{@"title":@"移除团购",   @"key":@"DYYYHideGroupon"},
        @{@"title":@"移除直播",   @"key":@"DYYYHideTabLive"},
        @{@"title":@"移除热点",   @"key":@"DYYYHidePadHot"},
        @{@"title":@"移除经验",   @"key":@"DYYYHideHangout"},
        @{@"title":@"移除短剧",   @"key":@"DYYYHidePlaylet"},
        @{@"title":@"移除看剧",   @"key":@"DYYYHideCinema"},
        @{@"title":@"移除少儿",   @"key":@"DYYYHideKidsV2"},
        @{@"title":@"移除游戏",   @"key":@"DYYYHideGame"},
        @{@"title":@"移除长视频", @"key":@"DYYYHideMediumVideo"}
    ];

    if (_focusKey.length > 0) {
        dispatch_async(dispatch_get_main_queue(), ^{
            for (NSInteger row = 1; row < (NSInteger)self->_items.count; row++) {
                if ([self->_items[row][@"key"] isEqualToString:self->_focusKey]) {
                    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:0]
                                          atScrollPosition:UITableViewScrollPositionMiddle
                                                  animated:NO];
                    break;
                }
            }
        });
    }
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
    return _items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *reuse = @"DYToolsTopBarCell";

    UITableViewCell *cell =
        [tableView dequeueReusableCellWithIdentifier:reuse];

    if (!cell) {
        cell = [[UITableViewCell alloc]
                initWithStyle:UITableViewCellStyleDefault
                reuseIdentifier:reuse];
    }

    NSDictionary *item = _items[indexPath.row];

    cell.textLabel.text = item[@"title"];
    cell.textLabel.font = [UIFont systemFontOfSize:16.0];
    cell.backgroundColor = UIColor.secondarySystemGroupedBackgroundColor;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    /*
     * 第一行“一键全选”也是普通功能行风格。
     * 右侧使用 Switch 表示当前是否全部开启。
     */
    if (indexPath.row == 0) {
        UISwitch *sw = [UISwitch new];
        sw.onTintColor = UIColor.systemBlueColor;

        BOOL allEnabled = YES;
        for (NSUInteger i = 1; i < _items.count; i++) {
            NSString *key = _items[i][@"key"];
            if (![[NSUserDefaults standardUserDefaults] boolForKey:key]) {
                allEnabled = NO;
                break;
            }
        }

        sw.on = allEnabled;
        sw.tag = 0;
        [sw addTarget:self
               action:@selector(dy_selectAllSwitch:)
     forControlEvents:UIControlEventValueChanged];

        cell.accessoryView = sw;
        return cell;
    }

    UISwitch *sw = [UISwitch new];
    sw.onTintColor = UIColor.systemBlueColor;
    sw.on = [[NSUserDefaults standardUserDefaults] boolForKey:item[@"key"]];
    sw.tag = indexPath.row;

    [sw addTarget:self
           action:@selector(dy_switch:)
 forControlEvents:UIControlEventValueChanged];

    cell.accessoryView = sw;
    return cell;
}

- (void)dy_switch:(UISwitch *)sender {
    NSString *key = _items[sender.tag][@"key"];

    [[NSUserDefaults standardUserDefaults] setBool:sender.isOn
                                             forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];

    [self.tableView reloadRowsAtIndexPaths:@[
        [NSIndexPath indexPathForRow:0 inSection:0]
    ] withRowAnimation:UITableViewRowAnimationNone];
}

@end

@interface DYToolsBottomBarViewController : UITableViewController
@property(nonatomic,copy) NSString *focusKey;
- (instancetype)initWithFocusKey:(NSString *)focusKey;
@end

@implementation DYToolsBottomBarViewController {
    NSArray<NSDictionary *> *_items;
}

- (instancetype)initWithFocusKey:(NSString *)focusKey {
    self = [super initWithStyle:UITableViewStyleInsetGrouped];
    if (self) _focusKey = [focusKey copy];
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"移除底栏";
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleInsetGrouped];
    self.tableView.backgroundColor = UIColor.systemGroupedBackgroundColor;
    self.tableView.rowHeight = 52.0;
    _items = @[
        @{@"title":@"隐藏底栏商城", @"key":@"DYYYHideShopButton"},
        @{@"title":@"隐藏双列入口", @"key":@"DYYYHideDoubleColumnEntry"},
        @{@"title":@"隐藏底栏消息", @"key":@"DYYYHideMessageButton"},
        @{@"title":@"隐藏底栏朋友", @"key":@"DYYYHideFriendsButton"},
        @{@"title":@"隐藏底栏我的", @"key":@"DYYYHideMyButton"},
        @{@"title":@"隐藏底栏加号", @"key":@"DYYYHidePlusButton"},
        @{@"title":@"隐藏底栏评论", @"key":@"DYYYHideComment"},
        @{@"title":@"隐藏底栏红点", @"key":@"DYYYHideBottomDot"},
        @{@"title":@"隐藏底栏背景", @"key":@"DYYYHideBottomBg"},
        @{@"title":@"精简平板底栏", @"key":@"DYYYHidePadTabBarElements"}
    ];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section { return _items.count; }
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *reuse = @"DYToolsBottomBarCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuse];
    if (!cell) cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuse];
    NSDictionary *item = _items[indexPath.row];
    cell.textLabel.text = item[@"title"];
    cell.textLabel.font = [UIFont systemFontOfSize:16.0];
    cell.backgroundColor = UIColor.secondarySystemGroupedBackgroundColor;
    UISwitch *sw = [UISwitch new];
    sw.onTintColor = UIColor.systemBlueColor;
    sw.on = [[NSUserDefaults standardUserDefaults] boolForKey:item[@"key"]];
    sw.tag = indexPath.row;
    [sw addTarget:self action:@selector(dy_switch:) forControlEvents:UIControlEventValueChanged];
    cell.accessoryView = sw;
    return cell;
}
- (void)dy_switch:(UISwitch *)sender {
    NSString *key = _items[sender.tag][@"key"];
    [[NSUserDefaults standardUserDefaults] setBool:sender.isOn forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
- (void)dy_setAll:(BOOL)value {
    NSUserDefaults *d = [NSUserDefaults standardUserDefaults];
    for (NSDictionary *item in _items) [d setBool:value forKey:item[@"key"]];
    [d synchronize];
    [self.tableView reloadData];
}
- (void)dy_selectAll { [self dy_setAll:YES]; }
- (void)dy_selectNone { [self dy_setAll:NO]; }
@end

@interface DYToolsVideoSettingsViewController : UITableViewController
@property(nonatomic,copy) NSString *focusKey;
- (instancetype)initWithFocusKey:(NSString *)focusKey;
@end

@implementation DYToolsVideoSettingsViewController {
    NSArray<NSDictionary *> *_items;
}

- (instancetype)initWithFocusKey:(NSString *)focusKey {
    self = [super initWithStyle:UITableViewStyleInsetGrouped];
    if (self) _focusKey = [focusKey copy];
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"视频设置";
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero
                                                  style:UITableViewStyleInsetGrouped];
    self.tableView.backgroundColor = UIColor.systemGroupedBackgroundColor;
    self.tableView.rowHeight = 52.0;
    self.tableView.showsVerticalScrollIndicator = NO;

    _items = @[
        @{@"title":@"一键全选", @"action":@"selectAll"},
        @{@"title":@"移除去汽水听", @"key":kDYToolsRemoveShuiTingKey},
        @{@"title":@"移除相关搜索", @"key":kDYToolsRemoveRelatedSearchKey},
        @{@"title":@"移除热点栏", @"key":kDYToolsRemoveHotspotKey},
        @{@"title":@"移除音乐按钮", @"key":kDYToolsHideMusicButtonKey},
        @{@"title":@"移除视频位置", @"key":@"DYYYHideLocation"}
    ];

    if (_focusKey.length > 0) {
        dispatch_async(dispatch_get_main_queue(), ^{
            for (NSInteger row = 1; row < (NSInteger)self->_items.count; row++) {
                if ([self->_items[row][@"key"] isEqualToString:self->_focusKey]) {
                    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:0]
                                          atScrollPosition:UITableViewScrollPositionMiddle
                                                  animated:NO];
                    break;
                }
            }
        });
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *reuse = @"DYToolsVideoSettingsCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuse];

    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:reuse];
    }

    NSDictionary *item = _items[indexPath.row];
    cell.textLabel.text = item[@"title"];
    cell.textLabel.font = [UIFont systemFontOfSize:16.0];
    cell.textLabel.textColor = UIColor.labelColor;
    cell.backgroundColor = UIColor.secondarySystemGroupedBackgroundColor;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    UISwitch *sw = [UISwitch new];
    sw.onTintColor = UIColor.systemBlueColor;

    if (indexPath.row == 0) {
        BOOL allEnabled = YES;
        for (NSUInteger i = 1; i < _items.count; i++) {
            if (![[NSUserDefaults standardUserDefaults] boolForKey:_items[i][@"key"]]) {
                allEnabled = NO;
                break;
            }
        }
        sw.on = allEnabled;
        sw.tag = 0;
        [sw addTarget:self action:@selector(dy_selectAllSwitch:)
      forControlEvents:UIControlEventValueChanged];
    } else {
        sw.on = [[NSUserDefaults standardUserDefaults] boolForKey:item[@"key"]];
        sw.tag = indexPath.row;
        [sw addTarget:self action:@selector(dy_switch:)
      forControlEvents:UIControlEventValueChanged];
    }

    cell.accessoryView = sw;
    return cell;
}

- (void)dy_switch:(UISwitch *)sender {
    NSString *key = _items[sender.tag][@"key"];
    [[NSUserDefaults standardUserDefaults] setBool:sender.isOn forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];

    [self.tableView reloadRowsAtIndexPaths:@[
        [NSIndexPath indexPathForRow:0 inSection:0]
    ] withRowAnimation:UITableViewRowAnimationNone];
}

- (void)dy_selectAllSwitch:(UISwitch *)sender {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

    for (NSUInteger i = 1; i < _items.count; i++) {
        [defaults setBool:sender.isOn forKey:_items[i][@"key"]];
    }

    [defaults synchronize];
    [self.tableView reloadData];
}

@end


#pragma mark - DYYY Basic Settings

static NSString *DYToolsBasicDisplayValue(NSString *key) {
    id value = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    if (!value) return @"";
    return [value isKindOfClass:NSString.class] ? value : [value description];
}

static void DYToolsBasicSetDefaultIfNeeded(NSString *key, id value) {
    NSUserDefaults *d = [NSUserDefaults standardUserDefaults];
    if ([d objectForKey:key] == nil && value != nil) [d setObject:value forKey:key];
}

@interface DYToolsBasicSettingsViewController : UITableViewController
@property(nonatomic,copy) NSString *focusKey;
@end

@implementation DYToolsBasicSettingsViewController {
    NSArray<NSDictionary *> *_sections;
}

- (instancetype)init {
    return [self initWithFocusKey:nil];
}

- (instancetype)initWithFocusKey:(NSString *)focusKey {
    self = [super initWithStyle:UITableViewStyleInsetGrouped];
    if (self) _focusKey = [focusKey copy];
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"基本设置";
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 52.0;
    self.tableView.showsVerticalScrollIndicator = NO;

    _sections = @[
        @{@"title":@"基本设置",@"items":@[
        @{@"title":@"视频背景颜色",@"key":@"DYYYVideoBGColor",@"type":@"text",@"placeholder":@"十六进制"},
        @{@"title":@"启用弹幕改色",@"key":@"DYYYEnableDanmuColor",@"type":@"switch"},
        @{@"title":@"自定弹幕颜色",@"key":@"DYYYDanmuColor",@"type":@"text",@"placeholder":@"十六进制"},
        @{@"title":@"设置默认倍速",@"key":@"DYYYDefaultSpeed",@"type":@"picker"},@{@"title":@"设置长按倍速",@"key":@"DYYYLongPressSpeed",@"type":@"picker"},
        @{@"title":@"上下控制倍速",@"key":@"DYYYEnableLongPressSpeedGesture",@"type":@"switch"},@{@"title":@"显示进度时长",@"key":@"DYYYShowScheduleDisplay",@"type":@"switch"},
        @{@"title":@"进度时长样式",@"key":@"DYYYScheduleStyle",@"type":@"text",@"placeholder":@"默认"},@{@"title":@"进度纵轴位置",@"key":@"DYYYTimelineVerticalPosition",@"type":@"text",@"placeholder":@"-12.5"},
        @{@"title":@"进度标签颜色",@"key":@"DYYYProgressLabelColor",@"type":@"text",@"placeholder":@"十六进制"},@{@"title":@"隐藏视频进度",@"key":@"DYYYHideVideoProgress",@"type":@"switch"},
        @{@"title":@"启用自动播放",@"key":@"DYYYEnableAutoPlay",@"type":@"switch"},@{@"title":@"忽略投屏 VPN 检测",@"key":@"DYYYDisableCastVPNCheck",@"type":@"switch"},
        @{@"title":@"推荐过滤直播",@"key":@"DYYYSkipLive",@"type":@"switch"},@{@"title":@"推荐过滤热点",@"key":@"DYYYSkipHotSpot",@"type":@"switch"},
        @{@"title":@"推荐过滤低赞",@"key":@"DYYYFilterLowLikes",@"type":@"text",@"placeholder":@"填0关闭"},@{@"title":@"推荐视频时限",@"key":@"DYYYFilterTimeLimit",@"type":@"text",@"placeholder":@"填0关闭，单位为天"},
        @{@"title":@"推荐过滤HDR",@"key":@"DYYYFilterFeedHDR",@"type":@"switch"},@{@"title":@"启用首页净化",@"key":@"DYYYEnablePure",@"type":@"switch"},
        @{@"title":@"启用首页全屏",@"key":@"DYYYEnableFullScreen",@"type":@"switch"},@{@"title":@"启用屏蔽广告",@"key":@"DYYYNoAds",@"type":@"switch"},
        @{@"title":@"屏蔽检测更新",@"key":@"DYYYNoUpdates",@"type":@"switch"},@{@"title":@"去青少年弹窗",@"key":@"DYYYHideTeenMode",@"type":@"switch"},
        @{@"title":@"评论区毛玻璃",@"key":@"DYYYEnableCommentBlur",@"type":@"switch"},@{@"title":@"通知玻璃效果",@"key":@"DYYYEnableNotificationTransparency",@"type":@"switch"},
        @{@"title":@"毛玻璃透明度",@"key":@"DYYYCommentBlurTransparent",@"type":@"text",@"placeholder":@"0-1小数"},@{@"title":@"通知圆角半径",@"key":@"DYYYNotificationCornerRadius",@"type":@"text",@"placeholder":@"默认12"},
        @{@"title":@"时间属地显示",@"key":@"DYYYEnableArea",@"type":@"switch"},@{@"title":@"国外解析账号",@"key":@"DYYYGeonamesUsername",@"type":@"text",@"placeholder":@"需填写才能解析国外"},
        @{@"title":@"时间标签颜色",@"key":@"DYYYLabelColor",@"type":@"text",@"placeholder":@"十六进制"},@{@"title":@"属地随机渐变",@"key":@"DYYYEnableRandomGradient",@"type":@"switch"},
        @{@"title":@"隐藏系统顶栏",@"key":@"DYYYHideStatusbar",@"type":@"switch"},@{@"title":@"关注二次确认",@"key":@"DYYYFollowTips",@"type":@"switch"},
        @{@"title":@"收藏二次确认",@"key":@"DYYYCollectTips",@"type":@"switch"},@{@"title":@"默认直播画质",@"key":@"DYYYLiveQuality",@"type":@"picker"},
        @{@"title":@"提高视频画质",@"key":@"DYYYEnableVideoHighestQuality",@"type":@"switch"},@{@"title":@"禁用直播PCDN功能",@"key":@"DYYYDisableLivePCDN",@"type":@"switch"},
        @{@"title":@"评论具体时间",@"key":@"DYYYCommentExactTime",@"type":@"switch"},
        @{@"title":@"屏蔽灵动岛抖音播放信息",@"key":@"DYYYDisableFeedNowPlayingInfo",@"type":@"switch"}
        ]} 
    ];

    for (NSDictionary *section in _sections) {
        for (NSDictionary *item in section[@"items"]) {
            if ([item[@"type"] isEqualToString:@"switch"]) {
                DYToolsBasicSetDefaultIfNeeded(item[@"key"], @NO);
            }
        }
    }

    if (_focusKey.length > 0) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self dy_scrollToFocusKey];
        });
    }
}

- (void)dy_scrollToFocusKey {
    for (NSInteger s = 0; s < (NSInteger)_sections.count; s++) {
        NSArray *items = _sections[s][@"items"];
        for (NSInteger r = 0; r < (NSInteger)items.count; r++) {
            if ([items[r][@"key"] isEqualToString:_focusKey]) {
                [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:r inSection:s]
                                      atScrollPosition:UITableViewScrollPositionMiddle
                                              animated:NO];
                return;
            }
        }
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _sections.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return _sections[section][@"title"];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_sections[section][@"items"] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *reuse = @"DYToolsBasicSettingsCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuse];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                      reuseIdentifier:reuse];
    }

    NSDictionary *item = _sections[indexPath.section][@"items"][indexPath.row];
    cell.textLabel.text = item[@"title"];
    cell.textLabel.font = [UIFont systemFontOfSize:16.0];
    cell.textLabel.textColor = UIColor.labelColor;
    cell.detailTextLabel.textColor = UIColor.secondaryLabelColor;
    cell.detailTextLabel.numberOfLines = 1;
    cell.backgroundColor = UIColor.secondarySystemGroupedBackgroundColor;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    if ([item[@"type"] isEqualToString:@"switch"]) {
        UISwitch *sw = [UISwitch new];
        sw.on = [[NSUserDefaults standardUserDefaults] boolForKey:item[@"key"]];
        sw.tag = indexPath.row;
        [sw addTarget:self action:@selector(dy_basicSwitch:) forControlEvents:UIControlEventValueChanged];
        cell.accessoryView = sw;
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.detailTextLabel.text = nil;
    } else {
        cell.accessoryView = nil;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        NSString *value = DYToolsBasicDisplayValue(item[@"key"]);
        if (value.length == 0) {
            cell.detailTextLabel.text = item[@"placeholder"] ?: @"";
        } else {
            cell.detailTextLabel.text = value;
        }
    }
    return cell;
}

- (NSDictionary *)dy_itemForSwitch:(UISwitch *)sender {
    NSIndexPath *path = [self.tableView indexPathForCell:(UITableViewCell *)sender.superview];
    if (!path) {
        UIView *v = sender.superview;
        while (v && ![v isKindOfClass:UITableViewCell.class]) v = v.superview;
        if (v) path = [self.tableView indexPathForCell:(UITableViewCell *)v];
    }
    return path ? _sections[path.section][@"items"][path.row] : nil;
}

- (void)dy_basicSwitch:(UISwitch *)sender {
    NSDictionary *item = [self dy_itemForSwitch:sender];
    if (!item) return;
    [[NSUserDefaults standardUserDefaults] setBool:sender.isOn forKey:item[@"key"]];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSArray<NSString *> *)dy_pickerOptionsForKey:(NSString *)key {
    if ([key isEqualToString:@"DYYYDefaultSpeed"] || [key isEqualToString:@"DYYYLongPressSpeed"]) {
        return @[@"0.75x",@"1.0x",@"1.25x",@"1.5x",@"2.0x",@"2.5x",@"3.0x"];
    }
    if ([key isEqualToString:@"DYYYScheduleStyle"]) {
        return @[@"进度条两侧上下",@"进度条左侧剩余",@"进度条左侧完整",@"进度条右侧剩余",@"进度条右侧完整"];
    }
    if ([key isEqualToString:@"DYYYLabelStyle"]) {
        return @[@"文案标签显示",@"文案标签隐藏",@"文案标签禁止跳转搜索"];
    }
    if ([key isEqualToString:@"DYYYLiveQuality"]) {
        return @[@"蓝光帧彩",@"蓝光",@"超清",@"高清",@"标清",@"自动"];
    }
    return @[];
}

- (void)dy_showTextForItem:(NSDictionary *)item {
    NSString *key = item[@"key"];
    NSString *current = DYToolsBasicDisplayValue(key);
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:item[@"title"]
                                                                   message:item[@"placeholder"]
                                                            preferredStyle:UIAlertControllerStyleAlert];
    [alert addTextFieldWithConfigurationHandler:^(UITextField *field) {
        field.text = current;
        field.placeholder = item[@"placeholder"];
        field.clearButtonMode = UITextFieldViewModeWhileEditing;
    }];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [alert addAction:[UIAlertAction actionWithTitle:@"保存" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        NSString *value = [alert.textFields.firstObject.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        [[NSUserDefaults standardUserDefaults] setObject:value ?: @"" forKey:key];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [self.tableView reloadData];
    }]];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)dy_showPickerForItem:(NSDictionary *)item {
    NSString *key = item[@"key"];
    NSArray *options = [self dy_pickerOptionsForKey:key];
    NSString *current = DYToolsBasicDisplayValue(key);
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:item[@"title"]
                                                                   message:nil
                                                            preferredStyle:UIAlertControllerStyleActionSheet];
    for (NSString *option in options) {
        [alert addAction:[UIAlertAction actionWithTitle:option
                                                  style:UIAlertActionStyleDefault
                                                handler:^(UIAlertAction *action) {
            [[NSUserDefaults standardUserDefaults] setObject:action.title forKey:key];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [self.tableView reloadData];
        }]];
    }
    if (current.length > 0) {
        // 当前值仅作为展示，不额外创建重复选项。
    }
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    if (alert.popoverPresentationController) {
        alert.popoverPresentationController.sourceView = self.view;
        alert.popoverPresentationController.sourceRect = CGRectMake(self.view.bounds.size.width/2.0, self.view.bounds.size.height-40.0, 1.0, 1.0);
    }
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *item = _sections[indexPath.section][@"items"][indexPath.row];
    if ([item[@"type"] isEqualToString:@"text"]) {
        [self dy_showTextForItem:item];
    } else if ([item[@"type"] isEqualToString:@"picker"]) {
        [self dy_showPickerForItem:item];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end


@interface DYToolsControlViewController : UIViewController <UISearchResultsUpdating>
@end

@implementation DYToolsControlViewController {
    UISwitch *_fullscreenSwitch;
    UISwitch *_removeShuiTingSwitch;
    UISwitch *_removeRelatedSearchSwitch;
    UISwitch *_removeHotspotSwitch;
    UISwitch *_hideEnterLiveSwitch;
    UISwitch *_disableAutoEnterLiveSwitch;
    UISwitch *_hideMusicButtonSwitch;
    UISwitch *_hideLocationSwitch;
    UITableView *_dyTableView;
    UISearchController *_globalSearchController;
    NSArray *_globalSearchEntries;
    NSArray *_globalSearchResults;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = UIColor.systemGroupedBackgroundColor;
    self.title = @"DY-tools";
    self.navigationController.navigationBar.prefersLargeTitles = YES;
    self.navigationItem.largeTitleDisplayMode = UINavigationItemLargeTitleDisplayModeAlways;
    _globalSearchEntries = [self dy_buildGlobalSearchEntries];
    _globalSearchResults = @[];
    _globalSearchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    _globalSearchController.searchResultsUpdater = self;
    _globalSearchController.obscuresBackgroundDuringPresentation = NO;
    _globalSearchController.searchBar.placeholder = @"搜索插件功能";
    self.navigationItem.searchController = _globalSearchController;
    self.navigationItem.hidesSearchBarWhenScrolling = NO;
    self.definesPresentationContext = YES;

    self.navigationItem.leftBarButtonItem =
        [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemClose
                                                       target:self
                                                       action:@selector(dy_close)];

    UITableView *table =
        [[UITableView alloc] initWithFrame:CGRectZero
                                     style:UITableViewStyleInsetGrouped];
    table.translatesAutoresizingMaskIntoConstraints = NO;
    table.backgroundColor = UIColor.clearColor;
    table.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    table.separatorInset = UIEdgeInsetsMake(0.0, 16.0, 0.0, 16.0);
    table.showsVerticalScrollIndicator = NO;
    table.rowHeight = 52.0;
    table.dataSource = (id<UITableViewDataSource>)self;
    table.delegate = (id<UITableViewDelegate>)self;
    [self.view addSubview:table];
    _dyTableView = table;

    [NSLayoutConstraint activateConstraints:@[
        [table.topAnchor constraintEqualToAnchor:self.view.topAnchor],
        [table.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor],
        [table.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
        [table.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor]
    ]];

    _fullscreenSwitch = [UISwitch new];
    _fullscreenSwitch.on = DYFSIsEnabled();
    [_fullscreenSwitch addTarget:self action:@selector(dy_fullscreenChanged:)
                forControlEvents:UIControlEventValueChanged];

    _removeShuiTingSwitch = [UISwitch new];
    _removeShuiTingSwitch.on = DYToolsBool(kDYToolsRemoveShuiTingKey);
    [_removeShuiTingSwitch addTarget:self action:@selector(dy_removeShuiTingChanged:)
                    forControlEvents:UIControlEventValueChanged];

    _removeRelatedSearchSwitch = [UISwitch new];
    _removeRelatedSearchSwitch.on = DYToolsBool(kDYToolsRemoveRelatedSearchKey);
    [_removeRelatedSearchSwitch addTarget:self action:@selector(dy_removeRelatedSearchChanged:)
                    forControlEvents:UIControlEventValueChanged];

    _removeHotspotSwitch = [UISwitch new];
    _removeHotspotSwitch.on = DYToolsBool(kDYToolsRemoveHotspotKey);
    [_removeHotspotSwitch addTarget:self action:@selector(dy_removeHotspotChanged:)
                    forControlEvents:UIControlEventValueChanged];

    _hideEnterLiveSwitch = [UISwitch new];
    _hideEnterLiveSwitch.on = DYToolsBool(kDYToolsHideEnterLiveKey);
    [_hideEnterLiveSwitch addTarget:self action:@selector(dy_hideEnterLiveChanged:)
                    forControlEvents:UIControlEventValueChanged];

    _disableAutoEnterLiveSwitch = [UISwitch new];
    _disableAutoEnterLiveSwitch.on = DYToolsBool(kDYToolsDisableAutoEnterLiveKey);
    [_disableAutoEnterLiveSwitch addTarget:self action:@selector(dy_disableAutoEnterLiveChanged:)
                    forControlEvents:UIControlEventValueChanged];

    _hideMusicButtonSwitch = [UISwitch new];
    _hideMusicButtonSwitch.on = DYToolsBool(kDYToolsHideMusicButtonKey);
    [_hideMusicButtonSwitch addTarget:self action:@selector(dy_hideMusicButtonChanged:)
                    forControlEvents:UIControlEventValueChanged];

    _hideLocationSwitch = [UISwitch new];
    _hideLocationSwitch.on = DYToolsBool(kDYToolsHideLocationKey);
    [_hideLocationSwitch addTarget:self action:@selector(dy_hideLocationChanged:)
                    forControlEvents:UIControlEventValueChanged];

    NSArray *switches = @[
        _fullscreenSwitch,
        _removeShuiTingSwitch,
        _removeRelatedSearchSwitch,
        _removeHotspotSwitch,
        _hideEnterLiveSwitch,
        _disableAutoEnterLiveSwitch,
        _hideMusicButtonSwitch,
        _hideLocationSwitch
    ];
    for (UISwitch *sw in switches) {
        sw.onTintColor = UIColor.systemBlueColor;
        sw.transform = CGAffineTransformMakeScale(0.92, 0.92);
    }
}

- (void)dy_close {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)dy_fullscreenChanged:(UISwitch *)sender {
    BOOL enabled = sender.isOn;
    [[NSUserDefaults standardUserDefaults] setBool:enabled forKey:kDYFSFullScreenEnabledKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
    if (!enabled) DYFSRunRestoreHooks();
}

- (void)dy_removeShuiTingChanged:(UISwitch *)sender {
    [[NSUserDefaults standardUserDefaults] setBool:sender.isOn forKey:kDYToolsRemoveShuiTingKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)dy_removeRelatedSearchChanged:(UISwitch *)sender {
    [[NSUserDefaults standardUserDefaults] setBool:sender.isOn forKey:kDYToolsRemoveRelatedSearchKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)dy_removeHotspotChanged:(UISwitch *)sender {
    [[NSUserDefaults standardUserDefaults] setBool:sender.isOn forKey:kDYToolsRemoveHotspotKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)dy_hideEnterLiveChanged:(UISwitch *)sender {
    [[NSUserDefaults standardUserDefaults] setBool:sender.isOn forKey:kDYToolsHideEnterLiveKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)dy_disableAutoEnterLiveChanged:(UISwitch *)sender {
    [[NSUserDefaults standardUserDefaults] setBool:sender.isOn forKey:kDYToolsDisableAutoEnterLiveKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)dy_hideMusicButtonChanged:(UISwitch *)sender {
    [[NSUserDefaults standardUserDefaults] setBool:sender.isOn forKey:kDYToolsHideMusicButtonKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)dy_hideLocationChanged:(UISwitch *)sender {
    [[NSUserDefaults standardUserDefaults] setBool:sender.isOn forKey:kDYToolsHideLocationKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (_globalSearchController.isActive) return _globalSearchResults.count;
    switch (section) {
        case 0: return 1; // Basic
        case 1: return 1; // Fullscreen
        case 2: return 3; // Video
        case 3: return 2; // Live / interaction
        default: return 0;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    switch (section) {
        case 0: return @"设置";
        case 1: return @"全屏";
        case 2: return @"视频界面";
        case 3: return @"直播与互动";
        default: return nil;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    switch (section) {
        case 0: return @"搜索全部插件功能，或进入 DYYY 基本设置。";
        case 1: return @"开启后，视频播放区域会使用全屏布局。";
        case 2: return @"视频设置、顶栏和底栏功能分类管理。";
        case 3: return @"用于处理直播入口及直播自动跳转行为。";
        default: return nil;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 52.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 38.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 38.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    static NSString *reuse = @"DYToolsCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuse];

    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:reuse];
    }

    cell.accessoryView = nil;
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = UIColor.secondarySystemGroupedBackgroundColor;

    cell.textLabel.font = [UIFont systemFontOfSize:16.0 weight:UIFontWeightRegular];
    cell.textLabel.textColor = UIColor.labelColor;
    cell.textLabel.numberOfLines = 1;

    UISwitch *sw = nil;

    if (_globalSearchController.isActive) {
        NSDictionary *item = _globalSearchResults[indexPath.row];
        cell.textLabel.text = item[@"title"];
        cell.detailTextLabel.text = item[@"category"];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleDefault;
        return cell;
    }

    if (indexPath.section == 0) {
        cell.textLabel.text = @"基本设置";
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    } else if (indexPath.section == 1) {
        cell.textLabel.text = @"视频全屏";
        sw = _fullscreenSwitch;
    } else if (indexPath.section == 2) {
        switch (indexPath.row) {
            case 0:
                cell.textLabel.text = @"视频设置";
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                break;
            case 1:
                cell.textLabel.text = @"移除顶栏";
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                break;
            case 2:
                cell.textLabel.text = @"移除底栏";
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                break;
        }
    } else {
        switch (indexPath.row) {
            case 0:
                cell.textLabel.text = @"去除进入直播间提示";
                sw = _hideEnterLiveSwitch;
                break;
            case 1:
                cell.textLabel.text = @"禁止自动进入直播间";
                sw = _disableAutoEnterLiveSwitch;
                break;
        }
    }

    if (sw) {
        sw.onTintColor = UIColor.systemBlueColor;
        cell.accessoryView = sw;
    }

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_globalSearchController.isActive && _globalSearchResults.count > 0) {
        NSDictionary *item = _globalSearchResults[indexPath.row];
        UIViewController *vc=nil;
        if([item[@"type"] isEqualToString:@"basic"]) vc=[[DYToolsBasicSettingsViewController alloc] initWithFocusKey:item[@"key"]];
        else if([item[@"type"] isEqualToString:@"video"]) vc=[[DYToolsVideoSettingsViewController alloc] initWithFocusKey:item[@"key"]];
        else if([item[@"type"] isEqualToString:@"top"]) vc=[[DYToolsTopBarViewController alloc] initWithFocusKey:item[@"key"]];
        else if([item[@"type"] isEqualToString:@"bottom"]) vc=[[DYToolsBottomBarViewController alloc] initWithFocusKey:item[@"key"]];
        if(vc){ [_globalSearchController setActive:NO]; [self.navigationController pushViewController:vc animated:YES]; }
        return;
    }
    if(indexPath.section==0){ [self.navigationController pushViewController:[DYToolsBasicSettingsViewController new] animated:YES]; return; }
    if(indexPath.section==2&&indexPath.row==0){ [self.navigationController pushViewController:[DYToolsVideoSettingsViewController new] animated:YES]; return; }
    if(indexPath.section==2&&indexPath.row==1){ [self.navigationController pushViewController:[DYToolsTopBarViewController new] animated:YES]; return; }
    if(indexPath.section==2&&indexPath.row==2){ [self.navigationController pushViewController:[DYToolsBottomBarViewController new] animated:YES]; return; }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end


#pragma mark - DYYY Basic Feature Hooks

%hook TTAdSplashModel
+ (id)alloc { if (DYToolsBool(@"DYYYNoAds")) return nil; return %orig; }
%end
%hook AWEOriginalAdModel
- (instancetype)init { if (DYToolsBool(@"DYYYNoAds")) return nil; return %orig; }
- (instancetype)initWithDictionary:(id)dict error:(NSError **)error { if (DYToolsBool(@"DYYYNoAds")) return nil; return %orig; }
%end
%hook AWEGeneralSearchModel
- (instancetype)initWithDictionary:(id)dict error:(NSError **)error {
 id obj=%orig;
 if (DYToolsBool(@"DYYYNoAds") && [[obj valueForKeyPath:@"commonDynamicPatchModel.is_ad"] integerValue]==1) return nil;
 return obj;
}
%end
%hook AWEAwesomeSplashFeedCellOldAccessoryView
- (id)ddExtraView { if (DYToolsBool(@"DYYYNoAds")) return nil; return %orig; }
%end
%hook AWETeenModeAlertView
- (BOOL)show { if (DYToolsBool(@"DYYYHideTeenMode")) return NO; return %orig; }
%end
%hook AWETeenModeSimpleAlertView
- (BOOL)show { if (DYToolsBool(@"DYYYHideTeenMode")) return NO; return %orig; }
%end
%hook AWEVersionUpdateManager
- (void)startVersionUpdateWorkflow:(id)arg1 completion:(id)arg2 { if(DYToolsBool(@"DYYYNoUpdates")) { if(arg2)((void(^)(void))arg2)(); return;} %orig; }
- (id)workflow { if(DYToolsBool(@"DYYYNoUpdates")) return nil; return %orig; }
- (id)badgeModule { if(DYToolsBool(@"DYYYNoUpdates")) return nil; return %orig; }
%end
%hook AWEAwemeStatusModel
- (void)setListenVideoStatus:(NSInteger)status { if(status==1&&DYToolsBool(@"DYYYEnableBackgroundListen"))status=2; %orig(status); }
%end
%hook AWEFeedIPhoneAutoPlayManager
- (BOOL)isAutoPlayOpen { if(DYToolsBool(@"DYYYEnableAutoPlay"))return YES; return %orig; }
%end
%hook BDByteCastMonitorManager
- (BOOL)netVPNStatus { if(DYToolsBool(@"DYYYDisableCastVPNCheck"))return NO; return %orig; }
- (void)setNetVPNStatus:(BOOL)v { if(DYToolsBool(@"DYYYDisableCastVPNCheck")){%orig(NO);return;} %orig(v); }
%end
%hook BDByteCastEnvInfo
- (BOOL)isVPNActive { if(DYToolsBool(@"DYYYDisableCastVPNCheck"))return NO; return %orig; }
- (void)setIsVPNActive:(BOOL)v { if(DYToolsBool(@"DYYYDisableCastVPNCheck")){%orig(NO);return;} %orig(v); }
%end
%hook BDByteScreenCastContext
- (BOOL)isVPNActive { if(DYToolsBool(@"DYYYDisableCastVPNCheck"))return NO; return %orig; }
- (void)setIsVPNActive:(BOOL)v { if(DYToolsBool(@"DYYYDisableCastVPNCheck")){%orig(NO);return;} %orig(v); }
%end

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    NSString *q=[searchController.searchBar.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if(!q.length){_globalSearchResults=@[];}else{
      _globalSearchResults=[_globalSearchEntries filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(NSDictionary *o,NSDictionary *b){
        return [o[@"title"] localizedCaseInsensitiveContainsString:q]||[o[@"key"] localizedCaseInsensitiveContainsString:q]||[o[@"category"] localizedCaseInsensitiveContainsString:q];
      }]];
    }
    [_dyTableView reloadData];
}
- (NSArray *)dy_buildGlobalSearchEntries {
 NSMutableArray *a=[NSMutableArray array];
 void(^add)(NSString*,NSString*,NSString*,NSString*)=^(NSString*t,NSString*k,NSString*c,NSString*y){[a addObject:@{@"title":t,@"key":k?:@"",@"category":c,@"type":y}];};
 add(@"视频全屏",kDYFSFullScreenEnabledKey,@"全屏",@"main");
 add(@"移除去汽水听",kDYToolsRemoveShuiTingKey,@"视频设置",@"video");
 add(@"移除相关搜索",kDYToolsRemoveRelatedSearchKey,@"视频设置",@"video");
 add(@"移除热点栏",kDYToolsRemoveHotspotKey,@"视频设置",@"video");
 add(@"移除音乐按钮",kDYToolsHideMusicButtonKey,@"视频设置",@"video");
 add(@"移除视频位置",@"DYYYHideLocation",@"视频设置",@"video");
 NSArray *b=@[
 @[@"视频背景颜色",@"DYYYVideoBGColor"],@[@"启用弹幕改色",@"DYYYEnableDanmuColor"],@[@"自定弹幕颜色",@"DYYYDanmuColor"],@[@"设置默认倍速",@"DYYYDefaultSpeed"],@[@"设置长按倍速",@"DYYYLongPressSpeed"],@[@"上下控制倍速",@"DYYYEnableLongPressSpeedGesture"],@[@"显示进度时长",@"DYYYShowScheduleDisplay"],@[@"进度时长样式",@"DYYYScheduleStyle"],@[@"进度纵轴位置",@"DYYYTimelineVerticalPosition"],@[@"进度标签颜色",@"DYYYProgressLabelColor"],@[@"隐藏视频进度",@"DYYYHideVideoProgress"],@[@"启用自动播放",@"DYYYEnableAutoPlay"],@[@"忽略投屏 VPN 检测",@"DYYYDisableCastVPNCheck"],@[@"推荐过滤直播",@"DYYYSkipLive"],@[@"推荐过滤热点",@"DYYYSkipHotSpot"],@[@"推荐过滤低赞",@"DYYYFilterLowLikes"],@[@"推荐视频时限",@"DYYYFilterTimeLimit"],@[@"推荐过滤HDR",@"DYYYFilterFeedHDR"],@[@"启用首页净化",@"DYYYEnablePure"],@[@"启用首页全屏",@"DYYYEnableFullScreen"],@[@"启用屏蔽广告",@"DYYYNoAds"],@[@"屏蔽检测更新",@"DYYYNoUpdates"],@[@"去青少年弹窗",@"DYYYHideTeenMode"],@[@"评论区毛玻璃",@"DYYYEnableCommentBlur"],@[@"通知玻璃效果",@"DYYYEnableNotificationTransparency"],@[@"毛玻璃透明度",@"DYYYCommentBlurTransparent"],@[@"通知圆角半径",@"DYYYNotificationCornerRadius"],@[@"时间属地显示",@"DYYYEnableArea"],@[@"国外解析账号",@"DYYYGeonamesUsername"],@[@"时间标签颜色",@"DYYYLabelColor"],@[@"属地随机渐变",@"DYYYEnableRandomGradient"],@[@"隐藏系统顶栏",@"DYYYHideStatusbar"],@[@"关注二次确认",@"DYYYFollowTips"],@[@"收藏二次确认",@"DYYYCollectTips"],@[@"默认直播画质",@"DYYYLiveQuality"],@[@"提高视频画质",@"DYYYEnableVideoHighestQuality"],@[@"禁用直播PCDN功能",@"DYYYDisableLivePCDN"],@[@"评论具体时间",@"DYYYCommentExactTime"],@[@"屏蔽灵动岛抖音播放信息",@"DYYYDisableFeedNowPlayingInfo"]];
 for(NSArray*x in b)add(x[0],x[1],@"基本设置",@"basic");
 NSArray*t=@[@"推荐",@"DYYYHideHotContainer",@"朋友",@"DYYYHideFriend",@"关注",@"DYYYHideFollow",@"精选",@"DYYYHideMediumVideo",@"商城",@"DYYYHideMall",@"同城",@"DYYYHideNearby",@"团购",@"DYYYHideGroupon",@"直播",@"DYYYHideTabLive",@"热点",@"DYYYHidePadHot",@"经验",@"DYYYHideHangout",@"短剧",@"DYYYHidePlaylet",@"看剧",@"DYYYHideCinema",@"少儿",@"DYYYHideKidsV2",@"游戏",@"DYYYHideGame"];
 for(NSUInteger i=0;i+1<t.count;i+=2)add([NSString stringWithFormat:@"移除%@",t[i]],t[i+1],@"顶栏移除",@"top");
 NSArray*bt=@[@"商城",@"DYYYHideShopButton",@"双列入口",@"DYYYHideDoubleColumnEntry",@"消息",@"DYYYHideMessageButton",@"朋友",@"DYYYHideFriendsButton",@"我的",@"DYYYHideMyButton",@"加号",@"DYYYHidePlusButton",@"评论",@"DYYYHideComment",@"红点",@"DYYYHideBottomDot",@"背景",@"DYYYHideBottomBg",@"精简平板底栏",@"DYYYHidePadTabBarElements"];
 for(NSUInteger i=0;i+1<bt.count;i+=2)add([NSString stringWithFormat:@"隐藏底栏%@",bt[i]],bt[i+1],@"移除底栏",@"bottom");
 return a;
}


#pragma mark - DYYY Exact Comment Time + Dynamic Island Playback Info

@interface AWEDateTimeFormatter : NSObject
+ (id)formattedDateForTimestamp:(double)timestamp;
@end

%hook AWEDateTimeFormatter
+ (id)formattedDateForTimestamp:(double)timestamp {
    if (!DYToolsBool(@"DYYYCommentExactTime")) return %orig(timestamp);

    NSDateFormatter *formatter = [NSDateFormatter new];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    return [formatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:timestamp]];
}
%end

%hook AWERLVirtualLabel
- (void)setText:(NSString *)text {
    if (!DYToolsBool(@"DYYYCommentExactTime") || text.length == 0) {
        %orig(text);
        return;
    }

    NSError *error = nil;
    NSRegularExpression *regex =
        [NSRegularExpression regularExpressionWithPattern:@"^(\\d{10,13})([\\s\\S]*)"
                                                   options:0 error:&error];
    NSTextCheckingResult *match =
        [regex firstMatchInString:text options:0 range:NSMakeRange(0, text.length)];

    if (!match) {
        %orig(text);
        return;
    }

    NSString *rawTs = [text substringWithRange:[match rangeAtIndex:1]];
    NSString *suffix = [text substringWithRange:[match rangeAtIndex:2]];
    long long ts = rawTs.longLongValue;
    if (ts > 100000000000LL) ts /= 1000LL;

    NSDateFormatter *formatter = [NSDateFormatter new];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSString *dateText =
        [formatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:ts]];

    %orig([NSString stringWithFormat:@"%@%@", dateText, suffix]);
}
%end

@interface MPNowPlayingInfoCenter : NSObject
@property(nonatomic, copy) NSDictionary *nowPlayingInfo;
+ (instancetype)defaultCenter;
@end

static BOOL gDYToolsClearingNowPlaying = NO;
static CFTimeInterval gDYToolsLastNowPlayingClear = 0.0;

static void DYToolsClearNowPlayingInfo(void) {
    if (!DYToolsBool(@"DYYYDisableFeedNowPlayingInfo") || gDYToolsClearingNowPlaying) return;

    CFTimeInterval now = CFAbsoluteTimeGetCurrent();
    if (now - gDYToolsLastNowPlayingClear < 0.25) return;
    gDYToolsLastNowPlayingClear = now;

    Class cls = NSClassFromString(@"MPNowPlayingInfoCenter");
    if (!cls || ![cls respondsToSelector:@selector(defaultCenter)]) return;

    id center = ((id (*)(Class, SEL))objc_msgSend)(cls, @selector(defaultCenter));
    if (!center) return;

    gDYToolsClearingNowPlaying = YES;
    @try {
        if ([center respondsToSelector:@selector(setNowPlayingInfo:)]) {
            ((void (*)(id, SEL, id))objc_msgSend)(center, @selector(setNowPlayingInfo:), nil);
        }
        SEL playbackState = NSSelectorFromString(@"setPlaybackState:");
        if ([center respondsToSelector:playbackState]) {
            ((void (*)(id, SEL, NSInteger))objc_msgSend)(center, playbackState, 0);
        }
    } @catch (__unused NSException *e) {
    }
    gDYToolsClearingNowPlaying = NO;
}

%hook AWEAwemeBackgroundPlayModule
- (id)nowPlayingInfo {
    if (DYToolsBool(@"DYYYDisableFeedNowPlayingInfo")) {
        DYToolsClearNowPlayingInfo();
        return nil;
    }
    return %orig;
}
- (void)refreshNowPlayingInfoIfNeeded {
    if (DYToolsBool(@"DYYYDisableFeedNowPlayingInfo")) {
        DYToolsClearNowPlayingInfo();
        return;
    }
    %orig;
}
- (void)updateNowPlayingInfoPlayback {
    if (DYToolsBool(@"DYYYDisableFeedNowPlayingInfo")) {
        DYToolsClearNowPlayingInfo();
        return;
    }
    %orig;
}
%end

%hook AWEFeedBackgroundPlayManager
- (id)nowPlayingInfo {
    if (DYToolsBool(@"DYYYDisableFeedNowPlayingInfo")) {
        DYToolsClearNowPlayingInfo();
        return nil;
    }
    return %orig;
}
- (void)setNowPlayingInfo:(id)info {
    if (DYToolsBool(@"DYYYDisableFeedNowPlayingInfo")) {
        DYToolsClearNowPlayingInfo();
        return;
    }
    %orig(info);
}
- (void)resetNowPlayingInfo:(id)model {
    if (DYToolsBool(@"DYYYDisableFeedNowPlayingInfo")) {
        DYToolsClearNowPlayingInfo();
        return;
    }
    %orig(model);
}
- (void)refreshNowPlayingInfo {
    if (DYToolsBool(@"DYYYDisableFeedNowPlayingInfo")) {
        DYToolsClearNowPlayingInfo();
        return;
    }
    %orig;
}
- (void)updateNowPlayingInfoPlayback {
    if (DYToolsBool(@"DYYYDisableFeedNowPlayingInfo")) {
        DYToolsClearNowPlayingInfo();
        return;
    }
    %orig;
}
%end

%hook AWENowPlayingInfoCenter
- (void)becomePlayingPlayer:(id)player {
    if (DYToolsBool(@"DYYYDisableFeedNowPlayingInfo")) {
        DYToolsClearNowPlayingInfo();
        return;
    }
    %orig(player);
}
- (void)setNowPlayingInfo:(id)info {
    if (DYToolsBool(@"DYYYDisableFeedNowPlayingInfo")) {
        DYToolsClearNowPlayingInfo();
        return;
    }
    %orig(info);
}
- (void)refreshNowPlayingInfo {
    if (DYToolsBool(@"DYYYDisableFeedNowPlayingInfo")) {
        DYToolsClearNowPlayingInfo();
        return;
    }
    %orig;
}
%end

%hook MPNowPlayingInfoCenter
- (void)setNowPlayingInfo:(NSDictionary *)info {
    if (DYToolsBool(@"DYYYDisableFeedNowPlayingInfo") && !gDYToolsClearingNowPlaying) {
        %orig(nil);
        return;
    }
    %orig(info);
}
- (void)setPlaybackState:(NSInteger)state {
    if (DYToolsBool(@"DYYYDisableFeedNowPlayingInfo") && !gDYToolsClearingNowPlaying) {
        %orig(0);
        return;
    }
    %orig(state);
}
%end

#pragma mark - DYYY Basic Visual Effects

%hook AWEBaseListViewController
- (void)viewDidLayoutSubviews {
    %orig;
    if (!DYToolsBool(@"DYYYEnableCommentBlur")) return;
    if (![self isKindOfClass:NSClassFromString(@"AWECommentPanelContainerSwiftImpl.CommentContainerInnerViewController")]) return;

    UIView *view = self.view;
    if (!view) return;
    NSInteger tag = 190721;
    UIVisualEffectView *blur = [view viewWithTag:tag];
    if (!blur) {
        UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleSystemMaterial];
        blur = [[UIVisualEffectView alloc] initWithEffect:effect];
        blur.tag = tag;
        blur.userInteractionEnabled = NO;
        blur.frame = view.bounds;
        blur.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [view insertSubview:blur atIndex:0];
    }
    CGFloat alpha = [[NSUserDefaults standardUserDefaults] floatForKey:@"DYYYCommentBlurTransparent"];
    if (alpha <= 0.0 || alpha > 1.0) alpha = 0.9;
    blur.alpha = alpha;
}
%end

%hook AWEInnerNotificationWindow
- (void)layoutSubviews {
    %orig;
    if (!DYToolsBool(@"DYYYEnableNotificationTransparency")) return;

    UIView *container = nil;
    for (UIView *v in self.subviews) {
        if ([NSStringFromClass(v.class) containsString:@"AWEInnerNotificationContainerView"]) {
            container = v;
            break;
        }
    }
    if (!container) return;

    NSInteger tag = 190722;
    UIVisualEffectView *blur = [container viewWithTag:tag];
    if (!blur) {
        UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleSystemMaterial];
        blur = [[UIVisualEffectView alloc] initWithEffect:effect];
        blur.tag = tag;
        blur.userInteractionEnabled = NO;
        blur.frame = container.bounds;
        blur.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [container insertSubview:blur atIndex:0];
    }

    CGFloat radius = [[NSUserDefaults standardUserDefaults] floatForKey:@"DYYYNotificationCornerRadius"];
    if (radius <= 0.0 || radius > 50.0) radius = 12.0;
    container.layer.cornerRadius = radius;
    container.layer.masksToBounds = YES;
    blur.layer.cornerRadius = radius;
    blur.layer.masksToBounds = YES;
}
%end

static void DYToolsPresentControlPanel(void) {
    dispatch_async(dispatch_get_main_queue(), ^{
        UIViewController *presenter = DYToolsTopViewController();
        if (!presenter) return;
        if ([presenter isKindOfClass:[DYToolsControlViewController class]]) return;

        DYToolsControlViewController *panel = [DYToolsControlViewController new];
        UINavigationController *nav =
            [[UINavigationController alloc] initWithRootViewController:panel];

        nav.modalPresentationStyle = UIModalPresentationPageSheet;

        if (@available(iOS 15.0, *)) {
            UISheetPresentationController *sheet = nav.sheetPresentationController;
            sheet.detents = @[
                [UISheetPresentationControllerDetent mediumDetent],
                [UISheetPresentationControllerDetent largeDetent]
            ];
            sheet.prefersGrabberVisible = YES;
        }

        [presenter presentViewController:nav animated:YES completion:nil];
    });
}

static AWESettingItemModel *DYToolsMakeEntryItem(void) {
    Class itemClass = NSClassFromString(@"AWESettingItemModel");
    if (!itemClass) return nil;

    AWESettingItemModel *item = [itemClass new];
    item.identifier = @"DYToolsControlPanel";
    item.title = @"DY-tools";
    item.subTitle = @"插件控制面板";
    item.detail = @"1.0";

    // 同时设置两套抖音设置项图标字段，兼容不同 40.x 设置 Cell。
    item.iconImageName = @"ic_gearsimplify_outlined_20";
    item.svgIconImageName = @"ic_gearsimplify_outlined_20";

    item.cellType = 26;
    item.colorStyle = 0;
    item.isEnable = YES;
    item.isSwitchOn = NO;
    item.cellTappedBlock = ^{
        DYToolsPresentControlPanel();
    };
    return item;
}

%hook AWESettingsViewModel
- (NSArray *)sectionDataArray {
    NSArray *sections = %orig;
    if (![sections isKindOfClass:NSArray.class]) return sections;

    for (id section in sections) {
        NSArray *items = nil;
        @try { items = [section valueForKey:@"itemArray"]; } @catch (__unused NSException *e) {}
        for (id item in items) {
            NSString *identifier = nil;
            @try { identifier = [item valueForKey:@"identifier"]; } @catch (__unused NSException *e) {}
            if ([identifier isEqualToString:@"DYToolsControlPanel"]) return sections;
        }
    }

    AWESettingItemModel *entry = DYToolsMakeEntryItem();
    Class sectionClass = NSClassFromString(@"AWESettingSectionModel");
    if (!entry || !sectionClass) return sections;

    AWESettingSectionModel *section = [sectionClass new];
    section.sectionHeaderTitle = @"DY-tools";
    section.sectionHeaderHeight = 40.0;
    section.sectionFooterTitle = @"";
    section.type = 0;
    section.itemArray = @[entry];

    NSMutableArray *result = [sections mutableCopy];
    if (!result) result = [NSMutableArray array];
    [result insertObject:section atIndex:0];
    return [result copy];
}
%end

#pragma mark - Author profile comment bar removal

@interface AWEAwemeDetailTableViewController : UIViewController
@property(nonatomic,copy) NSString *referString;
- (BOOL)canShowFixedBottomBar;
- (void)setBottomBarHidden:(BOOL)hidden;
@end

static BOOL DYFSShouldHideDetailBottomBar(void) {
    return DYFSIsEnabled();
}

static BOOL DYFSIsAuthorWorkDetailContext(UIView *view) {
    if (!view) return NO;
    UIResponder *r = view;
    NSInteger depth = 0;
    while ((r = [r nextResponder]) && depth++ < 40) {
        NSString *name = NSStringFromClass(r.class);
        if ([name containsString:@"UserHome"] ||
            [name containsString:@"UserProfile"] ||
            [name containsString:@"ProfileViewController"] ||
            [name containsString:@"Personal"] ||
            [name containsString:@"AWEAwemeDetailCellViewController"]) {
            return YES;
        }
    }
    return NO;
}

%hook AWEAwemeDetailTableViewController
- (BOOL)canShowFixedBottomBar {
    if (DYFSShouldHideDetailBottomBar()) return NO;
    return %orig;
}

- (void)setBottomBarHidden:(BOOL)hidden {
    if (DYFSShouldHideDetailBottomBar()) hidden = YES;
    %orig(hidden);
}

- (void)viewDidLayoutSubviews {
    %orig;
    if (DYFSShouldHideDetailBottomBar() &&
        [self respondsToSelector:@selector(setBottomBarHidden:)]) {
        [self setBottomBarHidden:YES];
    }
}
%end

@interface AWEAwemeIMDetailTableViewController : UIViewController
- (void)setBottomBarHidden:(BOOL)hidden;
@end
%hook AWEAwemeIMDetailTableViewController
- (void)setBottomBarHidden:(BOOL)hidden {
    if (DYFSShouldHideDetailBottomBar()) hidden = YES;
    %orig(hidden);
}
%end

%ctor {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults objectForKey:kDYFSFullScreenEnabledKey] == nil) {
        [defaults setBool:NO forKey:kDYFSFullScreenEnabledKey];
        [defaults synchronize];
    }

    %init(_ungrouped);

    if (!gDYFSStretchedTables) {
        gDYFSStretchedTables = [NSHashTable weakObjectsHashTable];
    }
    DYFSRegisterRestore(DYFSRestoreFeedTables);

    NSLog(@"[DY-FullScreen] loaded, fullscreen=%@", DYFSIsEnabled() ? @"ON" : @"OFF");
}