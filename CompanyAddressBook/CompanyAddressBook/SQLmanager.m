//
//  SQLmanager.m
//  CompanyAddressBook
//
//  Created by Thomas on 4/11/11.
//  Copyright 2011 Supinfo. All rights reserved.
//

#import "SQLmanager.h"
#import "Contact.h"
#import "CompanyAddressBookAppDelegate.h"
#import "ContactsTableViewController.h"
#import "ContactDetailsViewController.h"
#import "ContactMapViewController.h"


@implementation SQLmanager

@synthesize contacts;


//Constructeur 

-(id) initDatabase{
	
    if (self = [super init]) {
        //Nom de la base de données
        databaseName = @"sqlDatabase.sql";
		
        // Obtenir le chemins complet de la base de donées
        NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDir = [documentPaths objectAtIndex:0];
        databasePath = [documentsDir stringByAppendingPathComponent:databaseName];
    }
	
    return self;
}

//Validation et creation de la base de donnees
-(void) checkAndCreateDatabaseWithOverwrite:(BOOL)overwriteDB {
    // BOOL qui servira de verification de l'existance de la BD
    BOOL success;
	
    // Objet pour faire des operations sur le systeme de fichiers
    NSFileManager *fileManager = [NSFileManager defaultManager];
	
    // Verifier de la BD dans databasePath
    success = [fileManager fileExistsAtPath:databasePath];
	
    // Retourner si la BD existe et que le BOOL overwriteDB n'est pas à oui
    if (success && !overwriteDB) {
        return;
    }
	
    // Chaines de caracteres avec le chemin de la BD dans l'app Bundle
    NSString *databasePathFromApp = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:databaseName];
	
    // Copier la BD de l'app Bundle vers le repertoire de documents
    [fileManager copyItemAtPath:databasePathFromApp toPath:databasePath error:nil];
}

//Creation d'une liste des noms de colonnes pour obtenir son Index
- (NSDictionary *)indexByColumnName:(sqlite3_stmt *)init_statement {
	
    //Tableau des cles et des valeurs qui seront trouvees
    NSMutableArray *keys = [[NSMutableArray alloc] init];
    NSMutableArray *values = [[NSMutableArray alloc] init];
	
    //Nombre de colonnes
    int num_fields = sqlite3_column_count(init_statement);
	
    //Pour chaque colonne Ajout des donnees dans les Tableaux respectifs
    for(int index_value = 0; index_value < num_fields; index_value++) {
        const char* field_name = sqlite3_column_name(init_statement, index_value);
        if (!field_name){
            field_name="";
        }
        NSString *col_name = [NSString stringWithUTF8String:field_name];
        NSNumber *index_num = [NSNumber numberWithInt:index_value];
        [keys addObject:col_name];
        [values addObject:index_num];
    }
    //Creation du dictionnaire a partir des cles et valeurs obtenues
    NSDictionary *dictionary = [NSDictionary dictionaryWithObjects:values forKeys:keys];
	
	//NSLog(@"lol");
	
    // Deallocation des tableaux
    [keys release];
    [values release];
	
    // Retourne le dictionnaire
    return dictionary;
}

-(NSMutableArray *)getContacts {
    //Declaration d'un objet SQLITE
    sqlite3 *database;
	contacts = [[NSMutableArray alloc] init];
    //Declaration de notre String qui sera retourne
    //NSString *contactString = [NSString string];
	
    // Ouverture de la base de donnees
    if(sqlite3_open([databasePath UTF8String], &database) == SQLITE_OK) {
		
        //Chaine de caracteres de la requete
        const char *sqlStatement = "SELECT * FROM contacts";
		
        //Creation de l'objet statement
        sqlite3_stmt *compiledStatement;
		
        //Compilation de la requete et verification du succes
        if(sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK) {
			
            // Creation d'un dictionnaire des noms de colonnes
            NSDictionary *dictionary = [self indexByColumnName:compiledStatement];
			
			
			
            while(sqlite3_step(compiledStatement) == SQLITE_ROW) {
				
                NSString *firstName = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, [[dictionary objectForKey:@"first_name"] intValue])];
				NSString *lastName = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, [[dictionary objectForKey:@"last_name"] intValue])];
				NSString *category = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, [[dictionary objectForKey:@"category"] intValue])];
				NSString *email = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, [[dictionary objectForKey:@"email"] intValue])];
				NSString *phoneNumber = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, [[dictionary objectForKey:@"phonen"] intValue])];
				NSString *address = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, [[dictionary objectForKey:@"address"] intValue])];
				
				// Create a new animal object with the data from the database
				Contact *contact = [[Contact alloc] init];
				
				contact.firstName = firstName; 
				contact.lastName=lastName; 
				contact.category=category;
				contact.email=email; 
				contact.phoneNumber=phoneNumber; 
				contact.address=address;
				
				// Add the animal object to the animals Array
				[contacts addObject:contact];
				
				[contact release];
				
            }
        }
        else {
            //Envois une exception en cas de probleme de requete
            NSAssert1(0, @"Erreur :. '%s'", sqlite3_errmsg(database));
        }
		
        // Finalisation de la requete pour liberer la memoire
        sqlite3_finalize(compiledStatement);
		
    }
    else {
        //Envois une exception en cas de probleme d'ouverture
        NSAssert(0, @"Erreur d'ouverture de la base de donnees");
    }
	
    //Fermer la base de donnees
    sqlite3_close(database);
	

	
    //Retourne la valeur
    return contacts;
}

//Ajout d'un utilisateur
-(NSMutableArray *)addContacts {
    //Declaration d'un objet SQLITE
    sqlite3 *database;
	
	contacts = [[NSMutableArray alloc] init];
	
	Contact *contact1 = [[Contact alloc] init];
	
    // Ouverture de la base de donnees
    if(sqlite3_open([databasePath UTF8String], &database) == SQLITE_OK) {
		
        //Chaine de caracteres de la requete
        const char *sqlStatement = "INSERT INTO contacts (id, address, last_name, first_name, category, email, phonen) VALUES (?, ?, ?, ?, ?, ?, ?)";
		
        //Creation de l'objet statement
        sqlite3_stmt *compiledStatement;
		
        //Compilation de la requete et verification du succes
        if(sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK) {
			
            //Ajout du texte dans la cellule
            sqlite3_bind_text(compiledStatement, 1, [contact1.address UTF8String], -1, SQLITE_TRANSIENT);
			sqlite3_bind_text(compiledStatement, 2, [contact1.lastName UTF8String], -1, SQLITE_TRANSIENT);
			sqlite3_bind_text(compiledStatement, 3, [contact1.firstName UTF8String], -1, SQLITE_TRANSIENT);
			sqlite3_bind_text(compiledStatement, 4, [contact1.category UTF8String], -1, SQLITE_TRANSIENT);
			sqlite3_bind_text(compiledStatement, 5, [contact1.email UTF8String], -1, SQLITE_TRANSIENT);
			sqlite3_bind_text(compiledStatement, 6, [contact1.phoneNumber UTF8String], -1, SQLITE_TRANSIENT);
			
            //Evaluation du succes de la requete
            if(SQLITE_DONE != sqlite3_step(compiledStatement)) {
                //Envois une exception en cas de probleme de requete
                NSAssert1(0, @"Erreur :. '%s'", sqlite3_errmsg(database));
            }
            // Finalisation de la requete pour liberer la memoire
            sqlite3_finalize(compiledStatement);
        }
        else {
            //Envois une exception en cas de probleme de requete
            NSAssert1(0, @"Erreur :. '%s'", sqlite3_errmsg(database));
        }
		
    }
    else {
        //Envois une exception en cas de probleme d'ouverture
        NSAssert(0, @"Erreur d'ouverture de la base de donnees");
    }
	
	[contacts addObject:contact1];
	[contact1 release];
    //Fermer la base de donnees
    sqlite3_close(database);
	
	return contacts;
	
}
//Retrouve le nombre d'enregistrement
-(NSNumber *)getUserCount {
    //Declaration d'un objet SQLITE
    sqlite3 *database;
	
    //Declaration de notre entier qui sera retourne
    int nbUsers = 0;
	
    // Ouverture de la base de donnees
    if(sqlite3_open([databasePath UTF8String], &database) == SQLITE_OK) {
		
        //Chaine de caracteres de la requete
        const char *sqlStatement = "SELECT count(*) FROM contacts";
		
        //Creation de l'objet statement
        sqlite3_stmt *compiledStatement;
		
        //Compilation de la requete et verification du succes
        if(sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK) {
			
            // Creation d'un dictionnaire des noms de colonnes
            NSDictionary *dictionary = [self indexByColumnName:compiledStatement];
			
            while(sqlite3_step(compiledStatement) == SQLITE_ROW) {
				
                //Assigne la valeur dans la chaine de caracteres
                nbUsers = sqlite3_column_int(compiledStatement, [[dictionary objectForKey:@"count(*)"] intValue]);
				
            }
        }
        else {
            //Envois une exception en cas de probleme de requete
            NSAssert1(0, @"Erreur :. '%s'", sqlite3_errmsg(database));
        }
		
        // Finalisation de la requete pour liberer la memoire
        sqlite3_finalize(compiledStatement);
		
    }
    else {
        //Envois une exception en cas de probleme d'ouverture
        NSAssert(0, @"Erreur d'ouverture de la base de donnees");
    }
	
    //Fermer la base de donnees
    sqlite3_close(database);
	
    //Retourne la valeur
    return [NSNumber numberWithInt:nbUsers];
}

@end
