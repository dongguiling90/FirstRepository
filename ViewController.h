//
//  ViewController.h
//  httpPostRequest
//
//  Created by user on 2017/11/14.
//  Copyright © 2017年 user. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "newsList.h"
#import "customCell.h"
#import "status.h"
@interface ViewController :UIViewController<NSURLSessionDataDelegate,
                                                NSURLSessionTaskDelegate>
@property(nonatomic,copy) NSArray *listArray;
@property(nonatomic,strong) NSMutableArray *cells;
@property(nonatomic,strong)customCell* cell;
@property(nonatomic,strong)status *sta;
@property(nonatomic,strong)NSDictionary *dict;
@property (strong, nonatomic) IBOutlet UITableView *table;

@end

