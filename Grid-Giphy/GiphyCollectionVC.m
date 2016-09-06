//
//  GiphyCollectionVC.m
//  Grid-Giphy
//
//  Created by DetroitLabs on 9/1/16.
//  Copyright © 2016 DetroitLabs. All rights reserved.
//

#import "GiphyCollectionVC.h"
#import "FLAnimatedImage.h"
#import "Networking.h"

@interface GiphyCollectionVC () {
    NSMutableArray *giphyArray;
    NSMutableArray *finalArray;
    NSURLSessionDataTask *task;
    
}

@end

@implementation GiphyCollectionVC

- (void)viewDidLoad {
    [super viewDidLoad];
    giphyArray = [[NSMutableArray alloc]init];
    finalArray = [[NSMutableArray alloc]init];
    [self sessionCreation];
}


- (void)sessionCreation {
    NSString *urlString = @"http://api.giphy.com/v1/gifs/search?q=american+psycho&api_key=dc6zaTOxFJmzC&limit=100";
    
    NSURL *giphyUrl = [NSURL URLWithString:urlString];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:giphyUrl];
    
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
    
    [self americanPsychoTask:session withRequest:request];
    
}

- (void)americanPsychoTask:(NSURLSession *)session withRequest:(NSURLRequest *)request {
    
    task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) { NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
        
        if (httpResponse.statusCode == 200) {
            NSError *JSONError;
            
            NSMutableDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&JSONError];
            
            giphyArray = [dict valueForKeyPath:@"data.images.downsized.url"];
            
            [self loadDataForGrid:giphyArray];

            [self.collectionView reloadData];
            
        } else {
            NSLog(@"ERROR MICHAEL: %@", error);
        }
    }];
    
    [task resume];
}

- (void)loadDataForGrid:(NSMutableArray *)array {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        for (NSString *giphString in array) {
            FLAnimatedImage *giph = [FLAnimatedImage animatedImageWithGIFData:[NSData dataWithContentsOfURL:[NSURL URLWithString:giphString]]];
            [finalArray addObject:giph];
            
            [self.collectionView reloadData];
            
        }
        [self.collectionView reloadData];
    });
    
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return finalArray.count;
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSString *identifier = @"Cell";
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];

    FLAnimatedImageView *imageView = (FLAnimatedImageView *)[cell viewWithTag:100];
    
    imageView.animatedImage = [finalArray objectAtIndex:indexPath.row];
    
    return cell;
}



@end



// Pre-Refactor
/*
- (void)americanPsychoMethod {
    NSString *urlString = @"http://api.giphy.com/v1/gifs/search?q=american+psycho&api_key=dc6zaTOxFJmzC&limit=100";
    
    NSURL *giphyUrl = [NSURL URLWithString:urlString];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:giphyUrl];
    
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
    
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) { NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
        
        if (httpResponse.statusCode == 200) {
            NSError *JSONError;
            
            NSMutableDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&JSONError];
            
            giphyArray = [dict valueForKeyPath:@"data.images.downsized.url"];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                for (NSString *giphString in giphyArray) {
                    // NSURL *URLString = [NSURL URLWithString:giph];
                    // NSData *data = [NSData dataWithContentsOfURL:URLString];
                    
                    //Short Hand version
                    FLAnimatedImage *giph = [FLAnimatedImage animatedImageWithGIFData:[NSData dataWithContentsOfURL:[NSURL URLWithString:giphString]]];
                    
                    [finalArray addObject:giph];
                    
                    [self.collectionView reloadData];
                    
                }
                
                [self.collectionView reloadData];
                
            });
            
            [self.collectionView reloadData];
            
        } else {
            NSLog(@"ERROR MICHAEL: %@", error);
        }
    }];
    
    [task resume];
}
 */
