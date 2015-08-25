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
#import <CloudantToolkit/CDTQuery.h>

/**
 * CDTCloudant query provides the convenience of using NSPredicates and performing a query on either a remote or local database.  Cloudant queries can also be specified directly as an NSDictionary.
 */
@interface CDTCloudantQuery : CDTQuery

/**
 * Specifies a reference to a Cloudant query in the form of a NSDictionary.
 */
@property (nonatomic, strong) NSDictionary* cloudantQuery;


/**
  A NSArray of columns to sort in the form of: @{<colname>:@"asc" | @"desc"}
 */
@property (nonatomic, strong) NSArray* sortDescriptors;

/**
 * Initializes an instance of CDTQuery with NSPredicate.
 * @param predicate NSPredicate to generate a query.
 * @return An instance of CDTCloudantQuery.
 */
- (instancetype) initWithPredicate: (NSPredicate*) predicate;

/**
 * Initializes an instance of CDTCloudantQuery with NSPredicate and sort descriptors.
 * @param predicate NSPredicate to generate a query.
 * @param sortDescriptors A NSArray of columns to sort in the form of: @{<colname>:@"asc" | @"desc"}
 * @return An instance of CDTCloudantQuery.
 */
- (instancetype) initWithPredicate: (NSPredicate*) predicate sortDescriptors: (NSArray*) sortDescriptors;

/**
 * Initializes an instance of CDTCloudantQuery with NSPredicate to query for data type.
 * @param dataType The type of objects to return from the query.  Only objects of type datatype are returned.
 * @return An instance of CDTCloudantQuery.
 */
- (instancetype) initDataType: (NSString*) dataType;

/**
 * Initializes an instance of CDTCloudantQuery with NSPredicate.
 * @param dataType The type of objects to return from the query.  Only objects of type datatype are returned.
 * @param predicate NSPredicate to generate a query.
 * @return An instance of CDTCloudantQuery.
 */
- (instancetype) initDataType: (NSString*) dataType withPredicate: (NSPredicate*) predicate;

/**
 * Initializes an instance of CDTCloudantQuery with NSPredicate and sort descriptors.
 * @param dataType The type of objects to return from the query.  Only objects of type datatype are returned.
 * @param predicate NSPredicate to generate a query.
 * @param sortDescriptors A list of columns to sort in the form of: @{<colname>:@"asc" | @"desc"}
 * @return An instance of CDTCloudantQuery.
 */
- (instancetype) initDataType: (NSString*) dataType withPredicate: (NSPredicate*) predicate sortDescriptors: (NSArray*) sortDescriptors;

/**
 * Initializes an instance of CDTCloudantQuery with NSPredicate and sort descriptors.
 * @param cloudantQuery The NSDictionary that contains a Cloudant Query.
 * @return An instance of CDTCloudantQuery.
 */
-(instancetype) initWithCloudantQuery: (NSDictionary*) cloudantQuery;

/**
 * Initializes an instance of CDTCloudantQuery with NSPredicate and sort descriptors.
 * @param cloudantQuery The NSDictionary that contains a Cloudant Query.
 * @param sortDescriptors A list of columns to sort in the form of: @{<colname>:@"asc" | @"desc"}
 * @return An instance of CDTCloudantQuery.
 */
-(instancetype) initWithCloudantQuery: (NSDictionary*) cloudantQuery sortDescriptors: (NSArray*) sortDescriptors;


@end
