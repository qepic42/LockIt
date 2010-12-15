//
//  RootView.m
//  LockIt
//
//  Created by Q on 14.10.10.
//  Copyright 2010 PQ-Developing. All rights reserved.
//

#import "RootView.h"
#import "DetailLockView.h"

@implementation RootView
@synthesize myTableView, dataArray, noClientsAlert;

- (void)viewDidLoad {
    
    dataArray = [[NSMutableArray alloc]init];
    
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center postNotificationName:@"getAllClients"
                          object:self
                        userInfo:nil];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(setAllClients:)
                                                 name:@"dataArray"
                                               object:nil];
    
    [super viewDidLoad];
    
    myTableView = [[UITableView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame] style:UITableViewStyleGrouped];
	myTableView.delegate = self;
	myTableView.dataSource = self;
	
	myTableView.autoresizesSubviews = YES;
	
	self.navigationItem.title = @"Available Clients";

	self.view = myTableView;
    
    [self setAllClients:nil];
    
}

-(void)setAllClients:(NSNotification *)notification{
    
    // UIAlertView
    UIAlertView *myAlert = [[UIAlertView alloc]
                            initWithTitle:@"Loading…" message:nil
                            delegate:self 
                            cancelButtonTitle:nil
                            otherButtonTitles:nil];
    
    [myAlert show]; 

    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    
    indicator.center = CGPointMake(myAlert.bounds.size.width / 2, myAlert.bounds.size.height - 50);
    [indicator startAnimating];
    [myAlert addSubview:indicator];
    [indicator release];
    
    
    self.dataArray = [[notification userInfo]objectForKey:@"dataArray"];
    
    [self.myTableView reloadData];
    
    [myAlert dismissWithClickedButtonIndex:0 animated:YES];
    [myAlert release];
    
    if([self.dataArray count] == 0){
        [self showNoClientsAvailableAlert];
        
        NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
        [center postNotificationName:@"noClientsAvailable"
                              object:self
                            userInfo:nil];
        
        
    }else if([self.dataArray count] >= 1){
        [self removeNoClientsAvailableAlert];
    }
    
}


-(void)showNoClientsAvailableAlert{
    
    NSNotificationCenter * center;
    center = [NSNotificationCenter defaultCenter];
    [center postNotificationName:@"noClientsAvailable"
                          object:self];
    
    self.noClientsAlert = [[UIAlertView alloc]
                            initWithTitle:@"No servers available- awating connection…" message:nil
                            delegate:self 
                            cancelButtonTitle:nil
   //                         otherButtonTitles:@"Help",nil];
                           otherButtonTitles:nil];
    
    [self.noClientsAlert show]; 
    
    
    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    
//    indicator.center = CGPointMake(self.noClientsAlert.bounds.size.width / 2, self.noClientsAlert.bounds.size.height - 50);
    indicator.center = CGPointMake(145, 90);
    [indicator startAnimating];
    [self.noClientsAlert addSubview:indicator];
    [indicator release];
    
}

-(void)removeNoClientsAvailableAlert{
    
    [self.myTableView reloadData];
    
    [self.noClientsAlert dismissWithClickedButtonIndex:0 animated:YES];
    
}


- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    [myTableView deselectRowAtIndexPath:[myTableView indexPathForSelectedRow] animated:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dataArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath  {  
    return 70;  
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    NSDictionary *devDict = [self.dataArray objectAtIndex:indexPath.row];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    BOOL cache = [[devDict objectForKey:@"isLocked"] boolValue ];
    
    if (cache == YES){
        
        if (cell == nil) {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
        }
        
        cell.textLabel.text = [devDict objectForKey:@"deviceName"];
        cell.detailTextLabel.text = @"locked from another iDevice";
        cell.imageView.image = [UIImage imageNamed:[devDict objectForKey:@"lockImageName"]];
        
        return cell;

        
    }else if (cache == NO){
        
        if (cell == nil) {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        }
        
        cell.textLabel.text = [devDict objectForKey:@"deviceName"];
        cell.imageView.image = [UIImage imageNamed:[devDict objectForKey:@"imageName"]];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

        return cell;
    }
        
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSDictionary *devDict = [self.dataArray objectAtIndex:indexPath.row];
    
    DetailLockView *detail = [[DetailLockView alloc]initWithStyle:UITableViewStyleGrouped];

    [detail setDevDict:devDict];
    
    BOOL cache = [[devDict objectForKey:@"isLocked"] boolValue ];
    
    if (cache == YES){
        // UIAlertView
        
        NSString *cache = [NSString stringWithFormat:@"%@ %@ %@ %@", [devDict objectForKey:@"deviceName"], @"is currently locked.\n Please try to unlock with the Device used for locking", [devDict objectForKey:@"deviceName"], @"and try again."];
        
        UIAlertView *myAlert = [[UIAlertView alloc]
                                initWithTitle:@"Device currently locked" message:cache
                                delegate:self 
                                cancelButtonTitle:nil
                                otherButtonTitles:@"OK", nil];
    
        [myAlert show]; 
        [myAlert release];
          
    }else{
        [self.navigationController pushViewController:detail animated:YES]; 
    }
    
    
    [detail release];
     
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
    [super viewDidUnload];
}


- (void)dealloc {
    [noClientsAlert release];
    [dataArray release];
	[myTableView release];
    [super dealloc];
}


@end
