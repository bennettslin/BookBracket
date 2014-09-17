//
//  Book.h
//  BookBracket
//
//  Created by Bennett Lin on 9/8/14.
//  Copyright (c) 2014 Bennett Lin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Book : NSObject <NSCoding>

@property (strong, nonatomic) NSString *id;
@property (strong, nonatomic) NSString *author;
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) UIImage *image;

@property (assign, nonatomic) NSUInteger bracketRank;

@end
