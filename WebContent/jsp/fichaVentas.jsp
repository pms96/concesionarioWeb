<%@ page import="java.util.List, 
	java.util.HashMap,
	java.util.Date,
	java.text.SimpleDateFormat,
	Utils.RequestUtils,
	model.Cliente,
	model.Coche,
	model.Concesionario,
	model.Venta,
	model.controladores.ClienteControlador,
	model.controladores.ConcesionarioControlador,
	model.controladores.CocheControlador,
	model.controladores.VentaControlador"%>

<jsp:include page="cabecera.jsp" flush="true">
	<jsp:param name="tituloDePagina" value="Ficha de Clientes" />
</jsp:include>

<%

SimpleDateFormat sdfFechaNac = new SimpleDateFormat("dd/MM/yyy");
	// Obtengo una HashMap con todos los parámetros del request, sea este del tipo que sea;
HashMap<String, Object> hashMap = RequestUtils.requestToHashMap(request);

// Para plasmar la información de un profesor determinado utilizaremos un parámetro, que debe llegar a este Servlet obligatoriamente
// El parámetro se llama "idProfesor" y gracias a él podremos obtener la información del profesor y mostrar sus datos en pantalla
Venta venta = null;
// Obtengo el profesor a editar, en el caso de que el profesor exista se cargarán sus datos, en el caso de que no exista quedará a null
try {
	int idVenta = RequestUtils.getIntParameterFromHashMap(hashMap, "idVenta"); // Necesito obtener el id del profesor que se quiere editar. En caso de un alta
	// de profesor obtendríamos el valor 0 como idProfesor
	if (idVenta != 0) {
		venta = (Venta) VentaControlador.getControlador().find(idVenta);
	}
} catch (Exception e) {
	e.printStackTrace();
}
// Inicializo unos valores correctos para la presentación del profesor
if (venta == null) {
	venta = new Venta();
}
if (venta.getCliente() == null)
	venta.setCliente((Cliente)ClienteControlador.getControlador().find(1));
if (venta.getConcesionario() == null)
	venta.setConcesionario((Concesionario)ConcesionarioControlador.getControlador().find(1));
if (venta.getCoche() == null)
	venta.setCoche((Coche)CocheControlador.getControlador().find(1));
if (venta.getFecha() == null)
	venta.setFecha(null);
if (venta.getPrecioVenta()==0)
	venta.setPrecioVenta(0);


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
		VentaControlador.getControlador().remove(venta);
		response.sendRedirect(request.getContextPath() + "jsp/listaVentas.jsp?idPag=1"); // Redirección del response hacia el listado
	} catch (Exception ex) {
		mensajeAlUsuario = "ERROR - Imposible eliminar. Es posible que existan restricciones.";
	}
}

// Segunda acción posible: guardar
if (RequestUtils.getStringParameterFromHashMap(hashMap, "guardar") != null) {
	// Obtengo todos los datos del profesor y los almaceno en BBDD
	try {
		venta.setCliente((Cliente)ClienteControlador.getControlador().find(RequestUtils.getIntParameterFromHashMap(hashMap, "idCliente")));
		venta.setConcesionario((Concesionario)ConcesionarioControlador.getControlador().find(RequestUtils.getIntParameterFromHashMap(hashMap, "IdConcesionario")));
		venta.setCoche((Coche)CocheControlador.getControlador().find(RequestUtils.getIntParameterFromHashMap(hashMap, "IdCoche")));
		try {
			venta.setFecha(sdfFechaNac.parse(RequestUtils.getStringParameterFromHashMap(hashMap, "fecha")));
		}
		catch (Exception e){
			e.printStackTrace();
		}
		venta.setPrecioVenta(Float.parseFloat(RequestUtils.getStringParameterFromHashMap(hashMap, "precioVenta")));

		// Finalmente guardo el objeto de tipo profesor 
		VentaControlador.getControlador().save(venta);
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
					<h4 class="mb-0">Ficha Venta</h4>
				</div>
				<div class="card-body">

					<a href="listaVenta.jsp?idPag=1">Ir a la lista de Ventas</a>
					<form id="form1" name="form1" method="post"
						action="fichaVentas.jsp" enctype="multipart/form-data"
						class="form" role="form" autocomplete="off">
						
						<input type="hidden" name="idCliente" value="<%=venta.getId()%>"/>
						
						<div class="form-group row">
							<label class="col-lg-3 col-form-label form-control-label"
								for="idCliente">Cliente:</label>
							<div class="col-lg-9">
								<select name="idCliente" id="idCliente"
									class="form-control">
									<%
										// Inserto los valores de la tipología del sexo del profesor y, si el registro tiene un valor concreto, lo establezco
									List<Cliente> clientes = ClienteControlador.getControlador().findAllClientes();
									for (Cliente cliente : clientes) {
									%>
									<option value="<%=cliente.getId()%>"
										<%=((cliente.getId() == venta.getCliente().getId()) ? "selected=\"selected\"" : "")%>><%=cliente.getDniNie()%></option>
									<% } %>
								</select>
							</div>						
						</div>
						<div class="form-group row">
							<label class="col-lg-3 col-form-label form-control-label"
								for="idConcesionario">Concesionario</label>
							<div class="col-lg-9">
								<select name="idConcesionario" id="idConcesionario"
									class="form-control">
									<%
										// Inserto los valores de la tipología del sexo del profesor y, si el registro tiene un valor concreto, lo establezco
									List<Concesionario> concesionarios = ConcesionarioControlador.getControlador().findAllConcesionarios();
									for (Concesionario concesionario : concesionarios) {
									%>
									<option value="<%=concesionario.getId()%>"
										<%=((concesionario.getId() == venta.getConcesionario().getId()) ? "selected=\"selected\"" : "")%>><%=concesionario.getNombre()%></option>
									<% } %>
								</select>
							</div>						
						</div>
						<div class="form-group row">
							<label class="col-lg-3 col-form-label form-control-label"
								for="idCoche">Coche:</label>
							<div class="col-lg-9">
								<select name="idCoche" id="idCoche"
									class="form-control">
									<%
										// Inserto los valores de la tipología del sexo del profesor y, si el registro tiene un valor concreto, lo establezco
									List<Coche> coches = CocheControlador.getControlador().findAllCoches();
									for (Coche coche : coches) {
									%>
									<option value="<%=coche.getId()%>"
										<%=((coche.getId() == venta.getCoche().getId()) ? "selected=\"selected\"" : "")%>><%=coche.getBastidor()%></option>
									<% } %>
								</select>
							</div>						
						</div>
						<div class="form-group row">
							<label class="col-lg-3 col-form-label form-control-label"
								for="fecha">Fecha Venta:</label>
							<div class="col-lg-9">
								<input name="fecha" class="form-control" type="text"
									id="fecha" value="<%=((venta.getFecha() != null)? sdfFechaNac.format(venta.getFecha()) : "")%>" />
							</div>
						</div>
						<div class="form-group row">
							<label class="col-lg-3 col-form-label form-control-label"
								for="precioVenta">Precio Venta:</label>
							<div class="col-lg-9">
								<input name="precioVenta" class="form-control" type="text"
									id="precioVenta" value="<%=venta.getPrecioVenta()%>" />
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
