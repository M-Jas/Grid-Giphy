//
//  Networking.m
//  Grid-Giphy
//
//  Created by DetroitLabs on 9/6/16.
//  Copyright © 2016 DetroitLabs. All rights reserved.
//

#import "Networking.h"
#import "FLAnimatedImage.h"
#import "GiphyCollectionVC.h"

@implementation Networking




- (void)taskCreationWithURL:(NSURL *)url giphyArray:(NSMutableArray *)array{
   
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    _config = [NSURLSessionConfiguration defaultSessionConfiguration];
    _session = [NSURLSession sessionWithConfiguration:_config];

    _task = [_session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) { NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;


        if (httpResponse.statusCode == 200) {
            [self parseData:data];
        
        } else {
            NSLog(@"ERROR MICHAEL: %@", error);
        }
    }];
    [_task resume];
}
    
- (NSMutableArray *)parseData:(NSData *)data {
     NSError *JSONError;
    NSMutableDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error: &JSONError];
    NSMutableArray *arrayFromSerial = [dict valueForKeyPath:@"data.images.downsized.url"];
  
    //
        dispatch_async(dispatch_get_main_queue(), ^{
    //
    //        for (NSString *giphString in array) {
    //            FLAnimatedImage *giph = [FLAnimatedImage animatedImageWithGIFData:[NSData dataWithContentsOfURL:[NSURL URLWithString:giphString]]];
    //            [finalArray addObject:giph];
    //
    //            [self.collectionView reloadData];
    //
    //        }
    //        [self.collectionView reloadData];
    //    });
    
    return arrayFromSerial;
    
    
}



@end
