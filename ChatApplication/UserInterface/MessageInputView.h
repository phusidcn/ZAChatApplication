//
//  MessageInputView.h
//  ChatApplication
//
//  Created by CPU11899 on 8/7/19.
//  Copyright © 2019 CPU11899. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol MessageInputViewDelegate <NSObject>

- (void) sendTapped:(NSString*) message;

@end

@interface MessageInputView : UIView <UITextViewDelegate>
@property UITextField* textField;
@property UIButton* sendButton;
@property id<MessageInputViewDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
