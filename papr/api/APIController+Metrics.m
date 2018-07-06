//
//  APIController+Metrics.m
//  papr
//
//  Created by Brian WF Tobin on 9/26/17.
//  Copyright © 2017 Jebudas Communications, Inc. All rights reserved.
//

#import "APIController+Metrics.h"


@implementation APIController (Metrics)


// GET Metrics
- (void) getMetrics:(NSDictionary *)metricsDictionaryRCVD success:(MetricsSuccess)success failure:(MetricsFailure)failure {
    
    NSString *path = [NSString stringWithFormat:@"%@/api/metrics/category/?format=json", PAPR_API_BASE_URL];
    
    [self apiGET:path parameters:metricsDictionaryRCVD success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSArray *responseItems = [[NSArray alloc] initWithArray:[responseObject objectForKey:@"Items"]];
        NSDictionary *responseDictionary;
        if (responseItems.count > 0) {
            responseDictionary = [[NSDictionary alloc] initWithDictionary: [responseItems objectAtIndex:0] ];
        } else {
            responseDictionary = [[NSDictionary alloc] init];
        }
        
        success(responseDictionary);
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        failure(error);
        
    }];
    
}

// PUBLISH METRICS
- (void) publishMetrics:(NSDictionary *)metricsDictionaryRCVD success:(MetricsSuccess)success failure:(MetricsFailure)failure {
    
    NSString *path = [NSString stringWithFormat:@"%@/api/metrics/category/?format=json", PAPR_API_BASE_URL];
    
    [self apiPOST:path parameters:metricsDictionaryRCVD success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSArray *responseItems = [[NSArray alloc] initWithArray:[responseObject objectForKey:@"Items"]];
        NSDictionary *responseDictionary;
        if (responseItems.count > 0) {
            responseDictionary = [[NSDictionary alloc] initWithDictionary: [responseItems objectAtIndex:0] ];
        } else {
            responseDictionary = [[NSDictionary alloc] init];
        }
        
        success(responseDictionary);
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        failure(error);
        
    }];
    
}


- (NSString *) returnFBTimestamp {
    
    NSString *timestamp = [[NSProcessInfo processInfo] globallyUniqueString];
    
    int digit_08 = arc4random_uniform(9);
    int digit_18 = 8 - digit_08;
    
    NSString *string_08 = [NSString stringWithFormat:@"%i", digit_08];
    NSString *string_18 = [NSString stringWithFormat:@"%i", digit_18];
    
    timestamp = [timestamp stringByReplacingCharactersInRange:NSMakeRange(8, 1) withString:string_08];
    timestamp = [timestamp stringByReplacingCharactersInRange:NSMakeRange(18, 1) withString:string_18];
    
    return timestamp;
    
}

@end
