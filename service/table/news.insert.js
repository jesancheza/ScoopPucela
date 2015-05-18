function insert(item, user, request) {
    if (item.noticia != "" && item.titulo != "") {
        request.execute();
    } else {
        request.respond(statusCodes.BAD_REQUEST, 'El título y la noticia son obligatorios');
    }
}