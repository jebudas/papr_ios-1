//
//  APIController+Statistics.h
//  papr
//
//  Created by Brian WF Tobin on 10/16/17.
//  Copyright © 2017 Jebudas Communications, Inc. All rights reserved.
//

#import "APIController.h"

typedef void(^StatisticsSuccess)(NSDictionary *StatisticsDictionary);
typedef void(^StatisticsFailure)(NSError *error);


@interface APIController (Statistics)

// GET USER STATS
- (void) getStats:(NSDictionary *)parameters success:(StatisticsSuccess)success failure:(StatisticsFailure)failure;
// POST STATS
- (void) postStats:(NSDictionary *)statsDictionaryRCVD success:(StatisticsSuccess)success failure:(StatisticsFailure)failure;
// SEND STATS
- (void) sendStatistics;
// POST STATS . VIEWS
- (void) postStatisticsViews:(NSDictionary *)statsDictionaryRCVD success:(StatisticsSuccess)success failure:(StatisticsFailure)failure;


@end
