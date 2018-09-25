<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Index.aspx.cs" Inherits="ProjetoPPI.PagMedico.PaginaMedico" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title></title>
</head>
<body>
<form id="form1" runat="server">
<div>
    <asp:Label ID="lbSatisfacaoMedia" runat="server" Text="Satisfação Média: "></asp:Label>
    <asp:Button ID="btnConsultaAtual" runat="server" Text="Consulta Atual" OnClick="btnConsultaAtual_Click" />
    <asp:Timer ID="tmrConsultaAtual" runat="server" OnTick="tmrConsultaAtual_Tick"></asp:Timer>
</div>
</form>
</body>
</html>
