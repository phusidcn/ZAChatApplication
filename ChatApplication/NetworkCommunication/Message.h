//
//  Message.h
//  ChatApplication
//
//  Created by CPU11899 on 8/5/19.
//  Copyright © 2019 CPU11899. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"
#import "MessageEnum.h"

NS_ASSUME_NONNULL_BEGIN

@interface Message : NSObject
@property User* sender;
@property NSString* message;
@property MessageSender messageSender;
@property MessageType messageType;
- (instancetype) initWithUser:(User*) user Message:(NSString*)message MessageType:(MessageType)type AndMessageSender:(MessageSender) sender;
@end

NS_ASSUME_NONNULL_END
