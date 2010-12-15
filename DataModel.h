//
//  DataModel.h
//  LockIt for Mac
//
//  Created by Q on 13.11.10.
//  Copyright (c) 2010 PQ-Developing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "LockItHTTPConnection.h"

@interface DataModel : NSObject {
    NSMutableArray *dataArray;
    NSMutableArray *searchArray;
    NSMutableData *response;
    NSDictionary *devInfoDict;
    NSDictionary *currentDict;
    
    NSURLConnection *connection;
    LockItHTTPConnection *lockCon;
    
}

@property (nonatomic, retain) NSMutableData *response;
@property (retain, nonatomic) NSMutableArray *dataArray;
@property (retain,nonatomic) NSMutableArray *searchArray;
@property (retain,nonatomic) NSDictionary *devInfoDict;

-(void)addDevice:(NSNotification *)notification;
-(void)removeDevice:(NSNotification *)notification;
-(void)getDeviceFromUUID:(NSNotification *)notification;
-(void)sendAllClients:(NSNotification *)notification;

@end
