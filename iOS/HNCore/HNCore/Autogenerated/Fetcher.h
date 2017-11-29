//
//  Generated by the J2ObjC translator.  DO NOT EDIT!
//  source: ../../../HNCore/Java-core/src/main//java/io/ernesto/hn/Fetcher.java
//

#include "J2ObjC_header.h"

#pragma push_macro("INCLUDE_ALL_Fetcher")
#ifdef RESTRICT_Fetcher
#define INCLUDE_ALL_Fetcher 0
#else
#define INCLUDE_ALL_Fetcher 1
#endif
#undef RESTRICT_Fetcher

#if !defined (IOEFetcher_) && (INCLUDE_ALL_Fetcher || defined(INCLUDE_IOEFetcher))
#define IOEFetcher_

@interface IOEFetcher : NSObject

#pragma mark Public

- (instancetype)initWithNSString:(NSString *)baseURL;

- (NSString *)fetchURLSegment:(NSString *)segment;

@end

J2OBJC_STATIC_INIT(IOEFetcher)

FOUNDATION_EXPORT void IOEFetcher_initWithNSString_(IOEFetcher *self, NSString *baseURL);

FOUNDATION_EXPORT IOEFetcher *new_IOEFetcher_initWithNSString_(NSString *baseURL) NS_RETURNS_RETAINED;

FOUNDATION_EXPORT IOEFetcher *create_IOEFetcher_initWithNSString_(NSString *baseURL);

J2OBJC_TYPE_LITERAL_HEADER(IOEFetcher)

@compatibility_alias IoErnestoHnFetcher IOEFetcher;

#endif

#pragma pop_macro("INCLUDE_ALL_Fetcher")