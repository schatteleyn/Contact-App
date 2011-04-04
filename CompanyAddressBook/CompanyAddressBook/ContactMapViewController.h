//
//  ContactMapViewController.h
//  CompanyAddressBook
//
//  Created by Nicolas VERINAUD on 31/03/11.
//  Copyright 2011 SUPINFO. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface ContactMapViewController : UIViewController <MKMapViewDelegate> 
{
    //we need the map kit framework
    IBOutlet MKMapView *mapView;
    NSMutableArray *contacts;
    MKPlacemark *mPlacemark;

}

@property (nonatomic,retain) NSMutableArray *contacts;

@end
