 //
//  ImageViewController.m
//  imaginarium
//
//  Created by Shanshan ZHAO on 14-1-20.
//  Copyright (c) 2014年 Shanshan ZHAO. All rights reserved.
//

#import "ImageViewController.h"

@interface ImageViewController () <UIScrollViewDelegate, UISplitViewControllerDelegate>
@property (nonatomic, strong)                    UIImageView * imageView;
@property (nonatomic, strong)                    UIImage     * image;
@property (weak, nonatomic) IBOutlet            UIScrollView * scrollView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView * wait;

@end

@implementation ImageViewController


- (void)setScrollView:(UIScrollView *)scrollView
{
    _scrollView = scrollView;
    _scrollView.maximumZoomScale = 2.0;
    _scrollView.minimumZoomScale = 0.2;
    _scrollView.delegate = self ;
    self.scrollView.contentSize = self.image? self.image.size : CGSizeZero;
    
}

- (UIView * )viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imageView;
}

- (void)setImageURL:(NSURL *)imageURL
{
    _imageURL = imageURL;
//    self.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:self.imageURL]];
    [self startDownloadingImage];
}

-(void)startDownloadingImage
{
    self.image = nil;
    [self.wait startAnimating];
    if (self.imageURL) {
        NSURLRequest * request = [NSURLRequest requestWithURL:self.imageURL];
        NSURLSessionConfiguration * configuration = [NSURLSessionConfiguration ephemeralSessionConfiguration];
        NSURLSession * session = [NSURLSession sessionWithConfiguration:configuration];
        NSURLSessionDownloadTask * task = [session downloadTaskWithRequest:request
                              completionHandler:^(NSURL *localfile, NSURLResponse *response, NSError *error)
        {
            if (!error) {
                if ([request.URL isEqual:self.imageURL]) {
                    UIImage * image = [UIImage imageWithData:[NSData dataWithContentsOfURL:localfile]];
                    dispatch_async(dispatch_get_main_queue(),  ^ {self.image = image;});
                }
                }
            }];
        [task resume];

        }
}

-(UIImageView *)imageView
{
    if (!_imageView) _imageView = [[UIImageView alloc] init];
    return _imageView;
}

- (UIImage *)image
{
    return self.imageView.image;
}

- (void)setImage:(UIImage *)image
{
    self.scrollView.zoomScale = 1.0 ;
    self.imageView.image = image;
    self.imageView.frame = CGRectMake(0, 0, self.image.size.width, self.image.size.height);
    self.scrollView.contentSize = self.image? self.image.size : CGSizeZero;
    [self.wait stopAnimating];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.scrollView addSubview:self.imageView];
}

#pragma mark - 
#pragma mark UISplitViewControllerDelegate

- (void)awakeFromNib
{
    self.splitViewController.delegate = self;
    
}

- (BOOL)splitViewController:(UISplitViewController *)svc shouldHideViewController:(UIViewController *)vc inOrientation:(UIInterfaceOrientation)orientation
{
    return UIInterfaceOrientationIsPortrait(orientation);
}

-(void)splitViewController:(UISplitViewController *)svc willHideViewController:(UIViewController *)aViewController withBarButtonItem:(UIBarButtonItem *)barButtonItem forPopoverController:(UIPopoverController *)pc
{
    barButtonItem.title = aViewController.title;
    self.navigationItem.leftBarButtonItem = barButtonItem;
}

-(void)splitViewController:(UISplitViewController *)svc willShowViewController:(UIViewController *)aViewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    self.navigationItem.leftBarButtonItem = nil; 
}

@end
