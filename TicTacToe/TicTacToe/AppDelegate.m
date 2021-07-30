//
//  AppDelegate.m
//  TicTacToe
//
//  Created by Rona Wang on 30/7/21.
//

#import "AppDelegate.h"
#import "TTTViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    TTTViewController *vc = [[TTTViewController alloc] init];
    
    self.window.rootViewController = vc;
    
    self.window.backgroundColor = [UIColor blackColor];
    [self.window makeKeyAndVisible];
    return YES;
}

@end
