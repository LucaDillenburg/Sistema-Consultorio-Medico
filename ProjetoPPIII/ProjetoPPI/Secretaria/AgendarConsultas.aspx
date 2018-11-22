<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="AgendarConsultas.aspx.cs" Inherits="ProjetoPPI.PagSecretaria.AgendarConsultas" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="ajaxToolkit" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title></title>
    <link href="https://fonts.googleapis.com/css?family=Baloo+Tammudu" rel="stylesheet"/>
    <link href="https://fonts.googleapis.com/css?family=Comfortaa" rel="stylesheet"/>
    <link href="https://fonts.googleapis.com/css?family=Pacifico" rel="stylesheet"/>
    <link href="/Content/bootstrap.css" rel="stylesheet" />
    <script src="/Scripts/jquery-1.10.2.min.js"></script>
    <link rel="stylesheet" href="/estilo.css" />
</head>
<body style="background-image: url('../imgs/assistant-beard-boss-630836.jpg');background-attachment: fixed; background-position: center; background-size: cover; background-repeat: no-repeat; overflow-y: hidden;">
<form id="form1" runat="server">
<asp:scriptmanager runat="server"></asp:scriptmanager>

    <a href="IndexSecretaria.aspx" class="btnVoltar"><i class="glyphicon glyphicon-chevron-left"></i></a>

<div class="consulta">
    <h1 class="title-originais">Agendar Consulta</h1>

    <table class="tab-cadastro">
        <tr>
            <td> Propósito: </td>
            <td> <asp:TextBox ID="txtProposito" runat="server"></asp:TextBox> </td>
        </tr>
        <tr><td><asp:Label CssClass="lblErro" ID="lbMsgProposito" runat="server" Text=""></asp:Label></td></tr>

        <tr>
            <td> Médico: </td>
            <td>
                <asp:DropDownList ID="ddlMedicos" runat="server" DataSourceID="SqlDataSourceMedicos" DataTextField="nomeCompleto" DataValueField="email">
                </asp:DropDownList>
                <asp:SqlDataSource ID="SqlDataSourceMedicos" runat="server" ConnectionString="<%$ ConnectionStrings:PR317188ConnectionString %>" SelectCommand="SELECT [email], [nomeCompleto] FROM [medico]"></asp:SqlDataSource>
            </td>
        </tr>
        <tr><td><asp:Label CssClass="lblErro" ID="lbMsgMedico" runat="server" Text=""></asp:Label></td></tr>

        <tr>
            <td> Paciente: </td>
            <td>
                <asp:DropDownList ID="ddlPacientes" runat="server" DataSourceID="SqlDataSourcePacientes" DataTextField="nomeCompleto" DataValueField="email">
                </asp:DropDownList>
                <asp:SqlDataSource ID="SqlDataSourcePacientes" runat="server" ConnectionString="<%$ ConnectionStrings:PR317188ConnectionString %>" SelectCommand="SELECT [email], [nomeCompleto] FROM [paciente]"></asp:SqlDataSource>
            </td>
        </tr>
        <tr><td><asp:Label CssClass="lblErro" ID="lbMsgPaciente" runat="server" Text=""></asp:Label></td></tr>

        <tr>
            <td> Horário: <asp:TextBox ID="txtDia" runat="server" TextMode="Date"></asp:TextBox>
            </td>
            <td> <asp:TextBox ID="txtHorario" runat="server"></asp:TextBox></td>

            <!-- MÁSCARA HORÁRIO -->
            <ajaxToolkit:MaskedEditExtender ID="MaskedEditExtender1" runat="server"
                TargetControlID="txtHorario"
                Mask="99:99"
                MaskType="Number"
                InputDirection="LeftToRight"
                ClearMaskOnLostFocus ="False" />
        </tr>
        <tr><td><asp:Label CssClass="lblErro" ID="lbMsgHorario" runat="server" Text=""></asp:Label></td></tr>

        <tr>
            <td> Tempo da consulta: </td>
            <td>
                <asp:DropDownList ID="ddlTempoConsulta" runat="server">
                    <asp:ListItem Selected="True" Value="30">30 minutos</asp:ListItem>
                    <asp:ListItem Value="60">1 hora</asp:ListItem>
                </asp:DropDownList>
            </td>
        </tr>
        <tr><td><asp:Label CssClass="lblErro" ID="lbMsgTempoConsulta" runat="server" Text=""></asp:Label></td></tr>
    </table>

    <div class="btnFinal">
        <asp:Label ID="lbMsg" runat="server" CssClass="lblErro" Text=""></asp:Label>
        <asp:button CssClass="asp_button" ID="btnAgendar" runat="server" text="Agendar" OnClick="btnAgendar_Click" />
    </div>

</div>
</form>
</body>
</html>
