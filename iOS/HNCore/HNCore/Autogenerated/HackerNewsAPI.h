//
//  Generated by the J2ObjC translator.  DO NOT EDIT!
//  source: ../../../HNCore/Java-core/src/main//java/io/ernesto/hn/HackerNewsAPI.java
//

#include "J2ObjC_header.h"

#pragma push_macro("INCLUDE_ALL_HackerNewsAPI")
#ifdef RESTRICT_HackerNewsAPI
#define INCLUDE_ALL_HackerNewsAPI 0
#else
#define INCLUDE_ALL_HackerNewsAPI 1
#endif
#undef RESTRICT_HackerNewsAPI

#if __has_feature(nullability)
#pragma clang diagnostic push
#pragma GCC diagnostic ignored "-Wnullability-completeness"
#endif

#if !defined (IOEHackerNewsAPI_) && (INCLUDE_ALL_HackerNewsAPI || defined(INCLUDE_IOEHackerNewsAPI))
#define IOEHackerNewsAPI_

@class IOSObjectArray;

@interface IOEHackerNewsAPI : NSObject

#pragma mark Public

- (instancetype)init;

- (IOSObjectArray * __nullable)fetch;

- (void)next;

@end

J2OBJC_EMPTY_STATIC_INIT(IOEHackerNewsAPI)

FOUNDATION_EXPORT void IOEHackerNewsAPI_init(IOEHackerNewsAPI *self);

FOUNDATION_EXPORT IOEHackerNewsAPI *new_IOEHackerNewsAPI_init() NS_RETURNS_RETAINED;

FOUNDATION_EXPORT IOEHackerNewsAPI *create_IOEHackerNewsAPI_init();

J2OBJC_TYPE_LITERAL_HEADER(IOEHackerNewsAPI)

@compatibility_alias IoErnestoHnHackerNewsAPI IOEHackerNewsAPI;

#endif


#if __has_feature(nullability)
#pragma clang diagnostic pop
#endif
#pragma pop_macro("INCLUDE_ALL_HackerNewsAPI")