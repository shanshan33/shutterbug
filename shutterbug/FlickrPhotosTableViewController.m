//
//  FlickrPhotosTableViewController.m
//  shutterbug
//
//  Created by Shanshan ZHAO on 14-1-21.
//  Copyright (c) 2014年 Shanshan ZHAO. All rights reserved.
//

#import "FlickrPhotosTableViewController.h"
#import "FlickrFetcher.h"
#import "ImageViewController.h"

@interface FlickrPhotosTableViewController ()

@end

@implementation FlickrPhotosTableViewController



-(void)setPhotos:(NSArray *)photos
{
    _photos = photos;
    [self.tableView reloadData];
}

#pragma mark -
#pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.photos count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Flickr Photo Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    
    NSDictionary * photo = self.photos[indexPath.row];
    cell.textLabel.text = [photo valueForKeyPath:FLICKR_PHOTO_TITLE];
    cell.detailTextLabel.text = [photo valueForKeyPath:FLICKR_PHOTO_DESCRIPTION];
    
    return cell;
}

#pragma mark - 
#pragma mark UITableViewDelegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    id detail = self.splitViewController.viewControllers[1];
    
    if ([detail isKindOfClass:[UINavigationController class]]) {
        detail = [((UINavigationController *)detail).viewControllers firstObject];
    }
    
    if ([detail isKindOfClass:[ImageViewController class]]) {
        [self prepareImageViewController:detail
                          toDisplayPhoto:self.photos[indexPath.row]];
    }
}


#pragma mark -
#pragma mark Navigation

- (void)prepareImageViewController: (ImageViewController *)imageVC toDisplayPhoto:(NSDictionary *)photo
{
    imageVC.imageURL = [FlickrFetcher URLforPhoto:photo format:FlickrPhotoFormatLarge];
    imageVC.title = [photo valueForKeyPath:FLICKR_PHOTO_TITLE];

}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([sender isKindOfClass:[UITableViewCell class]]) {
        NSIndexPath * indexPath = [self.tableView indexPathForCell:sender];
        if (indexPath) {
            if ([segue.identifier isEqualToString:@"Display Photo"]) {
                if ([segue.destinationViewController isKindOfClass:[ImageViewController class]]) {
                    [self prepareImageViewController: segue.destinationViewController
                                      toDisplayPhoto:self.photos[indexPath.row]];
                   
                }
            }
        }
    }
}



@end
