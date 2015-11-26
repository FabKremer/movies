//
//  KMDiscoverMapSource.m
//  TheMovieDB
//
//  Created by Kevin Mindeguia on 03/02/2014.
//  Copyright (c) 2014 iKode Ltd. All rights reserved.
//

#import "OptionsSource.h"
#import "KMSourceConfig.h"
#import "AFNetworking.h"
#import "KMMovie.h"

#define kOptionsUrlFormat @"%@/%@"

@implementation OptionsSource

#pragma mark -
#pragma mark Init Methods

+ (OptionsSource*)optionsSource;
{
    static dispatch_once_t onceToken;
    static OptionsSource* instance = nil;
    dispatch_once(&onceToken, ^{
        instance = [[OptionsSource alloc]init];
    });
    return instance;
}

#pragma mark -
#pragma mark Request Methods

- (void)getOptionsListForType:(NSString *)type completion:(OptionsListCompletionBlock)completionBlock
{
    if (completionBlock)
    {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        
        [manager GET:[self prepareUrlWithType:type] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject)
         {
             NSLog(@"JSON: %@", responseObject);
             NSDictionary* infosDictionary = [self dictionaryFromResponseData:operation.responseData jsonPatternFile:@"KMOptionsSourceJsonPattern.json"];
             dispatch_async(dispatch_get_main_queue(), ^{
                 [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                 completionBlock([self processResponseObject:infosDictionary], nil);
             });
         }
             failure:^(AFHTTPRequestOperation *operation, NSError *error)
         {
             NSLog(@"Error: %@", error);
             dispatch_async(dispatch_get_main_queue(), ^{
                 [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                 NSString* errorString = error.localizedDescription;
                 if ([errorString length] == 0)
                     errorString = nil;
                 completionBlock(nil, errorString);
             });
         }];
    }
}

#pragma mark -
#pragma mark Data Parsing

- (NSArray*)processResponseObject:(NSDictionary*)data
{
    if (data == nil)
        return nil;
    NSArray* itemsList = [NSArray arrayWithArray:[data objectForKey:@"options"]];
    NSMutableArray* sortedArray = [[NSMutableArray alloc] init];
    for (NSString* option in itemsList)
    {
        [sortedArray addObject:option];
    }
    return sortedArray;
}


#pragma mark -
#pragma mark Private

- (NSString*)prepareUrlWithType: (NSString*)type
{
    return [NSString stringWithFormat:kOptionsUrlFormat, [KMSourceConfig config].serverHost, type];
}

@end
