<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="AgendarConsultas.aspx.cs" Inherits="ProjetoPPI.PagSecretaria.AgendarConsultas" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title></title>    
    <link href="https://fonts.googleapis.com/css?family=Baloo+Tammudu" rel="stylesheet"/>
    <link href="https://fonts.googleapis.com/css?family=Comfortaa" rel="stylesheet"/>
    <link href="https://fonts.googleapis.com/css?family=Pacifico" rel="stylesheet"/>
    <script src="/Scripts/jquery-1.10.2.min.js"></script>    
    <link rel="stylesheet" href="/estilo.css" />
</head>
<body style="background-image: url('../assistant-beard-boss-630836.jpg');background-attachment: fixed; background-position: center; background-size: cover; background-repeat: no-repeat; overflow-y: hidden;">
<form id="form1" runat="server">
<div class="consulta">    
    <%
        if (Session["usuario"] == null || Session["conexao"] == null || Session["usuario"].GetType() != typeof(ProjetoPPI.Secretaria))
        {
            Response.Redirect("../Index.aspx");
            return;
        }
    %>

    <h1 class="title-originais">Agendar Consulta</h1>
    
    <table class="tab-cadastro">
        <tr>
            <td>
                Propósito: 
            </td>
            <td>
                <asp:TextBox ID="txtProposito" runat="server"></asp:TextBox>
                <asp:Label ID="lbMsgProposito" runat="server" Text=""></asp:Label>
            </td>
        </tr>
        <tr>
            <td>
                <label>Médico: </label>
            </td>
            <td>
                <asp:DropDownList ID="ddlMedicos" runat="server" DataSourceID="SqlDataSourceMedicos" DataTextField="nomeCompleto" DataValueField="email">
                </asp:DropDownList>
                <asp:SqlDataSource ID="SqlDataSourceMedicos" runat="server" ConnectionString="<%$ ConnectionStrings:PR317188ConnectionString %>" SelectCommand="SELECT [email], [nomeCompleto] FROM [medico]"></asp:SqlDataSource>

                <asp:Label ID="lbMsgMedico" runat="server" Text=""></asp:Label>
            </td>
        </tr>
        <tr>
            <td>
                <label>Paciente: </label>
            </td>
            <td>
                <asp:DropDownList ID="ddlPacientes" runat="server" DataSourceID="SqlDataSourcePacientes" DataTextField="nomeCompleto" DataValueField="email">
                </asp:DropDownList>
                <asp:SqlDataSource ID="SqlDataSourcePacientes" runat="server" ConnectionString="<%$ ConnectionStrings:PR317188ConnectionString %>" SelectCommand="SELECT [email], [nomeCompleto] FROM [paciente]"></asp:SqlDataSource>

                <asp:Label ID="lbMsgPaciente" runat="server" Text=""></asp:Label>
            </td>
        </tr>
        <tr>
            <!-- -->

            <td>
                <label>Horário: </label><asp:TextBox ID="txtDia" runat="server" TextMode="Date"></asp:TextBox>
            </td>
            <td>
                <asp:TextBox ID="txtHorario" runat="server"></asp:TextBox>

                <asp:Label ID="lbMsgHorario" runat="server" Text=""></asp:Label>
            </td>
        </tr>
        <tr>
            <td>
                <label>Tempo da consulta: </label>
            </td>
            <td>
                <asp:DropDownList ID="ddlTempoConsulta" runat="server">
                    <asp:ListItem Selected="True" Value="30">30 minutos</asp:ListItem>
                    <asp:ListItem Value="60">1 hora</asp:ListItem>
                </asp:DropDownList>

                <asp:Label ID="lbMsgTempoConsulta" runat="server" Text=""></asp:Label>
            </td>
        </tr>
    </table>
    
    <div class="btnFinal">
        <asp:Label ID="lbMsg" runat="server" Text=""></asp:Label>    
        <asp:button CssClass="asp_button" ID="btnAgendar" runat="server" text="Agendar" OnClick="btnAgendar_Click" />
    </div>
    
</div>
</form>
</body>
</html>
