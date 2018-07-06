//
//  APIController+Comments.h
//  papr
//
//  Created by Brian WF Tobin on 9/17/17.
//  Copyright © 2017 Jebudas Communications, Inc. All rights reserved.
//

#import "APIController.h"
#import "DataController.h"

typedef void(^CommentsSuccess)(NSDictionary *CommentsDictionary);
typedef void(^CommentsFailure)(NSError *error);

@interface APIController (Comments)


// GET COMMENTS
- (void) getComments:(NSDictionary *)commentDictionaryRCVD success:(CommentsSuccess)success failure:(CommentsFailure)failure;
// PUBLISH COMMENT
- (void) publishComment:(NSDictionary *)commentDictionaryRCVD success:(CommentsSuccess)success failure:(CommentsFailure)failure;
// GET REPLIES
- (void) getReplies:(NSDictionary *)commentDictionaryRCVD success:(CommentsSuccess)success failure:(CommentsFailure)failure;
// GET NOTIFICATIONS
- (void) getNotifications:(CommentsSuccess)success failure:(CommentsFailure)failure;
// PUBLISH NOTIFICATIONS
- (void) postNotifications:(NSDictionary *)commentDictionaryRCVD success:(CommentsSuccess)success failure:(CommentsFailure)failure;



@end
