//
//  GoodreadsAPI.h
//  BookBracket
//
//  Created by Bennett Lin on 9/8/14.
//  Copyright (c) 2014 Bennett Lin. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Book;

@interface GoodreadsAPI : NSObject

-(NSArray *)getBooksArrayForSearchQuery:(NSString *)string;
-(Book *)getBookForID:(NSString *)string;

@end
