//
//  ResultItem.m
//  CompanyAddressBook
//
//  Created by Simon on 04/04/11.
//  Copyright 2011 Supinfo. All rights reserved.
//

#import "ResultItem.h"


@implementation ResultItem

@synthesize kind;
@synthesize title;
@synthesize htmlTitle;
@synthesize link;
@synthesize displayLink;
@synthesize snippet;
@synthesize htmlSnippet;
@synthesize pagemap;

+(id) itemWithJsonObject:(NSDictionary *)object {
	return [[[ResultItem alloc] initWithJsonObject:object] autorelease];
}

-(id) initWithJsonObject:(NSDictionary *)object {
	self = [super init];
	if (self) {
		kind = [NSString stringWithString:[object valueForKey:@"kind"]];
		title = [NSString stringWithString:[object valueForKey:@"title"]];
		htmlTitle = [NSString stringWithString:[object valueForKey:@"htmlTitle"]];
		link = [NSURL URLWithString:[object valueForKey:@"link"]];
		displayLink = [NSURL URLWithString:[object valueForKey:@"displayLink"]];
		snippet = [NSString stringWithString:[object valueForKey:@"snippet"]];
		htmlSnippet = [NSString stringWithString:[object valueForKey:@"htmlSnippet"]];
		pagemap = [NSDictionary dictionaryWithDictionary:[object valueForKey:@"pagemap"]];
        
		return self;
	}
	else {
		return nil;
	}
}

-(NSString*) description {
	return [NSString stringWithFormat:@"%@ - %@", kind, title];
}

-(void) dealloc {
	[super dealloc];
}

@end

