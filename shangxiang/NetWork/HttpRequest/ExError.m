//
//  ExError.m
//  shangxiang
//
//  Created by 倾慕 on 15/1/10.
//  Copyright (c) 2015年 倾慕. All rights reserved.
//

#import "ExError.h"

@implementation ExError
- (NSString*)titleForError {
    NSString* title = nil;
	if (NSOrderedSame == [self.domain compare:@"NSURLErrorDomain"]) {
		switch (self.code) {
			case NSURLErrorNotConnectedToInternet:
                title = @"网络连接失败，请稍后再试";
                break;
            case NSURLErrorTimedOut:
                title = @"连接超时";
                break;
            case kCFURLErrorCancelled:
                title = @"网络连接失败，请稍后再试";
			default:
				break;
		}
	} else if (NSOrderedSame == [self.domain compare:@"NSPOSIXErrorDomain"]) {
		title = @"网络连接失败，请稍后再试";
	}
    else
    {
        
    }
	
    if (title == nil) {
        title = [self.userInfo objectForKey:@"error_msg"];
    }
    // 如果还没取到，就写死
    if (title == nil) {
        title = @"网络连接失败，请稍后再试";
    }
    
	return title;
}

-(NSString*)codeForError {
    NSString* code = [self.userInfo objectForKey:@"error_code"];
    return code;
}

-(NSString*)errorMessage {
    NSString* message = [self.userInfo objectForKey:@"error_msg"];
    return message;
}

+ (ExError*)errorWithNSError:(NSError*)error {
    if(nil == error) {
        return nil;
    }
	ExError* myError = [ExError errorWithDomain:error.domain code:error.code userInfo:error.userInfo];
	return myError;
}
///////////////////////////////////////////////////////////////////////////////////////////////////
+ (ExError*)errorWithCode:(NSString*)code errorMessage:(NSString*)errorMessage {
	NSMutableDictionary* userInfo = [[NSMutableDictionary alloc] initWithCapacity:2];
	[userInfo setObject:code forKey:@"error_code"];
    if (errorMessage) {
        [userInfo setObject:errorMessage forKey:@"error_msg"];
    }
	
	ExError* error = [ExError errorWithDomain:@"shangxiang" code:0 userInfo:userInfo];
    
	return error;
	
}
@end
