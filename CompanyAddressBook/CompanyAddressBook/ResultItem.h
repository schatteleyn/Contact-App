#import <Foundation/Foundation.h>

@interface ResultItem : NSObject {
	NSString*		kind;
	NSString*		title;
	NSString*		htmlTitle;
	NSURL*			link;
	NSURL*			displayLink;
	NSString*		snippet;
	NSString*		htmlSnippet;
	NSDictionary*	pagemap;
}

@property(nonatomic, retain, readonly)	NSString*		kind;
@property(nonatomic, retain, readonly)	NSString*		title;
@property(nonatomic, retain, readonly)	NSString*		htmlTitle;
@property(nonatomic, retain, readonly)	NSURL*			link;
@property(nonatomic, retain, readonly)	NSURL*			displayLink;
@property(nonatomic, retain, readonly)	NSString*		snippet;
@property(nonatomic, retain, readonly)	NSString*		htmlSnippet;
@property(nonatomic, retain, readonly)	NSDictionary*	pagemap;

+(id) itemWithJsonObject:(NSDictionary*) object;
-(id) initWithJsonObject:(NSDictionary*) object;

@end
