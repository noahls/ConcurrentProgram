//
//  AFRequestOperation.h
//  ConcurrentProgram
//
//  Created by yanliu on 20/04/2017.
//  Copyright © 2017 huawei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
@interface AFRequestOperation : NSOperation
@property (nonatomic,copy) NSString *url;
@property (nonatomic,copy) void (^successHandler)(id response);
@property (nonatomic,copy) void (^errorHandler)(NSError* error);
@end
