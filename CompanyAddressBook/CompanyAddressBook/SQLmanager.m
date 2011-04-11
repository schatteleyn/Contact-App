//
//  SQLmanager.m
//  CompanyAddressBook
//
//  Created by Thomas on 4/11/11.
//  Copyright 2011 Supinfo. All rights reserved.
//

#import "SQLmanager.h"


@implementation SQLmanager

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

-(NSString *)getContact {
    //Declaration d'un objet SQLITE
    sqlite3 *database;
	
    //Declaration de notre String qui sera retourne
    NSString *contactString = [NSString string];
	
    // Ouverture de la base de donnees
    if(sqlite3_open([databasePath UTF8String], &database) == SQLITE_OK) {
		
        //Chaine de caracteres de la requete
        const char *sqlStatement = "SELECT first_name FROM contacts";
		
        //Creation de l'objet statement
        sqlite3_stmt *compiledStatement;
		
        //Compilation de la requete et verification du succes
        if(sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK) {
			
            // Creation d'un dictionnaire des noms de colonnes
            NSDictionary *dictionary = [self indexByColumnName:compiledStatement];
			
            while(sqlite3_step(compiledStatement) == SQLITE_ROW) {
				
                //Assigne la valeur dans la chaine de caracteres
                char * str = (char *)sqlite3_column_int(compiledStatement, [[dictionary objectForKey:@"identifier"] intValue]);
                if (!str){
                    str=" ";
                }
				
                //Convertion de la chaine vers un NSString pour retourner la valeur
                contactString = [NSString stringWithUTF8String:str];
				
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
    return contactString;
}

//Ajout d'un utilisateur
-(void)addUsernameWithName:(NSString *)userName {
    //Declaration d'un objet SQLITE
    sqlite3 *database;
	
    // Ouverture de la base de donnees
    if(sqlite3_open([databasePath UTF8String], &database) == SQLITE_OK) {
		
        //Chaine de caracteres de la requete
        const char *sqlStatement = "INSERT INTO userlist (username) VALUES (?)";
		
        //Creation de l'objet statement
        sqlite3_stmt *compiledStatement;
		
        //Compilation de la requete et verification du succes
        if(sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK) {
			
            //Ajout du texte dans la cellule
            sqlite3_bind_text(compiledStatement, 1, [userName UTF8String], -1, SQLITE_TRANSIENT);
			
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
	
    //Fermer la base de donnees
    sqlite3_close(database);
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
        const char *sqlStatement = "SELECT count(*) FROM userlist";
		
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
