//
//  APIController+Search.m
//  papr
//
//  Created by Brian WF Tobin on 9/22/17.
//  Copyright © 2017 Jebudas Communications, Inc. All rights reserved.
//

#import "APIController+Search.h"

@implementation APIController (Search)

// GET USER SUBSCRIPTIONS
- (void) getFeatured:(NSDictionary *)parametersRCVD success:(SearchSuccess)success failure:(SearchFailure)failure {
    
    NSString *path = [NSString stringWithFormat:@"%@/api/search/featured/?format=json", PAPR_API_BASE_URL];
    
    [self apiGET:path parameters:parametersRCVD success:^(NSURLSessionDataTask *task, id responseObject) {
        
        success(responseObject);
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        failure(error);
        
    }];
    
}

// GET SEARCH USERS
- (void) getUsers:(NSDictionary *)parametersRCVD success:(SearchSuccess)success failure:(SearchFailure)failure {
    
    NSString *path = [NSString stringWithFormat:@"%@/api/search/search/?format=json", PAPR_API_BASE_URL];
    
    [self apiGET:path parameters:parametersRCVD success:^(NSURLSessionDataTask *task, id responseObject) {
        
        success(responseObject);
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        failure(error);
        
    }];
    
}

@end
