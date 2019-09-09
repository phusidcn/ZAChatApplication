//
//  MessageArray.m
//  ChatApplication
//
//  Created by CPU11899 on 8/6/19.
//  Copyright © 2019 CPU11899. All rights reserved.
//

#import "MessageArray.h"


@implementation MessageArray
- (instancetype) init {
    self = [super init];
    if (self) {
        self.array = [[NSMutableArray alloc] init];
    }
    return self;
}

+ (dispatch_queue_t) safeDispatchQueue {
    static dispatch_queue_t queue;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        queue = dispatch_queue_create("com.chat.safe.thread", DISPATCH_QUEUE_CONCURRENT);
    });
    return queue;
}

- (void) addMessage:(Message *)message {
    dispatch_barrier_async([MessageArray safeDispatchQueue], ^{
        [[self array] addObject:message];
    });
}

- (NSArray<Message*>*) getAllMessages {
    __block NSArray<Message*>* result;
    dispatch_sync([MessageArray safeDispatchQueue], ^{
        result = [NSArray arrayWithArray:[self array]];
    });
    return result;
}

- (Message*) messageAtIndex:(NSUInteger)index {
    __block Message* message;
    dispatch_sync([MessageArray safeDispatchQueue], ^{
        message = [[self array] objectAtIndex:index];
    });
    return message;
}

- (NSUInteger) numberOfMessage {
    __block NSUInteger result;
    dispatch_sync([MessageArray safeDispatchQueue], ^{
        result = [[self array] count];
    });
    return result;
}
@end
