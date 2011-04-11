//
//  SQLmanager.h
//  CompanyAddressBook
//
//  Created by Thomas on 4/11/11.
//  Copyright 2011 Supinfo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>


@interface SQLmanager : NSObject {
	
	NSString *databaseName; //Nom du fichier de la BDD
	NSString *databasePath; //Chemin BDD

}

-(id) initDatabase; //Constructeur
-(void)checkAndCreateDatabaseWithOverwrite:(BOOL)overwriteDB; //Valider et creer la base

-(NSString *)getContact; //Obtenir un utilisation alleatoire
-(void)addUsernameWithName:(NSString *)userName; //Aout d'un utilisateur
-(NSNumber *)getUserCount; //Retroune le nombre d'utilisateur

@end
