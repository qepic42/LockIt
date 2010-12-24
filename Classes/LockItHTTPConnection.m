//
//  LockItHTTPConnection.m
//  LockIt
//
//  Created by Q on 02.10.10.
//  Copyright 2010 PQ-Developing. All rights reserved.
//

#import "LockItHTTPConnection.h"
#import "HTTPServer.h"
#import "HTTPResponse.h"
#import "AsyncSocket.h"
#import "RootView.h"


@implementation LockItHTTPConnection
@synthesize commandString;

- (NSObject<HTTPResponse> *)httpResponseForMethod:(NSString *)method URI:(NSString *)path{
    NSString *error = nil;
	HTTPDataResponse* response = nil;
	
	NSString *command = [path substringFromIndex:1];
    NSArray *listItems = [path componentsSeparatedByString:@"/"];
    NSString *uuid = [listItems objectAtIndex:1];
    
    self.commandString = [listItems objectAtIndex:2];
    
	NSLog(@"Command: %@",self.commandString);
    NSLog(@"UUID: %@",uuid);
	
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithObject:command 
																   forKey:@"command"];
    
    NSRange isLocked = [self.commandString  rangeOfString:@"identify"];
    if  (isLocked.location != NSNotFound){
        
        [dict setObject:[[UIDevice currentDevice] uniqueIdentifier]
				 forKey:@"uuid"];
        
    }else{
        
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        [prefs setObject:self.commandString forKey:@"command"];        
        [prefs synchronize];
        
        NSDictionary *uuidDict = [NSDictionary dictionaryWithObject:uuid forKey:@"uuid"];
        
        NSNotificationCenter * center;
        center = [NSNotificationCenter defaultCenter];
        [center postNotificationName:@"getDeviceFromUUID"
                              object:self
                            userInfo:uuidDict];
        
    }
    
	NSData* data = [NSPropertyListSerialization dataFromPropertyList:dict
															  format:NSPropertyListXMLFormat_v1_0
													errorDescription:&error];
	
	if (error) {
		NSLog(@"%@", error);
		[error release]; // see documentation for this!
	} else {
		response = [[[HTTPDataResponse alloc] initWithData:data] autorelease];
	}
    
    
	return response;
}


- (void)sendCommands:(NSNotification *)notification{
    
    NSDictionary *deviceInfoDict = [notification userInfo];
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    
    self.commandString = [prefs stringForKey:@"command"];
    
    if ([deviceInfoDict count] == 0){
        NSLog(@"Non bonjour client alert!!");
    }else{
        
        NSRange accessAllowed = [self.commandString  rangeOfString:@"accessAllowed"];
        if  (accessAllowed.location != NSNotFound){
            
            NSNotificationCenter * center;
            center = [NSNotificationCenter defaultCenter];
            [center postNotificationName:@"accessAllowed"
                                  object:self
                                userInfo:nil];
            
        }
        
        NSRange accessRefused = [self.commandString  rangeOfString:@"accessDenyed"];
        if  (accessRefused.location != NSNotFound){
            
            NSNotificationCenter * center;
            center = [NSNotificationCenter defaultCenter];
            [center postNotificationName:@"accessDenyed"
                                  object:self
                                userInfo:nil];
            
        }
        
        NSRange deviceLocked = [self.commandString  rangeOfString:@"locked"];
        if  (deviceLocked.location != NSNotFound){
            
            NSNotificationCenter * center;
            center = [NSNotificationCenter defaultCenter];
            [center postNotificationName:@"deviceLocked"
                                  object:self
                                userInfo:nil];
            
        }
        
        NSRange deviceUnlocked = [self.commandString  rangeOfString:@"released"];
        if  (deviceUnlocked.location != NSNotFound){
            
            NSNotificationCenter * center;
            center = [NSNotificationCenter defaultCenter];
            [center postNotificationName:@"deviceUnlocked"
                                  object:self
                                userInfo:nil];
            
        }
        
    }
    
    
}

- (BOOL)isBrowseable:(NSString *)path{
	return YES;
}

- (NSString *)createBrowseableIndex:(NSString *)path{
    NSArray *array = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:path error:nil];
    
    NSMutableString *outdata = [NSMutableString new];
	[outdata appendString:@"<html><head>"];
	[outdata appendFormat:@"<title>Files from %@</title>", server.name];
    [outdata appendString:@"<style>html {background-color:#eeeeee} body { background-color:#FFFFFF; font-family:Tahoma,Arial,Helvetica,sans-serif; font-size:18x; margin-left:15%; margin-right:15%; border:3px groove #006600; padding:15px; } </style>"];
    [outdata appendString:@"</head><body>"];
	[outdata appendFormat:@"<h1>Files from %@</h1>", server.name];
    [outdata appendString:@"<bq>The following files are hosted live from the iPhone's Docs folder.</bq>"];
    [outdata appendString:@"<p>"];
	[outdata appendFormat:@"<a href=\"..\">..</a><br />\n"];
    for (NSString *fname in array)
    {
        NSDictionary *fileDict = [[NSFileManager defaultManager] attributesOfItemAtPath:[path stringByAppendingPathComponent:fname] error:NO];
		//NSLog(@"fileDict: %@", fileDict);
        NSString *modDate = [[fileDict objectForKey:NSFileModificationDate] description];
		if ([[fileDict objectForKey:NSFileType] isEqualToString: @"NSFileTypeDirectory"]) fname = [fname stringByAppendingString:@"/"];
		[outdata appendFormat:@"<a href=\"%@\">%@</a>		(%8.1f Kb, %@)<br />\n", fname, fname, [[fileDict objectForKey:NSFileSize] floatValue] / 1024, modDate];
    }
    [outdata appendString:@"</p>"];
	
	if ([self supportsPOST:path withSize:0])
	{
		[outdata appendString:@"<form action=\"\" method=\"post\" enctype=\"multipart/form-data\" name=\"form1\" id=\"form1\">"];
		[outdata appendString:@"<label>upload file"];
		[outdata appendString:@"<input type=\"file\" name=\"file\" id=\"file\" />"];
		[outdata appendString:@"</label>"];
		[outdata appendString:@"<label>"];
		[outdata appendString:@"<input type=\"submit\" name=\"button\" id=\"button\" value=\"Submit\" />"];
		[outdata appendString:@"</label>"];
		[outdata appendString:@"</form>"];
	}
	
	[outdata appendString:@"</body></html>"];
    
	//NSLog(@"outData: %@", outdata);
    return [outdata autorelease];
}


- (BOOL)supportsMethod:(NSString *)method atPath:(NSString *)relativePath
{
	if ([@"POST" isEqualToString:method])
	{
		return YES;
	}
	
	return [super supportsMethod:method atPath:relativePath];
}

- (BOOL)supportsPOST:(NSString *)path withSize:(UInt64)contentLength
{
	//	NSLog(@"POST:%@", path);
	
	dataStartIndex = 0;
	multipartData = [[NSMutableArray alloc] init];
	postHeaderOK = FALSE;
	
	return YES;
}

- (void)dealloc {
    [commandString release];
    [super dealloc];
}


- (void)processDataChunk:(NSData *)postDataChunk{
	
	if (!postHeaderOK)
	{
		UInt16 separatorBytes = 0x0A0D;
		NSData* separatorData = [NSData dataWithBytes:&separatorBytes length:2];
		
		int l = [separatorData length];
		
		for (int i = 0; i < [postDataChunk length] - l; i++)
		{
			NSRange searchRange = {i, l};
			
			if ([[postDataChunk subdataWithRange:searchRange] isEqualToData:separatorData])
			{
				NSRange newDataRange = {dataStartIndex, i - dataStartIndex};
				dataStartIndex = i + l;
				i += l - 1;
				NSData *newData = [postDataChunk subdataWithRange:newDataRange];
				
				if ([newData length])
				{
					[multipartData addObject:newData];
				}
				else
				{
					postHeaderOK = TRUE;
					
					NSString* postInfo = [[NSString alloc] initWithBytes:[[multipartData objectAtIndex:1] bytes] length:[[multipartData objectAtIndex:1] length] encoding:NSUTF8StringEncoding];
					NSArray* postInfoComponents = [postInfo componentsSeparatedByString:@"; filename="];
					postInfoComponents = [[postInfoComponents lastObject] componentsSeparatedByString:@"\""];
					postInfoComponents = [[postInfoComponents objectAtIndex:1] componentsSeparatedByString:@"\\"];
					NSString* filename = [[[server documentRoot] path] stringByAppendingPathComponent:[postInfoComponents lastObject]];
					NSRange fileDataRange = {dataStartIndex, [postDataChunk length] - dataStartIndex};
					
					[[NSFileManager defaultManager] createFileAtPath:filename contents:[postDataChunk subdataWithRange:fileDataRange] attributes:nil];
					NSFileHandle *file = [[NSFileHandle fileHandleForUpdatingAtPath:filename] retain];
					
					if (file)
					{
						[file seekToEndOfFile];
						[multipartData addObject:file];
					}
					
					[postInfo release];
					
					break;
				}
			}
		}
	}
	else
	{
		[(NSFileHandle*)[multipartData lastObject] writeData:postDataChunk];
	}
}


@end
