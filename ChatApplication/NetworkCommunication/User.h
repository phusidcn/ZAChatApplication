//
//  User.h
//  ChatApplication
//
//  Created by CPU11899 on 8/5/19.
//  Copyright © 2019 CPU11899. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface User : NSObject
@property NSString* userName;
- (instancetype) init;
- (instancetype) initWithName:(NSString*)name;
@end

NS_ASSUME_NONNULL_END
