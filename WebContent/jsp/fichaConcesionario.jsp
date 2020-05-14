<%@ page import="java.util.List, 
	java.util.HashMap,
	Utils.RequestUtils,
	model.Concesionario,
	model.controladores.ConcesionarioControlador"%>

<jsp:include page="cabecera.jsp" flush="true">
	<jsp:param name="tituloDePagina" value="Ficha de Concesionarios" />
</jsp:include>

<%
	// Obtengo una HashMap con todos los parámetros del request, sea este del tipo que sea;
HashMap<String, Object> hashMap = RequestUtils.requestToHashMap(request);

// Para plasmar la información de un profesor determinado utilizaremos un parámetro, que debe llegar a este Servlet obligatoriamente
// El parámetro se llama "idProfesor" y gracias a él podremos obtener la información del profesor y mostrar sus datos en pantalla
Concesionario concesionario = null;
// Obtengo el profesor a editar, en el caso de que el profesor exista se cargarán sus datos, en el caso de que no exista quedará a null
try {
	int idConcesionario = RequestUtils.getIntParameterFromHashMap(hashMap, "idConcesionario"); // Necesito obtener el id del profesor que se quiere editar. En caso de un alta
	// de profesor obtendríamos el valor 0 como idProfesor
	if (idConcesionario != 0) {
		concesionario = (Concesionario) ConcesionarioControlador.getControlador().find(idConcesionario);
	}
} catch (Exception e) {
	e.printStackTrace();
}
// Inicializo unos valores correctos para la presentación del profesor
if (concesionario == null) {
	concesionario = new Concesionario();
}
if (concesionario.getCif() == null)
	concesionario.setCif("");
if (concesionario.getNombre() == null)
	concesionario.setNombre("");
if (concesionario.getLocalidad() == null)
	concesionario.setLocalidad("");

// Ahora debo determinar cuál es la acción que este página debería llevar a cabo, en función de los parámetros de entrada al Servlet.
// Las acciones que se pueden querer llevar a cabo son tres:
//    - "eliminar". Sé que está es la acción porque recibiré un un parámetro con el nombre "eliminar" en el request
//    - "guardar". Sé que está es la acción elegida porque recibiré un parámetro en el request con el nombre "guardar"
//    - Sin acción. En este caso simplemente se quiere editar la ficha

// Variable con mensaje de información al usuario sobre alguna acción requerida
String mensajeAlUsuario = "";

// Primera acción posible: eliminar
if (RequestUtils.getStringParameterFromHashMap(hashMap, "eliminar") != null) {
	// Intento eliminar el registro, si el borrado es correcto redirijo la petición hacia el listado de profesores
	try {
		ConcesionarioControlador.getControlador().remove(concesionario);
		response.sendRedirect(request.getContextPath() + "jsp/listaConcesionario.jsp?idPag=1"); // Redirección del response hacia el listado
	} catch (Exception ex) {
		mensajeAlUsuario = "ERROR - Imposible eliminar. Es posible que existan restricciones.";
	}
}

// Segunda acción posible: guardar
if (RequestUtils.getStringParameterFromHashMap(hashMap, "guardar") != null) {
	// Obtengo todos los datos del profesor y los almaceno en BBDD
	try {
		concesionario.setCif(RequestUtils.getStringParameterFromHashMap(hashMap, "cif" ));
		concesionario.setNombre(RequestUtils.getStringParameterFromHashMap(hashMap, "nombre"));
		concesionario.setLocalidad(RequestUtils.getStringParameterFromHashMap(hashMap, "localidad"));
		byte[] posibleImagen = RequestUtils.getByteArrayFromHashMap(hashMap, "ficheroImagen");
		if (posibleImagen != null && posibleImagen.length > 0) {
	concesionario.setImagen(posibleImagen);
		}

		// Finalmente guardo el objeto de tipo profesor 
		ConcesionarioControlador.getControlador().save(concesionario);
		mensajeAlUsuario = "Guardado correctamente";
	} catch (Exception e) {
		throw new ServletException(e);
	}
}

// Ahora muestro la pantalla de respuesta al usuario
%>


<div class="container py-3">
	<%
		String tipoAlerta = "alert-success";
	if (mensajeAlUsuario != null && mensajeAlUsuario != "") {
		if (mensajeAlUsuario.startsWith("ERROR")) {
			tipoAlerta = "alert-danger";
		}
	%>
	<div class="alert <%=tipoAlerta%> alert-dismissible fade show">
		<button type="button" class="close" data-dismiss="alert">&times;</button>
		<%=mensajeAlUsuario%>
	</div>
	<%
		}
	%>
	<div class="row">
		<div class="mx-auto col-sm-6">
			<!-- form user info -->
			<div class="card">
				<div class="card-header">
					<h4 class="mb-0">Ficha Concesionario</h4>
				</div>
				<div class="card-body">

					<a href="listaConcesionario.jsp?idPag=1">Ir a la lista de concesionarios</a>
					<form id="form1" name="form1" method="post"
						action="fichaConcesionario.jsp" enctype="multipart/form-data"
						class="form" role="form" autocomplete="off">
						<p />
						<img class="mx-auto d-block rounded-circle"
							src="../Utils/DownloadImagenProfesor?idConcesionario=<%=concesionario.getId()%>"
							width='100px' height='100px' />
						<p />
						<input type="hidden" name="idConcesionario"
							value="<%=concesionario.getId()%>" />
						<div class="form-group row">
							<label class="col-lg-3 col-form-label form-control-label"
								for="ficheroImagen">Imagen:</label>
							<div class="col-lg-9">
								<input name="ficheroImagen" class="form-control-file"
									type="file" id="ficheroImagen" />
							</div>
						</div>
												<div class="form-group row">
							<label class="col-lg-3 col-form-label form-control-label"
								for="cif">Cif:</label>
							<div class="col-lg-9">
								<input name="cif" class="form-control" type="text"
									id="cif" value="<%=concesionario.getCif()%>" />
							</div>
						</div>
						<div class="form-group row">
							<label class="col-lg-3 col-form-label form-control-label"
								for="nombre">Nombre:</label>
							<div class="col-lg-9">
								<input name="nombre" class="form-control" type="text"
									id="nombre" value="<%=concesionario.getNombre()%>" />
							</div>
						</div>
						<div class="form-group row">
							<label class="col-lg-3 col-form-label form-control-label"
								for="localidad">Localidad:</label>
							<div class="col-lg-9">
								<input name="localidad" class="form-control" type="text"
									id="localidad" value="<%=concesionario.getLocalidad()%>" />
							</div>
						</div>
						<div class="form-group row">
							<div class="col-lg-9">
								<input type="submit" name="guardar" class="btn btn-primary"
									value="Guardar" /> <input type="submit" name="eliminar"
									class="btn btn-secondary" value="Eliminar" />
							</div>
						</div>
					</form>
				</div>
			</div>
		</div>
	</div>
</div>
<%@ include file="pie.jsp"%>
