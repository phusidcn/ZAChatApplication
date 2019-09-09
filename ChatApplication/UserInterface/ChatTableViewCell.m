//
//  ChatTableViewCell.m
//  ChatApplication
//
//  Created by CPU11899 on 8/6/19.
//  Copyright © 2019 CPU11899. All rights reserved.
//

#import "ChatTableViewCell.h"

@implementation ChatTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

+ (CGFloat) heightForText:(NSString*)string WithFontSize:(CGFloat) fontSize maxSize:(CGSize) maxSize {
    NSLog(@"%@", string);
    UIFont* font = [UIFont systemFontOfSize:fontSize];
    NSDictionary* attribute = [NSDictionary dictionaryWithObject:font forKey:NSFontAttributeName];
    NSAttributedString* attributeString = [[NSAttributedString alloc] initWithString:string attributes:attribute];
    CGRect textRect = [attributeString boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin context:nil];
    CGFloat textHeight = textRect.size.height;
    return textHeight;
}

+ (CGFloat) height:(Message*) message {
    CGSize maxSize = CGSizeMake(2 * (UIScreen.mainScreen.bounds.size.width /3), FLT_MAX);
    CGFloat nameHeight;
    if (message.messageSender == ourself) {
        nameHeight = 0;
    } else {
        nameHeight = [ChatTableViewCell heightForText:[[message sender] userName] WithFontSize:10 maxSize:maxSize] + 4;
    }
    CGFloat messageHeight = [ChatTableViewCell heightForText:message.message WithFontSize:17 maxSize:maxSize];
    return nameHeight + messageHeight + 32 + 16;
}

- (instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    self.nameLabel = [[UILabel alloc] init];
    self.messageLabel = [[ChatContent alloc] init];
    self.messageLabel.clipsToBounds = true;
    self.messageLabel.numberOfLines = 0;
    self.nameLabel.textColor = [UIColor blackColor];
    self.nameLabel.font = [UIFont systemFontOfSize:10];
    self.clipsToBounds = true;
    [self addSubview:self.messageLabel];
    [self addSubview:self.nameLabel];
    return self;
}

- (void) applyMessage:(Message*) message {
    self.messageLabel.text = [NSString stringWithString:message.message];
    self.messageSender = message.messageSender;
    self.messageType = message.messageType;
    self.nameLabel.text = [NSString stringWithString:message.sender.userName];
    [self setNeedsLayout];
}

- (void) layoutSubviews {
    [super layoutSubviews];
    if (self.messageType == joinMessage) {
        [self layoutForJoinMessage];
    } else {
        self.messageLabel.font = [UIFont systemFontOfSize:17];
        self.messageLabel.textColor = [UIColor blackColor];
        CGSize size = [[self messageLabel] sizeThatFits:CGSizeMake(2 * (self.bounds.size.width / 3), FLT_MAX)];
        [[self messageLabel] setFrame:CGRectMake(0, 0, size.width + 32, size.height + 16)];
        if (self.messageSender == ourself) {
            [[self nameLabel] setHidden:true];
            self.messageLabel.center = CGPointMake(self.bounds.size.width - self.messageLabel.bounds.size.width / 2.0 - 16, self.bounds.size.height/2.0);
            self.messageLabel.backgroundColor = [UIColor colorWithRed:24.0/255 green:180.0/255 blue:128.0/255 alpha:1];
        } else {
            [[self nameLabel] setHidden:false];
            [[self nameLabel] sizeToFit];
            self.nameLabel.center = CGPointMake(self.nameLabel.bounds.size.width / 2.0 + 16 + 4, self.nameLabel.bounds.size.height/2.0 + 4);
            self.messageLabel.center = CGPointMake(self.messageLabel.bounds.size.width / 2.0 + 16, self.messageLabel.bounds.size.height / 2.0 + self.nameLabel.bounds.size.height + 8);
            self.messageLabel.backgroundColor = [UIColor lightGrayColor];
        }
    }
    self.messageLabel.layer.cornerRadius = MIN(self.messageLabel.bounds.size.height / 2, 20);
}

- (void) layoutForJoinMessage {
    self.messageLabel.font = [UIFont systemFontOfSize:10];
    self.messageLabel.textColor = [UIColor lightGrayColor];
    self.messageLabel.backgroundColor = [UIColor colorWithRed:247.0 / 255 green:247.0/255 blue:247.0/255 alpha:1];
    CGSize size = [[self messageLabel] sizeThatFits:CGSizeMake(2.0/3 * self.bounds.size.width, FLT_MAX)];
    self.messageLabel.frame = CGRectMake(0, 0, size.width + 32, size.height + 16);
    self.messageLabel.center = CGPointMake(self.bounds.size.width / 2, self.bounds.size.height / 2.0);
}

@end
