//
//  Networking.h
//  Grid-Giphy
//
//  Created by DetroitLabs on 9/6/16.
//  Copyright © 2016 DetroitLabs. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Networking : NSObject
@property (strong, nonatomic) NSURLSession *session;
@property (strong, nonatomic) NSURLSessionConfiguration *config;
@property (strong, nonatomic) NSURLSessionDataTask *task;
@property (strong, nonatomic) NSMutableArray *finalArr;


- (void)taskCreationWithURL:(NSURL *)url;
- (void)parseData:(NSData *)data;


@end
