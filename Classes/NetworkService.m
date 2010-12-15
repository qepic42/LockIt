//
//  NetworkService.m
//  LockIt
//
//  Created by Q on 02.10.10.
//  Copyright 2010 PQ-Developing. All rights reserved.
//

#import "NetworkService.h"

@implementation NetworkService
@synthesize response, dataArray, otherSender;

- (id) init {
	self = [super init];
	if (self != nil) {
        dataArray = [[NSMutableArray alloc]init];
		serviceBrowser = [[NSNetServiceBrowser alloc] init];
		[serviceBrowser setDelegate:self];
		[serviceBrowser searchForServicesOfType:@"_lockitmac._tcp." inDomain:@""];
		self.response = [NSMutableData data];
    
	}
	return self;
}

- (void) dealloc {
    [otherSender release];
    [deviceInfo release];
    [dataArray release];
	[serviceBrowser release];
	[response release];
	[super dealloc];
}

// Error handling code
- (void)handleError:(NSNumber *)error {
    NSLog(@"An error occurred. Error code = %d", [error intValue]);
    // Handle error here
}

#pragma mark -
#pragma mark NetServices delegate methods
// Sent when browsing begins
- (void)netServiceBrowserWillSearch:(NSNetServiceBrowser *)browser {
	// Show a spinning wheel or something else
}

// Sent when browsing stops
- (void)netServiceBrowserDidStopSearch:(NSNetServiceBrowser *)browser {
	// Stop the spinning wheel
}

// Sent if browsing fails
- (void)netServiceBrowser:(NSNetServiceBrowser *)browser
			 didNotSearch:(NSDictionary *)errorDict {
    [self handleError:[errorDict objectForKey:NSNetServicesErrorCode]];
}

// Sent when a service appears
- (void)netServiceBrowser:(NSNetServiceBrowser *)browser
		   didFindService:(NSNetService *)aNetService
			   moreComing:(BOOL)moreComing {
    
//	NSLog(@"Found NetService: %@", [aNetService name]);
    
	[aNetService setDelegate:self];
	[aNetService resolveWithTimeout:5];
	[aNetService retain];
}


// Sent when a service disappears
- (void)netServiceBrowser:(NSNetServiceBrowser *)browser
		 didRemoveService:(NSNetService *)aNetService
			   moreComing:(BOOL)moreComing {
//	NSLog(@"Lost  NetService: %@", [aNetService name]);
	
    NSDictionary *devInfo  = [NSDictionary dictionaryWithObjectsAndKeys:[aNetService name], @"deviceName", nil];
    
    NSNotificationCenter * center;
	center = [NSNotificationCenter defaultCenter];
	[center postNotificationName:@"removeDevice"
						  object:self
						userInfo:devInfo];

}

// NetService is now ready to be used
- (void)netServiceDidResolveAddress:(NSNetService *)sender {
	
    self.otherSender = sender;
    
    NSString *urlString   = [NSString stringWithFormat:@"http://%@:%i/identify/%@/0", [sender hostName], [sender port], [[UIDevice currentDevice] uniqueIdentifier]];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
		
}

- (void)netService:(NSNetService *)sender didNotResolve:(NSDictionary *)errorDict {
    [self handleError:[errorDict objectForKey:NSNetServicesErrorCode]];
	[sender release];
}


#pragma mark -
#pragma mark NSConnection delegate methods

- (void)connection:(NSURLConnection *)connection
didReceiveResponse:(NSURLResponse *)urlResponse {
	[self.response setLength:0];
}

- (void)connection:(NSURLConnection *)connection
	didReceiveData:(NSData *)data {
	// Received another block of data. Appending to existing data
    [self.response appendData:data];
}

- (void)connection:(NSURLConnection *)connection
  didFailWithError:(NSError *)error {
	// An error occured
	NSLog(@"ERROR: %@",error);
    
    // UIAlertView
    UIAlertView *myAlert = [[UIAlertView alloc]
                            initWithTitle:@"An error occured while connecting to a server" message:[error localizedDescription]
                            delegate:self 
                            cancelButtonTitle:nil
                            otherButtonTitles:@"OK", nil];
    [myAlert show]; 
    [myAlert release];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    // Once this method is invoked, "serverResponse" contains the complete result
	NSPropertyListFormat format;
    
    NSDictionary *dict =  [NSPropertyListSerialization propertyListFromData:self.response mutabilityOption:0 format:&format errorDescription:nil];
    
    NSNumber *lockedWithTimer = [NSNumber numberWithBool:NO];
    NSNumber *lockDelay = [NSNumber numberWithInt:0];
    NSString *imageName = @"Bonjour.png";
    NSString *lockImageName = @"secure2";
    
    NSDictionary *devInfo  = [NSDictionary dictionaryWithObjectsAndKeys:[otherSender name], @"deviceName", [otherSender hostName], @"deviceHostname", [NSNumber numberWithInteger:[otherSender port]], @"devicePort", [dict objectForKey:@"uuid"], @"deviceUUID",[dict objectForKey:@"lockState"], @"isLocked", lockedWithTimer, @"lockedWithTimer", lockDelay, @"lockDelay", imageName, @"imageName", lockImageName, @"lockImageName", nil];
    
 //   NSLog(@"BOOL: %@",[dict objectForKey:@"lockState"]);
    
    NSNotificationCenter * center;
	center = [NSNotificationCenter defaultCenter];
	[center postNotificationName:@"addDevice"
						  object:self
						userInfo:devInfo];
    
   
}


@end
