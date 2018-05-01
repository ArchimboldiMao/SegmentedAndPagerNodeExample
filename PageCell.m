//
//  PageCell.m
//  SegmentedAndPagerNodeExample
//
//  Created by Archimboldi Mao on 2018/4/30.
//  Copyright © 2018 me.archimboldi. All rights reserved.
//

#import "PageCell.h"

static UIColor *randomColor() {
    CGFloat hue = ( arc4random() % 256 / 256.0 );  //  0.0 to 1.0
    CGFloat saturation = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from white
    CGFloat brightness = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from black
    return [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1];
}

@implementation PageCell {
    ASTextNode                     *_titleNode;
}

- (instancetype)initWithText:(NSString *)titleText {
    if (!(self = [super init])) {
        return nil;
    }
    self.backgroundColor = randomColor();
    self.automaticallyManagesSubnodes = YES;
    
    _titleNode = [[ASTextNode alloc] init];
    NSMutableParagraphStyle *centerParagraphStyle = [[NSMutableParagraphStyle alloc] init];
    centerParagraphStyle.alignment = NSTextAlignmentCenter;
    NSDictionary *titleAttributes = @{NSFontAttributeName: [UIFont systemFontOfSize:23.0f], NSForegroundColorAttributeName: [UIColor darkTextColor], NSParagraphStyleAttributeName: centerParagraphStyle};
    _titleNode.attributedText = [[NSAttributedString alloc] initWithString: [NSString stringWithFormat:@"%@ page", titleText] attributes:titleAttributes];
    [self addSubnode:_titleNode];
    return self;
}

- (ASLayoutSpec *)layoutSpecThatFits:(ASSizeRange)constrainedSize {
    ASStackLayoutSpec *stack = [ASStackLayoutSpec horizontalStackLayoutSpec];
    stack.alignItems = ASStackLayoutAlignItemsCenter;
    stack.alignContent = ASStackLayoutAlignContentCenter;
    _titleNode.style.width = ASDimensionMake(constrainedSize.max.width);
    stack.children = @[_titleNode];
    return stack;
}


@end
