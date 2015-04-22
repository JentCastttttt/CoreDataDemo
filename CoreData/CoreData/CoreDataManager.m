//
//  CoreDataManager.m
//  CoreDataEx
//
//  Created by Cao JianRong on 15-4-22.
//  Copyright (c) 2015年 Cao JianRong. All rights reserved.
//

#import "CoreDataManager.h"

@implementation CoreDataManager

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;


- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *context = self.managedObjectContext;
    if (context != nil) {
        if ([context hasChanges] && ![context save:&error]) {
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

#pragma mark - Core Data stack 

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"NewsModel" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"NewsModel.sqlite"];
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}

- (void)insertCoreData:(News *)obj
{
    //当News是由用户自己手动建立的NSObject对象时，可以使用这个方法进行数据插入
    NSManagedObjectContext *context = [self managedObjectContext];
    News *newsInfo = [NSEntityDescription insertNewObjectForEntityForName:TableName inManagedObjectContext:context];
    newsInfo.newsId = obj.newsId;
    newsInfo.title = obj.title;
    newsInfo.desc = obj.desc;
    newsInfo.isRead = obj.isRead;
    
    NSError *error;
    if(![context save:&error])
    {
        NSLog(@"不能保存：%@",[error localizedDescription]);
    }
    
//    //当News 是由NewsModel.xcdatamodeld 通过Editor -> Create NSManagedObject Subclass 生成的时候  则以以下方法进行插入
//    NSEntityDescription *entity = [NSEntityDescription entityForName:@"News" inManagedObjectContext:self.managedObjectContext];
//    News *newsInfo = [[News alloc] initWithEntity:entity insertIntoManagedObjectContext:self.managedObjectContext];
//    newsInfo.newsId = obj.newsId;
//    newsInfo.title = obj.title;
//    newsInfo.desc = obj.desc;
//    newsInfo.isRead = obj.isRead;
//    
//    NSError *error;
//    if(![self.managedObjectContext save:&error])
//    {
//        NSLog(@"不能保存：%@",[error localizedDescription]);
//    }
}

- (void)insertCoreDatas:(NSMutableArray *)newsArray
{
    for (News *info in newsArray) {
        [self insertCoreData:info];
    }
}

- (NSMutableArray *)selectNews:(NSInteger)pageSize andOffset:(NSInteger)currentPage
{
    NSManagedObjectContext *context = [self managedObjectContext];
//    常用方法：
//    -setEntity:设置你要查询的数据对象的类型（Entity）
//    -setPredicate:设置查询条件
//    -setFetchLimit:设置最大查询对象数目
//    -setSortDescriptors:设置查询结果的排序方法
//    -setAffectedStores:设置可以在哪些数据存储中查询
//    -setFetchOffset:设置查询的偏移量
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    [fetchRequest setFetchLimit:pageSize];
    [fetchRequest setFetchOffset:currentPage];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:TableName inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    NSError *error;
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    NSMutableArray *resultArray = [NSMutableArray array];
    
    for (News *info in fetchedObjects) {
        NSLog(@"id:%@", info.newsId);
        NSLog(@"title:%@", info.title);
        [resultArray addObject:info];
    }
    return resultArray;
}

- (void)deleteNews
{
    NSManagedObjectContext *context = [self managedObjectContext];
    NSEntityDescription *entity = [NSEntityDescription entityForName:TableName inManagedObjectContext:context];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setIncludesPropertyValues:NO];
    [request setEntity:entity];
    NSError *error = nil;
    NSArray *datas = [context executeFetchRequest:request error:&error];
    if (!error && datas && [datas count])
    {
        for (NSManagedObject *obj in datas)
        {
            [context deleteObject:obj];
        }
        if (![context save:&error])
        {
            NSLog(@"error:%@",error);
        }
    }
}

- (void)deleteNewsWithObject:(id)obj
{
    NSManagedObjectContext *context = [self managedObjectContext];
    NSEntityDescription *entity = [NSEntityDescription entityForName:TableName inManagedObjectContext:context];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"title = %@", [obj valueForKey:@"title"]];  //查询条件
    NSSortDescriptor * sort = [[NSSortDescriptor alloc] initWithKey:@"title" ascending:YES];  //排序条件
    NSArray * sortDescriptors = [NSArray arrayWithObject: sort];
    
    NSFetchRequest * request = [[NSFetchRequest alloc] init];
    [request setIncludesPropertyValues:YES];
    [request setEntity: entity];
    [request setPredicate: predicate];
    [request setSortDescriptors: sortDescriptors];
    
    
//    NSFetchRequest *request = [[NSFetchRequest alloc] init];
//    [request setEntity:entity];
    NSError *error = nil;
    NSArray *datas = [context executeFetchRequest:request error:&error];
    if (!error && datas && [datas count])
    {
        [context deleteObject:[datas firstObject]];
        if (![context save:&error])
        {
            NSLog(@"error:%@",error);
        }
    }
}

- (void)updateNews:(NSString *)newsId withIsRead:(NSString *)isRead
{
    NSManagedObjectContext *context = [self managedObjectContext];
    
    NSPredicate *predicate = [NSPredicate
                              predicateWithFormat:@"newsId like[cd] %@",newsId];
    
    //首先你需要建立一个request
    NSFetchRequest * request = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:TableName inManagedObjectContext:context]];
    [request setPredicate:predicate];//这里相当于sqlite中的查询条件，具体格式参考苹果文档
    
    //https://developer.apple.com/library/mac/#documentation/Cocoa/Conceptual/Predicates/Articles/pCreating.html
    NSError *error = nil;
    NSArray *result = [context executeFetchRequest:request error:&error];//这里获取到的是一个数组，你需要取出你要更新的那个obj
    for (News *info in result) {
        info.isRead = isRead;
    }
    
    //保存
    if ([context save:&error]) {
        //更新成功
        NSLog(@"更新成功");
    }
}
@end
