//
//  DetailLockView.h
//  LockIt
//
//  Created by Q on 31.10.10.
//  Copyright 2010 PQ-Developing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NetworkService.h"

@interface DetailLockView : UITableViewController<UITableViewDelegate,UITableViewDataSource> {
    NetworkService *netService;
    
    UITableView *myTableView;
    NSMutableData *response;
    NSIndexPath *sliderCellIndexPath;
    CGFloat rowCount;
    UIView *myView;
    UIActivityIndicatorView *myIndicator;
    NSTimer *testTime;
    UILabel *myLabel;
    NSMutableDictionary *devInfo;
    
    IBOutlet UITableViewCell *lockItCell;
    IBOutlet UITableViewCell *sliderCell;
    IBOutlet UITableViewCell *progressCell;
    IBOutlet UISwitch *lockItSwitch;
    IBOutlet UISlider *lockItSlider;
    IBOutlet UIProgressView *lockItProgress;
    IBOutlet UILabel *lockItSliderValue;
    IBOutlet UILabel *lockItSliderCellHeader;
    IBOutlet UILabel *lockItProgressValue;
    IBOutlet UILabel *lockItProgressCellHeader;
    
}

-(IBAction)changeLockItSwitch:(id)sender;
-(IBAction)changeLockItSlider:(id)sender;
-(void)showLoadingView:(NSTimer *)timer;
-(void)removeLoadingView:(NSTimer *)timer;
-(void)getAutorisation;
-(void)showDeneyView;
-(void)setDevDict:(NSDictionary *)dict;
-(void)pushBack;

@property (nonatomic, retain) IBOutlet UITableViewCell* lockItCell;
@property (nonatomic, retain) IBOutlet UITableViewCell* sliderCell;
@property (nonatomic, retain) IBOutlet UITableViewCell* progressCell;
@property (nonatomic, retain) IBOutlet UIProgressView *lockItProgress;
@property (nonatomic, retain) IBOutlet UISwitch *lockItSwitch;
@property (nonatomic, retain) IBOutlet UISlider *lockItSlider;
@property (nonatomic, retain) IBOutlet UILabel *lockItSliderValue;
@property (nonatomic, retain) IBOutlet UILabel *lockItSliderCellHeader;
@property (nonatomic, retain) IBOutlet UILabel *lockItProgressValue;
@property (nonatomic, retain) IBOutlet UILabel *lockItProgressCellHeader;

@property (nonatomic, retain) NSMutableDictionary *devInfo;
@property (nonatomic, retain) UITableView *myTableView;
//@property (nonatomic, retain) NSMutableData *response;

@end
