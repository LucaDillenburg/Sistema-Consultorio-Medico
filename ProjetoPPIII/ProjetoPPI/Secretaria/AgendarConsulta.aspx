<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="AgendarConsulta.aspx.cs" Inherits="ProjetoPPI.AgendarConsulta" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="ajaxToolkit" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title></title>
</head>
<body>
<form id="form1" runat="server">
<!---->

<div>
    <h1>Agendar Consulta</h1>

    <table>
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
    
    <asp:Label ID="lbMsg" runat="server" Text=""></asp:Label>
    <br />
    <br />
    <asp:button ID="btnAgendar" runat="server" text="Agendar" OnClick="btnAgendar_Click" />
</div>
</form>
</body>
</html>
