//
//  RootView.h
//  LockIt
//
//  Created by Q on 14.10.10.
//  Copyright 2010 PQ-Developing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NetworkService.h"

@class NetworkService;
@interface RootView : UITableViewController<UITableViewDelegate,UITableViewDataSource,UINavigationControllerDelegate> {
    UITableView *myTableView;
    NSMutableArray *dataArray;
    UIAlertView *noClientsAlert;
    
    NetworkService *netService;
    
}

@property (nonatomic,retain)UITableView *myTableView;
@property (nonatomic,retain)UIAlertView *noClientsAlert;
@property (assign) NSMutableArray *dataArray;

-(void)setAllClients:(NSNotification *)notification;
-(void)showNoClientsAvailableAlert;
-(void)removeNoClientsAvailableAlert;

@end
