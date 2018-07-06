//
//  APIController.h
//  papr
//
//  Created by Brian WF Tobin on 8/8/17.
//  Copyright © 2017 Jebudas Communications, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "AFNetworking.h"
#import "DataController.h"
#import "Reachability.h"

// STAGING
// static NSString * const PAPR_API_BASE_URL = @"http://papr-be-dev-20170810.us-east-1.elasticbeanstalk.com ";
// static NSString * const PAPR_API_BASE_URL = @"http://papr-be-dev-20170811.us-east-1.elasticbeanstalk.com";
// PRODUCTION
static NSString * const PAPR_API_VERSION = @"atsbtsip1p1"; // WHAT MATTERS HERE IS THE 1p1 AT THE END (1.1)
static NSString * const PAPR_API_BASE_URL = @"https://papr.co";
static NSString * const PAPR_API_SHARE_URL = @"https://papr.co/s";
// DEPRECATED IN v1.4
static NSString * const PAPR_API_ARTICLE_URL = @"https://papr.co/article/?article_url=";

typedef void(^ApiControllerSuccess)(NSURLSessionDataTask *task, id responseObject);
typedef void(^ApiControllerFailure)(NSURLSessionDataTask *task, NSError *error);


@interface APIController : NSObject {

    //
    
}

// AUTRE
@property (strong,nonatomic) NSDate *start;
// VOTES
@property (nonatomic, strong) NSMutableDictionary *voteDictionary;
@property (nonatomic, strong) NSMutableArray *arrayOfComments;
@property (nonatomic, strong) NSMutableArray *arrayOfLikes;
@property (nonatomic, strong) NSMutableArray *arrayOfViews;
@property (nonatomic, strong) NSMutableArray *arrayOfVotesUp;
@property (nonatomic, strong) NSMutableArray *arrayOfVotesDown;


// AFNETWORKING
- (void) apiGET : (NSString *)urlRCVD parameters:(NSDictionary *)parametersRCVD success:(ApiControllerSuccess)success failure:(ApiControllerFailure)failure;
- (void) apiPOST : (NSString *)urlRCVD parameters:(NSDictionary *)parametersRCVD success:(ApiControllerSuccess)success failure:(ApiControllerFailure)failure;
// VOTING
- (NSDictionary *) returnVoteDictionary;
- (void) addComments : (NSString *)commentRCVD;
- (void) addLikes : (NSString *)likeRCVD;
- (void) removeLikes : (NSString *)likeRCVD;
- (void) addViews : (NSString *)viewRCVD;
- (void) addUpVotes : (NSString *)voteRCVD;
- (void) removeUpVotes : (NSString *)voteRCVD;
- (void) addDownVotes : (NSString *)voteRCVD;
- (void) removeDownVotes : (NSString *)voteRCVD;
// SINGLETON
+ (APIController *) api;


@end




