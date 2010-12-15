//
//  lockItAppDelegate.m
//  lockIt
//
//  Created by Q on 14.10.10.
//  Copyright (c) 2010 PQ-Developing. All rights reserved.
//


#import "lockItAppDelegate.h"
#import "HTTPServer.h"
#import "LockItHTTPConnection.h"
#import "NetworkService.h"
#import "RootView.h"
#import "DataModel.h"

@implementation lockItAppDelegate


@synthesize window;

@synthesize navigationController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
	
    dataModel = [[DataModel alloc]init];
	netService = [[NetworkService alloc]init];
    
    NSString *root = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES) objectAtIndex:0];
	
	httpServer = [HTTPServer new];
	[httpServer setType:@"_lockitiphone._tcp."];
    [httpServer setConnectionClass:[LockItHTTPConnection class]];
	[httpServer setDocumentRoot:[NSURL fileURLWithPath:root]];
	
    NSError *error;
    if(![httpServer start:&error])
    {
        NSLog(@"Error starting HTTP Server: %@", error);
    }else{
		// NSLog(@"Server started without errors");
    }
	
	rootView = [[RootView alloc] init];
 //   navController = rootView; 
    navController = [[UINavigationController alloc]
                                              initWithRootViewController:rootView];
	
    [window addSubview:navController.view];
    [window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillTerminate:(UIApplication *)application {

    // Save data if appropriate.
}

- (void)dealloc {
    [httpServer stop];
    [httpServer release];
    [dataModel release];
    [rootView release];
    [navController release];
    [window release];
    [netService release];
    [navigationController release];
    [super dealloc];
}

@end

