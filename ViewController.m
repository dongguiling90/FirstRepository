//
//  ViewController.m
//  httpPostRequest
//
//  Created by user on 2017/11/14.
//  Copyright © 2017年 user. All rights reserved.
//
#import<foundation/foundation.h>
#import <MJExtension/MJExtension.h>
#import <MJRefresh/MJRefresh.h>
#import "ViewController.h"
#import "customCell.h"
#import "firstCell.h"
#import "status.h"
#import"newsList.h"
#import "postRequest.h"
#define postRequestString  @"https://www.fin-market.com.cn/brisbane/news/list"
#define parameter      @{@"channel":@"ios"}
@class customCell;
@interface ViewController ()

@end
NSDictionary *dict;
NSMutableArray *array;
@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.table.estimatedRowHeight=80;
    self.table.rowHeight=UITableViewAutomaticDimension;
    
    // Do any additional setup after loading the view, typically from a nib
    UIBarButtonItem *button=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(add)];
    self.navigationItem.rightBarButtonItem=button;
    button.tintColor=[UIColor whiteColor];
    self.navigationController.navigationBar.barStyle=UIBarStyleBlack;
    //self.navigationController.navigationBar.barTintColor=[UIColor blueColor];
    UITabBarItem* item0= [self.tabBarController.tabBar.items objectAtIndex:0];
    item0.title=@"首页";
    [item0 setTitleTextAttributes:[[NSDictionary alloc]initWithObjectsAndKeys:[UIColor colorWithRed:200/255.0 green:200/255.0 blue:200/255.0 alpha:1], NSForegroundColorAttributeName,[UIFont systemFontOfSize:12],NSFontAttributeName,nil]forState:UIControlStateNormal];
    [item0 setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithRed:50/255.0 green:150/255.0 blue:50/255.0 alpha:1],NSForegroundColorAttributeName,[UIFont systemFontOfSize:12],NSFontAttributeName,nil] forState:UIControlStateSelected];
    UITabBarItem *item1=[self.tabBarController.tabBar.items objectAtIndex:1];
    item1.title=@"喜欢";
    [item1 setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithRed:200/255.0 green:200/255.0 blue:200/255.0 alpha:1],NSForegroundColorAttributeName,[UIFont systemFontOfSize:12],NSFontAttributeName,nil] forState:UIControlStateNormal];
    [item1 setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithRed:50/255.0 green:150/255.0 blue:50/255.0 alpha:1],NSForegroundColorAttributeName,[UIFont systemFontOfSize:12],NSFontAttributeName, nil] forState:UIControlStateSelected];
   // self.table.separatorStyle=UITableViewCellSeparatorStyleNone;
    self.table.tableFooterView=[[UIView alloc]initWithFrame:CGRectZero];
     //设置分割线insets；
  if([self.table respondsToSelector:@selector(setSeparatorInset:)])
     self.table.separatorInset=UIEdgeInsetsZero;
    if([self.table respondsToSelector:@selector(setLayoutMargins:)])
        self.table.layoutMargins=UIEdgeInsetsZero;
    [self getData];
    __weak typeof(self) weakself=self;
   self.table.mj_header=[MJRefreshNormalHeader headerWithRefreshingBlock:^{
   [weakself getData];
    } ];
    
}
-(void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    [self.table layoutSubviews];
    [_table layoutIfNeeded];
}
-(void)add{
    NSLog(@"add");
}
-(void)getData{
    postRequest *post=[postRequest getInstance];
    [post request: postRequestString  parameters: parameter success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@",[responseObject class]);
        //_strong typeof(weakself) strongself=weakself;
        dict=responseObject;
        NSLog(@"%@",dict);
        NSLog(@"%@",[NSThread currentThread]);
        [self setFramesAndCells:dict];
        //[self  performSelectorOnMainThread:@selector(getResponse:) withObject:responseObject waitUntilDone:NO];
    }];
    // dict=[[NSDictionary alloc]init];
     //dict=post.response;
     //NSLog(@"%@",dict);
    
    //[self performSelectorOnMainThread:@selector(setFramesAndCells:) withObject:self.dict waitUntilDone:NO];
    /**
     NSString* urlstr=[NSString stringWithFormat:@"https://www.fin-market.com.cn/brisbane/news/list"];
    NSURL* url=[NSURL URLWithString:urlstr];
    NSMutableURLRequest* request=[NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod=@"POST";
    NSString* post=[NSString stringWithFormat:@"channel=ios"];
    NSData* postdata=[post dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPBody:postdata];
    NSURLSession* session=[NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    NSURLSessionDataTask* dataTask=[session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if(error==nil){
          NSLog(@"%@",[NSThread currentThread]);
            NSLog(@"---接收服务器响应数据完成----");
         dict=[NSJSONSerialization JSONObjectWithData: data options:NSJSONReadingAllowFragments error:NULL];
            NSString* desc=[dict description];
           desc=[NSString stringWithCString:[desc cStringUsingEncoding:NSUTF8StringEncoding] encoding:NSNonLossyASCIIStringEncoding];
            NSLog(@"%@",[desc description]);
            
       [self performSelectorOnMainThread:@selector(setFramesAndCells:) withObject:dict waitUntilDone:NO];
            
         
        }
    }];
    [dataTask resume];
   */
    
}

-(void)setFramesAndCells:(NSDictionary *)dict{
      _sta=[status mj_objectWithKeyValues:dict];
    NSLog(@"%@",_sta.msg);
    NSLog(@"%@ %@ %@",_sta.newsLists[0],_sta.newsLists[1],_sta.newsLists[2]);
    self.listArray=_sta.newsLists;
   NSMutableArray * array1=[[NSMutableArray alloc]init];
    for(int i=0;i<self.listArray.count;i++){
    customCell *cell=[[customCell alloc] init];
        cell.status=_sta;
        [array1 addObject:cell];
    }
    self.cells=array1;
    [self.table.mj_header endRefreshing];
    [_table reloadData];
}
 

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    /*if(self.listArray.count==0)
        tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    else if(self.listArray.count>0)
        tableView.separatorStyle=UITableViewCellSeparatorStyleSingleLine;
     */
    return self.listArray.count;
   
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"3");
   customCell* cell=[customCell cellWithTableView:tableView];
    newsList *list=[self.listArray objectAtIndex:indexPath.row];
    NSLog(@"%@",list);
    //firstCell *cell=[firstCell cellWithTableView:tableView];

    cell.status=_sta;
    cell.list=list;
    //[cell layoutIfNeeded];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"2");
    //customCell *cell=_cells[indexPath.row];
    //cell.list=self.listArray[indexPath.row];
   //firstCell *cell=(firstCell *)[self tableView:tableView cellForRowAtIndexPath:indexPath];
     //[cell setNeedsLayout];
     //[cell setNeedsUpdateConstraints];
     //[cell updateConstraintsIfNeeded];
     //CGSize size=[cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    //return size.height+1.0;
     return 100.0;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
