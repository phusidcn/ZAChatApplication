//
//  ViewController.m
//  ChatApplication
//
//  Created by CPU11899 on 8/5/19.
//  Copyright © 2019 CPU11899. All rights reserved.
//

#import "JoinChatViewController.h"

@interface JoinChatViewController ()
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *hostTextField;
@property (weak, nonatomic) IBOutlet UITextField *portTextField;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *hostLabel;
@property (weak, nonatomic) IBOutlet UILabel *portLabel;
@property (weak, nonatomic) IBOutlet UIImageView *logoImage;
@property (weak, nonatomic) IBOutlet UIButton *connectButton;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@end

@implementation JoinChatViewController

- (void) addKeyboardObserver {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDisapear:) name:UIKeyboardWillHideNotification object:nil];
}

- (void) removeKeyboardObserver {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void) keyboardWasShown:(NSNotification*) notification {
    NSDictionary* info = [notification userInfo];
    CGSize keyboardSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    CGPoint buttonOrigin = self.connectButton.frame.origin;
    CGFloat buttonHeight = self.connectButton.frame.size.height;
    CGPoint bottomPoint = CGPointMake(buttonOrigin.x, buttonOrigin.y + buttonHeight);
    CGRect visibleRect = self.view.frame;
    visibleRect.size.height -= keyboardSize.height;
    [self.scrollView setContentSize:CGSizeMake(visibleRect.size.width, bottomPoint.y + keyboardSize.height)];
    if (!CGRectContainsPoint(visibleRect, bottomPoint)){
        [[self scrollView] setScrollEnabled:true];
        CGPoint scrollPoint = CGPointMake(0.0, bottomPoint.y - visibleRect.size.height);
        [self.scrollView setContentOffset:scrollPoint animated:YES];
    }
}

- (void) keyboardDisapear:(NSNotification*) notification {
    [self.scrollView setContentOffset:CGPointZero animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self addKeyboardObserver];
    self.connectButton.clipsToBounds = true;
    self.connectButton.layer.cornerRadius = 4;
}

- (void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self removeKeyboardObserver];
}

- (BOOL) textFieldShouldReturn:(UITextField*) textField {
    return true;
}

- (IBAction)joinChatButtonTouch:(id)sender {
    NSString* userName = self.nameTextField.text;
    NSString* host = self.hostTextField.text;
    NSString* port = self.portTextField.text;
    if ([userName isEqualToString:@""] || [host isEqualToString:@""] || [port isEqualToString:@""]) {
        NSLog(@"ERROR");
    } else {
        ChatViewController* chatRoom = [[ChatViewController alloc] init];
        chatRoom.user = [[User alloc] initWithName:userName];
        chatRoom.host = host;
        chatRoom.port = port;
        [[self navigationController] pushViewController:chatRoom animated:true];
    }
}

@end
