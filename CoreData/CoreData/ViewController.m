//
//  ViewController.m
//  CoreData
//
//  Created by Cao JianRong on 15-4-22.
//  Copyright (c) 2015年 Cao JianRong. All rights reserved.
//

#import "ViewController.h"
#import "News.h"
#import "CoreDataManager.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    CoreDataManager *dataManager = [[CoreDataManager alloc] init];
    [dataManager saveContext];
// 1.第一种数据处理方式
    //当News是由用户自己手动建立的NSObject对象时，可以使用这个方法进行数据插入
    NSDictionary *dictionary = @{@"newsId":@"102",@"isRead":@"13785649937",@"desc":@"韦德今天砍下职业生涯新高的79分,韦德今天砍下职业生涯新高的79分",@"title":@"马刺-热火VI"};
    News *newsI = [[News alloc] initWithDictionary:dictionary];
//    [dataManager insertCoreData:newsI];
    
    [dataManager selectNews:2 andOffset:1];
    
    [dataManager updateNews:@"1234567800" withIsRead:@"13895004789"];
    
    [dataManager deleteNewsWithObject:newsI];
    
    [dataManager deleteNews];
    
//    News *newsII = [[News alloc] init];
//    [newsII setValue:@"110" forKey:@"newsId"];
//    [newsII setValue:@"15895880696" forKey:@"isRead"];
//    [newsII setValue:@"非常好NBA常规赛继续进行今天天气非常好NBA常规赛继续进行" forKey:@"desc"];
//    [newsII setValue:@"小妞-雄鹿XI" forKey:@"title"];
//    NSMutableArray *insertModels = [[NSMutableArray alloc] initWithObjects:newsI,newsII,nil];
//    [dataManager insertCoreDatas:insertModels];

    
    
// 2.第二种数据处理方式
//    //当News 是由NewsModel.xcdatamodeld 通过Editor -> Create NSManagedObject Subclass 生成的时候  则以以下方法进行插入
//    //NSManagedObject初始化只能使用下面的方式，不然无法进行成功的初始化
//    NSEntityDescription *entityDesc = [NSEntityDescription entityForName:@"News" inManagedObjectContext:dataManager.managedObjectContext];
//    News *newsInfo = [[News alloc] initWithEntity:entityDesc insertIntoManagedObjectContext:dataManager.managedObjectContext];
//    [newsInfo setValue:@"12345678" forKey:@"newsId"];
//    [newsInfo setValue:@"15895880478" forKey:@"isRead"];
//    [newsInfo setValue:@"今天天气非常好今天天气非常好今天天气非常好今天天气非常好今天天气非常好" forKey:@"desc"];
//    [newsInfo setValue:@"天气预报新闻" forKey:@"title"];
//    NSError *error;
//    if(![dataManager.managedObjectContext save:&error])
//    {
//        NSLog(@"不能保存：%@",[error localizedDescription]);
//    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
