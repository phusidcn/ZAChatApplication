//
//  ChatTableViewCell.h
//  ChatApplication
//
//  Created by CPU11899 on 8/6/19.
//  Copyright © 2019 CPU11899. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "../NetworkCommunication/MessageEnum.h"
#import "../NetworkCommunication/Message.h"
#import "../NetworkCommunication/User.h"
#import "ChatContent.h"

NS_ASSUME_NONNULL_BEGIN

@interface ChatTableViewCell : UITableViewCell
@property MessageSender messageSender;
@property ChatContent* messageLabel;
@property UILabel* nameLabel;
@property MessageType messageType;
+ (CGFloat) height:(Message*)message;
- (void) applyMessage:(Message*)message;
@end

NS_ASSUME_NONNULL_END
