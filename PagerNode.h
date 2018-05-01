//
//  PagerNode.h
//  SegmentedAndPagerNodeExample
//
//  Created by Archimboldi Mao on 2018/4/30.
//  Copyright © 2018 me.archimboldi. All rights reserved.
//

#import <AsyncDisplayKit/AsyncDisplayKit.h>

@interface PagerNode : ASViewController<ASPagerNode *>

- (instancetype)init UNAVAILABLE_ATTRIBUTE;
- (instancetype)initWithFrame:(CGRect)frame segmentedItems:(NSArray<NSString *> *)segmentedItems;

@end
