//
//  APIController+Metrics.h
//  papr
//
//  Created by Brian WF Tobin on 9/26/17.
//  Copyright © 2017 Jebudas Communications, Inc. All rights reserved.
//

#import "APIController.h"
#import "DataController.h"

typedef void(^MetricsSuccess)(NSDictionary *MetricsDictionary);
typedef void(^MetricsFailure)(NSError *error);

@interface APIController (Metrics)


// GET Metrics
- (void) getMetrics:(NSDictionary *)metricsDictionaryRCVD success:(MetricsSuccess)success failure:(MetricsFailure)failure;
// PUBLISH METRICS
- (void) publishMetrics:(NSDictionary *)metricsDictionaryRCVD success:(MetricsSuccess)success failure:(MetricsFailure)failure;

@end
