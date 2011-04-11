//
//  CompanyAddressBookAppDelegate.m
//  CompanyAddressBook
//
//  Created by florian petit on 26/02/11.
//  Copyright 2011 Supinfo. All rights reserved.
//

#import "CompanyAddressBookAppDelegate.h"
#import "ContactsTableViewController.h"
#import "Contact.h"
#import "SQLmanager.h"

@implementation CompanyAddressBookAppDelegate


@synthesize window=_window;
//@synthesize contacts;

@synthesize navigationController=_navigationController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
	/*[self initDatabase];
	[self checkAndCreateDatabase];
	
	// Query the database for all animal records and construct the "animals" array
	[self readContactsFromDatabase];*/
	
	// Creation de l'instance (le constructeur est donc initie)
    SQLmanager *sqlManager = [[SQLmanager alloc] initDatabase];

    //Execution de la methode de validation de l'existance de la BD
    [sqlManager checkAndCreateDatabaseWithOverwrite:NO];
	
	
	
    //Evitons les fuites memoire
    [sqlManager release];
	
	[self.window addSubview:self.navigationController.view];
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}


/*-(id) initDatabase{
	//On définit le nom de la base de données
	databaseName = @"sqlDatabase.sql";
	NSLog(@"%@", databaseName);
	// On récupère le chemin
	NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDir = [documentPaths objectAtIndex:0];
	databasePath = [documentsDir stringByAppendingPathComponent:databaseName];
	
	return self;
}

-(void) checkAndCreateDatabase{
	// On vérifie si la BDD a déjà été sauvegardée dans l'iPhone de l'utilisateur
	BOOL success;
	
		
	// Crée un objet FileManagerCreate qui va servir à vérifer le status
	// de la base de données et de la copier si nécessaire
	NSFileManager *fileManager = [NSFileManager defaultManager];
	
	// Vérifie si la BDD a déjà été créée  dans les fichiers system de l'utilisateur
	success = [fileManager fileExistsAtPath:databasePath];
	NSLog(@"%@", fileManager);

	// Si la BDD existe déjà "return" sans faire la suite
	//if(success) return;
	
	NSLog(@"lol");
	
	// Si ce n'est pas le cas alors on copie la BDD de l'application vers les fichiers système de l'utilisateur
	
	// On récupère le chemin vers la BDD dans l'application
	NSString *databasePathFromApp = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:databaseName];
	
	NSLog(@"%@", databasePathFromApp);
	
	// On copie la BDD de l'application vers le fichier systeme de l'application
	[fileManager copyItemAtPath:databasePathFromApp toPath:databasePath error:nil];
	
	[fileManager release];
}

-(void) readContactsFromDatabase {
	// Déclaration de l'objet database
	sqlite3 *database;
	
	// Initialisation du tableau de score
	contacts = [[NSMutableArray alloc] init];
	
	NSLog(@"lol");
	
	// On ouvre la BDD à partir des fichiers système
	//if(sqlite3_open([databasePath UTF8String], &database) == SQLITE_OK) {
		// Préparation de la requête SQL qui va permettre de récupérer les objets score de la BDD
		//en triant les scores dans l'ordre décroissant
		//const char *sqlStatement = "select * FROM contacts";
		
		//NSLog(@"%@", sqlStatement);
		NSLog(@"lol");
		//création d'un objet permettant de connaître le status de l'exécution de la requête
		sqlite3_stmt *compiledStatement;
		
		//if(sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK) {
			// On boucle tant que l'on trouve des objets dans la BDD
			while(sqlite3_step(compiledStatement) == SQLITE_ROW) {
				// On lit les données stockées dans le fichier sql
				// Dans la première colonne on trouve du texte que l'on place dans un NSString
				NSString *Fname = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 4)];
				// Dans la deuxième colonne on récupère le score dans un NSInteger
				NSInteger id = sqlite3_column_int(compiledStatement, 1);
				NSLog(@"%@", Fname);
				// On crée un objet Score avec les pramètres récupérés dans la BDD
				Contact *contact = [[Contact alloc] init];
				
				contact.firstName = Fname;
				contact.identifier = id;
				
				// On ajoute le score au tableau
				[contacts addObject:contact];
				[contact release];
			//Ò®}
		//}
		// On libère le compiledStamenent de la mémoire
		sqlite3_finalize(compiledStatement);
		
}
	//On ferme la BDD
	sqlite3_close(database);
	
}*/


- (void)dealloc
{
    [_window release];
    [_navigationController release];
    [super dealloc];
}

@end
