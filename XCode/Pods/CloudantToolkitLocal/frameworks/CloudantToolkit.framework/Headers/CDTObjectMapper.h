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
@class CDTStore;
@class CDTDocumentRevision;

#define CDT_DATATYPE_KEY    @"@datatype"
#define CDT_DATATYPE_INDEX_NAME @"cdtdatatypeindex"

/**
 Provides the ability to insert custom code to map native objects onto CDTDocumentRevisions.  This allows the developer to program with native objects and persist them to Cloudant.
 */
@protocol CDTObjectMapper <NSObject>

/**
 Maps a native Object to a CDTDocumentRevision.
 @param object The input Object
 @param error Error found during mapping or nil
 @return the mapped CDTDocumentRevision
 */
-(CDTDocumentRevision*) objectToDocument: (id) object error: (NSError**) error;

/**
 Maps a CDTDocumentRevision to a native Object.
 @param document The CDTDocumentRevision to map
 @param error Error found during mapping or nil
 @return the mapped native Object
 */
-(id) documentToObject: (CDTDocumentRevision*) document error: (NSError**) error;

/**
 Looks up the data type for a given class.
 @param className The name of the class to lookup
 @return The dataType for the class.
 */
-(NSString*) dataTypeForClassName: (NSString*) className;

/**
 Looks up the Class for a given data type.
 @param dataType The data type to lookup
 @return The class name for the data type.
 */
-(NSString*) classNameForDataType: (NSString*) dataType;

/**
 Associates a data type with a class name
 @param dataType The data type to associate with the class
 @param className The class name to be associated with the dataType
 */
-(void)setDataType:(NSString*)dataType forClassName: (NSString*)className;

@end
