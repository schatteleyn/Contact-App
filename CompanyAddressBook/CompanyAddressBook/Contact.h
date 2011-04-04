//
//  Contact.h
//  CompanyAddressBook
//
//  Created by Nicolas VERINAUD on 31/03/11.
//  Copyright 2011 SUPINFO. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Contact : NSObject {
    int identifier;
    NSString *firstName;
    NSString *lastName;
    NSString *category;
    NSString *email;
    NSString *phoneNumber;
    NSString *address;
    
    
}
@property (nonatomic) int identifier;
@property (nonatomic, copy) NSString *firstName;
@property (nonatomic, copy) NSString *lastName;
@property (nonatomic, copy) NSString *category;
@property (nonatomic, copy) NSString *email;
@property (nonatomic, copy) NSString *phoneNumber;
@property (nonatomic, copy) NSString *address;


-(id)initWithId:(int)ident firstname:(NSString *)fname lastname:(NSString *)lname email:(NSString *)eml category:(NSString *)categ adress:(NSString *)addrs phonenumber:(NSString *)phonen;

+(id)ContactWithId:(int)ident firstname:(NSString *)fname lastname:(NSString *)lname email:(NSString *)eml category:(NSString *)categ adress:(NSString *)addrs phonenumber:(NSString *)phonen;
@end
