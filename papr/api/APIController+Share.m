//
//  APIController+Share.m
//  papr
//
//  Created by Brian WF Tobin on 5/23/18.
//  Copyright © 2018 Jebudas Communications, Inc. All rights reserved.
//

#import "APIController+Share.h"

@implementation APIController (Share)

// GET SHARE URL
- (void) getShareURL:(NSDictionary *)parametersRCVD success:(ShareSuccess)success failure:(ShareFailure)failure {
    
    NSString *path = [NSString stringWithFormat:@"%@/api/atsbtsip1p1/share/?format=json", PAPR_API_BASE_URL];
    
    [self apiGET:path parameters:parametersRCVD success:^(NSURLSessionDataTask *task, id responseObject) {
        
        success(responseObject);
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        failure(error);
        
    }];
    
}

// POST SHARE URL
- (void) postShareURL:(NSDictionary *)parametersRCVD success:(ShareSuccess)success failure:(ShareFailure)failure {
    
    NSString *path = [NSString stringWithFormat:@"%@/api/atsbtsip1p1/share/?format=json", PAPR_API_BASE_URL];
    
    [self apiPOST:path parameters:parametersRCVD success:^(NSURLSessionDataTask *task, id responseObject) {
        
        success(responseObject);
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        failure(error);
        
    }];
    
}


@end
