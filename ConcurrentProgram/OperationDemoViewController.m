//
//  OperationDemoViewController.m
//  ConcurrentProgram
//
//  Created by yanliu on 20/04/2017.
//  Copyright © 2017 huawei. All rights reserved.
//

#import "OperationDemoViewController.h"

@interface OperationDemoViewController ()

@end

@implementation OperationDemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self opDependency];
    
    // Do any additional setup after loading the view.
}

- (void)opDependency{
    __block long i = 0;
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    NSOperation *calculateOp1 = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"start do some calulation 1");
        while (true) {
            i++;
        }
    }];
    [queue addOperation:calculateOp1];
    
    NSOperation *calculateOp2 = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"start do some calulation 2");
        [NSThread sleepForTimeInterval:2];
        NSLog(@"end cal 2, do some update");
        [calculateOp1 cancel];
    }];
    [queue addOperation:calculateOp2];
    
    NSOperation *doAfterPreOpDone = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"do something which depend on op1 and op2");
        NSLog(@"i is %ld",i);
    }];
    [doAfterPreOpDone addDependency:calculateOp1];
    [doAfterPreOpDone addDependency:calculateOp2];
    
    [queue addOperation:doAfterPreOpDone];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSOperation*)taskWithData:(id)data {
    NSInvocationOperation* theOp = [[NSInvocationOperation alloc] initWithTarget:self
                                                                        selector:@selector(myTaskMethod:) object:data];

    return theOp;
}

// This is the method that does the actual work of the task.
- (void)myTaskMethod:(id)data {
    // Perform the task.
}

- (NSBlockOperation *)createBlockOp{
    NSBlockOperation* theOp = [NSBlockOperation blockOperationWithBlock: ^{
        NSLog(@"Beginning operation.\n");
        // Do some work.
    }];
    return theOp;
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
