//
//  KMDiscoverMapSource.h
//  TheMovieDB
//
//  Created by Kevin Mindeguia on 03/02/2014.
//  Copyright (c) 2014 iKode Ltd. All rights reserved.
//


#import "KMBaseSource.h"

typedef void (^KMDiscoverListCompletionBlock)(NSArray* data, NSString* errorString);

@interface KMDiscoverSource : KMBaseSource

+ (KMDiscoverSource*)discoverSource;

- (void)getMoviesWithParams:(NSDictionary*)params completion:(KMDiscoverListCompletionBlock)completionBlock;

@end
