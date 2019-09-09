//
//  ChatContent.m
//  ChatApplication
//
//  Created by CPU11899 on 8/6/19.
//  Copyright © 2019 CPU11899. All rights reserved.
//

#import "ChatContent.h"

@implementation ChatContent

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (void) drawTextInRect:(CGRect)rect {
    UIEdgeInsets inset = UIEdgeInsetsMake(8, 16, 8, 16);
    [super drawTextInRect:UIEdgeInsetsInsetRect(rect, inset)];
}

@end
