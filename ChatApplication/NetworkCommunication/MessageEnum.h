//
//  MessageSender.h
//  ChatApplication
//
//  Created by CPU11899 on 8/6/19.
//  Copyright © 2019 CPU11899. All rights reserved.
//

#ifndef MessageSender_h
#define MessageSender_h
typedef enum {
    ourself,
    someoneElse
} MessageSender;

typedef enum {
    joinMessage,
    chatMessage
} MessageType;

#endif /* MessageSender_h */
