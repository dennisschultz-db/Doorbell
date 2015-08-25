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
/**
 * Query Cursor is an opaque object returned by CDTQueryOperation.
 * If returned by CDTQueryOperation it indicates that there may be more results to return
 * The user can initialize a new CDTQueryOperation with this cursor to fetch the next 
 *    page of results.
 */
@interface CDTQueryCursor : NSObject

/**
The query associated with this cursor
 */
@property (readonly, nonatomic, strong) CDTQuery* query;

/**
 The offset associated with this cursor.  A query will skip to this offset when returning results.
 */
@property (readonly, nonatomic, strong) NSNumber* offset;

/**
 Creates a new CDTQueryCursor to enable paging of queries.
 @param query The query to be used for this cursor
 @param offset A query will skip to this offset when returning results.
 @return The CDTQueryCursor that was created
 */
-(instancetype)initWithQuery:(CDTQuery*) query offset:(NSNumber*) offset;

@end
