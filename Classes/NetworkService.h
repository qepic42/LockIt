//
//  NetworkService.h
//  LockIt
//
//  Created by Q on 02.10.10.
//  Copyright 2010 PQ-Developing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RootView.h"


@class RootView;
@interface NetworkService : NSObject <NSNetServiceDelegate, NSNetServiceBrowserDelegate> {
	NSNetServiceBrowser *serviceBrowser;
	NSMutableData *response;
    NSMutableArray *dataArray;
    NSMutableArray *deviceInfo;
    NSDictionary *deviceInfoDict;
    NSNetService *otherSender;
    NSURLConnection *connection;
	
    RootView *root;
}
@property (nonatomic, retain) NSMutableData *response;
@property (nonatomic,retain)NSNetService *otherSender;
@property (retain) NSMutableArray *dataArray;

@end
