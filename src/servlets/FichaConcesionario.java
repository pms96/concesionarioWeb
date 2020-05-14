package servlets;

import java.io.IOException;
import java.util.HashMap;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import Utils.FormularioIncorrectoRecibidoException;
import Utils.RequestUtils;
import Utils.SuperTipoServlet;
import model.Concesionario;
import model.controladores.ConcesionarioControlador;


/**
 * Servlet implementation class FichaConcesionario
 */
@WebServlet("/FichaConcesionario")
public class FichaConcesionario extends SuperTipoServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public FichaConcesionario() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		HashMap<String, Object> hashMap = RequestUtils.requestToHashMap(request);
		Concesionario concesionario = null;
		// buscamos cómo conseguir el concesionario a editar, si existe se cargará y si no, aparecerá como null
		try {
			int idConcesionario = RequestUtils.getIntParameterFromHashMap(hashMap, "idConcesionario");// necsitamos saber el id para acceder al 
			//concesionario que vamos a editar, si es nuevo, sale a 0
			if (idConcesionario != 0) {
			concesionario = (Concesionario) ConcesionarioControlador.getControlador().find(idConcesionario);
			}    
			
		} catch (Exception e) {
			 e.printStackTrace();
		
		}	 
				if (concesionario == null) {
					concesionario = new Concesionario();
				}
				if (concesionario.getCif() == null) concesionario.setCif("");
				if (concesionario.getNombre() == null) concesionario.setNombre("");
				if (concesionario.getLocalidad() == null) concesionario.setLocalidad("");	 
			 
			 
		
		
		
		String mensajeAlUsuario = "";


		if(RequestUtils.getStringParameterFromHashMap(hashMap, "eliminar") != null) {
			try {
				ConcesionarioControlador.getControlador().remove(concesionario);
				response.sendRedirect(request.getContextPath() + "/ListaConcesionario");
			} catch (Exception e) {
				mensajeAlUsuario = "No se puedo eliminar. Quizás haya restricciones asociadas a este registro";
			}
		}


		if(RequestUtils.getStringParameterFromHashMap(hashMap, "guardar") != null) {
			try {
				concesionario.setCif(RequestUtils.getStringParameterFromHashMap(hashMap, "cif"));
				concesionario.setNombre(RequestUtils.getStringParameterFromHashMap(hashMap, "nombre"));
				concesionario.setLocalidad(RequestUtils.getStringParameterFromHashMap(hashMap, "localidad"));
				byte[] posibleImagen = RequestUtils.getByteArrayFromHashMap(hashMap, "ficheroImagen");
				if (posibleImagen != null && posibleImagen.length > 0) {
					concesionario.setImagen(posibleImagen); 
					}

				ConcesionarioControlador.getControlador().save(concesionario);
				mensajeAlUsuario = "Guardado correctamente";
//				response.sendRedirect(request.getContextPath() + "/ListaConcesionario");

			} catch (Exception e) {
				throw new ServletException(e);
			}
		}

		response.getWriter().append(this.getCabeceraHTML("Ficha Concesionario"));
		response.getWriter().append("\r\n" + 
				
				"<script> \r\n" +
				"function validateForm() {" +
				"var x = document.forms[\"form1\"][\"cif\"].value;" +
				"var y = document.forms[\"form1\"][\"nombre\"].value;" +
				"var z = document.forms[\"form1\"][\"localidad\"].value;" +
				"if (x == \"\"){" +
				"alert (\"No has introducido el cif\");"+
				"return false;"+
				"}" +
				"if (y == \"\"){" +
				"alert (\"No has introducido el nombre\");"+
				"return false;"+
				"}" +
				"if (z == \"\"){" +
				"alert (\"No has introducido el localidad\");"+
				"return false;"+
				"}" +
				"}" +
				"</script>\r\n" +
				"\r\n" + 
				"<body " +((mensajeAlUsuario != null && mensajeAlUsuario != "")? "onLoad=\"alert('" + mensajeAlUsuario + "');\"" : "")  + " >\r\n" +
				"<h1 align=\"center\">Ficha de concesionario</h1>\r\n" + 
				"<form id=\"form1\" name=\"form1\" method=\"post\" action=\"FichaConcesionario\" enctype=\"multipart/form-data\" onsubmit=\"return validateForm()\">\r\n" + 
				" <img src=\"Utils/DownloadImagenProfesor?idConcesionario=" + concesionario.getId() + "\" width='100px' height='100px'/>" +
				" <input type=\"hidden\" name=\"idConcesionario\" value=\"" + concesionario.getId() + "\"\\>" +
				"  <p>\r\n" + 
				"    <label for=\"ficheroImagen\">Imagen:</label>\r\n" + 
				"    <input name=\"ficheroImagen\" type=\"file\" id=\"ficheroImagen\" />\r\n" + 
				"  </p>\r\n" + 
				" <input type=\"hidden\" name=\"idConcesionario\" value=\"" + ((concesionario != null)? concesionario.getId() : "") + "\"\\>" +
				"  <p>\r\n" + 
				"    <label for=\"cif\">Cif:</label>\r\n" +
				"    <input name=\"cif\" type=\"text\" id=\"cif\"  value=\"" + ((concesionario != null)? concesionario.getCif() : "") + "\" />\r\n" + 
				"  </p>\r\n" +
				"  <p>\r\n" + 
				"    <label for=\"nombre\">Nombre: </label>\r\n" +  
				"    <input name=\"nombre\" type=\"text\" id=\"nombre\" value=\"" + ((concesionario != null)? concesionario.getNombre() : "") + "\" />\r\n" +
				"  </p>\r\n" +
				"  <p>\r\n" +
				"    <label for=\"localidad\">Localidad: </label>\r\n" + 
				"    <input name=\"localidad\" type=\"text\" id=\"localidad\" value=\"" + ((concesionario != null)? concesionario.getLocalidad() : "") + "\" />\r\n" +
				"  </p>\r\n" + 
				"  <p>\r\n" + 
				"    <input type=\"submit\" name=\"guardar\" value=\"Guardar\" />\r\n" + 
				"  </p>\r\n" + 
				"  <p>\r\n" + 
				"    <input type=\"submit\" name=\"eliminar\" value=\"Eliminar\" />\r\n" + 
				"  </p>\r\n" + 
				"</form>" + 
				"  <p align=\"center\">\r\n" +
				"<a href=\"ListaConcesionario\"><img src=\"https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcRfSMHWhACAn1KPtgA3hqF0mnYsEZl-EwY0ARdRBlJurujxwOS0&usqp=CAU\" width=\"45\" height=\"45\" BORDER=\"0\" alt=\"Lista\"></a>" +
				"  </p>\r\n"
				);
				response.getWriter().append(this.getPieHTML());
	}

}
