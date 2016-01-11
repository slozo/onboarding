//
//  KnowledgeTableViewController.m
//  onboarding-test
//
//  Created by Mateusz Szlosek on 10.01.2016.
//  Copyright © 2016 slozo. All rights reserved.
//

#import "KnowledgeTableViewController.h"

@interface KnowledgeTableViewController () <UISplitViewControllerDelegate>

@property (strong, nonatomic) NSArray *data;
@property (assign, nonatomic) BOOL shouldCollapseDetailViewController;

@end

@implementation KnowledgeTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.data = @[@{@"header":@"Company",
                    @"cells":@[@"About Us",
                               @"Our Values",
                               @"Managment Team",
                               @"Company Blog",
                               @"Where We Are",
                               @"Guilds"]},
                  @{@"header":@"Guides",
                    @"cells":@[@"How-to’s",
                               @"All Things HR",
                               @"JIRA"]}];
    
    
    // Setup BOOL for not collapsing on iPhone
    self.shouldCollapseDetailViewController = true;
    self.splitViewController.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.data.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[self.data[section] objectForKey:@"cells"] count];
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [self.data[section] objectForKey:@"header"];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"basicCell"
                                                            forIndexPath:indexPath];
    
    cell.textLabel.text = [self.data[indexPath.section] objectForKey:@"cells"][indexPath.row];
    
    return cell;
}


// To prevent showing the detail view at the first time we enter split view, we use our BOOL.
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.shouldCollapseDetailViewController = false;
}

- (BOOL)splitViewController:(UISplitViewController *)splitViewController collapseSecondaryViewController:(UIViewController *)secondaryViewController ontoPrimaryViewController:(UIViewController *)primaryViewController {
    
    // This delegate method is called every time we click on Root View Controller (also when we implement hiding the RootViewController on the "iPad" (collapse)
    return self.shouldCollapseDetailViewController;
}


// Pass the value to detail view controller in segue.
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    UINavigationController *nc = [segue destinationViewController];
    
    nc.topViewController.navigationItem.title = self.data[self.tableView.indexPathForSelectedRow.section][@"cells"][self.tableView.indexPathForSelectedRow.row];
}


@end
