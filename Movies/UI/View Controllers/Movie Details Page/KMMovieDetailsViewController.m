//
//  KMMovieDetailsViewController.m
//  TheMovieDB
//
//  Created by Kevin Mindeguia on 04/02/2014.
//  Copyright (c) 2014 iKode Ltd. All rights reserved.
//

#import "KMMovieDetailsViewController.h"
#import "StoryBoardUtilities.h"
#import "KMMovieDetailsCell.h"
#import "KMMovieDetailsDescriptionCell.h"
#import "KMMovieDetailsPopularityCell.h"
#import "KMMovieDetailsCastCell.h"
#import "KMMovieDetailsSource.h"
#import "UIImageView+WebCache.h"

@interface KMMovieDetailsViewController ()

@property (nonatomic, strong) KMNetworkLoadingViewController* networkLoadingViewController;
@property (assign) CGPoint scrollViewDragPoint;

@end

@implementation KMMovieDetailsViewController

#pragma mark -
#pragma mark Init Methods

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma mark -
#pragma mark View Lifecycle

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    [self.navigationController setNavigationBarHidden:YES animated:YES];
    self.navigationController.interactivePopGestureRecognizer.delegate = nil;
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupNavbarButtons];
    
    [self requestMovieDetails];
    
    [self setupDetailsPageView];
}

#pragma mark -
#pragma mark Setup

- (void)setupDetailsPageView
{
    self.detailsPageView.tableViewDataSource = self;
    self.detailsPageView.tableViewDelegate = self;
    self.detailsPageView.delegate = self;
    self.detailsPageView.tableViewSeparatorColor = [UIColor clearColor];
}

- (void)setupNavbarButtons
{
    UIButton *buttonBack = [UIButton buttonWithType:UIButtonTypeCustom];
    
    buttonBack.frame = CGRectMake(10, 31, 22, 22);
    [buttonBack setImage:[UIImage imageNamed:@"back_icon"] forState:UIControlStateNormal];
    [buttonBack addTarget:self action:@selector(popViewController:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:buttonBack];
    
    self.navBarTitleLabel.text = self.movieDetails.movieTitle;
}

#pragma mark -
#pragma mark Container Segue Methods

- (void) prepareForSegue:(UIStoryboardSegue*)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:[NSString stringWithFormat:@"%s", class_getName([KMNetworkLoadingViewController class])]])
    {
        self.networkLoadingViewController = segue.destinationViewController;
        self.networkLoadingViewController.delegate = self;
    }
}

#pragma mark -
#pragma mark Network Request Methods

- (void)requestMovieDetails
{
    KMMovieDetailsCompletionBlock completionBlock = ^(KMMovie* movieDetails, NSString* errorString)
    {
        if (movieDetails != nil)
            [self processMovieDetailsData:movieDetails];
        else
            [self.networkLoadingViewController showErrorView];
    };
    
    KMMovieDetailsSource* source = [KMMovieDetailsSource movieDetailsSource];
    [source getMovieDetails:self.movieDetails.movieId completion:completionBlock];
}

#pragma mark -
#pragma mark Fetched Data Processing

- (void)processMovieDetailsData:(KMMovie*)data
{
    self.movieDetails = data;
    self.movieDetails.cast = [NSArray arrayWithObjects:@"Cameron Diaz",@"Matt Damon",@"La Fer del CAP", @"Fulano de Tal",nil];

    [self.detailsPageView reloadData];
    
    [self hideLoadingView];
}

#pragma mark -
#pragma mark Action Methods

- (IBAction)popViewController:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -
#pragma mark UITableView Data Source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // A much nicer way to deal with this would be to extract this code to a factory class, that would take care of building the cells.
    UITableViewCell* cell = nil;
    
    switch (indexPath.row) {
        case 0:
        {
            KMMovieDetailsCell *detailsCell = [tableView dequeueReusableCellWithIdentifier:@"KMMovieDetailsCell"];
            
            if(detailsCell == nil)
                detailsCell = [KMMovieDetailsCell movieDetailsCell];
            
            [detailsCell.posterImageView sd_setImageWithURL:[NSURL URLWithString:self.movieDetails.movieThumbnailBackdropImageUrl]];
            detailsCell.movieTitleLabel.text = self.movieDetails.movieTitle;
            detailsCell.genresLabel.text = self.movieDetails.movieGenresString;

            cell = detailsCell;
            
            break;
        }
        case 1:
        {
            KMMovieDetailsDescriptionCell *descriptionCell = [tableView dequeueReusableCellWithIdentifier:@"KMMovieDetailsDescriptionCell"];
            
            if(descriptionCell == nil)
                descriptionCell = [KMMovieDetailsDescriptionCell movieDetailsDescriptionCell];
            
            descriptionCell.movieDescriptionLabel.text = self.movieDetails.movieSynopsis;
            
            cell = descriptionCell;
            
            break;
        }
        case 2:
        {
            KMMovieDetailsPopularityCell *popularityCell = [tableView dequeueReusableCellWithIdentifier:@"KMMovieDetailsPopularityCell"];
            
            if(popularityCell == nil)
                popularityCell = [KMMovieDetailsPopularityCell movieDetailsPopularityCell];
            
            popularityCell.popularityLabel.text = self.movieDetails.moviePopularity;
            popularityCell.voteAverageLabel.text = self.movieDetails.movieVoteAverage;
            popularityCell.voteCountLabel.text = self.movieDetails.movieVoteCount;
            
            
            cell = popularityCell;
            
            break;
        }
        case 3:
        {
            KMMovieDetailsCastCell *castCell = [tableView dequeueReusableCellWithIdentifier:@"KMMovieDetailsCastCell"];
            
            if(castCell == nil)
                castCell = [KMMovieDetailsCastCell movieDetailsCastCell];
            NSString * cast = [self.movieDetails.cast componentsJoinedByString:@","];
            castCell.movieCastText.text = cast;
            
            cell = castCell;
            
            break;
        }
        default:
            break;
    }
    return cell;
}

#pragma mark -
#pragma mark UITableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.contentView.backgroundColor = [UIColor clearColor];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // A much nicer way to deal with this would be to extract this code to a factory class, that would return the cells' height.
    CGFloat height = 0;
    
    switch (indexPath.row) {
        case 0:
        {
            height = 120;
            break;
        }
        case 1:
        {
            height = 150;
            break;
        }
        case 2:
        {
            height = 67;
            break;
        }
        case 3:
        {
            height = 100;
            break;
        }
        default:
        {
            height = 100;
            break;
        }
    }
    
    return height;
}

#pragma mark -
#pragma mark KMDetailsPageDelegate

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    self.scrollViewDragPoint = scrollView.contentOffset;
}

- (CGPoint)detailsPage:(KMDetailsPageView *)detailsPageView tableViewWillBeginDragging:(UITableView *)tableView;
{
    return self.scrollViewDragPoint;
}

- (UIViewContentMode)contentModeForImage:(UIImageView *)imageView
{
    return UIViewContentModeTop;
}

- (UIImageView*)detailsPage:(KMDetailsPageView*)detailsPageView imageDataForImageView:(UIImageView*)imageView;
{
    __block UIImageView* blockImageView = imageView;
    
    [imageView sd_setImageWithURL:[NSURL URLWithString:[self.movieDetails movieOriginalBackdropImageUrl]] completed:^ (UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
        if ([detailsPageView.delegate respondsToSelector:@selector(headerImageViewFinishedLoading:)])
            [detailsPageView.delegate headerImageViewFinishedLoading:blockImageView];
        
    }];
    
    return imageView;
}

- (void)detailsPage:(KMDetailsPageView *)detailsPageView tableViewDidLoad:(UITableView *)tableView
{
    tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
}

- (void)detailsPage:(KMDetailsPageView *)detailsPageView headerViewDidLoad:(UIView *)headerView
{
    [headerView setAlpha:0.0];
    [headerView setHidden:YES];
}

#pragma mark -
#pragma mark KMNetworkLoadingViewController Methods

- (void)hideLoadingView
{
    [UIView transitionWithView:self.view duration:0.3f options:UIViewAnimationOptionTransitionCrossDissolve animations:^(void){
        
         [self.networkLoadingContainerView removeFromSuperview];
        
     } completion:^(BOOL finished) {
         
         [self.networkLoadingViewController removeFromParentViewController];
         self.networkLoadingContainerView = nil;
         
     }];
    
    self.detailsPageView.navBarView = self.navigationBarView;
}

#pragma mark -
#pragma mark KMNetworkLoadingViewDelegate

-(void)retryRequest;
{
    [self requestMovieDetails];
}

@end
