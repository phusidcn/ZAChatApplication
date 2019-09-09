//
//  User.m
//  ChatApplication
//
//  Created by CPU11899 on 8/5/19.
//  Copyright © 2019 CPU11899. All rights reserved.
//

#import "User.h"

@implementation User
- (instancetype) init {
    self = [super init];
    return self;
}

- (instancetype) initWithName:(NSString *)name {
    self = [super init];
    if (self) {
        self.userName = name;
    }
    return self;
}
@end
