// Copyright (c) 2016 RAMBLER&Co
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "LectureViewController.h"

#import "LectureViewOutput.h"
#import "LectureDataDisplayManager.h"
#import "SpeakerPlainObject.h"
#import "LecturePlainObject.h"
#import "SpeakerShortInfoModuleInput.h"

#import "UINavigationBar+States.h"
#import "Extensions/UIViewController+CDObserver/UIViewController+CDObserver.h"
#import "UIViewController+RCFForceRotation.h"
#import "TagModuleTableViewCell.h"
#import "CollectionViewContentCellAnimator.h"

static CGFloat kTableViewEstimatedRowHeight = 44.0f;
static CGFloat kTableViewFooterHeight = 16.0f;

@implementation LectureViewController

- (void)viewDidLoad {
	[super viewDidLoad];
    
    [self cd_startObserveProtocols:@[@protocol(LectureInfoTableViewCellActionProtocol),
                                     @protocol(TagTableViewCellDelegate)]];
    [self.output setupView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
   
    [self rcf_forceRotateToOrientation:UIDeviceOrientationPortrait];
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

#pragma mark - LectureViewInput

- (void)configureViewWithLecture:(LecturePlainObject *)lecture {
    [self.dataDisplayManager configureDataDisplayManagerWithLecture:lecture];
    
    self.tableView.dataSource = [self.dataDisplayManager dataSourceForTableView:self.tableView];
    self.tableView.delegate = [self.dataDisplayManager delegateForTableView:self.tableView
                                                           withBaseDelegate:nil];
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, kTableViewFooterHeight)];
    
    self.tableView.estimatedRowHeight = kTableViewEstimatedRowHeight;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    [self setupViewInitialState];
}

#pragma mark - <LectureDataDisplayManagerDelegate>

- (void)didTapVideoRecordCellWithVideoUrl:(NSURL *)videoUrl {
    [self.output didTapVideoPreviewWithUrl:videoUrl];
}

- (void)didTapMaterialCellWithUrl:(NSURL *)materialUrl {
    [self.output didTapMaterialWithUrl:materialUrl];
}

#pragma mark - <LectureInfoTableViewCellActionProtocol>

- (void)didSpeakerViewWithSpeakerId:(NSString *)speakerId {
    [self.output didTapSpeakerWithId:speakerId];
}

#pragma mark - Private methods

- (void)setupViewInitialState {
    [self.navigationController.navigationBar rcf_becomeTransparent];
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    self.navigationController.navigationBar.hidden = NO;
    self.animator.tableView = self.tableView;
}

- (IBAction)didTapShareButton:(id)sender {
    [self.output didTapShareButton];
}

- (void)collectionViewDidChangeContentSize:(UICollectionView *)collectionView
                                      cell:(UITableViewCell *)cell {
    [self.animator animateChangeCellSizeFromCollectionView:collectionView
                                                      cell:cell];
}

@end