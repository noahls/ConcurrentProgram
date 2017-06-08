//
//  AFRequestOperation.m
//  ConcurrentProgram
//
//  Created by yanliu on 20/04/2017.
//  Copyright © 2017 huawei. All rights reserved.
//

#import "AFRequestOperation.h"
@interface AFRequestOperation (){
    BOOL finished;
    BOOL executing;
}
@end

@implementation AFRequestOperation
- (instancetype)init{
    self = [super init];
    if (self) {
        finished = NO;
        executing = NO;
    }
    return self;
}

- (void)start{
    // Always check for cancellation before launching the task.
    if ([self isCancelled])
    {
        // Must move the operation to the finished state if it is canceled.
        [self willChangeValueForKey:@"isFinished"];
        finished = YES;
        [self didChangeValueForKey:@"isFinished"];
        return;
    }
    
    // If the operation is not canceled, begin executing the task.
    [self willChangeValueForKey:@"isExecuting"];
    executing = YES;
    [self didChangeValueForKey:@"isExecuting"];
    
    [self performTask];
}

- (void)performTask{
    AFHTTPSessionManager *sessionManager = [AFHTTPSessionManager manager];
    sessionManager.responseSerializer = [AFHTTPResponseSerializer serializer];
    sessionManager.responseSerializer.acceptableContentTypes = [sessionManager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    [sessionManager GET:_url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (self.successHandler) {
            self.successHandler(responseObject);
        }
        [self willChangeValueForKey:@"isExecuting"];
        executing = NO;
        [self didChangeValueForKey:@"isExecuting"];
        
        [self willChangeValueForKey:@"isFinished"];
        finished = YES;
        [self didChangeValueForKey:@"isFinished"];
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (self.errorHandler) {
            self.errorHandler(error);
        }
        
        [self willChangeValueForKey:@"isExecuting"];
        executing = NO;
        [self didChangeValueForKey:@"isExecuting"];
        
        [self willChangeValueForKey:@"isFinished"];
        finished = YES;
        [self didChangeValueForKey:@"isFinished"];
    }];
}

- (BOOL)isFinished {
    return finished;
}

- (BOOL)isExecuting {
    return executing;
}
@end
