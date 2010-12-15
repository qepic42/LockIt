//
//  LockItServerSetup.m
//  LockIt
//
//  Created by Q on 02.10.10.
//  Copyright 2010 PQ-Developing. All rights reserved.
//

#import "LockItServerSetup.h"
#import "HTTPServer.h"
#import "LockItHTTPConnection.h"

@implementation LockItServerSetup

- (id) init
{
	self = [super init];
	if (self != nil) {
		[self setupServer];	}
	return self;
}

- (void)setupServer{
	
	NSLog(@"Setup HTTPServer");
	
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
		NSLog(@"Server started");
	}
}

- (void) dealloc
{
	[httpServer stop];
	
	[httpServer release];
	[super dealloc];
}


@end
