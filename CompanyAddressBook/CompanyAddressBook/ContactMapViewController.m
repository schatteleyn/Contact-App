//
//  ContactMapViewController.m
//  CompanyAddressBook
//
//  Created by Nicolas VERINAUD on 31/03/11.
//  Copyright 2011 SUPINFO. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>

#import "ContactMapViewController.h"
#import "Contact.h"
#import "JSON.h"


@interface ContactMapViewController ()

@property(nonatomic,retain) IBOutlet MKMapView *mapView;

@end


@implementation ContactMapViewController
@synthesize mapView, contacts;


- (id)init
{
	self = [self initWithNibName:nil bundle:nil];
	return self;
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        contacts = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)dealloc
{
	[contacts release];
	[mPlacemark release];
	[mapView release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSString *address;
    for (Contact *cont in contacts) {
        address = [cont address];
		CLLocationCoordinate2D location;
		NSString *requestString = [address stringByReplacingOccurrencesOfString:@" " withString:@"+"];
		NSString *jSonresult = [NSString stringWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://maps.googleapis.com/maps/api/geocode/json?address=%@&sensor=true", requestString]] encoding:NSUTF8StringEncoding error:nil];
	   
		//parse Json
		NSDictionary *theDictionary = [jSonresult JSONValue];
		NSArray *items = [[[theDictionary valueForKeyPath:@"results"] valueForKey:@"geometry"] valueForKey:@"location"];
	  
		location.latitude = [[[items objectAtIndex:0] objectForKey:@"lat"] doubleValue];
		location.longitude = [[[items objectAtIndex:0] objectForKey:@"lng"] doubleValue];

		MKCoordinateRegion region;
		region.center = location;
		[mapView setRegion:region animated:NO];
		[mapView regionThatFits:region];
		
		mPlacemark = [[MKPlacemark alloc] initWithCoordinate:location addressDictionary:nil];
		[mapView addAnnotation:mPlacemark];
			address = nil;
    }    
}

- (void)viewDidUnload
{
	self.mapView = nil;
    [super viewDidUnload];
}

@end
