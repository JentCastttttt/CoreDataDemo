//
//  News.h
//  CoreData
//
//  Created by Cao JianRong on 15-4-22.
//  Copyright (c) 2015年 Cao JianRong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface News : NSObject//NSManagedObject

@property (nonatomic, retain) NSString * desc;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * newsId;
@property (nonatomic, retain) NSString * isRead;

- (id)initWithDictionary:(NSDictionary *)dictionary;

@end