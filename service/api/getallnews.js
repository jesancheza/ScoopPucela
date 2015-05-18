exports.get = function(request, response) {
    
    var estado = request.query.estado;
    var querySQL = "Select titulo, noticia, autor, estado, rating from news where estado = '"+ estado +"'";
    
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