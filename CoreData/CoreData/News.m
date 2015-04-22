//
//  News.m
//  CoreData
//
//  Created by Cao JianRong on 15-4-22.
//  Copyright (c) 2015年 Cao JianRong. All rights reserved.
//

#import "News.h"

@implementation News

//@dynamic desc;
//@dynamic title;
//@dynamic newsId;
//@dynamic isRead;

@synthesize desc;
@synthesize title;
@synthesize newsId;
@synthesize isRead;

- (id)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self) {
        self.title = [dictionary objectForKey:@"title"];
        self.newsId = [dictionary objectForKey:@"newsId"];
        self.isRead = [dictionary objectForKey:@"isRead"];
        self.desc = [dictionary objectForKey:@"desc"];
    }
    return self;
}

@end
