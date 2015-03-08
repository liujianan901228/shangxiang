//
//  ExError.h
//  shangxiang
//
//  Created by 倾慕 on 15/1/10.
//  Copyright (c) 2015年 倾慕. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ExError : NSError
+ (ExError*)errorWithCode:(NSString*)code errorMessage:(NSString*)errorMessage;
- (NSString*)titleForError;
- (NSString*)codeForError;
+ (ExError*)errorWithNSError:(NSError*)error;
-(NSString*)errorMessage;
@end
