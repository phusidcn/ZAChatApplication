//
//  ChatViewController.m
//  ChatApplication
//
//  Created by CPU11899 on 8/5/19.
//  Copyright © 2019 CPU11899. All rights reserved.
//

#import "ChatViewController.h"

@interface ChatViewController ()
@property UITableView *messageTableView;
@property MessageInputView* messageInputBar;
@property MessageArray* array;
@property Communicator* communicator;
@end

@implementation ChatViewController

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.communicator = [[Communicator alloc] initWithHost:self.host AndPort:self.port AndUser:[self user]];
    self.communicator.delegate = self;
    [[self communicator] joinChatWithUser:[self user]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChange:) name:UIKeyboardWillChangeFrameNotification object:nil];
    self.messageTableView = [[UITableView alloc] init];
    self.messageInputBar = [[MessageInputView alloc] init];
    self.array = [[MessageArray alloc] init];
    [self loadViews];
}

- (void) keyboardWillChange:(NSNotification*) notification {
    NSDictionary* userInfo = [notification userInfo];
    //CGSize viewSize = self.view.bounds.size;
    CGRect keyboardFrame = [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat messageBarHeight = self.messageInputBar.frame.size.height;
    CGPoint point = CGPointMake(self.messageInputBar.center.x, keyboardFrame.origin.y - messageBarHeight / 2.0);
    UIEdgeInsets inset = UIEdgeInsetsMake(0, 0, keyboardFrame.size.height, 0);
    self.messageInputBar.center = point;
    self.messageTableView.contentInset = inset;
    [UIView animateWithDuration:0.25 animations:^{
        self.messageInputBar.center = point;
        self.messageTableView.contentInset = inset;
        [self.messageInputBar setHidden:false];
    }];
}

- (void) loadViews {
    self.navigationItem.title = @"Chat room";
    self.navigationItem.backBarButtonItem.title = @"Leave chat room";
    self.view.backgroundColor = [UIColor whiteColor];
    self.messageTableView.backgroundColor = [UIColor whiteColor];
    self.messageTableView.dataSource = self;
    self.messageTableView.delegate = self;
    self.messageTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [[self view] addSubview: [self messageInputBar]];
    [[self view] addSubview: [self messageTableView]];
    self.messageInputBar.delegate = self;
}

- (void) viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    CGFloat messageBarHeight = 60;
    CGSize size = self.view.bounds.size;
    self.messageTableView.frame = CGRectMake(0, 0, size.width, size.height - messageBarHeight - self.view.safeAreaInsets.bottom);
    self.messageInputBar.frame = CGRectMake(0, size.height - messageBarHeight - self.view.safeAreaInsets.bottom, size.width, messageBarHeight);
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[self communicator] endSessionChat];
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    ChatTableViewCell* cell = [[ChatTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"messageCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell applyMessage:[[self array] messageAtIndex:indexPath.row]];
    return cell;
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.array.numberOfMessage;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat height = [ChatTableViewCell height:[[self array] messageAtIndex:indexPath.row]];
    return height;
}

- (void) receiveMessage:(Message *)message {
    dispatch_async(dispatch_get_main_queue(), ^{
        [[self array] addMessage:message];
        NSIndexPath* indexPath = [NSIndexPath indexPathForRow:self.array.numberOfMessage - 1 inSection:0];
        [[self messageTableView] beginUpdates];
        [[self messageTableView] insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationBottom];
        [[self messageTableView] endUpdates];
        [[self messageTableView] scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:true];
    });
}

- (void)connectError:(nonnull NSString *)error {
    UIAlertController* alertController = [UIAlertController alertControllerWithTitle:@"Connection Error" message:error preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction* retry = [UIAlertAction actionWithTitle:@"Retry" style:UIAlertActionStyleDefault handler:^(UIAlertAction* action) {
        [[self communicator] reconnect];
    }];
    [alertController addAction:cancel];
    [alertController addAction:retry];
    [self presentViewController:alertController animated:true completion:nil];
}


- (void)sendTapped:(nonnull NSString *)message {
    [[self communicator] sendMessage:message];
}

@end

