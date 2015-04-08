//
//  MyURLCache.m
//  SampleApp
//
//  Created by matoh on 2015/04/01.
//  Copyright (c) 2015年 iti. All rights reserved.
//

#import "MyURLCache.h"

@implementation MyURLCache

- (NSCachedURLResponse *)cachedResponseForRequest:(NSURLRequest *)request {
    return nil;
}

- (void)storeCachedResponse:(NSCachedURLResponse *)cachedResponse forRequest:(NSURLRequest *)request {
    NSLog(@"storeCachedResponse[%@][%zd]", request, [cachedResponse storagePolicy] );
    
    NSCachedURLResponse *newCachedResponse = [[NSCachedURLResponse alloc] initWithResponse:[cachedResponse response]
                                                                                      data:[cachedResponse data]
                                                                                  userInfo:[cachedResponse userInfo]
                                                                             storagePolicy:NSURLCacheStorageAllowedInMemoryOnly];
    

    [super storeCachedResponse:newCachedResponse forRequest:request];
    
}

@end
