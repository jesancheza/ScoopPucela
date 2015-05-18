exports.get = function(request, response) {
    
    var authenticatedUserId = request.user.userId;

    var providerName = authenticatedUserId.split(":")[0];
    var providerUserId = authenticatedUserId.split(":")[1];
    
    var querySQL = "Select titulo, estado, rating from news where userID = '"+ providerUserId +"'";
    
    console.log(querySQL);
    
    var mssql = request.service.mssql;
    
    mssql.query(querySQL, {
       success:function(result){
           response.send(200, result);
       },
       error:function(error){
           response.error(error);
       } 
    });
};