//
//  MessageInputView.m
//  ChatApplication
//
//  Created by CPU11899 on 8/7/19.
//  Copyright © 2019 CPU11899. All rights reserved.
//

#import "MessageInputView.h"

@implementation MessageInputView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype) initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    self.textField = [[UITextField alloc] init];
    self.sendButton = [[UIButton alloc] init];
    self.backgroundColor = [UIColor whiteColor];
    self.textField.layer.cornerRadius = 4;
    //self.textField.layer.borderWidth = 1;
    self.textField.font = [UIFont systemFontOfSize:17];
    self.textField.placeholder = @"Type message ...";
    self.sendButton.layer.cornerRadius = 4;
    [[self sendButton] setImage:[UIImage imageNamed:@"Send"] forState:UIControlStateNormal];
    //[[self sendButton] setTitle:@"Send" forState:UIControlStateNormal];
    [[self sendButton] setEnabled:true];
    [[self sendButton] addTarget:self action:@selector(sendTapped) forControlEvents:UIControlEventTouchUpInside];
    self.sendButton.backgroundColor = [UIColor whiteColor];
    [self addSubview:[self textField]];
    [self addSubview:[self sendButton]];
    return self;
}

- (void) layoutSubviews {
    [super layoutSubviews];
    CGSize size = self.bounds.size;
    self.textField.bounds = CGRectMake(0, 0, size.width - 32 - 8 -60, 30);
    self.sendButton.bounds = CGRectMake(0, 0, 40, 40);
    self.textField.center = CGPointMake(self.textField.bounds.size.width/2.0 + 16, self.bounds.size.height / 2.0);
    self.sendButton.center = CGPointMake(self.bounds.size.width - 30 - 16, self.bounds.size.height / 2.0);
}

- (void) sendTapped {
    NSString* message = self.textField.text;
    if (![message isEqualToString:@""]) {
        [[self delegate] sendTapped:message];
        [[self textField] setText:@""];
    }
}

- (BOOL) textViewShouldEndEditing:(UITextView *)textView {
    return true;
}

@end
