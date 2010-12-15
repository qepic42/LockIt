//
//  DataModel.m
//  LockIt for Mac
//
//  Created by Q on 13.11.10.
//  Copyright (c) 2010 PQ-Developing. All rights reserved.
//

#import "DataModel.h"
#import "LockItHTTPConnection.h"

@implementation DataModel
@synthesize dataArray, response, devInfoDict, searchArray;


- (id)init {
    if ((self = [super init])) {
        // Initialization code here.
        
        self.dataArray = [[NSMutableArray alloc]init];
        
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(addDevice:)
                                                     name:@"addDevice"
                                                   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(removeDevice:)
                                                     name:@"removeDevice"
                                                   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(getDeviceFromUUID:)
                                                     name:@"getDeviceFromUUID"
                                                   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(sendAllClients:)
                                                     name:@"getAllClients"
                                                   object:nil];
        
    }
    
    return self;
}

- (void)addDevice:(NSNotification *)notification{
    
    NSDictionary *deviceInfoDict = [notification userInfo];
    
    [self.dataArray addObject:deviceInfoDict];
    
    [self sendAllClients:nil];
}

-(void)removeDevice:(NSNotification *)notification{
    
    NSDictionary *deviceInfoDict = [notification userInfo];
    
    currentDict = [[NSDictionary alloc]init];
    
    NSInteger position = 0;
    
    for(currentDict in self.dataArray){
        
        if([[currentDict objectForKey:@"deviceName"] isEqualToString:[deviceInfoDict objectForKey:@"deviceName"]]){
            position = [self.dataArray indexOfObject:currentDict];
            
            NSLog(@"Remove Device: %@",[currentDict objectForKey:@"deviceName"]);
            break;
        }
        
        
    }
    
    [self.dataArray removeObjectAtIndex:position];
    
    [self sendAllClients:nil];
}

-(void)sendAllClients:(NSNotification *)notification{
    
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:dataArray, @"dataArray",nil];
    
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center postNotificationName:@"dataArray"
                          object:self
                        userInfo:dict];
    
}


- (void)getDeviceFromUUID:(NSNotification *)notification{ 
    
    NSString *UUID =  [[notification userInfo] valueForKey:@"uuid"];
    
    devInfoDict = [[NSDictionary alloc]init];
    
    currentDict = [[NSDictionary alloc]init];
    
    for(currentDict in self.dataArray){
        
        NSString *deviceName = [currentDict objectForKey:@"deviceName"];
        NSString *deviceHostName = [currentDict objectForKey:@"deviceHostname"];
        NSString *deviceUUID = [currentDict objectForKey:@"deviceUUID"];
        NSNumber *devicePort = [currentDict objectForKey:@"devicePort"];
        NSNumber *deviceStartLockTime = [currentDict objectForKey:@"deviceStartLockTime"];
        NSNumber *lockState = [currentDict objectForKey:@"lockState"];
        NSNumber *lockedWithTimer = [currentDict objectForKey:@"lockedWithTimer"];
        NSNumber *lockDelay = [currentDict objectForKey:@"lockDelay"];
        NSString *imageName = [currentDict objectForKey:@"imageName"];
        NSString *lockImageName = [currentDict objectForKey:@"lockImageName"];
        
        if([deviceUUID isEqualToString:UUID]){
        
            devInfoDict = [NSDictionary dictionaryWithObjectsAndKeys:deviceName, @"deviceName", deviceHostName, @"deviceHostname", devicePort, @"devicePort", deviceUUID, @"deviceUUID", deviceStartLockTime, @"deviceStartLockTime", lockState, @"isLocked",  lockedWithTimer, @"lockedWithTimer", lockDelay, @"lockDelay", imageName, @"imageName", lockImageName, @"lockImageName", nil];
            
            break;
            
        }else{
            
            continue;
            
        }
        
    }
    
    //WARNING
  //  [[[LockItHTTPConnection alloc]init]autorelease];
    lockCon = [[LockItHTTPConnection alloc]init];
    
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center postNotificationName:@"returnTargetDict"
                          object:self
                        userInfo:devInfoDict];
    
    [currentDict retain];
    
}


- (void)dealloc {
    // Clean-up code here.
    
    [lockCon release];
    [currentDict release];
    [connection release];
    [devInfoDict release];
    [searchArray release];
    [response release];
    [dataArray release];
    [super dealloc];
}

@end
