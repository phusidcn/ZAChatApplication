//
//  Message.m
//  ChatApplication
//
//  Created by CPU11899 on 8/5/19.
//  Copyright © 2019 CPU11899. All rights reserved.
//

#import "Message.h"

@implementation Message
- (instancetype) initWithUser:(User *)user Message:(NSString *)message MessageType:(MessageType)type AndMessageSender:(MessageSender)sender{
    self = [super init];
    if (self) {
        self.message = message;
        self.sender = user;
        self.messageSender = sender;
        self.messageType = type;
    };
    return self;
}
@end
