//
//  FoodTableViewController.m
//  onboarding-test
//
//  Created by Mateusz Szlosek on 10.01.2016.
//  Copyright © 2016 slozo. All rights reserved.
//

#import "FeedTableViewController.h"

@interface FeedTableViewController () <UIPopoverPresentationControllerDelegate>

@end

@implementation FeedTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 100;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// Fix for tableView without NavigationBar - scroll under status bar.

-(void)viewDidAppear:(BOOL)animated
{
    self.tableView.contentInset = UIEdgeInsetsMake(self.topLayoutGuide.length, 0.0f, 0.0f, 0.0f);
    [self.tableView setContentOffset:
                    CGPointMake(0, -self.tableView.contentInset.top) animated:YES];
}

// It's used instead of didRotateToInterfaceOrientation

-(void)willTransitionToTraitCollection:(UITraitCollection *)newCollection withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
    // Code is called before actual "rotation", context has properties for animations etc.
    
    BOOL shouldScroll = fabs(self.tableView.contentOffset.y - self.topLayoutGuide.length) < DBL_EPSILON;
    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
    } completion:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
        
        // It's called after the "rotation" and after changing for example split screen width.
        
        self.tableView.contentInset = UIEdgeInsetsMake(self.topLayoutGuide.length, 0.0f, 0.0f, 0.0f);
        if (shouldScroll) {
            [self.tableView setContentOffset:
             CGPointMake(0, -self.tableView.contentInset.top) animated:YES];
        }
    }];
}

// Here's the code for performing the segue from button on the dynamic cell.
- (IBAction)presentDirections:(id)sender {
    
    [self performSegueWithIdentifier:@"mapSegue" sender:sender];
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 7;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"feedCell" forIndexPath:indexPath];
    
    // Rounded rect image
    
    UIView *image = [cell viewWithTag:1000];
    image.layer.cornerRadius = CGRectGetWidth(image.bounds) / 2;
    image.layer.masksToBounds = YES;
    
    // Set the longer text in order to test dynamic cell height.
    
    UILabel *txtLabel = [cell viewWithTag:123];
    txtLabel.numberOfLines = 0;
    txtLabel.text = @"jsnld lkanlknl knalkndla dlakslsdlk nsld lsdkla skdnl askndlasn ldk alkdnl akdla kn d";
    
    // "iPad" fix for transparent backkground (in the runtime clearColor is overriden from storyboard on "iPad"
    
    cell.backgroundColor = [UIColor clearColor];
    cell.contentView.backgroundColor = [UIColor clearColor];
    
    // Configure the cell...
    
    return cell;
}




#pragma mark - Navigation

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    if ([segue.identifier isEqualToString:@"mapSegue"]) {
        if ([segue.destinationViewController.presentationController isKindOfClass:[UIPopoverPresentationController class]]) {
            UIPopoverPresentationController *presentation = (UIPopoverPresentationController *)segue.destinationViewController.presentationController;
            
            // Set the delegate in order to distinguish "iPad" from "iPhone" for different popovers.
            
            presentation.delegate = self;
            UIView *senderView = sender;
            presentation.sourceView = senderView;
            presentation.sourceRect = senderView.bounds;
            
            // By default hide Navigation controller, we're going to show it on "iPhone" later
            UINavigationController *nc = segue.destinationViewController;
            nc.navigationBarHidden = YES;
        }
    }
}

-(void)dismiss
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(UIViewController *)presentationController:(UIPresentationController *)controller viewControllerForAdaptivePresentationStyle:(UIModalPresentationStyle)style
{
    // This is called in "iPhone" size, where popover is changed to modal view.
    
    UIBarButtonItem *bbi = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(dismiss)];
    UINavigationController *nc = (UINavigationController *)controller.presentedViewController;
    nc.navigationBarHidden = NO;
    nc.topViewController.navigationItem.leftBarButtonItem = bbi;
    return controller.presentedViewController;
}

// Not needed, now "traitCollection" version is called instead.
-(UIModalPresentationStyle)adaptivePresentationStyleForPresentationController:(UIPresentationController *)controller
{
    return UIModalPresentationFullScreen;
}

-(UIModalPresentationStyle)adaptivePresentationStyleForPresentationController:(UIPresentationController *)controller traitCollection:(UITraitCollection *)traitCollection
{
    // Show it as popover in the regular size ("iPad")
    if (traitCollection.horizontalSizeClass == UIUserInterfaceSizeClassRegular) {
        return UIModalPresentationPopover;
    }
    
    // Show it as modal view controller otherwise
    return UIModalPresentationFullScreen;
}
 
@end
