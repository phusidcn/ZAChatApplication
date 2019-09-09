//
//  Communicator.h
//  ChatApplication
//
//  Created by CPU11899 on 8/5/19.
//  Copyright © 2019 CPU11899. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"
#import "Message.h"
#import "MessageEnum.h"
#import "ConnectionStatusEnum.h"
#import <Network/Network.h>

NS_ASSUME_NONNULL_BEGIN


@protocol CommunicatorDelegate <NSObject>

- (void) receiveMessage:(Message*)message;
- (void) connectError:(NSString*)error;

@end

@interface Communicator : NSObject <NSStreamDelegate>
@property nw_connection_t connection;
@property nw_endpoint_t hostEndPoint;
@property nw_parameters_t outboundParam;
@property nw_connection_state_t state;

@property id<CommunicatorDelegate> delegate;
@property User* user;
@property NSInteger maxLength;
@property ConnectStatus connectStatus;
@property NSString* host;
@property NSString* port;

+ (dispatch_queue_t) connectionQueue;
- (instancetype) initWithHost:(NSString*) host AndPort:(NSString*) port AndUser:(User*) user;
- (void) joinChatWithUser:(User*) user;
- (void) sendMessage:(NSString*) message;
- (void) endSessionChat;
- (void) reconnect;
@end

NS_ASSUME_NONNULL_END
