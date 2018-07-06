//
//  APIController+User.h
//  papr
//
//  Created by Brian WF Tobin on 8/8/17.
//  Copyright © 2017 Jebudas Communications, Inc. All rights reserved.
//

#import "APIController.h"
#import "DataController.h"

typedef void(^UserSuccess)(NSDictionary *userDictionary);
typedef void(^UserFailure)(NSError *error);


@interface APIController (User)

// SEND FACEBOOK ACCOUNT KIT AUTH CODE TO SERVER
- (void) sendAuthCode:(NSString *)codeRCVD success:(UserSuccess)success failure:(UserFailure)failure;
// SEND USERNAME TO SERVER FOR ACCOUNT CREATION
- (void) sendLoginKit:(NSDictionary *)loginKitRCVD success:(UserSuccess)success failure:(UserFailure)failure;
// UPDATE USER
- (void) updateUser:(NSDictionary *)userDictionaryRCVD success:(UserSuccess)success failure:(UserFailure)failure;
// GET FEATURED SUBSCRIPTIONS
- (void) getSignupSubscriptions:(NSDictionary *)parameters success:(UserSuccess)success failure:(UserFailure)failure;
// GET USER PROFILE
- (void) getUserProfile:(NSDictionary *)parameters success:(UserSuccess)success failure:(UserFailure)failure;
// GET FOLLOWERS
- (void) getMyFollowers:(NSDictionary *)parameters success:(UserSuccess)success failure:(UserFailure)failure;
// GET FOLLOWING
- (void) getMyFollowing:(NSDictionary *)parameters success:(UserSuccess)success failure:(UserFailure)failure;
// SUBSCRIBE TO THIS USER
- (void) updateMyFollowStatusForPublisher:(NSDictionary *)loginKitRCVD success:(UserSuccess)success failure:(UserFailure)failure;
// REQUEST PUBLISHER ABILITY
- (void) requestPublisherAbility:(NSDictionary *)parameters success:(UserSuccess)success failure:(UserFailure)failure;

@end
