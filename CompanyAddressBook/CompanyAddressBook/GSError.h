#import <Foundation/Foundation.h>

@interface GSError : NSError {
	NSString*	message;
}

@property(nonatomic, retain) NSString*	message;

+(id) errorWithJsonObject:(NSDictionary*) object;
-(id) initWithJsonObject:(NSDictionary*) object;

@end