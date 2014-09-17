//
//  Book.m
//  BookBracket
//
//  Created by Bennett Lin on 9/8/14.
//  Copyright (c) 2014 Bennett Lin. All rights reserved.
//

#import "Book.h"

@interface Book ()

@property (nonatomic) BOOL inRack;

@end

@implementation Book

-(id)initWithID:(NSString *)id {
  self = [super init];
  if (self) {
    self.id = id;
  }
  return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder {
  self = [super init];
  if (self) {
    self.id = [aDecoder decodeObjectForKey:@"id"];
    self.author = [aDecoder decodeObjectForKey:@"author"];
    self.title = [aDecoder decodeObjectForKey:@"title"];
    self.image = [aDecoder decodeObjectForKey:@"image"];
    self.bracketRank = [[aDecoder decodeObjectForKey:@"bracketRank"] unsignedIntegerValue];
  }
  return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder {
  [aCoder encodeObject:self.id forKey:@"id"];
  [aCoder encodeObject:self.author forKey:@"author"];
  [aCoder encodeObject:self.title forKey:@"title"];
  [aCoder encodeObject:self.image forKey:@"image"];
  [aCoder encodeObject:[NSNumber numberWithUnsignedInteger:self.bracketRank] forKey:@"bracketRank"];
}

@end
