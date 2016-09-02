//
//  GiphyCollectionVC.m
//  Grid-Giphy
//
//  Created by DetroitLabs on 9/1/16.
//  Copyright © 2016 DetroitLabs. All rights reserved.
//

#import "GiphyCollectionVC.h"

@interface GiphyCollectionVC () {
    NSMutableArray *giphyArray;
    NSMutableArray *finalArray;
    
}

@end

@implementation GiphyCollectionVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    giphyArray = [[NSMutableArray alloc]init];
    finalArray = [[NSMutableArray alloc]init];
    [self americanPsychoMethod];
    
}

- (void)americanPsychoMethod {
    NSString *urlString = @"http://api.giphy.com/v1/gifs/search?q=american+psycho&api_key=dc6zaTOxFJmzC&limit=5";
    
    NSURL *giphyUrl = [NSURL URLWithString:urlString];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:giphyUrl];
//    NSLog(@"Request %@", request);
    
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
//    NSLog(@"Config: %@", config);
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
//    NSLog(@"SESSION: %@", session);
    
 NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {         NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
        
        if (httpResponse.statusCode == 200) {
            NSError *JSONError;
            NSMutableDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&JSONError];
//            NSLog(@"Dictionay: %@", dict);
            
//            NSArray *responseArray = [dict valueForKeyPath:@"data.images.downsized.url"];
            giphyArray = [dict valueForKeyPath:@"data.images.downsized.url"];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                for (NSString *giph in giphyArray) {
                    NSURL *URLString = [NSURL URLWithString:giph];
                    NSData *data = [NSData dataWithContentsOfURL:URLString];
                    UIImage *psychoImage = [[UIImage alloc] initWithData:data];
//                    UIImage* mygif = [UIImage animatedImageWithAnimatedGIFURL:[NSURL URLWithString:@"http://en.wikipedia.org/wiki/File:Rotating_earth_(large).gif"]];
                    [finalArray addObject:psychoImage];
                    
                }
            
                NSLog(@"Final Array Call 2: %@", finalArray);
                [self.collectionView reloadData];
            });
            [self.collectionView reloadData];
            
        } else {
            NSLog(@"ERROR MICHAEL: %@", error);
        }
    }];
    
    [task resume];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSLog(@"Final Array Table: %@", finalArray);
    return finalArray.count;
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSString *identifier = @"Cell";
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    UIImageView *giphyImageView = (UIImageView *)[cell viewWithTag:100];
    giphyImageView.image = [finalArray objectAtIndex:indexPath.row];
    
   
    
    
    return cell;
}

@end
