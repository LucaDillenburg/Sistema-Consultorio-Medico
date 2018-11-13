<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Servidor.aspx.cs" Inherits="ProjetoPPI.PagSecretaria.Servidor" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title></title>
</head>
<body>
    <a href="/Secretaria/IndexSecretaria" class="btnVoltar"><i class="glyphicon glyphicon-chevron-left"></i></a>
    <form id="form1" runat="server">
        <center><h1>SERVIDOR</h1></center>
        <center><asp:ListBox ID="lbxComandos" runat="server" Rows="20" SelectionMode="Multiple"></asp:ListBox></center>      
    </form>
</body>
</html>
