//
//  MessageArray.h
//  ChatApplication
//
//  Created by CPU11899 on 8/6/19.
//  Copyright © 2019 CPU11899. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Message.h"
NS_ASSUME_NONNULL_BEGIN

@interface MessageArray : NSObject
@property NSMutableArray<Message*>* array;
- (instancetype) init;
+ (dispatch_queue_t) safeDispatchQueue;
- (void) addMessage:(Message*) message;
- (NSArray<Message*>*) getAllMessages;
- (Message*) messageAtIndex:(NSUInteger) index;
- (NSUInteger) numberOfMessage;
@end

NS_ASSUME_NONNULL_END
