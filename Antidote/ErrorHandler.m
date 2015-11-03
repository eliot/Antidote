//
//  ErrorHandler.m
//  Antidote
//
//  Created by Dmytro Vorobiov on 30/07/15.
//  Copyright (c) 2015 dvor. All rights reserved.
//

#import "ErrorHandler.h"
#import "OCTToxConstants.h"
#import "OCTToxAVConstants.h"
#import "OCTManagerConstants.h"

#define ELOCALIZED(string) NSLocalizedString(string, @"ErrorHandler")
#define INTERNAL_ERROR ELOCALIZED(@"Internal error")

@implementation ErrorHandler

#pragma mark -  Public

- (void)handleError:(NSError *)error type:(ErrorHandlerType)type
{
    DDLogWarn(@"ErrorHandler: handling type %lu, error %@", type, error);

    switch (type) {
        case ErrorHandlerTypeCreateOCTManager:
            [self handleCreateOCTManagerError:error];
            break;
        case ErrorHandlerTypeSetUserName:
            [self handleSetUserNameError:error];
            break;
        case ErrorHandlerTypeSetUserStatus:
            [self handleSetUserStatusError:error];
            break;
        case ErrorHandlerTypeSendFriendRequest:
            [self handleSendFriendRequestError:error];
            break;
        case ErrorHandlerTypeApproveFriendRequest:
            [self handleApproveFriendRequestError:error];
            break;
        case ErrorHandlerTypeRemoveFriend:
            [self handleRemoveFriendError:error];
            break;
        case ErrorHandlerTypeSendMessage:
            [self handleSendMessageError:error];
            break;
        case ErrorHandlerTypeDeleteProfile:
            [self handleDeleteProfileError:error];
            break;
        case ErrorHandlerTypeRenameProfile:
            [self handleRenameProfileError:error];
            break;
        case ErrorHandlerTypeOpenFileFromOtherApp:
            [self handleOpenFileFromOtherAppError:error];
            break;
        case ErrorHandlerTypeExportProfile:
            [self handleExportProfileError:error];
            break;
        case ErrorHandlerTypeSendCallControl:
            [self handleSendCallControlError:error];
            break;
        case ErrorHandlerTypeCallToChat:
            [self handleCallToChatError:error];
            break;
        case ErrorHandlerTypeAnswerCall:
            [self handleAnswerCallError:error];
            break;
        case ErrorHandlerTypeRouteAudio:
            [self handleRouteCallToSpeakerError:error];
            break;
    }
}

#pragma mark -  Private

- (void)showErrorWithMessage:(NSString *)message
{
    [self showErrorWithTitle:ELOCALIZED(@"Error") message:message];
}

- (void)showErrorWithTitle:(NSString *)title message:(NSString *)message
{
    DDLogWarn(@"ErrorHandler: showing message \"%@\"", message);

    [[[UIAlertView alloc] initWithTitle:title
                                message:message
                               delegate:nil
                      cancelButtonTitle:ELOCALIZED(@"OK")
                      otherButtonTitles:nil] show];
}

- (void)handleCreateOCTManagerError:(NSError *)error
{
    OCTManagerInitError code = error.code;
    NSString *title;
    NSString *message;

    switch (code) {
        case OCTManagerInitErrorPassphraseFailed:
            title = ELOCALIZED(@"Wrong password");
            message = ELOCALIZED(@"Password contains wrong symbols.");
            break;
        case OCTManagerInitErrorCannotImportToxSave:
            title = ELOCALIZED(@"Cannot import tox save file");
            message = ELOCALIZED(@"File does not exist.");
            break;
        case OCTManagerInitErrorDecryptNull:
            title = ELOCALIZED(@"Cannot decrypt tox save file");
            message = ELOCALIZED(@"Some input data was empty.");
            break;
        case OCTManagerInitErrorDecryptBadFormat:
            title = ELOCALIZED(@"Cannot decrypt tox save file");
            message = ELOCALIZED(@"File has bad format or is corrupted.");
            break;
        case OCTManagerInitErrorDecryptFailed:
            title = ELOCALIZED(@"Cannot decrypt tox save file");
            message = ELOCALIZED(@"Password is wrong or file is corrupted.");
            break;
        case OCTManagerInitErrorCreateToxUnknown:
            title = ELOCALIZED(@"Error");
            message = ELOCALIZED(@"Unknown error occured.");
            break;
        case OCTManagerInitErrorCreateToxMemoryError:
            title = ELOCALIZED(@"Error");
            message = ELOCALIZED(@"Not enought memory.");
            break;
        case OCTManagerInitErrorCreateToxPortAlloc:
            title = ELOCALIZED(@"Error");
            message = ELOCALIZED(@"Was unable to bind to a port.");
            break;
        case OCTManagerInitErrorCreateToxProxyBadType:
            title = ELOCALIZED(@"Proxy error");
            message = ELOCALIZED(@"Internal error.");
            break;
        case OCTManagerInitErrorCreateToxProxyBadHost:
            title = ELOCALIZED(@"Proxy error");
            message = ELOCALIZED(@"Proxy address has invalid format.");
            break;
        case OCTManagerInitErrorCreateToxProxyBadPort:
            title = ELOCALIZED(@"Proxy error");
            message = ELOCALIZED(@"Proxy port is invalid.");
            break;
        case OCTManagerInitErrorCreateToxProxyNotFound:
            title = ELOCALIZED(@"Proxy error");
            message = ELOCALIZED(@"Proxy host could not be resolved.");
            break;
        case OCTManagerInitErrorCreateToxEncrypted:
            title = ELOCALIZED(@"Error");
            message = ELOCALIZED(@"Profile is encrypted.");
            break;
        case OCTManagerInitErrorCreateToxBadFormat:
            title = ELOCALIZED(@"Error");
            message = ELOCALIZED(@"File has bad format or is corrupted.");
            break;
    }

    [self showErrorWithTitle:title message:message];
}

- (void)handleSetUserNameError:(NSError *)error
{
    OCTToxErrorSetInfoCode code = error.code;
    NSString *message;

    switch (code) {
        case OCTToxErrorSetInfoCodeTooLong:
            message = ELOCALIZED(@"Name is too long");
            break;
        case OCTToxErrorSetInfoCodeUnknow:
            message = INTERNAL_ERROR;
            break;
    }

    [self showErrorWithMessage:message];
}

- (void)handleSetUserStatusError:(NSError *)error
{
    OCTToxErrorSetInfoCode code = error.code;
    NSString *message;

    switch (code) {
        case OCTToxErrorSetInfoCodeTooLong:
            message = ELOCALIZED(@"Status message is too long");
            break;
        case OCTToxErrorSetInfoCodeUnknow:
            message = INTERNAL_ERROR;
            break;
    }

    [self showErrorWithMessage:message];
}

- (void)handleSendFriendRequestError:(NSError *)error
{
    OCTToxErrorFriendAdd code = error.code;
    NSString *message;

    switch (code) {
        case OCTToxErrorFriendAddTooLong:
            message = ELOCALIZED(@"Message is too long");
            break;
        case OCTToxErrorFriendAddNoMessage:
            message = ELOCALIZED(@"No message specified");
            break;
        case OCTToxErrorFriendAddOwnKey:
            message = ELOCALIZED(@"Cannot add myself to friend list");
            break;
        case OCTToxErrorFriendAddAlreadySent:
            message = ELOCALIZED(@"Friend request was already sent");
            break;
        case OCTToxErrorFriendAddBadChecksum:
            message = ELOCALIZED(@"Bad checksum, please check entered Tox ID");
            break;
        case OCTToxErrorFriendAddSetNewNospam:
            message = ELOCALIZED(@"Bad nospam value, please check entered Tox ID");
            break;
        case OCTToxErrorFriendAddMalloc:
        case OCTToxErrorFriendAddUnknown:
            message = INTERNAL_ERROR;
            break;
    }

    [self showErrorWithMessage:message];
}

- (void)handleApproveFriendRequestError:(NSError *)error
{
    OCTToxErrorFriendAdd code = error.code;
    NSString *message;

    switch (code) {
        case OCTToxErrorFriendAddTooLong:
        case OCTToxErrorFriendAddNoMessage:
        case OCTToxErrorFriendAddOwnKey:
        case OCTToxErrorFriendAddAlreadySent:
        case OCTToxErrorFriendAddBadChecksum:
        case OCTToxErrorFriendAddSetNewNospam:
        case OCTToxErrorFriendAddMalloc:
        case OCTToxErrorFriendAddUnknown:
            message = INTERNAL_ERROR;
            break;
    }

    [self showErrorWithMessage:message];
}

- (void)handleRemoveFriendError:(NSError *)error
{
    OCTToxErrorFriendDelete code = error.code;
    NSString *message;

    switch (code) {
        case OCTToxErrorFriendDeleteNotFound:
            message = INTERNAL_ERROR;
            break;
    }

    [self showErrorWithMessage:message];
}

- (void)handleSendMessageError:(NSError *)error
{
    OCTToxErrorFriendSendMessage code = error.code;
    NSString *message;

    switch (code) {
        case OCTToxErrorFriendSendMessageTooLong:
            message = ELOCALIZED(@"Message is too long");
            break;
        case OCTToxErrorFriendSendMessageEmpty:
            message = ELOCALIZED(@"Cannot send empty message");
            break;
        case OCTToxErrorFriendSendMessageFriendNotConnected:
            message = ELOCALIZED(@"Friend is not connected");
            break;
        case OCTToxErrorFriendSendMessageUnknown:
        case OCTToxErrorFriendSendMessageFriendNotFound:
        case OCTToxErrorFriendSendMessageAlloc:
            message = INTERNAL_ERROR;
            break;
    }

    [self showErrorWithMessage:message];
}

- (void)handleDeleteProfileError:(NSError *)error
{
    [self showErrorWithMessage:[error localizedDescription]];
}

- (void)handleRenameProfileError:(NSError *)error
{
    NSString *message = INTERNAL_ERROR;

    if (error.code == NSFileWriteInvalidFileNameError) {
        message = ELOCALIZED(@"Invalid name");
    }
    else if (error.code == NSFileWriteFileExistsError) {
        message = ELOCALIZED(@"Profile with this name already exists");
    }

    [self showErrorWithMessage:message];
}

- (void)handleOpenFileFromOtherAppError:(NSError *)error
{
    [self showErrorWithMessage:[error localizedDescription]];
}

- (void)handleExportProfileError:(NSError *)error
{
    [self showErrorWithMessage:[error localizedDescription]];
}

- (void)handleSendCallControlError:(NSError *)error
{
    OCTToxErrorCallControl code = error.code;
    NSString *message;

    switch (code) {
        case OCTToxAVErrorControlFriendNotFound:
        case OCTToxAVErrorControlFriendNotInCall:
        case OCTToxAVErrorControlInvaldTransition:
        case OCTToxAVErrorControlUnknown:
            message = INTERNAL_ERROR;
            break;
    }

    [self showErrorWithMessage:message];
}

- (void)handleCallToChatError:(NSError *)error
{
    OCTToxAVErrorCall code = error.code;
    NSString *message;

    switch (code) {
        case OCTToxAVErrorCallAlreadyInCall:
            message = ELOCALIZED(@"Already in a call");
            break;
        case OCTToxAVErrorCallFriendNotConnected:
            message = ELOCALIZED(@"Friend is offline");
            break;
        case OCTToxAVErrorCallFriendNotFound:
        case OCTToxAVErrorCallInvalidBitRate:
        case OCTToxAVErrorCallMalloc:
        case OCTToxAVErrorCallUnknown:
            message = INTERNAL_ERROR;
            break;
    }

    [self showErrorWithMessage:message];
}

- (void)handleAnswerCallError:(NSError *)error
{
    OCTToxAVErrorAnswer code = error.code;
    NSString *message;

    switch (code) {
        case OCTToxAVErrorAnswerCodecInitialization:
        case OCTToxAVErrorAnswerInvalidBitRate:
        case OCTToxAVErrorAnswerUnknown:
        case OCTToxAVErrorAnswerFriendNotFound:
            message = INTERNAL_ERROR;
            break;
        case OCTToxAVErrorAnswerFriendNotCalling:
            message = ELOCALIZED(@"Friend is not calling");
            break;
    }

    [self showErrorWithMessage:message];
}

- (void)handleRouteCallToSpeakerError:(NSError *)error
{
    NSString *message = INTERNAL_ERROR;

    [self showErrorWithMessage:message];
}

@end