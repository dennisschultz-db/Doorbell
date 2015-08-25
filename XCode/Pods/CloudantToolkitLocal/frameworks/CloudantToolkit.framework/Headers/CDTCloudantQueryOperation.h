/*
 * IBM Confidential OCO Source Materials
 *
 * 5725-I43 Copyright IBM Corp. 2015, 2015
 *
 * The source code for this program is not published or otherwise
 * divested of its trade secrets, irrespective of what has
 * been deposited with the U.S. Copyright Office.
 *
 */

#import "CDTQueryOperation.h"
@class CDTCloudantQuery;

@interface CDTCloudantQueryOperation : CDTQueryOperation

/**
 * Initialize an CDTQueryOperation object with an CDTQuery. Used when starting a new query.
 * @param query CDTQuery to run.
 * @return CDTQueryOperation
 */
- (instancetype) initWithQuery: (CDTCloudantQuery*) query;

/**
 * Initialize an CDTQueryOperation object with an CDTQueryCursor. Used when the last query operation has
 * more results to return but limited by the resultsLimit setting. The new CDTQueryOperation will run the
 * same query and try to position the cursor at where the last result was returned
 * @param cursor CDTQueryCursor
 * @return CDTQueryOperation
 */
- (instancetype) initWithCursor: (CDTQueryCursor*) cursor;

@end
