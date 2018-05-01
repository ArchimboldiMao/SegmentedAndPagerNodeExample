//
//  NotificationConstants.h
//  SegmentedAndPagerNodeExample
//
//  Created by Archimboldi Mao on 2018/4/30.
//  Copyright © 2018 me.archimboldi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NotificationConstants : NSObject

extern NSString * const SegmentedNodeSelectedSegmentNotification;
extern NSString * const SegmentedNodeRedrawBottomSplitNodeNotification;
extern NSString * const SegmentedNodeRedrawWholeNodeBySizeNotification;
extern NSString * const PagerNodeScrollToSelectedPageNotification;

@end
