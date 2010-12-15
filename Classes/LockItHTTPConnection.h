//
//  LockItHTTPConnection.h
//  LockIt
//
//  Created by Q on 02.10.10.
//  Copyright 2010 PQ-Developing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HTTPConnection.h"

@interface LockItHTTPConnection : HTTPConnection {
	int dataStartIndex;
	NSMutableArray* multipartData;
	BOOL postHeaderOK;
    NSString *commandString;
}

@property (nonatomic,retain)NSString *commandString;

- (BOOL)isBrowseable:(NSString *)path;
- (NSString *)createBrowseableIndex:(NSString *)path;
- (void)sendCommands:(NSNotification *)notification;
- (BOOL)supportsPOST:(NSString *)path withSize:(UInt64)contentLength;


@end
