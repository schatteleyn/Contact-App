//
//  CompanyAddressBookAppDelegate.h
//  CompanyAddressBook
//
//  Created by Nicolas VERINAUD on 31/03/11.
//  Copyright 2011 SUPINFO. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>

@interface CompanyAddressBookAppDelegate : NSObject <UIApplicationDelegate> {

    UIWindow *_window;
	UINavigationController *_navigationController;
	
	NSString *databaseName;
	NSString *databasePath;
	
	NSMutableArray *contacts;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UINavigationController *navigationController;
@property (nonatomic, retain) NSMutableArray *contacts;
@end
