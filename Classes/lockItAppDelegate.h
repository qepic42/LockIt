//
//  lockItAppDelegate.h
//  lockIt
//
//  Created by Q on 14.10.10.
//  Copyright (c) 2010 PQ-Developing. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "NetworkService.h"
#import "RootView.h"
#import "DataModel.h"

@class   HTTPServer;
@interface lockItAppDelegate : NSObject <UIApplicationDelegate> {
    NetworkService *netService;
	HTTPServer *httpServer;
    RootView *rootView;
    DataModel *dataModel;
    
    UIWindow *window;
    UINavigationController *navigationController;
    UINavigationController* navController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;


@property (nonatomic, retain) IBOutlet UINavigationController *navigationController;
@end

