<%@ page
	import="java.util.List,
	model.Coche,
	model.controladores.CocheControlador"%>

<jsp:include page="cabecera.jsp" flush="true">
	<jsp:param name="tituloDePagina" value="Lista de fabricantes" />
</jsp:include>

<%!
			public int getOffset(String param){
				int offset = Integer.parseInt(param);
				if(offset > 1){
					return 5 * offset;
				}
				else{
					return 0;
				}
				
			}
		%>
		<%! private int offset, paginationIndex; %>
		<% offset = getOffset(request.getParameter("idPag"));
			paginationIndex = Integer.parseInt(request.getParameter("idPag"));
		%>
<div class="container">
	<h1>Listado de Coches</h1>
	<table class="table table-hover">
		<thead class="thead-dark">
			<tr>
				<th>Fabricante</th>
				<th>Bastidor</th>
				<th>Modelo</th>
				<th>Color</th>
		</thead>
		<tbody>
			<%
				// Hasta la fila anterior ha llegado la primera fila de títulos de la tabla de profesores del centro educativo
			// En las siguietnes líneas se crea una fila "elemento <tr>" por cada fila de la tabla de BBDD "profesor"
			List<Coche> lista = CocheControlador.getControlador().findLimited(10, offset);
			for (Coche coche : lista) {
			%>
			<tr>
				<td><a
					href="fichaCoche.jsp?idCoche=<%=coche.getId()%>"> <%=coche.getFabricante()%>
				</a></td>
				<td><%=coche.getBastidor()%></td>
				<td><%=coche.getModelo()%></td>
				<td><%=coche.getColor()%></td>	
			</tr>
			<%
				}
			// Al finalizar de exponer la lista de profesores termino la tabla y cierro el fichero HTML
			%>
		</tbody>
	</table>
	<p />
	<input type="submit" class="btn btn-primary" name="nuevo" value="Nuevo"
		onclick="window.location='fichaCoche.jsp?idCoche=0'" />
		<ul class="pagination justify-content-center">
	   <li class="page-item"><a class="page-link" href="?idPag=1">First</a></li>
	  <%
	  List<Coche> c = CocheControlador.getControlador().findAllCoches();
	  double size = Math.ceil(c.size() / 10);
	  if (paginationIndex > 2){
		  %> 
		  <li class="page-item"><a class="page-link" href="?idPag=<%= paginationIndex-2 %>" ><%= paginationIndex-2 %></a></li>
		  <li class="page-item"><a class="page-link" href="?idPag=<%= paginationIndex-1 %>" ><%= paginationIndex-1 %></a></li>
		 
 		 <% }%>
 		 <li class="page-item active"><a class="page-link" href="?idPag=<%= paginationIndex %>" ><%= paginationIndex %></a></li>
	     <% if (paginationIndex < size-1){
		 %>		 
		  <li class="page-item"><a class="page-link" href="?idPag=<%= paginationIndex+1 %>" ><%= paginationIndex+1 %></a></li>
		  <li class="page-item"><a class="page-link" href="?idPag=<%= paginationIndex+2 %>" ><%= paginationIndex+2 %></a></li>
		  <% } %>
		  <li class="page-item"><a class="page-link" href="?idPag=<%= Math.round(size)%>">Last</a></li>
	 </ul> 	
</div>

<%@ include file="pie.jsp"%>