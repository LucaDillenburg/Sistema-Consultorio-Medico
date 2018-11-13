<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Servidor.aspx.cs" Inherits="ProjetoPPI.PagSecretaria.Servidor" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title>Servidor</title>
    <link href="/estilo.css" rel="stylesheet" />
    <link href="https://fonts.googleapis.com/css?family=Baloo+Tammudu" rel="stylesheet"/>
    <link href="https://fonts.googleapis.com/css?family=Comfortaa" rel="stylesheet"/>
    <link href="https://fonts.googleapis.com/css?family=Pacifico" rel="stylesheet"/>
    <link href="/Content/bootstrap.css" rel="stylesheet" />
    <style>
        body {
            background-image: url('/charts-cup-of-coffee-desk-1345089.jpg');
            background-attachment: fixed;
            background-position: center;
            background-repeat: no-repeat;
            background-size: cover;
        }
    </style>
</head>
<body>
<form id="form2" runat="server">
    <a href="/Secretaria/IndexSecretaria" class="btnVoltar"><i class="glyphicon glyphicon-chevron-left"></i></a>
<div class="consulta">
    <h1 class="title-originais"> SERVIDOR </h1>

    <center><asp:ListBox ID="lbxComandos" runat="server" Rows="20" SelectionMode="Multiple" Width="488px"></asp:ListBox></center>
</div>
</form>
</body>
</html>