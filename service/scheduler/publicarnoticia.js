function publicarnoticia() {
    console.log("Corriendo job");
    
    var updateQuery = "UPDATE news SET estado='Publicada' WHERE estado = 'Pendiente publicar'";
    
    mssql.query(updateQuery);
}