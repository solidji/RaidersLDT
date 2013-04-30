//
//  GHAppDelegate.m
//  GHSidebarNav
//
//  Created by Greg Haines on 11/20/11.
//

#import "GHAppDelegate.h"
#import "GHMenuCell.h"
#import "GHMenuViewController.h"
#import "GHRootViewController.h"
#import "GHRevealViewController.h"
#import "GHSidebarSearchViewController.h"
#import "GHSidebarSearchViewControllerDelegate.h"
#import "iVersion.h"
#import "APService.h"
#import <ShareSDK/ShareSDK.h>

#define kReviewTrollerRunCountDefault @"kReviewTrollerRunCountDefault"
#define kReviewTrollerDoneDefault @"kReviewTrollerDoneDefault"

#pragma mark -
#pragma mark Private Interface
@interface GHAppDelegate () <GHSidebarSearchViewControllerDelegate>
@property (nonatomic, strong) GHRevealViewController *revealController;
@property (nonatomic, strong) GHSidebarSearchViewController *searchController;
@property (nonatomic, strong) GHMenuViewController *menuController;

@property (nonatomic, strong) NSDictionary *pushInfo;
@end


#pragma mark -
#pragma mark Implementation
@implementation GHAppDelegate

#pragma mark Properties
@synthesize window;
@synthesize revealController, searchController, menuController;
@synthesize pushInfo;

#pragma mark UIApplicationDelegate
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    //ShareSDK
    [ShareSDK registerApp:@"10aa36d1da8"];
    //添加新浪微博应用
    [ShareSDK connectSinaWeiboWithAppKey:@"547995002"
                               appSecret:@"30fbe3db6456c9b73d6d8734f5ac4282"
                             redirectUri:@"http://www.appgame.com"];
    
    //添加腾讯微博应用
    [ShareSDK connectTencentWeiboWithAppKey:@"801350131"
                                  appSecret:@"791f5dc6308e63c0d87e8ab133fb9b54" redirectUri:@"http://www.appgame.com"];
    
    // jpush
    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    
    [defaultCenter addObserver:self selector:@selector(networkDidSetup:) name:kAPNetworkDidSetupNotification object:nil];
    [defaultCenter addObserver:self selector:@selector(networkDidClose:) name:kAPNetworkDidCloseNotification object:nil];
    [defaultCenter addObserver:self selector:@selector(networkDidRegister:) name:kAPNetworkDidRegisterNotification object:nil];
    [defaultCenter addObserver:self selector:@selector(networkDidLogin:) name:kAPNetworkDidLoginNotification object:nil];
    [defaultCenter addObserver:self selector:@selector(networkDidReceiveMessage:) name:kAPNetworkDidReceiveMessageNotification object:nil];
    
    //[[UIApplication sharedApplication] unregisterForRemoteNotifications];
    //NSLog(@"openuuid:%@",[APService openUDID]);
    //if ([application enabledRemoteNotificationTypes] == 0) {
    //if ([APService openUDID] == nil) {
    [APService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                   UIRemoteNotificationTypeSound |
                                                   UIRemoteNotificationTypeAlert)];
    //}
    [APService setupWithOption:launchOptions];
    //[APService setTags:[NSSet setWithObjects:@"tag1", @"tag2", @"tag3", nil] alias:@"别名"];
    
    //提示评分
    NSUserDefaults *standardDefaults = [NSUserDefaults standardUserDefaults];
    NSInteger numberOfExecutions = [standardDefaults integerForKey:kReviewTrollerRunCountDefault] + 1;
    BOOL reviewDone = [standardDefaults integerForKey:kReviewTrollerDoneDefault];
    [standardDefaults setInteger:numberOfExecutions forKey:kReviewTrollerRunCountDefault];
    [standardDefaults synchronize];
    //每运行20次提示评分,如果已经按过yes则不在提示
    if (numberOfExecutions % 50 == 0 && !reviewDone) {
        NSString *title = @"给我们评分";
        NSString *message = @"您的好评将激励我们做的更好.";
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title
                                                            message:message
                                                           delegate:self
                                                  cancelButtonTitle:NSLocalizedString(@"不", Nil)
                                                  otherButtonTitles:NSLocalizedString(@"好", Nil), Nil];
        alertView.tag = 101;
        [alertView show];
    }
    
    //iVersion 更新检测
    [iVersion sharedInstance].appStoreID = 642821803;
    

    //初始化
	[[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackOpaque animated:NO];
	
	//UIColor *bgColor = [UIColor colorWithRed:(206.0f/255.0f) green:(196.0f/255.0f) blue:(184.0f/255.0f) alpha:1.0f];
	self.revealController = [[GHRevealViewController alloc] initWithNibName:nil bundle:nil];
	//self.revealController.view.backgroundColor = bgColor;
    self.revealController.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Background.png"]];
	RevealBlock revealBlock = ^(){
		[self.revealController toggleSidebar:!self.revealController.sidebarShowing 
									duration:kGHRevealSidebarDefaultAnimationDuration];
	};
    
	NSArray *headers = @[
          @"",
          @""
          ];
	NSArray *controllers = @[
        @[
            [[UINavigationController alloc] initWithRootViewController:[[GHRootViewController alloc] initWithTitle:@"攻略For乱斗堂" withUrl:@"http://ldt.appgame.com/" withRevealBlock:revealBlock]]
        ],
		@[
			[[UINavigationController alloc] initWithRootViewController:[[GHRootViewController alloc] initWithTitle:@"快速升级&赚钱" withUrl:@"http://wz.appgame.com/category/shenjizuanqian" withRevealBlock:revealBlock]],
			[[UINavigationController alloc] initWithRootViewController:[[GHRootViewController alloc] initWithTitle:@"常见问题" withUrl:@"http://wz.appgame.com/category/faq" withRevealBlock:revealBlock]],
			[[UINavigationController alloc] initWithRootViewController:[[GHRootViewController alloc] initWithTitle:@"精灵系统" withUrl:@"http://wz.appgame.com/category/system/angel" withRevealBlock:revealBlock]],
            [[UINavigationController alloc] initWithRootViewController:[[GHRootViewController alloc] initWithTitle:@"星座系统" withUrl:@"http://wz.appgame.com/category/system/stars" withRevealBlock:revealBlock]],
            [[UINavigationController alloc] initWithRootViewController:[[GHRootViewController alloc] initWithTitle:@"宝石系统" withUrl:@"http://wz.appgame.com/category/system/baoshi" withRevealBlock:revealBlock]],
            [[UINavigationController alloc] initWithRootViewController:[[GHRootViewController alloc] initWithTitle:@"天使系统" withUrl:@"http://wz.appgame.com/category/system/shenling" withRevealBlock:revealBlock]],
            [[UINavigationController alloc] initWithRootViewController:[[GHRootViewController alloc] initWithTitle:@"刺客攻略" withUrl:@"http://wz.appgame.com/category/vocation-strategy/cike" withRevealBlock:revealBlock]],
			[[UINavigationController alloc] initWithRootViewController:[[GHRootViewController alloc] initWithTitle:@"法师攻略" withUrl:@"hhttp://wz.appgame.com/category/vocation-strategy/fashi" withRevealBlock:revealBlock]],
            [[UINavigationController alloc] initWithRootViewController:[[GHRootViewController alloc] initWithTitle:@"战士攻略" withUrl:@"http://wz.appgame.com/category/vocation-strategy/zhanshi" withRevealBlock:revealBlock]],
            [[UINavigationController alloc] initWithRootViewController:[[GHRootViewController alloc] initWithTitle:@"副本攻略" withUrl:@"http://wz.appgame.com/category/fuben-strategy" withRevealBlock:revealBlock]],
            [[UINavigationController alloc] initWithRootViewController:[[GHRootViewController alloc] initWithTitle:@"竞技场攻略" withUrl:@"http://wz.appgame.com/category/pvp" withRevealBlock:revealBlock]],
            [[UINavigationController alloc] initWithRootViewController:[[GHRootViewController alloc] initWithTitle:@"精彩视频" withUrl:@"http://wz.appgame.com/category/media/video" withRevealBlock:revealBlock]]
		]
	];
    /*
     我叫MT online 客户端左侧导航的分类和链接地址
     
     首页：http://mt.appgame.com/
     英雄图鉴：http://mt.appgame.com/heroes-profile
     副本攻略：http://mt.appgame.com/instance
     新手指南：http://mt.appgame.com/new-player-guide
     高手进阶：http://mt.appgame.com/master-road
     PVP对战：http://mt.appgame.com/pvp
     常见问题：http://mt.appgame.com/faq
     玩家交流：http://mt.appgame.com/bbs
     */
	NSArray *cellInfos = @[
		@[
            @{kSidebarCellImageKey: @"Unified.png", kSidebarCellTextKey: NSLocalizedString(@"首页", @"")}
        ],
		@[
			@{kSidebarCellImageKey: @"Unified.png", kSidebarCellTextKey: NSLocalizedString(@"快速升级&赚钱", @"")},
			@{kSidebarCellImageKey: @"Unified.png", kSidebarCellTextKey: NSLocalizedString(@"常见问题", @"")},
			@{kSidebarCellImageKey: @"Unified.png", kSidebarCellTextKey: NSLocalizedString(@"精灵系统", @"")},
            @{kSidebarCellImageKey: @"Unified.png", kSidebarCellTextKey: NSLocalizedString(@"星座系统", @"")},
            @{kSidebarCellImageKey: @"Unified.png", kSidebarCellTextKey: NSLocalizedString(@"宝石系统", @"")},
            @{kSidebarCellImageKey: @"Unified.png", kSidebarCellTextKey: NSLocalizedString(@"天使系统", @"")},
            @{kSidebarCellImageKey: @"Unified.png", kSidebarCellTextKey: NSLocalizedString(@"刺客攻略", @"")},
			@{kSidebarCellImageKey: @"Unified.png", kSidebarCellTextKey: NSLocalizedString(@"法师攻略", @"")},
            @{kSidebarCellImageKey: @"Unified.png", kSidebarCellTextKey: NSLocalizedString(@"战士攻略", @"")},
            @{kSidebarCellImageKey: @"Unified.png", kSidebarCellTextKey: NSLocalizedString(@"副本攻略", @"")},
            @{kSidebarCellImageKey: @"Unified.png", kSidebarCellTextKey: NSLocalizedString(@"竞技场攻略", @"")},
            @{kSidebarCellImageKey: @"Unified.png", kSidebarCellTextKey: NSLocalizedString(@"精彩视频", @"")}
		]
	];
	
	// Add drag feature to each root navigation controller
	[controllers enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop){
		[((NSArray *)obj) enumerateObjectsUsingBlock:^(id obj2, NSUInteger idx2, BOOL *stop2){
			UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self.revealController 
																						 action:@selector(dragContentView:)];
			panGesture.cancelsTouchesInView = YES;
			//[((UINavigationController *)obj2).navigationBar addGestureRecognizer:panGesture];
            [((UINavigationController *)obj2).view addGestureRecognizer:panGesture];
		}];
	}];
	
	self.searchController = [[GHSidebarSearchViewController alloc] initWithSidebarViewController:self.revealController];
	self.searchController.view.backgroundColor = [UIColor clearColor];
    self.searchController.searchDelegate = self;
	self.searchController.searchBar.autocapitalizationType = UITextAutocapitalizationTypeNone;
	self.searchController.searchBar.autocorrectionType = UITextAutocorrectionTypeNo;
	self.searchController.searchBar.backgroundImage = [UIImage imageNamed:@"searchBarBG.png"];
	self.searchController.searchBar.placeholder = NSLocalizedString(@"Search", @"");
	self.searchController.searchBar.tintColor = [UIColor colorWithRed:(58.0f/255.0f) green:(67.0f/255.0f) blue:(104.0f/255.0f) alpha:1.0f];
	for (UIView *subview in self.searchController.searchBar.subviews) {
		if ([subview isKindOfClass:[UITextField class]]) {
			UITextField *searchTextField = (UITextField *) subview;
			searchTextField.textColor = [UIColor colorWithRed:(154.0f/255.0f) green:(162.0f/255.0f) blue:(176.0f/255.0f) alpha:1.0f];
		}
	}
	[self.searchController.searchBar setSearchFieldBackgroundImage:[[UIImage imageNamed:@"searchTextBG.png"] 
																		resizableImageWithCapInsets:UIEdgeInsetsMake(16.0f, 17.0f, 16.0f, 17.0f)]	
														  forState:UIControlStateNormal];
	[self.searchController.searchBar setImage:[UIImage imageNamed:@"searchBarIcon.png"] 
							 forSearchBarIcon:UISearchBarIconSearch 
										state:UIControlStateNormal];
	
	self.menuController = [[GHMenuViewController alloc] initWithSidebarViewController:self.revealController 
																		withSearchBar:self.searchController.searchBar 
																		  withHeaders:headers 
																	  withControllers:controllers 
																		withCellInfos:cellInfos];
    
    //处理程序通过推送通知来启动时的情况
    NSDictionary *remoteNotif = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    if(remoteNotif)
    {
        //Handle remote notification
        [self performSelector:@selector(launchNotification:) withObject:remoteNotif afterDelay:1.0];
    }
	
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.rootViewController = self.revealController;
    [self.window makeKeyAndVisible];
    
    [NSThread sleepForTimeInterval:1];
	// Make this interesting.
    UIImageView *splashView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    splashView.image = [UIImage imageNamed:@"Default.png"];
    [self.window addSubview:splashView];
    [self.window bringSubviewToFront:splashView];
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:1.0f];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationTransition:UIViewAnimationTransitionNone forView: self.window cache:YES];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(startupAnimationDone:finished:context:)];
    splashView.alpha = 0.0f;
    splashView.frame = CGRectMake(-60, -85, 440, 635);
    [UIView commitAnimations];
    
    return YES;
}

#pragma mark GHSidebarSearchViewControllerDelegate
- (void)searchResultsForText:(NSString *)text withScope:(NSString *)scope callback:(SearchResultsBlock)callback {
	callback(@[@"现代战争4", @"MC4", @"HOC"]);
}

- (void)searchResult:(id)result selectedAtIndexPath:(NSIndexPath *)indexPath {
	NSLog(@"Selected Search Result - result: %@ indexPath: %@", result, indexPath);
}

- (UITableViewCell *)searchResultCellForEntry:(id)entry atIndexPath:(NSIndexPath *)indexPath inTableView:(UITableView *)tableView {
	static NSString* identifier = @"GHSearchMenuCell";
	GHMenuCell* cell = [tableView dequeueReusableCellWithIdentifier:identifier];
	if (!cell) {
		cell = [[GHMenuCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
	}
	cell.textLabel.text = (NSString *)entry;
	cell.imageView.image = [UIImage imageNamed:@"user"];
	return cell;
}

#pragma mark AlertViewDelegate
- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == 101) {
        if (buttonIndex == 1) {
            NSUserDefaults *standardDefaults = [NSUserDefaults standardUserDefaults];
            
            [standardDefaults setBool:YES forKey:kReviewTrollerDoneDefault];
            [standardDefaults synchronize];
            
            NSString *appId = @"642821803";
            
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=%@", appId]]];
        }else {
            NSUserDefaults *standardDefaults = [NSUserDefaults standardUserDefaults];
            
            [standardDefaults setBool:NO forKey:kReviewTrollerDoneDefault];
            [standardDefaults synchronize];
            
        }
    }else if (alertView.tag == 100)//运行状态下收到推送通知,进行询问
    {
        if (buttonIndex == 1){
            [self performSelector:@selector(launchNotification:) withObject:pushInfo afterDelay:1.0];
        }
    }
}
#pragma mark UIApplicationDelegate JPush
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    // Required
    [APService registerDeviceToken:deviceToken];
}

- (void)launchNotification:(NSDictionary *)userInfo
{
    NSLog(@"launchNotification");//仅在程序关闭时收到推送被调用
    NSString *urlField = [userInfo valueForKey:@"url"]; //自定义参数，key是自己定义的
    if (urlField != nil) {
        RevealBlock revealBlock = ^(){
            [self.revealController toggleSidebar:!self.revealController.sidebarShowing
                                        duration:kGHRevealSidebarDefaultAnimationDuration];
        };
        UINavigationController *pushViewController = [[UINavigationController alloc] initWithRootViewController:[[GHRootViewController alloc] initWithTitle:@"消息页面" withUrl:urlField withRevealBlock:revealBlock]];
        self.revealController.contentViewController = pushViewController;//设置默认页面
        
        UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self.revealController
                                                                                     action:@selector(dragContentView:)];
        panGesture.cancelsTouchesInView = YES;
        //[((UINavigationController *)obj2).navigationBar addGestureRecognizer:panGesture];
        [pushViewController.view addGestureRecognizer:panGesture];
    }
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    NSLog(@"didReceiveRemoteNotification");//仅在前台运行时收到推送 或 后台收到推送按下显示按钮打开时才被调用
    
    // 取得 APNs 标准信息内容
    pushInfo = userInfo;
    NSDictionary *aps = [userInfo valueForKey:@"aps"];
    NSString *content = [aps valueForKey:@"alert"]; //推送显示的内容
    NSInteger badge = [[aps valueForKey:@"badge"] integerValue]; //badge数量
    NSString *sound = [aps valueForKey:@"sound"]; //播放的声音
    
    // 取得自定义字段内容
    NSString *urlField = [userInfo valueForKey:@"url"]; //自定义参数，key是自己定义的
    NSLog(@"content=[%@], badge=[%d], sound=[%@], urlField=[%@]",content,badge,sound,urlField);
    
    // Required
    [APService handleRemoteNotification:userInfo];
    
    UIApplicationState appState = [[UIApplication sharedApplication] applicationState];
    if(appState == UIApplicationStateInactive){
        //NSLog(@"程序在锁屏与后台状态");
        //[self launchNotification:userInfo];
        [self performSelector:@selector(launchNotification:) withObject:userInfo afterDelay:1.0];
    }
    else if(appState == UIApplicationStateBackground)
    {
        //NSLog(@"程序在后台状态");
        [self performSelector:@selector(launchNotification:) withObject:userInfo afterDelay:1.0];
    }
    else if(appState == UIApplicationStateActive)
    {
        //NSLog(@"程序在运行状态");
        NSString *title = @"最新消息";
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title
                                                            message:content
                                                           delegate:self
                                                  cancelButtonTitle:NSLocalizedString(@"忽略", Nil)
                                                  otherButtonTitles:NSLocalizedString(@"查看", Nil), Nil];
        alertView.tag = 100;
        [alertView show];
    }
    
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    [application setApplicationIconBadgeNumber:0];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    NSLog(@"TYPESSSSSS: %d", [application enabledRemoteNotificationTypes]);
    
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *) error {
    NSLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
}

#pragma mark -

- (void)networkDidSetup:(NSNotification *)notification {
    NSLog(@"已连接");
}

- (void)networkDidClose:(NSNotification *)notification {
    NSLog(@"未连接。。。");
}

- (void)networkDidRegister:(NSNotification *)notification {
    NSLog(@"已注册");
}

- (void)networkDidLogin:(NSNotification *)notification {
    NSLog(@"已登录");
}

- (void)networkDidReceiveMessage:(NSNotification *)notification {
    NSDictionary * userInfo = [notification userInfo];
    
    NSString *title = [userInfo valueForKey:@"title"];
    NSString *content = [userInfo valueForKey:@"content"];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
    pushInfo = userInfo;
    NSLog(@"收到消息\ndate:%@\ntitle:%@\ncontent:%@", [dateFormatter stringFromDate:[NSDate date]],title,content);
}

- (BOOL)application:(UIApplication *)application
      handleOpenURL:(NSURL *)url
{
    return [ShareSDK handleOpenURL:url
                        wxDelegate:nil];
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    return [ShareSDK handleOpenURL:url
                 sourceApplication:sourceApplication
                        annotation:annotation
                        wxDelegate:nil];
}

@end
