//
//  RootTableViewController.m
//  ConcurrentProgram
//
//  Created by yanliu on 18/04/2017.
//  Copyright © 2017 huawei. All rights reserved.
//

#import "RootTableViewController.h"
#import "ViewController.h"
#import "OperationDemoViewController.h"
#import "AsyncTaskDependencyVC.h"
@interface RootTableViewController ()
@property (nonatomic,copy) NSArray *demos;

@property (strong,nonatomic) NSString *rStr;
@property (copy, nonatomic)   NSString *cStr;
@end

@implementation RootTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _demos = @[@"GCD基本概念",@"NSOperation的基本概念",@"异步请求依赖",@"OPperation请求依赖",@"GCD信号量"];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:NSStringFromClass([UITableViewCell class])];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    NSArray *arr = @[@72,@6,@57,@88,@60,@42,@83,@73,@48,@85];
    NSMutableArray *a = [arr mutableCopy];
    [self quickSortWithArrr:a left:0 right:a.count-1];
    NSLog(@"array is %@",a);
}

- (void)quickSortWithArrr:(NSMutableArray *)a left:(int )l right:(int)r{
    if (l<r) {
        int left = l;
        int right = r;
        int x = [a[l] intValue];
        while (l<r) {
            for (; r>l; r--) {
                if ([a[r] intValue]<x) {
                    a[l] = a[r];
                    break;
                }
            }
            for (; l<r; l++) {
                if ([a[l] intValue]>=x) {
                    a[r] = a[l];
                    break;
                }
            }
        }
        
        a[l] = @(x);
        NSLog(@"array is %@",a);
        [self quickSortWithArrr:a left:left right:l-1];
        [self quickSortWithArrr:a left:l+1 right:right];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _demos.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UITableViewCell class]) forIndexPath:indexPath];
    
    cell.textLabel.text = _demos[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UIViewController *vc;
    switch (indexPath.row) {
        case 0:
            vc = [[ViewController alloc] init];
            break;
        case 1:
            vc = [[OperationDemoViewController alloc] init];
            break;
        case 2:
            vc = [[AsyncTaskDependencyVC alloc] init];
            break;
        default:
            break;
    }
    vc.navigationItem.title = _demos[indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
