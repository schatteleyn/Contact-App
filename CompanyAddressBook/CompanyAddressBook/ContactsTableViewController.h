//
//  ContactsTableViewController.h
//  CompanyAddressBook
//
//  Created by florian petit on 27/02/11.
//  Copyright 2011 Supinfo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>


@interface ContactsTableViewController : UITableViewController 
{
    NSMutableArray *contacts;
    NSMutableArray *sectionsArray;
	NSMutableArray *dataToDisplay;
	UILocalizedIndexedCollation *collation; // our index 
    UITableViewCell *contactTableViewCell;
    UIBarButtonItem *showAllBtn;
}

@property (nonatomic, retain) NSMutableArray *contacts;
@property (nonatomic, assign) IBOutlet UITableViewCell *contactTableViewCell;
@property (nonatomic, retain) UIBarButtonItem *showAllBtn;

- (IBAction)showMap:(id)sender;

@end
