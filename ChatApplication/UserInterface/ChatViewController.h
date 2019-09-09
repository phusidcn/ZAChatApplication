//
//  ChatViewController.h
//  ChatApplication
//
//  Created by CPU11899 on 8/5/19.
//  Copyright © 2019 CPU11899. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChatTableViewCell.h"
#import "../NetworkCommunication/MessageArray.h"
#import "../NetworkCommunication/Communicator.h"
#import "MessageInputView.h"
#import "ChatContent.h"

NS_ASSUME_NONNULL_BEGIN

@interface ChatViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, CommunicatorDelegate,MessageInputViewDelegate, UITextFieldDelegate>
@property User* user;
@property NSString* host;
@property NSString* port;
@end
NS_ASSUME_NONNULL_END
