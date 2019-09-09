//
//  Communicator.m
//  ChatApplication
//
//  Created by CPU11899 on 8/5/19.
//  Copyright © 2019 CPU11899. All rights reserved.
//

#import "Communicator.h"

@implementation Communicator
- (instancetype) initWithHost:(NSString *)host AndPort:(NSString*)port AndUser:(nonnull User *)user{
    self = [super init];
    if (self) {
        self.user = user;
        const char* chost = [host cStringUsingEncoding:NSUTF8StringEncoding];
        const char* cport = [port cStringUsingEncoding:NSUTF8StringEncoding];
        self.hostEndPoint = nw_endpoint_create_host(chost, cport);
        
        nw_parameters_configure_protocol_block_t configure_tls = NW_PARAMETERS_DISABLE_PROTOCOL;
        self.outboundParam = nw_parameters_create_secure_tcp(configure_tls, NW_PARAMETERS_DEFAULT_CONFIGURATION);
        self.connection = nw_connection_create(self.hostEndPoint, self.outboundParam);
        [self startConnection];
    }
    return self;
}

+ (dispatch_queue_t) connectionQueue {
    static dispatch_queue_t networkQueue;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        networkQueue = dispatch_queue_create("com.network.queue", DISPATCH_QUEUE_SERIAL);
    });
    return networkQueue;
}

- (void) startConnection {
    nw_connection_set_queue(self.connection, [Communicator connectionQueue]);
    nw_connection_set_state_changed_handler(self.connection, ^(nw_connection_state_t state, nw_error_t error) {
        self.state = state;
        switch (state) {
            case nw_connection_state_ready:
                NSLog(@"ready");
                [self receiveMessage];
                break;
            case nw_connection_state_failed:
                NSLog(@"failed");
                break;
            case nw_connection_state_waiting:
                NSLog(@"waiting");
                [[self delegate] connectError:@"Connection is refused, cannot connect to server"];
                break;
            case nw_connection_state_preparing:
                NSLog(@"Preparing");
                break;
            case nw_connection_state_invalid:
                NSLog(@"Invalid");
                [[self delegate] connectError:@"Connection is invalid"];
                break;
            case nw_connection_state_cancelled:
                NSLog(@"Canceled");
                if (self.connectStatus == disconnectAfterConnected) {
                    [[self delegate] connectError:@"Connect cancel becase of losing connection to server"];
                }
                break;
            default:
                break;
        }
    });
    nw_connection_start(self.connection);
}

- (void) receiveMessage {
    nw_connection_receive(self.connection, 1, UINT32_MAX, ^(dispatch_data_t content, nw_content_context_t context, bool is_complete, nw_error_t receive_error) {
        if (content != NULL) {
            const void *buffer = NULL;
            size_t size = 0;
            dispatch_data_t new_data_file = dispatch_data_create_map(content, &buffer, &size);
            if(!new_data_file){
                NSLog(@"Error");
            }
            
            NSData *nsdata = [[NSData alloc] initWithBytes:buffer length:size];
            [self readMessage:nsdata];
        } else {
            if (self.connectStatus == connected) {
                self.connectStatus = disconnectAfterConnected;
            }
            [self endSessionChat];
        }
        
        if (!receive_error) {
            [self receiveMessage];
        } else {
            NSLog(@"Error");
        }
    });
}

- (void) sendMessageWithData:(dispatch_data_t) data {
    nw_connection_send(self.connection, data, NW_CONNECTION_DEFAULT_MESSAGE_CONTEXT, true, ^(nw_error_t error) {
        if (error == nil) {
            self.connectStatus = connected;
        } else {
            errno = nw_error_get_error_code(error);
            [[self delegate] connectError:[NSString stringWithFormat:@"Error occurred when send message %i", errno]];
        }
    });
}
- (void) joinChatWithUser:(User*)user {
    NSString* joinMessage = [NSString stringWithFormat:@"join:%@", [user userName]];
    NSData* joinData = [joinMessage dataUsingEncoding:NSUTF8StringEncoding];
    dispatch_data_t data = dispatch_data_create([joinData bytes], [joinData length], [Communicator connectionQueue], DISPATCH_DATA_DESTRUCTOR_DEFAULT);
    [self sendMessageWithData:data];
}

- (void) sendMessage:(NSString *)message {
    NSString* chatMessage = [NSString stringWithFormat:@"msg:%@", message];
    NSData* chatData = [chatMessage dataUsingEncoding:NSUTF8StringEncoding];
    dispatch_data_t data = dispatch_data_create([chatData bytes], [chatData length], [Communicator connectionQueue], DISPATCH_DATA_DESTRUCTOR_DEFAULT);
    [self sendMessageWithData:data];
}

- (void) readMessage:(NSData*) data {
    Message* receiveMessage = [self convertDataToMessage:data];
    if (receiveMessage) {
        [[self delegate] receiveMessage:receiveMessage];
    }
}

- (void) endSessionChat {
    nw_connection_cancel(self.connection);
}

- (void) reconnect {
    nw_connection_start(self.connection);
}

- (Message*) convertDataToMessage:(NSData*) data {
    NSString* string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSArray<NSString*>* components = [string componentsSeparatedByString:@":"];
    NSString* header = [components firstObject];
    NSString* message = [components lastObject];
    MessageSender messageSender = ourself;
    MessageType messageType = chatMessage;
    if ([header isEqualToString:@"joined"]) {
        messageType = joinMessage;
        message = [message substringToIndex:[message length] - 1];
        message = [message stringByAppendingString:@" has joined"];
    } else {
        messageType = chatMessage;
        if ([header isEqualToString:self.user.userName]) {
            messageSender = ourself;
        } else {
            messageSender = someoneElse;
        }
    }
    User* user = [[User alloc] initWithName:header];
    Message* messageInstance = [[Message alloc] initWithUser:user Message:message MessageType:messageType AndMessageSender:messageSender];
    return messageInstance;
}
@end
