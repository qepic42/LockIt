//
//  DetailLockView.m
//  LockIt
//
//  Created by Q on 31.10.10.
//  Copyright 2010 PQ-Developing. All rights reserved.
//

#import "DetailLockView.h"


@implementation DetailLockView
@synthesize myTableView, lockItCell, lockItSwitch, sliderCell, lockItSlider, lockItSliderValue, lockItSliderCellHeader, progressCell, lockItProgress, lockItProgressValue, lockItProgressCellHeader, devInfo;

#pragma mark -
#pragma mark View lifecycle
/*
- (id)init {
    if ((self = [super init])) {
        [self viewDidLoad];
        
        NSLog(@"INIT!!!");

    }
    return self;
}
*/
-(void)setDevDict:(NSDictionary *)dict{
    
    devInfo = [[NSMutableDictionary alloc]initWithDictionary:dict];
    
}

- (void)viewDidLoad {
    
//    NSLog(@"HIER BIN ICH!");
    
    
    [super viewDidLoad];
    
    myTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, 320, 430) style:UITableViewStyleGrouped];
    
    myTableView.dataSource = self;
    myTableView.delegate = self;
    
    self.view = myTableView;
    
    NSLog(@"Info: %@\n%@\n%i",[devInfo objectForKey:@"deviceName"], [devInfo objectForKey:@"deviceHostname"], [[devInfo objectForKey:@"devicePort"] integerValue]);
    
 //   [self performSelectorInBackground:@selector(showLoadingView:) withObject:nil];
    
    [self showLoadingView:nil];
    
 //   testTime = [NSTimer scheduledTimerWithTimeInterval: 5 target:self selector: 
 //               @selector(removeLoadingView:) userInfo:nil repeats:NO];
//  [testTime fire];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(removeLoadingView:)
                                                 name:@"accessAllowed"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(showDeneyView)
                                                 name:@"accessDeneyed"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(pushBack)
                                                 name:@"noClientsAvailable"
                                               object:nil];
    
}

- (void)pushBack{
//    NSLog(@"called");
    //[self popToRootViewControllerAnimated:YES];
//    [self viewWillDisappear:YES];
//    [self dealloc];
}

- (void)showLoadingView:(NSTimer *)timer{
    
    myView = [[UIView alloc]init];
    
    myView.backgroundColor = [UIColor colorWithWhite:0.2 alpha:1.0];
    
    self.view = myView;
    
    myIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    myIndicator.center = CGPointMake(160, 150);
    myIndicator.hidesWhenStopped = YES;
    
    [self.view addSubview:myIndicator];
    
    [myIndicator startAnimating];   
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    self.navigationItem.title = @"Get autorisation";
    self.title = @"Get autorisation";
    
    [self getAutorisation];
    
    myLabel = [[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 150, 20)]autorelease];
    myLabel.text = @"Getting autorisation";
    myLabel.center = CGPointMake(160, 210);
    myLabel.textColor = [UIColor whiteColor];
    myLabel.backgroundColor = [UIColor clearColor]; 
    [self.view addSubview:myLabel];
    
}

- (void)removeLoadingView:(NSTimer *)timer{
    
    [UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:2];	
    [UIView setAnimationTransition:UIViewAnimationTransitionCurlDown forView:myTableView cache:YES];
    [UIView commitAnimations];
    myView.hidden = YES;
    self.view = myTableView;
    [myIndicator stopAnimating];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    self.navigationItem.title = [devInfo objectForKey:@"deviceName"];
    
}

- (void)showDeneyView{
    
    [myIndicator stopAnimating];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    self.navigationItem.title = [devInfo objectForKey:@"deviceName"];

    myLabel.text = @"Access refused";
    myLabel.textColor = [UIColor redColor];
    
}

- (void)getAutorisation{
    
    NSString *urlString   = [NSString stringWithFormat:@"http://%@:%i/wantAccess/%@/0", [devInfo objectForKey:@"deviceHostname"], [[devInfo objectForKey:@"devicePort"] integerValue],[[UIDevice currentDevice] uniqueIdentifier]];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    [[[NSURLConnection alloc] initWithRequest:request delegate:self] autorelease];
    
    [myTableView reloadData];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.title = [devInfo objectForKey:@"deviceName"];
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 2;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    if (section == 0){
        return 1;
    }else if (section == 1){
        return 1;
    }
    return 0;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0){
        if (indexPath.row == 0){
            return 44;
        }
    }else {
        if (indexPath.row == 0){
            return 90;
        }
    }
    return 0;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = nil;
    
    if (indexPath.section == 0){
        
        if (indexPath.row == 0){
            
            static NSString *CellIdentifier = @"LockButonCell";
            cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            
            if (cell == nil) {
                
                [[NSBundle mainBundle] loadNibNamed:@"LockButtonCell" owner:self options:nil];
                cell = lockItCell;
            }
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            return cell;
            
        }
        
        return cell;
        
    } else if (indexPath.section == 1){
        
        if (indexPath.row == 0){
            
            if ([[devInfo objectForKey:@"isLocked"] isEqualToString:@"yes"]){
                
                if ([[devInfo objectForKey:@"lockedWithTimer"] isEqualToString:@"yes"]){
                    
                    static NSString *CellIdentifier = @"ProgessCell";
                    cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                    
                    if (cell == nil) {
                        
                        [[NSBundle mainBundle] loadNibNamed:@"LockSliderProgress" owner:self options:nil];
//                        cell = ;
                    }
                    
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    
                    lockItProgressCellHeader.text = @"Delay until lock";
                    
//                     = indexPath;
                    
                    return cell;
                    
                }else if ([[devInfo objectForKey:@"lockedWithTimer"] isEqualToString:@"no"]){
                    
                    static NSString *CellIdentifier = @"LockTimerCell";
                    cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                    
                    if (cell == nil) {
                        
                        [[NSBundle mainBundle] loadNibNamed:@"LockSliderCell" owner:self options:nil];
                        cell = sliderCell;
                    }
                    
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    
                    lockItSliderCellHeader.text = @"Delay to lock";
                    
                    sliderCellIndexPath = indexPath;
                    
                    return cell;
                }
                
                return cell;
                
            }else if ([[devInfo objectForKey:@"lockedWithTimer"] isEqualToString:@"no"]){
                
                static NSString *CellIdentifier = @"LockTimerCell";
                cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                
                if (cell == nil) {
                    
                    [[NSBundle mainBundle] loadNibNamed:@"LockSliderCell" owner:self options:nil];
                    cell = sliderCell;
                }
                
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
                lockItSliderCellHeader.text = @"Delay to lock";
                
                sliderCellIndexPath = indexPath;
                
                return cell;
            }
            
            return cell;
            
        }
        
        return cell;
        
    }

	return cell;
}


#pragma mark -
#pragma mark Custom Cell IBActions

-(IBAction)changeLockItSlider:(id)sender{
    
    lockItSliderValue.text = [NSString stringWithFormat:@"%i %@",[[NSNumber numberWithFloat:lockItSlider.value] integerValue], @"min"];
    
    [devInfo removeObjectForKey:@"lockdelay"];
    [devInfo setValue:[NSNumber numberWithInteger:[[NSNumber numberWithFloat:lockItSlider.value] integerValue]] forKey:@"lockDelay"];
    
    [devInfo removeObjectForKey:@"lockedWithTimer"];
    if ([[NSNumber numberWithFloat:lockItSlider.value] integerValue] == 0){
        [devInfo setValue:@"no" forKey:@"lockedWithTimer"];
    }else{
        [devInfo setValue:@"yes" forKey:@"lockedWithTimer"];
    }
    
}


-(IBAction)changeLockItSwitch:(id)sender{
    
    if (lockItSwitch.on){
        
        [devInfo removeObjectForKey:@"isLocked"];
        [devInfo setObject:@"yes" forKey:@"isLocked"];
        
        if([[devInfo objectForKey:@"lockedWithTimer"] isEqualToString:@"yes"]){
            
            NSString *urlString   = [NSString stringWithFormat:@"http://%@:%i/lock/%@/%@", [devInfo objectForKey:@"deviceHostname"], [[devInfo objectForKey:@"devicePort"] integerValue],[[UIDevice currentDevice] uniqueIdentifier], [devInfo objectForKey:@"lockDelay"]];
            NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
            [[[NSURLConnection alloc] initWithRequest:request delegate:self] autorelease];
            [sender release];
            
        }else{
            
            NSString *urlString   = [NSString stringWithFormat:@"http://%@:%i/lock/%@/0", [devInfo objectForKey:@"deviceHostname"], [[devInfo objectForKey:@"devicePort"] integerValue],[[UIDevice currentDevice] uniqueIdentifier]];
            NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
            [[[NSURLConnection alloc] initWithRequest:request delegate:self] autorelease];
            [sender release];
            
        }
        
        
        
        [myTableView reloadData];

    }else{
        
        NSString *urlString   = [NSString stringWithFormat:@"http://%@:%i/unlock/@",[devInfo objectForKey:@"deviceHostname"], [[devInfo objectForKey:@"devicePort"] integerValue],[[UIDevice currentDevice] uniqueIdentifier]];
		NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
		[[[NSURLConnection alloc] initWithRequest:request delegate:self] autorelease];
		[sender release];
        
        [myTableView reloadData];
    }
    
}


#pragma mark -
#pragma mark Observer Methods 

-(void)changeSliderCell{
    
    [myTableView reloadData];
    
}


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

}


#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
}


- (void)dealloc {
    [devInfo release];
    [lockItSliderCellHeader release];
    [lockItSliderValue release];
    [lockItSlider release];
    [sliderCell release];
    [lockItCell release];
    [lockItSwitch release];
    [myTableView release];
    [super dealloc];
}


@end

