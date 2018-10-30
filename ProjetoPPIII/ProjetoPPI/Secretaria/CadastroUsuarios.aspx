﻿<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="CadastroUsuarios.aspx.cs" Inherits="ProjetoPPI.CadastroUsuarios" %>

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
    <%
        if (Session["usuario"] == null || Session["conexao"] == null || Session["usuario"].GetType() != typeof(Secretaria))
        {
            Response.Redirect("../Index.aspx");
            return;
        }

        if (Session["tipoUsCadastrar"] == null)
            Session["tipoUsCadastrar"] = ProjetoPPI.TipoUsuario.paciente;
        this.tipoUsCadastrar = (ProjetoPPI.TipoUsuario)Session["tipoUsCadastrar"];
    %>
<div>
    <h1> Cadastrar 
        <%
            switch(this.tipoUsCadastrar)
            {
                case ProjetoPPI.TipoUsuario.paciente:
                    %>Paciente<%
                    break;
                case ProjetoPPI.TipoUsuario.medico:
                    %>Médico<%
                    break;
                case ProjetoPPI.TipoUsuario.secretaria:
                    %>Secretária<%
                    break;
            }
        %>
    </h1>
    <br /> <br />

    <table>
        <tr>
            <td><label>Email: </label></td>
            <td><asp:TextBox ID="txtEmail" runat="server" MaxLength="50" OnTextChanged="txtEmail_TextChanged"></asp:TextBox>
            <asp:Label ID="lbMsgEmail" runat="server"></asp:Label>
            </td>
        </tr>

        <tr>
            <td><label>Nome completo: </label></td>
            <td><asp:TextBox ID="txtNome" runat="server" MaxLength="50" OnTextChanged="txtNome_TextChanged"></asp:TextBox>
            <asp:Label ID="lbMsgNome" runat="server"></asp:Label>
            </td>
        </tr>

        <%
            if (this.tipoUsCadastrar == ProjetoPPI.TipoUsuario.medico)
            {
        %>
            <tr>
                <!-- -->

                <td><label>CRM: </label></td>
                <td><asp:TextBox ID="txtCRM" runat="server" MaxLength="13" OnTextChanged="txtCRM_TextChanged"></asp:TextBox>
                <asp:Label ID="lbMsgCRM" runat="server"></asp:Label>
                </td>
            </tr>
        <%
            }
        %>

        <%
            if (this.tipoUsCadastrar != ProjetoPPI.TipoUsuario.secretaria)
            {
        %>
            <tr>
                <!-- -->

                <td><label>Celular: </label></td>
                <td><asp:TextBox ID="txtCelular" runat="server" MaxLength="14" OnTextChanged="txtCelular_TextChanged"></asp:TextBox>
                <asp:Label ID="lbMsgCelular" runat="server"></asp:Label>
                </td> 
            </tr>

            <tr>
                <!-- -->

                <td><label>Telefone: </label></td>
                <td><asp:TextBox ID="txtTelefone" runat="server" MaxLength="13" OnTextChanged="txtTelefone_TextChanged"></asp:TextBox>
                <asp:Label ID="lbMsgTelefone" runat="server"></asp:Label>
                </td>
            </tr>
        <%
            }
        %>

        <tr>
            <td><label>Endereço: </label></td>
            <td><asp:TextBox ID="txtEndereco" runat="server" MaxLength="100" OnTextChanged="txtEndereco_TextChanged"></asp:TextBox>
            <asp:Label ID="lbMsgEndereco" runat="server"></asp:Label>
            </td>
        </tr>

        <%
            if (this.tipoUsCadastrar != ProjetoPPI.TipoUsuario.secretaria)
            {
        %>
            <tr>
                <!-- -->

                <td><label>Data de Nascimento: </label></td>
                <td><asp:TextBox ID="txtDataNascimento" runat="server" TextMode="Date" MaxLength="10" OnTextChanged="txtDataNascimento_TextChanged"></asp:TextBox>
                <asp:Label ID="lbMsgDataNascimento" runat="server"></asp:Label>
                </td>
            </tr>
        <%
            }
        %>

        <tr>
            <td><label>Senha: </label></td>
            <td><asp:TextBox ID="txtSenha" runat="server" TextMode="Password" MaxLength="30" OnTextChanged="txtSenha_TextChanged"></asp:TextBox>
            <asp:Label ID="lbMsgSenha" runat="server"></asp:Label>
            </td>
        </tr>

        <tr>
            <td><label>Confirmação de senha: </label></td>
            <td><asp:TextBox ID="txtConfirmacaoSenha" runat="server" TextMode="Password" MaxLength="30" OnTextChanged="txtConfirmacaoSenha_TextChanged"></asp:TextBox>
            <asp:Label ID="lbMsgConfSenha" runat="server"></asp:Label>
            </td>
        </tr>
    </table>

    <asp:Label ID="lbMsg" runat="server" Text=""></asp:Label>
    <br />
    <br />

    <asp:Button ID="btnCadastrar" runat="server" Text="Cadastrar" OnClick="btnCadastrar_Click" />
</div>
</form>
</body>
</html>
