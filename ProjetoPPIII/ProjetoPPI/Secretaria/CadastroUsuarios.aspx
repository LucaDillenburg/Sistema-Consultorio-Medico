﻿<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="CadastroUsuarios.aspx.cs" Inherits="ProjetoPPI.PagSecretaria.CadastroUsuarios" EnableEventValidation="false" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="ajaxToolkit" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <link href="/estilo.css" rel="stylesheet" />
    <link href="https://fonts.googleapis.com/css?family=Baloo+Tammudu" rel="stylesheet"/>
    <link href="https://fonts.googleapis.com/css?family=Comfortaa" rel="stylesheet"/>
    <link href="https://fonts.googleapis.com/css?family=Pacifico" rel="stylesheet"/>
    <link href="/Content/bootstrap.css" rel="stylesheet" />
    <title></title>
</head>
<body style="background-image: url('../imgs/assistant-beard-boss-630836.jpg');background-attachment: fixed; background-position: center; background-size: cover; background-repeat: no-repeat;">
<form id="form1" runat="server">
<asp:scriptmanager runat="server"></asp:scriptmanager>

    <%
        if (Session["tipoUsCadastrar"] == null)
            Session["tipoUsCadastrar"] = ProjetoPPI.TipoUsuario.paciente;
    %>
<div class="consulta">
    <a href="IndexSecretaria.aspx" class="btnVoltar"><i class="glyphicon glyphicon-chevron-left"></i></a>
    <h1 class="title-originais"> Cadastrar
        <%
            switch(Session["tipoUsCadastrar"])
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

    <table class="tab-cadastro">
        <tr>
            <td><label>Email: </label></td>
            <td><asp:TextBox ID="txtEmail" runat="server" MaxLength="50" OnTextChanged="txtEmail_TextChanged"></asp:TextBox></td>
        </tr>
        <tr><td><asp:Label CssClass="lblErro" ID="lbMsgEmail" runat="server"></asp:Label></td></tr>

        <tr>
            <td><label>Nome completo: </label></td>
            <td><asp:TextBox ID="txtNome" runat="server" MaxLength="50" OnTextChanged="txtNome_TextChanged"></asp:TextBox></td>
        </tr>
        <tr><td><asp:Label CssClass="lblErro" ID="lbMsgNome" runat="server"></asp:Label></td></tr>

        <%
            if ((ProjetoPPI.TipoUsuario)Session["tipoUsCadastrar"] == ProjetoPPI.TipoUsuario.medico)
            {
        %>
            <tr>
                <td><label>CRM: </label></td>
                <td><asp:TextBox ID="txtCRM" runat="server" MaxLength="13" OnTextChanged="txtCRM_TextChanged"></asp:TextBox></td>

                <!-- MÁSCARA CRM -->
                <ajaxToolkit:MaskedEditExtender ID="MaskedEditExtender4" runat="server"
                    TargetControlID="txtCRM"
                    Mask="99999999-9/LL"
                    InputDirection="LeftToRight"
                    ClearMaskOnLostFocus ="False" />
            </tr>
            <tr><td><asp:Label CssClass="lblErro" ID="lbMsgCRM" runat="server"></asp:Label></td></tr>
        <%
            }
        %>

        <%
            if ((ProjetoPPI.TipoUsuario)Session["tipoUsCadastrar"] != ProjetoPPI.TipoUsuario.secretaria)
            {
        %>
            <tr>
                <td><label>Celular: </label></td>
                <td><asp:TextBox ID="txtCelular" runat="server" MaxLength="14" OnTextChanged="txtCelular_TextChanged"></asp:TextBox></td>

                <!-- MÁSCARA CELULAR-->
                <ajaxToolkit:MaskedEditExtender ID="MaskedEditExtender2" runat="server"
                    TargetControlID="txtCelular"
                    Mask="(99)99999-9999"
                    MaskType="Number"
                    InputDirection="LeftToRight"
                    ClearMaskOnLostFocus ="False" />
            </tr>
            <tr><td><asp:Label CssClass="lblErro" ID="lbMsgCelular" runat="server"></asp:Label></td></tr>


            <tr>
                <td><label>Telefone: </label></td>
                <td><asp:TextBox ID="txtTelefone" runat="server" MaxLength="13" OnTextChanged="txtTelefone_TextChanged"></asp:TextBox></td>

                <!-- MÁSCARA TELEFONE -->
                <ajaxToolkit:MaskedEditExtender ID="MaskedEditExtender1" runat="server"
                    TargetControlID="txtTelefone"
                    Mask="(99)9999-9999"
                    MaskType="Number"
                    InputDirection="LeftToRight"
                    ClearMaskOnLostFocus ="False" />
            </tr>
            <tr><td><asp:Label CssClass="lblErro" ID="lbMsgTelefone" runat="server"></asp:Label></td></tr>
        <%
            }
        %>

        <tr>
            <td><label>Endereço: </label></td>
            <td><asp:TextBox ID="txtEndereco" runat="server" MaxLength="100" OnTextChanged="txtEndereco_TextChanged"></asp:TextBox></td>
        </tr>
        <tr><td><asp:Label ID="lbMsgEndereco" runat="server"></asp:Label></td></tr>

        <%
            if ((ProjetoPPI.TipoUsuario)Session["tipoUsCadastrar"] != ProjetoPPI.TipoUsuario.secretaria)
            {
        %>
            <tr>
                <td><label>Data de Nascimento: </label></td>
                <td><asp:TextBox ID="txtDataNascimento" runat="server" TextMode="Date" MaxLength="10" OnTextChanged="txtDataNascimento_TextChanged"></asp:TextBox></td>
            </tr>
            <tr><td><asp:Label CssClass="lblErro" ID="lbMsgDataNascimento" runat="server"></asp:Label></td></tr>
        <%
            }
        %>

        <tr>
            <td><label>Senha: </label></td>
            <td><asp:TextBox ID="txtSenha" runat="server" TextMode="Password" MaxLength="30" OnTextChanged="txtSenha_TextChanged"></asp:TextBox></td>
        </tr>
        <tr><td><asp:Label ID="lbMsgSenha" runat="server"></asp:Label></td></tr>

        <tr>
            <td><label>Confirmação de senha: </label></td>
            <td><asp:TextBox ID="txtConfirmacaoSenha" runat="server" TextMode="Password" MaxLength="30" OnTextChanged="txtConfirmacaoSenha_TextChanged"></asp:TextBox></td>
        </tr>
        <tr><td><asp:Label CssClass="lblErro" ID="lbMsgConfSenha" runat="server"></asp:Label></td></tr>
    </table>

    <div class="btnFinal">
        <asp:Label CssClass="lblErro" ID="lbMsg" runat="server" Text=""></asp:Label>
        <asp:Button CssClass="asp_button" ID="btnCadastrar" runat="server" Text="Cadastrar" OnClick="btnCadastrar_Click" CausesValidation="False"/>
    </div>
</div>
</form>
</body>
</html>
