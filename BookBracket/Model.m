//
//  Model.m
//  BookBracket
//
//  Created by Bennett Lin on 9/8/14.
//  Copyright (c) 2014 Bennett Lin. All rights reserved.
//

#import "Model.h"
#import "Book.h"

#define kMyPicksKey @"picksKey"

@interface Model ()

@property (strong, nonatomic) NSMutableArray *myPicks;

@end

@implementation Model

-(id)init {
  self = [super init];
  if (self) {
    self.myPicks = [NSMutableArray new];
  }
  return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder {
  self = [super init];
  if (self) {
    self.myPicks = [aDecoder decodeObjectForKey:kMyPicksKey];
  }
  return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder {
  [aCoder encodeObject:self.myPicks forKey:kMyPicksKey];
}

#pragma mark - picks methods

-(BOOL)addToMyPicksThisBook:(Book *)addedBook {
  
    // count can't exceed 16
  if (self.myPicks.count >= 16) {
    return NO;
  }
  
    // book with same ID can't already be in myPicks
  for (Book *thisBook in self.myPicks) {
    if ([thisBook.id isEqualToString:addedBook.id]) {
      return NO;
    }
  }
  
    // okay to add book
  [self.myPicks addObject:addedBook];
  return YES;
}

-(BOOL)removeFromMyPicksThisBook:(Book *)removedBook {
  
  Book *removedBookInArray;
  
    // remove book if it has the same ID
  for (Book *thisBook in self.myPicks) {
    if ([thisBook.id isEqualToString:removedBook.id]) {
      removedBookInArray = thisBook;
    }
  }
  
  if (removedBookInArray) {
    [self.myPicks removeObject:removedBookInArray];
    return YES;
  } else {
    return NO;
  }
}

#pragma mark - archive methods

+(void)saveModel:(Model *)model {
  [NSKeyedArchiver archiveRootObject:model toFile:[self getPathToArchive]];
}

+(Model *)getModel {
  Model *model = [NSKeyedUnarchiver unarchiveObjectWithFile:[self getPathToArchive]];
  return model ? model : [[Model alloc] init];
}

+(NSString *)getPathToArchive {
  NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
  NSString *directory = [paths objectAtIndex:0];
  NSString *pathString = [directory stringByAppendingPathComponent:@"model.plist"];
  return pathString;
}

#pragma mark - singleton method

+(Model *)model {
  static dispatch_once_t pred;
  static Model *shared = nil;
  dispatch_once(&pred, ^{
    shared = [[Model alloc] init];
  });
  return shared;
}

@end
