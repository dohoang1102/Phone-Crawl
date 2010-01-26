//
//  Phone_CrawlAppDelegate.h
//  Phone-Crawl
//
//  Created by Austin Kelley on 1/12/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HomeTabViewController;
@class MainMenu;

@interface Phone_CrawlAppDelegate : NSObject <UIApplicationDelegate, UITabBarControllerDelegate> {
    UIWindow *window;

	MainMenu *mainMenu;
	HomeTabViewController *homeTabController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain) HomeTabViewController *homeTabController;
@property (nonatomic, retain) MainMenu *mainMenu;

@end
