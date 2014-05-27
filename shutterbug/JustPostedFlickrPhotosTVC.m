//
//  JustPostedFlickrPhotosTVC.m
//  shutterbug
//
//  Created by Shanshan ZHAO on 14-1-21.
//  Copyright (c) 2014年 Shanshan ZHAO. All rights reserved.
//

#import "JustPostedFlickrPhotosTVC.h"
#import "FlickrFetcher.h"

@interface JustPostedFlickrPhotosTVC ()

@end

@implementation JustPostedFlickrPhotosTVC


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self fetchPhotos];
}


- (IBAction)fetchPhotos
{
    [self.refreshControl beginRefreshing];
    NSURL * url = [FlickrFetcher URLforRecentGeoreferencedPhotos];
    
// Solve the problem of block the main quene. first create another quene, UI things are on main Q
    
    dispatch_queue_t fetchQ = dispatch_queue_create("flickr fetch quene", NULL);
    dispatch_async(fetchQ, ^{
        NSData * jsonResult = [NSData dataWithContentsOfURL:url];
        NSDictionary * propertyListResults = [NSJSONSerialization JSONObjectWithData:jsonResult
                                                                             options:0
                                                                               error: NULL];
        NSLog(@"Flickr Result = %@", propertyListResults);
        NSArray * photos = [propertyListResults valueForKeyPath:FLICKR_RESULTS_PHOTOS];
        
        dispatch_async(dispatch_get_main_queue(),^{
            [self.refreshControl endRefreshing];
            self.photos = photos;
        });
    });

}

@end
