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
@protocol CDTObjectMapper;

@class CDTDatastore;
@class CDTQuery;

/**
 The CDTStore class is a class cluster that abstracts an common interface for local and remote Cloudant data stores.  Local data stores use the CDTDatastore and remote data stores use REST API to modify the remote data store.
 */
@interface CDTStore : NSObject

/** Specifies the CDTObjectMapper to use for mapping CDTDocumentRevision objects to objects and vice versa. */
@property id<CDTObjectMapper> mapper;

/**The CDTStore name*/
@property (readonly, atomic) NSString *name;

/**
 Indicates whether a CDTObjectMapper must be set when @datatype is part of the JSON body.
 */
@property (atomic) BOOL requireMapperWithDatatype;

/**
 Creates a CDTStore that is local to the device.
 @param datastore Specifies the CDTDatastore from which to create the local CDTStore.
 @return The newly created CDTStore.
 */
+(CDTStore*) localStoreWithDatastore: (CDTDatastore*) datastore;


/**
 Creates a CDTStore configured to access a remote Cloudant database.  If the remote Cloudant database does not exist, it will be created.
 @param url Specifies the NSURL for the Cloudant remote database.
 @param completionHandler Specifies the completion handler to call when the CDTStore has been created.
 @return The newly created CDTStore.
 */
+(void) remoteStoreWithUrl:(NSURL *)url completionHandler:(void (^)(CDTStore* store, NSError *error))completionHandler;

/**
 Creates an index on the CDTStore.  Indexes must be created on fields that are used in CDTQuery operations.
 @param indexName Specifies the name of the new index.
 @param fields Specifies the field names to index.
 @param completionHandler Specifies the completionHandler to call upon completion. The creation of an index is an asynchronous event.  If the error is nil, the operation was successful.
 */
-(void) createIndexWithName: (NSString*) indexName fields: (NSArray*) fields completionHandler: (void(^) (NSError *error)) completionHandler;

/**
 Deletes an index with a specific name.
 @param indexName Specifies the name of the index to delete.
 @param completionHandler Specifies the completionHandler to call upon completion. The deletion of an index is an asynchronous event.  If the error is nil, the operation was successful.
 */
-(void) deleteIndexWithName: (NSString*) indexName completionHandler: (void(^) (NSError *error)) completionHandler;

/**
 Creates an index with a data type. The data type is a cross-platform data type that can be used in CDTQuery.  There are corresponding CDTQuery methods that utilize the data type.  This method will create an index with the specified fields plus the field @datatype.  The @datatype can be used to model data objects.  The indexName will automatically be generated based on the dataType.
 @param dataType Specifies the class on which to create an index.
 @param fields Specifies the field names to index.
 @param completionHandler Specifies the completionHandler to call upon completion. The creation of an index is an asynchronous event.  If the error is nil, the operation was successful.
 */
-(void) createIndexWithDataType: (NSString*) dataType fields: (NSArray*) fields completionHandler: (void(^) (NSError *error)) completionHandler;

/**
Deletes an index with a data type. 
 @param dataType Specifies the class on which to delete an index.
 @param completionHandler Specifies the completionHandler to call upon completion. The deletion of an index is an asynchronous event.  If the error is nil, the operation was successful.
 */
-(void) deleteIndexWithDataType: (NSString*) dataType completionHandler: (void(^) (NSError *error)) completionHandler;

/**
 * Runs a query on the database. When the query is completed, the results are passed back in the NSArray.
 * @param query Specifies the query to run
 * @param completionHandler Specifies the completionHandler to call when the query completes.
 */
- (void) performQuery:(CDTQuery *)query completionHandler:(void (^)(NSArray *results, NSError *error)) completionHandler;

/**
 Saves an object to the CDTStore.
 @param objectToSave Specifies the object to save.
 @param completionHandler Specifies the completionHandler to call when the save is complete. Saving an object is an asynchronous event.  If error is nil, the operation was successful.
 */
-(void) save: (id) objectToSave completionHandler: (void (^)(id savedObject, NSError *error))completionHandler;

/**
 Deletes an object from the CDTStore.
 @param objectToDelete Specifies the object to delete.
 @param completionHandler Specifies the completionHandler to call when the deletion is complete. Deleting an object is an asynchronous event.  If error is nil, the operation was successful.
 */
-(void) delete: (id) objectToDelete completionHandler: (void (^)(NSString* deletedObjectId, NSString *deletedRevisionId, NSError *error))completionHandler;

/**
 Fetches an object with the objectId from the CDTStore
 @param documentId Specifies the object to fetch.
 @param completionHandler Specifies the completionHandler to call when the fetch is complete. Fetching an object is an asynchronous event.  If error is null, the operation was successful.
 */
-(void) fetchById: (NSString*) documentId completionHandler: (void (^)(id object, NSError *error))completionHandler;

/**
 * Add an operation to the database queue
 * @param operation Operation to add to the database operation queue
 */
- (void) addOperation:(NSOperation*) operation;

@end
