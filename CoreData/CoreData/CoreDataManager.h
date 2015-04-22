//
//  CoreDataManager.h
//  CoreDataEx
//
//  Created by Cao JianRong on 15-4-22.
//  Copyright (c) 2015年 Cao JianRong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "News.h"

#define TableName @"News"

@interface CoreDataManager : NSObject

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, strong) NSPersistentStoreCoordinator *persistentStoreCoordinator;

//保存上下文
- (void)saveContext;

//获取应用程序的Documents路径
- (NSURL *)applicationDocumentsDirectory;

//插入一条数据
- (void)insertCoreData:(News *)obj;

//插入一组数据
- (void)insertCoreDatas:(NSMutableArray *)newsArray;

//搜索某一页数据
- (NSMutableArray *)selectNews:(NSInteger)pageSize andOffset:(NSInteger)currentPage;

//删除所有的数据
- (void)deleteNews;

//删除某一条数据
- (void)deleteNewsWithObject:(id)obj;

//更新某一条数据
- (void)updateNews:(NSString *)newsId withIsRead:(NSString *)isRead;

@end
