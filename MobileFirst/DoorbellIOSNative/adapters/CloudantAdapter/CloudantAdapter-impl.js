/*
 *
    COPYRIGHT LICENSE: This information contains sample code provided in source code form. You may copy, modify, and distribute
    these sample programs in any form without payment to IBM® for the purposes of developing, using, marketing or distributing
    application programs conforming to the application programming interface for the operating platform for which the sample code is written.
    Notwithstanding anything to the contrary, IBM PROVIDES THE SAMPLE SOURCE CODE ON AN "AS IS" BASIS AND IBM DISCLAIMS ALL WARRANTIES,
    EXPRESS OR IMPLIED, INCLUDING, BUT NOT LIMITED TO, ANY IMPLIED WARRANTIES OR CONDITIONS OF MERCHANTABILITY, SATISFACTORY QUALITY,
    FITNESS FOR A PARTICULAR PURPOSE, TITLE, AND ANY WARRANTY OR CONDITION OF NON-INFRINGEMENT. IBM SHALL NOT BE LIABLE FOR ANY DIRECT,
    INDIRECT, INCIDENTAL, SPECIAL OR CONSEQUENTIAL DAMAGES ARISING OUT OF THE USE OR OPERATION OF THE SAMPLE SOURCE CODE.
    IBM HAS NO OBLIGATION TO PROVIDE MAINTENANCE, SUPPORT, UPDATES, ENHANCEMENTS OR MODIFICATIONS TO THE SAMPLE SOURCE CODE.

 */

//Database Methods



function createDB(name) {
	var method = "createDB";
	var msg = "method: <" + method + "> called.";
	WL.Logger.info(msg);
	var input = {
		    method : 'put',
		    returnedContentType : 'json',
		    path : name
		};
	
	return WL.Server.invokeHttp(input);
}

function deleteDB(name) {
	var method = "deleteDB";
	var msg = "method: <" + method + "> called.";
	WL.Logger.info(msg);
	var input = {
		    method : 'delete',
		    returnedContentType : 'json',
		    path : name
		};
	
	return WL.Server.invokeHttp(input);
}

function getAllDocs(name, limit, include_docs) {
	var method = "getAllDocs";
	var msg = "method: <" + method + "> called.";
	WL.Logger.info(msg);
	
	var path = name + '/_all_docs?include_docs=' + include_docs;
	if ((limit !== null) && (!isNaN(limit))) {
		path = path + "&limit=" + limit;
	}
	
	WL.Logger.info("Path: " + path);
	var input = {
		    method : 'get',
		    returnedContentType : 'json',
		    path : path,
		};
	
	return WL.Server.invokeHttp(input);
}

function updateDocs(name, updates) {
	var input = {
		    method : 'post',
		    returnedContentType : 'json',
		    path : name + '/_bulk_docs',
		    body: { 
                contentType : 'application/json',         
                content : createJsonObject('docs', updates)
            }
		};
	
	return WL.Server.invokeHttp(input);
}

// Document Methods
function createDoc(name, doc) {
	
	var input = {
		    method : 'post',
		    returnedContentType : 'json',
		    path : name + '/',
		    body: { 
	            contentType : 'application/json',         
	            content : JSON.stringify(doc)
	        }
		};
	
	return WL.Server.invokeHttp(input);
}

function getDoc(name, docID) {
	var path = name + '/' + docID;
	WL.Logger.info("Path: " + path);
	var input = {
		    method : 'get',
		    returnedContentType : 'json',
		    path : path
		};
	
	return WL.Server.invokeHttp(input);
}

function updateDoc(name, doc) {
	var input = {
		    method : 'put',
		    returnedContentType : 'json',
		    path : name,
		    body: { 
                contentType : 'application/json',         
                content : doc
            }
		};
	
	return WL.Server.invokeHttp(input);
}

function deleteDoc(name, docID, docRev) {
	var input = {
		    method : 'delete',
		    returnedContentType : 'json',
		    path : name + '/' + docID + '?rev=' + docRev
		};
	
	return WL.Server.invokeHttp(input);
}

function createDesignDoc(name, docName, designDoc) {
	var input = {
		    method : 'put',
		    returnedContentType : 'json',
		    path : name + '/_design/' + docName,
		    body: { 
                contentType : 'application/json',         
                content : designDoc
            }
		};
	
	return WL.Server.invokeHttp(input);
}

function search(name, designDocName, viewName, limit, include_docs, query) {
	
	var path = name + '/_design/' + designDocName + '/_search/' + viewName + '?q=' + query + '&include_docs=' + include_docs;
	
	if ((limit !== null) && (!isNaN(limit))) {
		path = path + "&limit=" + limit;
	}
	
	var input = {
		    method : 'get',
		    returnedContentType : 'json',
		    path : path
		};
	
	return WL.Server.invokeHttp(input);
}

function getView(name, designDocName, viewName, group) {
	
	var path = name + '/_design/' + designDocName + '/_view/' + viewName + '?group=' + group;
	
	var input = {
		    method : 'get',
		    returnedContentType : 'json',
		    path : path
		};
	
	return WL.Server.invokeHttp(input);
}

