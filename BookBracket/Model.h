//
//  Model.h
//  BookBracket
//
//  Created by Bennett Lin on 9/8/14.
//  Copyright (c) 2014 Bennett Lin. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Book;

@interface Model : NSObject <NSCoding>

@property (readonly, nonatomic) NSMutableArray *myPicks;

+(void)saveModel:(Model *)model;
+(Model *)getModel;

-(BOOL)addToMyPicksThisBook:(Book *)addedBook;
-(BOOL)removeFromMyPicksThisBook:(Book *)removedBook;

@end