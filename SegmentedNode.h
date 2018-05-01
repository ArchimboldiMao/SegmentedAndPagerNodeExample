//
//  SegmentedNode.h
//  SegmentedAndPagerNodeExample
//
//  Created by Archimboldi Mao on 2018/4/30.
//  Copyright © 2018 me.archimboldi. All rights reserved.
//

#import <AsyncDisplayKit/AsyncDisplayKit.h>

@interface SegmentedNode: ASDisplayNode

- (instancetype)init UNAVAILABLE_ATTRIBUTE;

- (instancetype)initWithFrame:(CGRect)frame titles:(NSArray<NSString *> *)titles selectedIndex:(NSUInteger)selectedIndex;

@end

