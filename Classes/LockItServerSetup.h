//
//  LockItServerSetup.h
//  LockIt
//
//  Created by Q on 02.10.10.
//  Copyright 2010 PQ-Developing. All rights reserved.
//

#import <Foundation/Foundation.h>

@class   HTTPServer;
@interface LockItServerSetup : NSObject {
	HTTPServer *httpServer;
}

- (void)setupServer;

@end
