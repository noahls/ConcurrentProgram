//
//  ViewController.m
//  ConcurrentProgram
//
//  Created by yanliu on 17/04/2017.
//  Copyright © 2017 huawei. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
//    [self dispatchAsyncFromMainToConcurrentQueue];
//    [self dispatchSyncFromMainToConcurrentQueue];
//    [self syncAfterAsync];
//    [self serialQueue];
//    [self dispatchToMain];
//    [self mainSyncMain];
    [self barrier];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)dispatchAsyncFromMainToConcurrentQueue{
    dispatch_queue_t concurrentQueue = dispatch_queue_create("concurrent.async", DISPATCH_QUEUE_CONCURRENT);
    
    NSLog(@"Before excute: %@",[NSThread currentThread]);
    dispatch_async(concurrentQueue, ^{
        [NSThread sleepForTimeInterval:3];
        NSLog(@"async block 1: %@",[NSThread currentThread]);
    });
    
    dispatch_async(concurrentQueue, ^{
        [NSThread sleepForTimeInterval:2];
        NSLog(@"async block 2: %@",[NSThread currentThread]);
    });
    NSLog(@"After excute: %@",[NSThread currentThread]);
}

- (void)dispatchSyncFromMainToConcurrentQueue{
    dispatch_queue_t concurrentQueue = dispatch_queue_create("concurrent.sync", DISPATCH_QUEUE_CONCURRENT);
    
    NSLog(@"Before excute: %@",[NSThread currentThread]);
    dispatch_sync(concurrentQueue, ^{
        [NSThread sleepForTimeInterval:3];
        NSLog(@"async block 1: %@",[NSThread currentThread]);
    });
    
    dispatch_sync(concurrentQueue, ^{
        [NSThread sleepForTimeInterval:2];
        NSLog(@"sync block 2: %@",[NSThread currentThread]);
    });
    NSLog(@"After excute: %@",[NSThread currentThread]);
}

- (void)syncAfterAsync{
    dispatch_queue_t concurrentQueue = dispatch_queue_create("concurrent.sync", DISPATCH_QUEUE_CONCURRENT);
    
    NSLog(@"Before excute: %@",[NSThread currentThread]);
    dispatch_async(concurrentQueue, ^{
        [NSThread sleepForTimeInterval:3];
        NSLog(@"async block 1: %@",[NSThread currentThread]);
    });
    
    dispatch_sync(concurrentQueue, ^{
        [NSThread sleepForTimeInterval:2];
        NSLog(@"sync block 2: %@",[NSThread currentThread]);
    });
    NSLog(@"After excute: %@",[NSThread currentThread]);
}

- (void)serialQueue{
    dispatch_queue_t serialQueue = dispatch_queue_create("serial", nil);
    NSLog(@"Before excute: %@",[NSThread currentThread]);
    dispatch_async(serialQueue, ^{
        [NSThread sleepForTimeInterval:3];
        NSLog(@"async block 1: %@",[NSThread currentThread]);
    });
    
    dispatch_sync(serialQueue, ^{
        [NSThread sleepForTimeInterval:2];
        NSLog(@"sync block 2: %@",[NSThread currentThread]);
    });
    NSLog(@"After excute: %@",[NSThread currentThread]);
}

- (void)dispatchToMain{
//    dispatch_queue_t concurrentQueue = dispatch_queue_create("concurrent.sync", DISPATCH_QUEUE_CONCURRENT);
    
    NSLog(@"Before excute: %@",[NSThread currentThread]);
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //do some calcutate
        [NSThread sleepForTimeInterval:3];
        NSLog(@"block calculate: %@",[NSThread currentThread]);
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"main block upadte: %@",[NSThread currentThread]);
        });
    });
    NSLog(@"After excute: %@",[NSThread currentThread]);
}

- (void)mainSyncMain{
    dispatch_queue_t queue = dispatch_queue_create("wrong", nil);
    NSLog(@"Before excute: %@",[NSThread currentThread]);
    dispatch_async(queue, ^{
        NSLog(@"block 1: %@",[NSThread currentThread]);
        dispatch_sync(queue, ^{
            NSLog(@"block2 %@",[NSThread currentThread]);
        });
        NSLog(@"after block2");
    });
    
    NSLog(@"After excute: %@",[NSThread currentThread]);
}

- (void)barrier{
    dispatch_queue_t queue = dispatch_queue_create("My concurrent queue", DISPATCH_QUEUE_CONCURRENT);
    __block int a1 = 0;
    __block int b1 = 0;
    __block int c1 = 0;
    dispatch_async(queue, ^{
        [NSThread sleepForTimeInterval:3];
        a1 = 5;
        NSLog(@"A finish");
    });
    
    dispatch_async(queue, ^{
        [NSThread sleepForTimeInterval:2];
        b1 = 10;
        NSLog(@"B finish");
    });
    
    dispatch_barrier_sync(queue, ^{
        [NSThread sleepForTimeInterval:1];
        c1 = a1+b1;
        NSLog(@"handle A1 and B1");
    });
    
    dispatch_async(queue, ^{
        NSLog(@"handle C1");
    });
    
    
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
