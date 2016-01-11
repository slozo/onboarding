//
//  MapViewController.m
//  onboarding
//
//  Created by Mateusz Szlosek on 09.01.2016.
//  Copyright © 2016 slozo. All rights reserved.
//

#import "MapViewController.h"
@import MapKit;

@interface MapViewController ()
@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // This is a sample code for showing the Point Annotation on the map.
    CLLocation *initialLocation = [[CLLocation alloc] initWithLatitude:51.103413 longitude:17.021449];
    CLLocationDistance distance = 1000;
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(initialLocation.coordinate, distance * 2, distance * 2);
    [self.mapView setRegion:region];
    MKPointAnnotation *pointAnnotation = [[MKPointAnnotation alloc] init];
    pointAnnotation.title = @"Caladian";
    pointAnnotation.coordinate = initialLocation.coordinate;
    
    [self.mapView addAnnotation:pointAnnotation];
    
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
