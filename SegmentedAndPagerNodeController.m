//
//  SegmentedAndPagerNodeController.m
//  SegmentedAndPagerNodeExample
//
//  Created by Archimboldi Mao on 2018/4/30.
//  Copyright © 2018 me.archimboldi. All rights reserved.
//

#import "SegmentedAndPagerNodeController.h"
#import "NotificationConstants.h"
#import "SegmentedNode.h"
#import "PagerNode.h"

static NSArray<NSString *> *segmentedItems() {
    return @[@"First", @"Second", @"Third"];
}

static CGFloat kSegmentedNodeHeight = 44.0f;

@interface SegmentedAndPagerNodeController() {
    SegmentedNode        *_segmentedNode;
    PagerNode           *_PagerNode;
}

@end


@implementation SegmentedAndPagerNodeController

- (instancetype)init {
    if (!(self = [super init])) {
        return nil;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.node.backgroundColor = [UIColor whiteColor];
    [self setupSegmentedNode];
    [self setupPagerNode];
    self.title = @"Segmented and Pager";
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    [[NSNotificationCenter defaultCenter] postNotificationName:SegmentedNodeRedrawWholeNodeBySizeNotification object:nil userInfo:@{@"newWidth": [NSNumber numberWithFloat: size.width], @"newHeight": [NSNumber numberWithFloat: kSegmentedNodeHeight]}];
}

- (void)setupSegmentedNode {
    if (!_segmentedNode) {
        _segmentedNode = [[SegmentedNode alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, kSegmentedNodeHeight) titles:segmentedItems() selectedIndex:0];
    }
    [self.view addSubnode:_segmentedNode];
}

- (void)setupPagerNode {
    if (!_PagerNode) {
        _PagerNode = [[PagerNode alloc] initWithFrame:CGRectMake(0, _segmentedNode.frame.size.height, self.view.frame.size.width, self.view.frame.size.height - _segmentedNode.frame.size.height) segmentedItems:segmentedItems()];
    }
    [self.view addSubnode:_PagerNode.node];
}

@end
