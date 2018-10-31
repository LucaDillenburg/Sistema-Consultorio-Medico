<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Index.aspx.cs" Inherits="ProjetoPPI.PagMedico.Index" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title></title>
</head>
<body>
<form id="form1" runat="server">
<asp:scriptmanager runat="server"></asp:scriptmanager>
    <%
        if (Session["usuario"] == null || Session["conexao"] == null || Session["usuario"].GetType() != typeof(ProjetoPPI.Medico))
        {
            Response.Redirect("../Index.aspx");
            return;
        }

        ProjetoPPI.AtributosConsulta consultaAtual = ((ProjetoPPI.Medico)Session["usuario"]).ConsultaAtual();
    %>

<div>
    <asp:Label ID="lbSatisfacaoMedia" runat="server" Text= "Satisfação Média: "></asp:Label>

    <% if (consultaAtual != null) { %>
        <asp:Button ID="btnConsultaAtual" runat="server" Text="Consulta Atual" OnClick="btnConsultaAtual_Click" />
    <%  } %>

    <asp:Timer ID="timer" runat="server" OnTick="timer_Tick"></asp:Timer>

    <asp:Button ID="btnNotificacoes" runat="server" Text="Notificacoes" OnClick="btnNotificacoes_Click" />
</div>
</form>
</body>
</html>
