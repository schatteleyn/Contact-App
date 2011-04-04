#import "GSError.h"

@implementation GSError

@synthesize message;

+(id) errorWithJsonObject:(NSDictionary*) object {
	return [[[GSError alloc] initWithJsonObject:object] autorelease];
}

-(id) initWithJsonObject:(NSDictionary*) object {
	self = [super initWithDomain:@"Google Error" code:[[object valueForKey:@"code"] intValue] userInfo:nil];
	if (self) {
		message = [NSString stringWithString:[object valueForKey:@"message"]];
        
		return self;
	}
	else {
		return nil;
	}
}

-(NSString*) localizedDescription {
	return [NSString stringWithString:message];
}

@end
