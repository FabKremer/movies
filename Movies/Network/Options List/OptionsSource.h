//
//  KMDiscoverMapSource.h
//  TheMovieDB
//
//  Created by Kevin Mindeguia on 03/02/2014.
//  Copyright (c) 2014 iKode Ltd. All rights reserved.
//


#import "KMBaseSource.h"

typedef void (^OptionsListCompletionBlock)(NSArray* data, NSString* errorString);

@interface OptionsSource : KMBaseSource

+ (OptionsSource*)optionsSource;

- (void)getOptionsListForType:(NSString*)type completion:(OptionsListCompletionBlock)completionBlock;

@end
