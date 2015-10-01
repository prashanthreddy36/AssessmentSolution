//
//  ViewController.m
//  Assessment
//
//  Created by Prashanth on 01/10/15.
//  Copyright (c) 2015 Prashanth. All rights reserved.
//

#import "ViewController.h"
#import "MBProgressHUD+Utility.h"
#import "AFHTTPRequestOperationManager.h"

#define kWebURL @"http://www.nactem.ac.uk/software/acromine/dictionary.py?sf=%@"

@interface ViewController () <UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITextField *abbrevation;
@property (nonatomic, strong) NSArray* meaningArray;
@property (weak, nonatomic) IBOutlet UITableView *meaningsTable;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)fetchMeaning:(id)sender {
    [self.abbrevation resignFirstResponder];
    NSString* abbText = self.abbrevation.text;
    if (abbText.length) {
        
        __weak ViewController* weakSelf = self;
        [MBProgressHUD showHUDAddedTo:self.view withText:@"Fetching..." animated:nil];
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        NSString* fetchURL = [NSString stringWithFormat:kWebURL, abbText];
        [manager GET:fetchURL parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                NSLog(@"Received JSON: %@", [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding]);
                NSError* error;
                NSArray* receivedArray = [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:&error];
                if (error) {
                    self.meaningArray = @[];
                    NSLog(@"error: %@", error.localizedDescription);
                    [[[UIAlertView alloc] initWithTitle:@"" message:@"Error in receiving data from server" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
                } else {
                    NSLog(@"%@", receivedArray);
                    NSArray* allEntries = receivedArray[0][@"lfs"];
                    NSMutableArray* arr = [@[] mutableCopy];
                    for (NSDictionary* dict in allEntries) {
                        [arr addObjectsFromArray:dict[@"vars"]];
                    }
                    self.meaningArray = arr;
                }
                [weakSelf.meaningsTable reloadData];
            });
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                [[[UIAlertView alloc] initWithTitle:@"Failure" message:@"Failed to fetch the meaning" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
            });
            NSLog(@"Error: %@", error);
        }];
    } else {
        [[[UIAlertView alloc] initWithTitle:@"" message:@"Please enter abbrevation and tap Submit" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.meaningArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"Meaning" forIndexPath:indexPath];
    NSDictionary* meaning = self.meaningArray[indexPath.row];
    cell.textLabel.text = [meaning[@"lf"] capitalizedString];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", meaning[@"since"]];
    return cell;
}


@end
