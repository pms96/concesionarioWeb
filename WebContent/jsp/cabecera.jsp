<!DOCTYPE html>
<html lang="es">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css">
  <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.4.0/jquery.min.js"></script>
  <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.7/umd/popper.min.js"></script>
  <script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.3.1/js/bootstrap.min.js"></script>
  <% String tituloDePagina = request.getParameter("tituloDePagina"); %>
  <title><%= (tituloDePagina != null)? tituloDePagina : "Sin título" %></title>
</head>
<body>

<nav class="navbar navbar-expand-sm bg-primary navbar-dark fixed-top">
  <a class="navbar-brand" href="#"><img src="coche.png"  alt="" width="50" height="30"></a>
  <ul class="navbar-nav">
    <li class="nav-item">
      <a class="nav-link" href="listaConcesionario.jsp?idPag=1">Concesionario</a>
    </li>
    <li class="nav-item">
      <a class="nav-link" href="listaFabricante.jsp?idPag=1">Fabricante</a>
    </li>
    <li class="nav-item">
      <a class="nav-link" href="listaCoche.jsp?idPag=1">Coche</a>
    </li>
    <li class="nav-item">
      <a class="nav-link" href="listaCliente.jsp?idPag=1">Cliente</a>
    </li>
    <li class="nav-item">
      <a class="nav-link" href="listaVenta.jsp?idPag=1">Venta</a>
    </li>
  </ul>
</nav>
<div>
<h1>.</h1>
</div>

</body>