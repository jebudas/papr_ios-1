//
//  APIController+Paprboy.m
//  papr
//
//  Created by Brian WF Tobin on 8/23/17.
//  Copyright © 2017 Jebudas Communications, Inc. All rights reserved.
//

#import "APIController+Paprboy.h"


@implementation APIController (Paprboy)

// GET SINGLE EDITION
- (void) getEdition:(NSDictionary *)parameters success:(PaprboySuccess)success failure:(PaprboyFailure)failure {
    
    NSString *path = [NSString stringWithFormat:@"%@/api/paprboy/edition/?format=json", PAPR_API_BASE_URL];
    
    [self apiGET:path parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        
        success(responseObject);
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        failure(error);
        
    }];
    
}


// GET USER SUBSCRIPTIONS
- (void) getSubscriptions:(NSDictionary *)parameters success:(PaprboySuccess)success failure:(PaprboyFailure)failure {
    
    NSString *path = [NSString stringWithFormat:@"%@/api/paprboy/gather/?format=json", PAPR_API_BASE_URL];
    
    [self apiGET:path parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        
        success(responseObject);
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        failure(error);
        
    }];
    
}

- (void) getArticle:(NSDictionary *)urlRCVD success:(PaprboySuccess)success failure:(PaprboyFailure)failure {
    
    NSString *path = [NSString stringWithFormat:@"%@/api/paprboy/newspaper/?format=json", PAPR_API_BASE_URL];
    
    [self apiGET:path parameters:urlRCVD success:^(NSURLSessionDataTask *task, id responseObject) {
        
        success(responseObject);
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        failure(error);
        
    }];
    
}

// POST USER SUBSCRIPTIONS TO DATABASE
- (void) updateUserSubscriptions:(NSArray *)subscriptionsRCVD success:(PaprboySuccess)success failure:(PaprboyFailure)failure {
    
    // TODO GGXGG : WE MIGHT BE ABLE TO DO THIS WITHOUT SENDING THE NSDICTIONARY BC/ THE SUBSCRIPTIONS ARE STORED LOCALLY
    
    NSString *path = [NSString stringWithFormat:@"%@/api/atsbtsip1p1/user/update_user_subscriptions/?format=json", PAPR_API_BASE_URL];
    
    NSDictionary *parameters = @{@"user_subscriptions" : subscriptionsRCVD};
    
    [self apiPOST:path parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        
        success(responseObject);
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        failure(error);
        
    }];
    
}
// POST NEW PAPR ITEM
- (void) postItemToPapr:(NSDictionary *)newItemDictionaryRCVD success:(PaprboySuccess)success failure:(PaprboyFailure)failure {
    
    // TODO GGXGG : WE MIGHT BE ABLE TO DO THIS WITHOUT SENDING THE NSDICTIONARY BC/ THE SUBSCRIPTIONS ARE STORED LOCALLY
    
    NSString *path = [NSString stringWithFormat:@"%@/api/paprboy/publish/?format=json", PAPR_API_BASE_URL];
    
    [self apiPOST:path parameters:newItemDictionaryRCVD success:^(NSURLSessionDataTask *task, id responseObject) {
        
        success(responseObject);
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        failure(error);
        
    }];
    
}
// GET ARCHIVE
- (void) getArchives:(NSDictionary *)userDictionaryRCVD success:(PaprboySuccess)success failure:(PaprboyFailure)failure {
    
    NSString *path = [NSString stringWithFormat:@"%@/api/paprboy/archives/?format=json", PAPR_API_BASE_URL];
    
    [self apiGET:path parameters:userDictionaryRCVD success:^(NSURLSessionDataTask *task, id responseObject) {
        
        success(responseObject);
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        failure(error);
        
    }];
    
}
// SAVE ITEM TO ARCHIVE
- (void) saveItemToArchives:(NSDictionary *)newItemDictionaryRCVD success:(PaprboySuccess)success failure:(PaprboyFailure)failure {
    
    NSString *path = [NSString stringWithFormat:@"%@/api/paprboy/archives/?format=json", PAPR_API_BASE_URL];
    
    [self apiPOST:path parameters:newItemDictionaryRCVD success:^(NSURLSessionDataTask *task, id responseObject) {
        
        success(responseObject);
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        failure(error);
        
    }];
    
}

// GET SAVED_POSTS
- (void) getSavedPosts:(PaprboySuccess)success failure:(PaprboyFailure)failure {
    
    NSString *path = [NSString stringWithFormat:@"%@/api/paprboy/saved_posts/?format=json", PAPR_API_BASE_URL];
    
    NSDictionary *parameters = @{@"publisher_id" : [[DataController dc] returnMyUserID]};
    
    [self apiGET:path parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        
        success(responseObject);
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        failure(error);
        
    }];
    
}
// SAVE ITEM TO SAVED_POSTS
- (void) saveItemToSavedPosts:(NSDictionary *)newItemDictionaryRCVD success:(PaprboySuccess)success failure:(PaprboyFailure)failure {
    
    NSString *path = [NSString stringWithFormat:@"%@/api/paprboy/saved_posts/?format=json", PAPR_API_BASE_URL];
    
    [self apiPOST:path parameters:newItemDictionaryRCVD success:^(NSURLSessionDataTask *task, id responseObject) {
        
        success(responseObject);
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        failure(error);
        
    }];
    
}

@end
