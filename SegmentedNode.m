//
//  SegmentedNode.m
//  SegmentedAndPagerNodeExample
//
//  Created by Archimboldi Mao on 2018/4/30.
//  Copyright © 2018 me.archimboldi. All rights reserved.
//

#import "SegmentedNode.h"
#import "NotificationConstants.h"

@implementation SegmentedNode {
    NSArray<ASTextNode *>       *_textNodes;
    ASDisplayNode           *_bottomSplitNode;
    NSArray<NSString *>     *_titles;
    NSUInteger              _selectedIndex;
}

- (instancetype)initWithFrame:(CGRect)frame titles:(NSArray<NSString *> *)titles selectedIndex:(NSUInteger)selectedIndex {
    if (!(self = [super init])) {
        return nil;
    }
    _titles = titles;
    _selectedIndex = selectedIndex;
    self.automaticallyManagesSubnodes = YES;
    self.view.frame = frame;
    self.backgroundColor = [UIColor whiteColor];
    self.userInteractionEnabled = YES;
    
    if (selectedIndex >= titles.count) {
        selectedIndex = 0;
    }
    NSMutableParagraphStyle *centerParagraphStyle = [[NSMutableParagraphStyle alloc] init];
    centerParagraphStyle.alignment = NSTextAlignmentCenter;
    float fontOfSize = 17.0f;
    NSDictionary *segmentedUnselectAttributed = @{NSFontAttributeName: [UIFont systemFontOfSize:fontOfSize], NSForegroundColorAttributeName: [UIColor lightGrayColor], NSParagraphStyleAttributeName: centerParagraphStyle};
    NSDictionary *segmentedSelectedAttributed = @{NSFontAttributeName: [UIFont systemFontOfSize:fontOfSize], NSForegroundColorAttributeName: [UIColor redColor], NSParagraphStyleAttributeName: centerParagraphStyle};
    NSMutableArray *nodeArray = [NSMutableArray new];
    for (int i = 0; i < titles.count; i++) {
        ASTextNode *textNode = [[ASTextNode alloc] init];
        textNode.backgroundColor = [UIColor whiteColor];
        NSDictionary *attributed;
        if (selectedIndex == i) {
            attributed = segmentedSelectedAttributed;
        } else {
            attributed = segmentedUnselectAttributed;
        }
        textNode.attributedText = [[NSAttributedString alloc] initWithString: titles[i] attributes:attributed];
        [textNode addTarget:self action:@selector(touchTextNodeAction:) forControlEvents:ASControlNodeEventTouchDragInside];
        [textNode addTarget:self action:@selector(touchTextNodeAction:) forControlEvents:ASControlNodeEventTouchUpInside];
        [textNode setUserInteractionEnabled:YES];
        [nodeArray addObject:textNode];
        [self addSubnode:textNode];
    }
    _textNodes = [nodeArray copy];
    
    _bottomSplitNode = [ASDisplayNode new];
    _bottomSplitNode.backgroundColor = [UIColor redColor];
    _bottomSplitNode.layer.zPosition = 1.1f;
    [self addSubnode:_bottomSplitNode];
    
    [self setupNotifications];
    return self;
}

- (void)setupNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(selectedSegmentNotification:) name:SegmentedNodeSelectedSegmentNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(redrawBottomSplitNodeNotification:) name:SegmentedNodeRedrawBottomSplitNodeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(redrawWholeNodeBySizeNotification:) name:SegmentedNodeRedrawWholeNodeBySizeNotification object:nil];
}

- (void)redrawWholeNodeBySizeNotification:(NSNotification *)notification {
    NSDictionary *userInfo = notification.userInfo;
    CGFloat newWidth = [[userInfo objectForKey:@"newWidth"] floatValue];
    CGFloat newHeight = [[userInfo objectForKey:@"newHeight"] floatValue];
    if ((newWidth > 0 && newHeight > 0) && (newWidth != self.view.frame.size.width || newHeight != self.view.frame.size.height)) {
        __weak typeof(self) weakSelf = self;
        dispatch_async(dispatch_get_main_queue(), ^{
            weakSelf.view.frame = CGRectMake(weakSelf.view.frame.origin.x, weakSelf.view.frame.origin.y, newWidth, newHeight);
            [weakSelf.view layoutSubviews];
        });
    }
}

- (void)redrawBottomSplitNodeNotification:(NSNotification *)notification {
    NSDictionary *userInfo = notification.userInfo;
    NSNumber *frameX = [userInfo objectForKey:@"frameX"];
    dispatch_async(dispatch_get_main_queue(), ^{
    self->_bottomSplitNode.view.frame = CGRectMake([frameX floatValue], self->_bottomSplitNode.view.frame.origin.y, self->_bottomSplitNode.view.frame.size.width, self->_bottomSplitNode.view.frame.size.height);
    });
}

- (void)selectedSegmentNotification:(NSNotification *)notification {
    NSDictionary *userInfo = notification.userInfo;
    NSUInteger selectedSegment = [[userInfo objectForKey:@"selectedSegment"] unsignedIntegerValue];
    _selectedIndex = selectedSegment;
    [self redrawSegmentedNodeBySelectedSegment:selectedSegment];
}

- (void)touchTextNodeAction:(id)sender {
    if (![sender isKindOfClass:[ASTextNode class]]) {
        return;
    }
    ASTextNode *textNode = (ASTextNode *)sender;
    NSUInteger index = [_textNodes indexOfObject:textNode];
    _selectedIndex = index;
    NSDictionary *userInfo = @{@"selectedPage": [NSNumber numberWithUnsignedInteger:index]};
    [[NSNotificationCenter defaultCenter] postNotificationName:PagerNodeScrollToSelectedPageNotification object:nil userInfo:userInfo];
}

- (void)redrawSegmentedNodeBySelectedSegment:(NSUInteger)selectedSegment {
    if (selectedSegment >= [self subnodes].count) {
        selectedSegment = 0;
    }
    _selectedIndex = selectedSegment;
    dispatch_async(dispatch_get_main_queue(), ^{
        NSMutableParagraphStyle *centerParagraphStyle = [[NSMutableParagraphStyle alloc] init];
        centerParagraphStyle.alignment = NSTextAlignmentCenter;
        float fontOfSize = 17.0f;
        NSDictionary *segmentedUnselectAttributed = @{NSFontAttributeName: [UIFont systemFontOfSize:fontOfSize], NSForegroundColorAttributeName: [UIColor lightGrayColor], NSParagraphStyleAttributeName: centerParagraphStyle};
        NSDictionary *segmentedSelectedAttributed = @{NSFontAttributeName: [UIFont systemFontOfSize:fontOfSize], NSForegroundColorAttributeName: [UIColor redColor], NSParagraphStyleAttributeName: centerParagraphStyle};
        for (int i = 0; i < self->_textNodes.count; i++) {
            ASTextNode *textNode = self->_textNodes[i];
            NSDictionary *attributed;
            if (selectedSegment == i) {
                attributed = segmentedSelectedAttributed;
            } else {
                attributed = segmentedUnselectAttributed;
            }
            textNode.attributedText = [[NSAttributedString alloc] initWithString: textNode.attributedText.string attributes:attributed];
        }
    });
}

- (ASLayoutSpec *)layoutSpecThatFits:(ASSizeRange)constrainedSize {
    ASStackLayoutSpec *segmentedStack = [ASStackLayoutSpec horizontalStackLayoutSpec];
    segmentedStack.alignItems = ASStackLayoutAlignItemsStretch;
    NSMutableArray *segmentedChildren = [NSMutableArray new];
    for (ASTextNode *textNode in _textNodes) {
        textNode.style.flexGrow = 1.0f;
        textNode.textContainerInset = UIEdgeInsetsMake((constrainedSize.max.height - textNode.attributedText.size.height) / 2, (constrainedSize.max.width / _textNodes.count - textNode.attributedText.size.width) / 2, (constrainedSize.max.height - textNode.attributedText.size.height) / 2, (constrainedSize.max.width / _textNodes.count - textNode.attributedText.size.width) / 2);
        [segmentedChildren addObject:textNode];
    }
    segmentedStack.children = segmentedChildren;
    
    _bottomSplitNode.style.height = ASDimensionMake(2.0f);
    
    CGFloat splitWidth = constrainedSize.max.width / _titles.count;
    UIEdgeInsets splitInsets = UIEdgeInsetsMake(INFINITY, _selectedIndex * splitWidth, 0, splitWidth * (_titles.count - (_selectedIndex + 1)));
    ASInsetLayoutSpec *splitInsetLayout = [ASInsetLayoutSpec insetLayoutSpecWithInsets:splitInsets child:_bottomSplitNode];
    ASOverlayLayoutSpec *bottomSplitOverlay = [ASOverlayLayoutSpec overlayLayoutSpecWithChild:splitInsetLayout overlay:segmentedStack];
    return bottomSplitOverlay;
}

@end
