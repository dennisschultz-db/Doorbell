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

#import <Foundation/Foundation.h>
#import <CloudantToolkit/CDTStoreOperation.h>

@class CDTQuery;
@class CDTViewQuery;
@class CDTQueryCursor;

extern NSUInteger CDTQueryDefaultMaximumResults;

/**
 CDTQueryOperation handles query operations.
 To use, initialize an CDTQueryOperation object with either an CDTQuery or an CDTQueryCursor returned by a prior CDTQueryOperation. Create and assign a recordFetchBlock to handle your results. Create and assign a queryCompletionBlock to receive any error during the query. You can limit the number of results returned by setting the resultsLimit property. CDTQueryCursor in the queryCompletion block will be set if there are more results to return. You can then initialize a new CDTQueryOperation with the cursor to continue the query. Note that running a query with CDTQueryCursor will cause a new query to run. If the result set has changed the result returned may not start where the last query left off. Records may be repeated or missed when continuing a query with CDTQueryCursor.
 */
@interface CDTQueryOperation : CDTStoreOperation


/**
 * Query to run
 */
@property (nonatomic, readonly, strong) CDTQuery *query;

/**
 * Cursor to use when continuing a prior query
 */
@property (nonatomic, readonly, strong) CDTQueryCursor *cursor;

/**
 * Limit the results returned when set. By default it is set to no limit
 */
@property (nonatomic, assign) NSUInteger resultsLimit;

/**
 * Sets the recordFetchBlock to receive a callback for every record fetched.
 */
@property (nonatomic, copy) void (^recordFetchBlock) (NSObject *record);

/**
 * Sets the queryCompletionBlock to receive a callback when the query completes.
 */
@property (nonatomic, copy) void (^queryCompletionBlock) (CDTQueryCursor *cursor, NSError* error);


//@property (nonatomic, copy)   NSArray *desiredKeys; // Need to check if it is implemented by Cloudant Sync?


@end
