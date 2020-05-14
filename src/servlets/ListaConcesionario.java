package servlets;

import java.io.IOException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import Utils.SuperTipoServlet;
import model.Concesionario;
import model.controladores.ConcesionarioControlador;

/**
 * Servlet implementation class MiPrimerServlets
 */
@WebServlet( "/ListaConcesionario")
public class ListaConcesionario extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public ListaConcesionario() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		response.getWriter().append("<!DOCTYPE html PUBLIC \"-//W3C//DTD XHTML 1.0 Transitional//EN\" \"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd\">\r\n" + 
				
				
				
				"<html xmlns=\"http://www.w3.org/1999/xhtml\">\r\n" + 
				"<head>\r\n" + 
				"<meta http-equiv=\"Content-Type\" content=\"text/html; charset=iso-8859-1\" />\r\n" + 
				"<title >Lista de Concesionarios</title>\r\n" + 
				"<style>" +
				
				
				"body{\r\n" + 
				"	background-color: #18A383;\r\n" + 
				"	font-family: Arial;\r\n" + 
				"}\r\n" + 
				"\r\n" + 
				"#main-container{\r\n" + 
				"	margin: 10px auto;\r\n" + 
				"	width: 600px;\r\n" + 
				"}\r\n" + 
				"\r\n" + 
				"table{\r\n" + 
				"	background-color: white;\r\n" + 
				"	text-align: left;\r\n" + 
				"	border-collapse: collapse;\r\n" + 
				"	width: 100%;\r\n" + 
				"}\r\n" + 
				"\r\n" + 
				"th, td{\r\n" + 
				"	padding: 20px;\r\n" + 
				"}\r\n" + 
				"\r\n" + 
				"thead{\r\n" + 
				"	background-color: #246355;\r\n" + 
				"	border-bottom: solid 5px #0F362D;\r\n" + 
				"	color: white;\r\n" + 
				"}\r\n" + 
				"\r\n" + 
				"tr:nth-child(even){\r\n" + 
				"	background-color: #ddd;\r\n" + 
				"}\r\n" + 
				"\r\n" + 
				"tr:hover td{\r\n" + 
				"	background-color: #369681;\r\n" + 
				"	color: white;\r\n" + 
				"}>\r\n" + 
				
				"</style>"+
				"</head>\r\n" + 
				"\r\n" + 
				"<body>\r\n" + 
				"<h1 align=\"center\">Listado de Concesionarios</h1>\r\n" + 
				"<div id=\"main-container\">\r\n" +
				"<table width=\"95%\" >\r\n" + 
				"  <tr>\r\n" + 
				"    <th scope=\"col\">Cif</th>\r\n" + 
				"    <th scope=\"col\">Nombre</th>\r\n" + 
				"    <th scope=\"col\">Localidad</th>\r\n" + 
				"    <th scope=\"col\">Imagen</th>\r\n" + 
				"  </tr>\r\n");
		// Hasta la fila anterior ha llegado la primera fila de títulos de la tabla de profesores del centro educativo
		// En las siguietnes líneas se crea una fila "elemento <tr>" por cada fila de la tabla de BBDD "profesor"
		List<Concesionario> concesionarios = ConcesionarioControlador.getControlador().findAllConcesionarios();
		for (Concesionario concesionario : concesionarios) {
			response.getWriter().append("" +
				"  <tr>\r\n" + 
				"    <td><a href=\"FichaConcesionario?idConcesionario=" + concesionario.getId() + "\">" + concesionario.getCif() + "</a></td>\r\n" + 
				"    <td>" + concesionario.getNombre() + "</td>\r\n" + 
				"    <td>" + concesionario.getLocalidad() + "</td>\r\n" + 
				"    <td>" + "<img src=\"Utils/DownloadImagenProfesor?idConcesionario=" + concesionario.getId() + "\" width='50px' height='50px'/>" +
				" <input type=\"hidden\" name=\"idConcesionario\" value=\"" + concesionario.getId() + "\"\\>" + "</td>\r\n" + 
				"  </tr>\r\n");
		}
		// Al finalizar de exponer la lista de profesores termino la tabla y cierro el fichero HTML
		response.getWriter().append("" + 
		"</table>\r\n" + 
		"<p/><input type=\"submit\"  name=\"nuevo\" value=\"Nuevo\"  onclick=\"window.location='FichaConcesionario?idConcesionario=0'\"/>" + 
		"</div>\r\n " +
		"</body>\r\n" + 
		"</html>\r\n" + 
		"");

	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		doGet(request, response);
	}

}

