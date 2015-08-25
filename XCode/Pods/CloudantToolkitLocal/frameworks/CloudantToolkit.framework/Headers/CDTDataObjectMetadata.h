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
 The CDTDataObjectMetadata class defines metadata that is required to manage the CDTDataObject object.
 */
@interface CDTDataObjectMetadata : NSObject

/** A string that uniquely identifies this object. This will be the docId of the CDTDocumentRevision that is persisted. */
@property (nonatomic, readonly) NSString	*documentId;

/** A string that identifies the revision for this object. This will be the revId of the CDTDocumentRevision that is persisted. */
@property (nonatomic, readonly) NSString    *revisionId;

/** Indicates if this revision has been deleted. This also corresponds to the CDTDocumentRevision deleted field.*/
@property (nonatomic, readonly) BOOL        deleted;

@end
