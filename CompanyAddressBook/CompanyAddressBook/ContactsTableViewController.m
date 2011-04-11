//
//  ContactsTableViewController.m
//  CompanyAddressBook
//
//  Created by Nicolas VERINAUD on 31/03/11.
//  Copyright 2011 SUPINFO. All rights reserved.
//

#import "ContactsTableViewController.h"
#import "Contact.h"
#import "ContactDetailsViewController.h"
#import "ContactMapViewController.h"
#import "JSON.h"
#import "SQLmanager.h"

@interface ContactsTableViewController()

@property (nonatomic, retain) NSMutableArray *sectionsArray;
@property (nonatomic, retain) UILocalizedIndexedCollation *collation;


- (void)configureSections;

@end



@implementation ContactsTableViewController

@synthesize contacts, sectionsArray, collation, showAllBtn, contactTableViewCell;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
	[sectionsArray release];
	[contacts release];
	[showAllBtn release];
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
	
    self.title =@"Contacts";
    
    showAllBtn = [[UIBarButtonItem alloc] initWithTitle:@"map" style:UIBarButtonSystemItemSearch target:self action:@selector(showMap:)];
    self.navigationItem.rightBarButtonItem = showAllBtn;
	
	
	//création d'un string avec le contenu du JSON récupéré à partir de l'URL
	NSString *myJSON = [NSString stringWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://www.labo-mobile-dev.eu/project/export.html"]] encoding:NSUTF8StringEncoding error:nil];
	 
	
	//Parsage du JSON à l'aide du framework importé
	NSDictionary *json    = [myJSON JSONValue];
	
	//récupération du tableau de contacts
	NSArray *listeContact    =  [json objectForKey:@"contacts"];
	
	contacts = [[NSMutableArray alloc] init];
	
	
	//On parcourt la liste de joueurs
	for (NSDictionary *dic in listeContact) {
		
		//création d'un objet Joueur
		Contact *contact = [[Contact alloc] init];
		
		//renseignement du nom
		contact.firstName = [dic objectForKey:@"first_name"];
		
		//renseingement du score
		contact.lastName = [dic objectForKey:@"last_name"];
		contact.address = [dic objectForKey:@"address"];
		contact.category = [dic objectForKey:@"category"];
		contact.email = [dic objectForKey:@"email"];
		contact.phoneNumber = [dic objectForKey:@"phonen"];
		
		//ajout à la liste
		[contacts addObject:contact];
		
		//libération de la mémoire
		[contact release];
	}
	
	
	SQLmanager *sqlManager = [[SQLmanager alloc] initDatabase];
	
	NSString *addContacts = [sqlManager getContact];
	
	[contacts addObject:addContacts];
	
	
    [self configureSections];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

//JSON Parser


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    //we can now get the number of sections from section array
    return [sectionsArray count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    //we have multiple sections, return number of rows in a section
    return [[sectionsArray objectAtIndex:section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"myCustomContactTableViewCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        [[NSBundle mainBundle] loadNibNamed:@"ContactTableViewCell" owner:self options:nil];
		cell = contactTableViewCell;
        contactTableViewCell = nil;
    }
    
    Contact *c1 = (Contact *)[[sectionsArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
	
	//getting labels from our cell using their tags
	UILabel *label;
	label = (UILabel *)[cell viewWithTag:1];
	label.text = [c1 firstName];
	label = (UILabel *)[cell viewWithTag:2];
	label.text = [c1 lastName];
	label = (UILabel *)[cell viewWithTag:3];
	label.text = [c1 category];
	
	
    return cell;
}

/*
Section-related methods: Retrieve the section titles and section index titles from the collation.
*/
//display section title
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [[self.collation sectionTitles] objectAtIndex:section];
}

//display index
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    return [self.collation sectionIndexTitles];
}
//get section for title pressed in index
- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    return [self.collation sectionForSectionIndexTitleAtIndex:index];
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    
     ContactDetailsViewController *detailViewController = [[ContactDetailsViewController alloc] init];
     // select the contact at row ... in section ...
    detailViewController.contactToDisplay = (Contact *) [[sectionsArray objectAtIndex:indexPath.section]objectAtIndex:indexPath.row];
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     [detailViewController release];
}

/*
    This method is used to configure the table view sections (create an array of sections)
*/
- (void)configureSections
{    
    // Get the current collation and keep a reference to it.
	self.collation = [UILocalizedIndexedCollation currentCollation];
	
	NSInteger index, sectionTitlesCount = [[self.collation sectionTitles] count];
	
	NSMutableArray *newSectionsArray = [[NSMutableArray alloc] initWithCapacity:sectionTitlesCount];
    
    // Set up the sections array: elements are mutable arrays that will contain the contacts for that section.
	for (index = 0; index < sectionTitlesCount; index++) {
		NSMutableArray *array = [[NSMutableArray alloc] init];
		[newSectionsArray addObject:array];
		[array release];
	}
	
	// Segregate the contacts into the appropriate arrays.
	for (Contact *contact in contacts) {
		
		// Ask the collation which section number the time zone belongs in, based on its  lastname.
		NSInteger sectionNumber = [self.collation sectionForObject:contact collationStringSelector:@selector(lastName)];
		
		// Get the array for the section.
		NSMutableArray *sectionContacts = [newSectionsArray objectAtIndex:sectionNumber];
		
		//  Add the contact to the section.
		[sectionContacts addObject:contact];
	}
	
	// Now that all the data's in place, each section array needs to be sorted.
	for (index = 0; index < sectionTitlesCount; index++) {
		
		NSMutableArray *contactsArrayForSection = [newSectionsArray objectAtIndex:index];
		
		// If the table view or its contents were editable, you would make a mutable copy here.
		NSArray *sortedContactsArrayForSection = [self.collation sortedArrayFromArray:contactsArrayForSection collationStringSelector:@selector(lastName)];
		
		// Replace the existing array with the sorted array.
		[newSectionsArray replaceObjectAtIndex:index withObject:sortedContactsArrayForSection];
	}
	
	self.sectionsArray = newSectionsArray;
	[newSectionsArray release];
}


- (IBAction)showMap:(id)sender 
{
    // show the map
    ContactMapViewController *mapViewController = [[ContactMapViewController alloc] init];
    mapViewController.contacts = self.contacts;
    [self.navigationController pushViewController:mapViewController animated:YES];
    [mapViewController release];
}

@end
