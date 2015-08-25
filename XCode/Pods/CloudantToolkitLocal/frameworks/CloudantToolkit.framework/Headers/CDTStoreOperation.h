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
#import <CloudantToolkit/CDTOperation.h>

@class CDTQuery;
@class CDTQueryCursor;
@class CDTStore;

/**
 * A Database operation is the base class for all operations having to do with the Database.
 */
@interface CDTStoreOperation : CDTOperation

/**
 * Reference to the database
 */
@property (nonatomic, strong) CDTStore* store;

@end
