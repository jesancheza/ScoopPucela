var azure = require('azure');
var queryString = require('querystring');

exports.get = function(request, response) {
    
    // En el parámetro llega el nombre de la imagen 
    var blobname = request.query.blobname;
    
    var accountName = 'scoopucela';
    var accountKey = 'WPiMR2Z8WUR9ah8/fgoX7xy+OuaF2plnZgMCFG3b1d6+41OV0IyG0VSZHRsrewBJfJTC3JL9A0fZeA21LtpQSA==';
    
    var host = accountName + 'blob.core.windows.net/';
    
    var blobService = azure.createBlobService(accountName, accountKey, host);
    
    var sharedAccessPolicy = {
        AccessPolicy : {
            Permissions: 'r',
            Expiry: minutesFromNow(15)
        }  
    };
    
    var sasURL = blobService.generateSharedAccessSignature('planos',blobname,sharedAccessPolicy);
    
    console.log('SAS ->'. sasURL);
};
