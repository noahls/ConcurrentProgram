//
//  AsyncTaskDependencyVC.m
//  ConcurrentProgram
//
//  Created by yanliu on 20/04/2017.
//  Copyright © 2017 huawei. All rights reserved.
//

#import "AsyncTaskDependencyVC.h"
#import "AFNetworking.h"
#import "AFRequestOperation.h"
@interface AsyncTaskDependencyVC ()

@end

@implementation AsyncTaskDependencyVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
//    [self orginalOp];
    [self customOp];
//    [self gcdGroup];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)customOp{
    NSString *url1 = @"http://www.baidu.com";
    NSString *url2 = @"http://www.jianshu.com";
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    AFRequestOperation *op1 = [[AFRequestOperation alloc] init];
    op1.url = url1;
    op1.successHandler = ^(id response) {
        NSLog(@"get data of %@ success",url1);
    };
    op1.errorHandler = ^(NSError *error) {
        NSLog(@"get data of %@ fail",url1);
    };
    [queue addOperation:op1];
    
    AFRequestOperation *op2 = [[AFRequestOperation alloc] init];
    op2.url = url2;
    op2.successHandler = ^(id response) {
        NSLog(@"get data of %@ success",url2);
    };
    op2.errorHandler = ^(NSError *error) {
        NSLog(@"get data of %@ fail",url2);
    };
    [queue addOperation:op2];
    
    NSOperation *pushOp = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"push to new controller after all data is ready!");
    }];
    [pushOp addDependency:op1];
    [pushOp addDependency:op2];
    [queue addOperation:pushOp];
}

- (void)orginalOp{
    NSString *url1 = @"http://www.baidu.com";
    NSString *url2 = @"http://www.jianshu.com";
    NSOperation *op1 = [NSBlockOperation blockOperationWithBlock:^{
        [self getHtmlOfUrl:url1 success:^(NSURLSessionDataTask * _Nonnull task, id _Nullable response) {
            NSLog(@"get data of %@ success",url1);
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"get html of %@ fail",url1);
        }];
    }];
    
    NSOperation *op2 = [NSBlockOperation blockOperationWithBlock:^{
        [self getHtmlOfUrl:url2 success:^(NSURLSessionDataTask * _Nonnull task, id _Nullable response) {
            NSLog(@"get data of %@ success",url2);
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"get html of %@ fail",url2);
        }];
    }];
    
    NSOperation *pushOp = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"push to new controller after all data is ready!");
    }];
    [pushOp addDependency:op1];
    [pushOp addDependency:op2];
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [queue addOperation:op1];
    [queue addOperation:op2];
    [queue addOperation:pushOp];
}

- (void)gcdGroup{
    NSString *url1 = @"http://www.baidu.com";
    NSString *url2 = @"http://www.jianshu.com";
    dispatch_group_t group = dispatch_group_create();
    
    dispatch_group_enter(group);
    [self getHtmlOfUrl:url1 success:^(NSURLSessionDataTask * _Nonnull task, id _Nullable response) {
        NSLog(@"get data of %@ success",url1);
        dispatch_group_leave(group);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"get html of %@ fail",url1);
        dispatch_group_leave(group);
    }];
    
    dispatch_group_enter(group);
    [self getHtmlOfUrl:url2 success:^(NSURLSessionDataTask * _Nonnull task, id _Nullable response) {
        NSLog(@"get data of %@ success",url2);
        dispatch_group_leave(group);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"get html of %@ fail",url2);
        dispatch_group_leave(group);
    }];
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        NSLog(@"push to new controller after all data is ready!");
    });
}

- (void)getHtmlOfUrl:(NSString *)url
             success:(void (^)(NSURLSessionDataTask * _Nonnull, id _Nullable))success
             failure:(void (^)(NSURLSessionDataTask * _Nullable, NSError * _Nonnull))failure{
    url = [url stringByRemovingPercentEncoding];
    
    AFHTTPSessionManager *sessionManager = [AFHTTPSessionManager manager];
    sessionManager.responseSerializer = [AFHTTPResponseSerializer serializer];
    sessionManager.responseSerializer.acceptableContentTypes = [sessionManager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    [sessionManager GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(task,responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(task,error);
    }];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
