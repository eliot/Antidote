//
//  CoreDataManager+Chat.m
//  Antidote
//
//  Created by Dmitry Vorobyov on 27.07.14.
//  Copyright (c) 2014 dvor. All rights reserved.
//

#import "CoreDataManager+Chat.h"
#import "CoreData+MagicalRecord.h"

@implementation CoreDataManager (Chat)

+ (NSArray *)allChatsSortedByDate
{
    __block NSArray *array;

    dispatch_sync([self private_queue], ^{
        array = [CDChat MR_findAllSortedBy:@"lastMessage.date" ascending:YES inContext:[self private_context]];
    });

    return array;
}

+ (NSFetchedResultsController *)allChatsFetchedControllerWithDelegate:(id <NSFetchedResultsControllerDelegate>)delegate
{
    __block NSFetchedResultsController *controller;

    dispatch_sync([self private_queue], ^{
        controller = [CDChat MR_fetchAllSortedBy:@"lastMessage.date"
                                       ascending:NO
                                   withPredicate:nil
                                         groupBy:nil
                                        delegate:delegate
                                       inContext:[self private_context]];
    });

    return controller;
}

+ (CDChat *)getOrInsertChatWithPredicate:(NSPredicate *)predicate configBlock:(void (^)(CDChat *theChat))configBlock
{
    __block CDChat *chat;

    dispatch_sync([self private_queue], ^{
        chat = [CDChat MR_findFirstWithPredicate:predicate inContext:[self private_context]];

        if (! chat) {
            chat = [NSEntityDescription insertNewObjectForEntityForName:@"CDChat"
                                                 inManagedObjectContext:[self private_context]];

            if (configBlock) {
                configBlock(chat);
            }

            [[self private_context] MR_saveToPersistentStoreAndWait];
        }
    });

    return chat;
}

+ (CDChat *)editChatWithPredicate:(NSPredicate *)predicate editBlock:(void (^)(CDChat *theChat))editBlock
{
    __block CDChat *chat;

    dispatch_sync([self private_queue], ^{
        chat = [CDChat MR_findFirstWithPredicate:predicate inContext:[self private_context]];

        if (chat && editBlock) {
            editBlock(chat);

            [[self private_context] MR_saveToPersistentStoreAndWait];
        }
    });

    return chat;
}

@end