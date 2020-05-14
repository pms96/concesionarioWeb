<%@ page import="java.util.List, 
	java.util.HashMap,
	java.util.Date,
	java.text.SimpleDateFormat,
	Utils.RequestUtils,
	model.Cliente,
	model.controladores.ClienteControlador"%>

<jsp:include page="cabecera.jsp" flush="true">
	<jsp:param name="tituloDePagina" value="Ficha de Clientes" />
</jsp:include>

<%

SimpleDateFormat sdfFechaNac = new SimpleDateFormat("dd/MM/yyy");
	// Obtengo una HashMap con todos los par�metros del request, sea este del tipo que sea;
HashMap<String, Object> hashMap = RequestUtils.requestToHashMap(request);

// Para plasmar la informaci�n de un profesor determinado utilizaremos un par�metro, que debe llegar a este Servlet obligatoriamente
// El par�metro se llama "idProfesor" y gracias a �l podremos obtener la informaci�n del profesor y mostrar sus datos en pantalla
Cliente cliente = null;
// Obtengo el profesor a editar, en el caso de que el profesor exista se cargar�n sus datos, en el caso de que no exista quedar� a null
try {
	int idCliente = RequestUtils.getIntParameterFromHashMap(hashMap, "idCliente"); // Necesito obtener el id del profesor que se quiere editar. En caso de un alta
	// de profesor obtendr�amos el valor 0 como idProfesor
	if (idCliente != 0) {
		cliente = (Cliente) ClienteControlador.getControlador().find(idCliente);
	}
} catch (Exception e) {
	e.printStackTrace();
}
// Inicializo unos valores correctos para la presentaci�n del profesor
if (cliente == null) {
	cliente = new Cliente();
}
if (cliente.getNombre() == null)
	cliente.setNombre("");
if (cliente.getApellidos() == null)
	cliente.setApellidos("");
if (cliente.getLocalidad() == null)
	cliente.setLocalidad("");
if (cliente.getDniNie() == null)
	cliente.setDniNie("");
if (cliente.getFechaNac()==null)
	cliente.setFechaNac(null);
if (cliente.getActivo()== false)
	cliente.setActivo(false);


// Ahora debo determinar cu�l es la acci�n que este p�gina deber�a llevar a cabo, en funci�n de los par�metros de entrada al Servlet.
// Las acciones que se pueden querer llevar a cabo son tres:
//    - "eliminar". S� que est� es la acci�n porque recibir� un un par�metro con el nombre "eliminar" en el request
//    - "guardar". S� que est� es la acci�n elegida porque recibir� un par�metro en el request con el nombre "guardar"
//    - Sin acci�n. En este caso simplemente se quiere editar la ficha

// Variable con mensaje de informaci�n al usuario sobre alguna acci�n requerida
String mensajeAlUsuario = "";

// Primera acci�n posible: eliminar
if (RequestUtils.getStringParameterFromHashMap(hashMap, "eliminar") != null) {
	// Intento eliminar el registro, si el borrado es correcto redirijo la petici�n hacia el listado de profesores
	try {
		ClienteControlador.getControlador().remove(cliente);
		response.sendRedirect(request.getContextPath() + "jsp/listaCliente.jsp?idPag=1"); // Redirecci�n del response hacia el listado
	} catch (Exception ex) {
		mensajeAlUsuario = "ERROR - Imposible eliminar. Es posible que existan restricciones.";
	}
}

// Segunda acci�n posible: guardar
if (RequestUtils.getStringParameterFromHashMap(hashMap, "guardar") != null) {
	// Obtengo todos los datos del profesor y los almaceno en BBDD
	try {
		cliente.setNombre(RequestUtils.getStringParameterFromHashMap(hashMap, "nombre"));
		cliente.setApellidos(RequestUtils.getStringParameterFromHashMap(hashMap, "apellidos"));
		cliente.setLocalidad(RequestUtils.getStringParameterFromHashMap(hashMap, "localidad"));
		cliente.setDniNie(RequestUtils.getStringParameterFromHashMap(hashMap, "dniNie"));
		try {
			cliente.setFechaNac(sdfFechaNac.parse(RequestUtils.getStringParameterFromHashMap(hashMap, "fechaNac")));
		}
		catch (Exception e){
			e.printStackTrace();
		}
		cliente.setActivo(Boolean.parseBoolean(RequestUtils.getStringParameterFromHashMap(hashMap, "activo")));

		// Finalmente guardo el objeto de tipo profesor 
		ClienteControlador.getControlador().save(cliente);
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
					<h4 class="mb-0">Ficha Clientes</h4>
				</div>
				<div class="card-body">

					<a href="listaCliente.jsp?idPag=1">Ir a la lista de Clientes</a>
					<form id="form1" name="form1" method="post"
						action="fichaCliente.jsp" enctype="multipart/form-data"
						class="form" role="form" autocomplete="off">
						
						<input type="hidden" name="idCliente" value="<%=cliente.getId()%>"/>
						
						<div class="form-group row">
							<label class="col-lg-3 col-form-label form-control-label"
								for="Nombre">Nombre:</label>
							<div class="col-lg-9">
								<input name="nombre" class="form-control" type="text"
									id="nombre" value="<%=cliente.getNombre()%>" />
							</div>
						</div>
						<div class="form-group row">
							<label class="col-lg-3 col-form-label form-control-label"
								for="apellidos">Apellidos:</label>
							<div class="col-lg-9">
								<input name="apellidos" class="form-control" type="text"
									id="apellidos" value="<%=cliente.getApellidos()%>" />
							</div>
						</div>
						<div class="form-group row">
							<label class="col-lg-3 col-form-label form-control-label"
								for="Localidad">Localidad:</label>
							<div class="col-lg-9">
								<input name="localidad" class="form-control" type="text"
									id="localidad" value="<%=cliente.getLocalidad()%>" />
							</div>
						</div>
						<div class="form-group row">
							<label class="col-lg-3 col-form-label form-control-label"
								for="dniNie">Dni/Nie:</label>
							<div class="col-lg-9">
								<input name="dniNie" class="form-control" type="text"
									id="dniNie" value="<%=cliente.getDniNie()%>" />
							</div>
						</div>
						<div class="form-group row">
							<label class="col-lg-3 col-form-label form-control-label"
								for="fechaNac">Fecha Nacimiento:</label>
							<div class="col-lg-9">
								<input name="fechaNac" class="form-control" type="text"
									id="fechaNac" value="<%=((cliente.getFechaNac() != null)? sdfFechaNac.format(cliente.getFechaNac()) : "")%>" />
							</div>
						</div>
						<div class="form-group row">
							<label class="col-lg-3 col-form-label form-check-label"
								for="activo">Activo:</label>
							<div class="col-lg-9">
								<input name="activo" class="form-check-input" type="checkbox"
									id="activo" value="<%=false%>" />
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
