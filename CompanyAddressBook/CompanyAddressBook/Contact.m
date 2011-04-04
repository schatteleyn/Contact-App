//
//  Contact.m
//  CompanyAddressBook
//
//  Created by Nicolas VERINAUD on 31/03/11.
//  Copyright 2011 SUPINFO. All rights reserved.
//

#import "Contact.h"


@implementation Contact
@synthesize identifier,firstName,lastName,email,category,address,phoneNumber;


// basic initializer implementation
- (id)init {
    self = [self initWithId:0 firstname:nil lastname:nil email:nil category:nil adress:nil phonenumber:nil];
    return self;
}

// designated initializer 
-(id)initWithId:(int)ident firstname:(NSString *)fname lastname:(NSString *)lname email:(NSString *)eml category:(NSString *)categ adress:(NSString *)addrs phonenumber:(NSString *)phonen
{
    self = [super init];
    if (self) {
        self.identifier = ident;
        self.firstName = fname;
        self.lastName = lname;
        self.email = eml;
        self.category = categ;
        self.address = addrs;
        self.phoneNumber = phonen;
    }
    return self;
}

// convenience constructor that uses autorelease (no need to release our instance at any time) (not mandatory)...
+(id)ContactWithId:(int)ident firstname:(NSString *)fname lastname:(NSString *)lname email:(NSString *)eml category:(NSString *)categ adress:(NSString *)addrs phonenumber:(NSString *)phonen
{
    Contact *newContact = [[Contact alloc] initWithId:ident firstname:fname lastname:lname email:eml category:categ adress:addrs phonenumber:phonen];
    return [newContact autorelease];

}

//destructor
- (void)dealloc 
{
    [firstName release]; //release attributes that are objects and that had been allocated using initializer
    [lastName release];
    [email release];
    [category release];
    [address release];
    [phoneNumber release];
    [super dealloc];
}


@end
