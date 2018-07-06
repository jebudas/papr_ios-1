//
//  APIController+Paprboy.h
//  papr
//
//  Created by Brian WF Tobin on 8/23/17.
//  Copyright © 2017 Jebudas Communications, Inc. All rights reserved.
//

#import "APIController.h"


typedef void(^PaprboySuccess)(NSDictionary *PaprboyDictionary);
typedef void(^PaprboyFailure)(NSError *error);


@interface APIController (Paprboy)

// GET SINGLE EDITION
- (void) getEdition:(NSDictionary *)parameters success:(PaprboySuccess)success failure:(PaprboyFailure)failure;
// GET FEATURED SUBSCRIPTIONS
- (void) getSubscriptions:(NSDictionary *)parameters success:(PaprboySuccess)success failure:(PaprboyFailure)failure;
// GET ARTICLE JSON FROM URL
- (void) getArticle:(NSDictionary *)urlRCVD success:(PaprboySuccess)success failure:(PaprboyFailure)failure;
// POST USER SUBSCRIPTIONS TO DATABASE
- (void) updateUserSubscriptions:(NSArray *)subscriptionsRCVD success:(PaprboySuccess)success failure:(PaprboyFailure)failure;
// POST ITEM
- (void) postItemToPapr:(NSDictionary *)newItemDictionaryRCVD success:(PaprboySuccess)success failure:(PaprboyFailure)failure;
// GET ARCHIVE
- (void) getArchives:(NSDictionary *)userDictionaryRCVD success:(PaprboySuccess)success failure:(PaprboyFailure)failure;
// SAVE ITEM TO ARCHIVE
- (void) saveItemToArchives:(NSDictionary *)newItemDictionaryRCVD success:(PaprboySuccess)success failure:(PaprboyFailure)failure;
// GET SAVED_POSTS
- (void) getSavedPosts:(PaprboySuccess)success failure:(PaprboyFailure)failure;
// SAVE ITEM TO SAVED_POSTS
- (void) saveItemToSavedPosts:(NSDictionary *)newItemDictionaryRCVD success:(PaprboySuccess)success failure:(PaprboyFailure)failure;

@end
