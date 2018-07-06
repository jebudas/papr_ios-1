//
//  APIController+Statistics.m
//  papr
//
//  Created by Brian WF Tobin on 10/16/17.
//  Copyright © 2017 Jebudas Communications, Inc. All rights reserved.
//

#import "APIController+Statistics.h"


@implementation APIController (Statistics)

// GET USER SUBSCRIPTIONS
- (void) getStats:(NSDictionary *)parametersRCVD success:(StatisticsSuccess)success failure:(StatisticsFailure)failure {
    
#warning GGXGG
    return;

    NSString *path = [NSString stringWithFormat:@"%@/api/%@/statistics/?format=json", PAPR_API_BASE_URL, PAPR_API_VERSION];

    [self apiGET:path parameters:parametersRCVD success:^(NSURLSessionDataTask *task, id responseObject) {
        
        success(responseObject);
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        failure(error);
        
    }];
    
}
// POST STATS
- (void) postStats:(NSDictionary *)statsDictionaryRCVD success:(StatisticsSuccess)success failure:(StatisticsFailure)failure {
    
#warning GGXGG
    return;

    NSString *path = [NSString stringWithFormat:@"%@/api/%@/statistics/?format=json", PAPR_API_BASE_URL, PAPR_API_VERSION];

    NSDictionary *statsDictionary = @{@"stats_dictionary" : statsDictionaryRCVD};
    
    [self apiPOST:path parameters:statsDictionary success:^(NSURLSessionDataTask *task, id responseObject) {
        
        success(responseObject);
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        failure(error);
        
    }];
    
}
// SEND STATS
- (void) sendStatistics {
    
}

// POST STATS . VIEWS
- (void) postStatisticsViews:(NSDictionary *)statsDictionaryRCVD success:(StatisticsSuccess)success failure:(StatisticsFailure)failure {
    
#warning GGXGG
    return;

    NSString *path = [NSString stringWithFormat:@"%@/api/%@/statistics/views/?format=json", PAPR_API_BASE_URL, PAPR_API_VERSION];
    
    NSDictionary *statsDictionary = @{@"stats_dictionary" : statsDictionaryRCVD};
    
    [self apiPOST:path parameters:statsDictionary success:^(NSURLSessionDataTask *task, id responseObject) {
        
        success(responseObject);
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        failure(error);
        
    }];
    
}


@end
