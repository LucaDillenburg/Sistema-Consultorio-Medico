<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="CadastroUsuarios.aspx.cs" Inherits="ProjetoPPI.CadastroUsuarios" %>

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
    <asp:Label ID="lbTitulo" runat="server" Text="Cadastrar Médico"></asp:Label>
    <br /> <br />

    <table>
        <tr>
            <td><asp:Label ID="Label1" runat="server" Text="Email: "></asp:Label></td>
            <td><asp:TextBox ID="txtEmail" runat="server" MaxLength="50" OnTextChanged="txtEmail_TextChanged"></asp:TextBox>
            <asp:Label ID="lbMsgEmail" runat="server"></asp:Label>
            </td>
        </tr>

        <tr>
            <td><asp:Label ID="Label2" runat="server" Text="Nome completo: "></asp:Label></td>
            <td><asp:TextBox ID="txtNome" runat="server" MaxLength="50" OnTextChanged="txtNome_TextChanged"></asp:TextBox>
            <asp:Label ID="lbMsgNome" runat="server"></asp:Label>
            </td>
        </tr>

        <asp:Panel ID="crm" runat="server">
        <tr>
            <!-- -->

            <td><asp:Label ID="lbCRM" runat="server" Text="CRM: "></asp:Label></td>
            <td><asp:TextBox ID="txtCRM" runat="server" MaxLength="13" OnTextChanged="txtCRM_TextChanged"></asp:TextBox>
            <asp:Label ID="lbMsgCRM" runat="server"></asp:Label>
            </td>
        </tr>
        </asp:Panel>

        <asp:Panel ID="celular" runat="server">
        <tr>
            <!-- -->

            <td><asp:Label ID="Label4" runat="server" Text="Celular: "></asp:Label></td>
            <td><asp:TextBox ID="txtCelular" runat="server" MaxLength="14" OnTextChanged="txtCelular_TextChanged"></asp:TextBox>
            <asp:Label ID="lbMsgCelular" runat="server"></asp:Label>
            </td> 
        </tr>
        </asp:Panel>

        <asp:Panel ID="telefone" runat="server">
        <tr>
            <!-- -->

            <td><asp:Label ID="Label5" runat="server" Text="Telefone: "></asp:Label></td>
            <td><asp:TextBox ID="txtTelefone" runat="server" MaxLength="13" OnTextChanged="txtTelefone_TextChanged"></asp:TextBox>
            <asp:Label ID="lbMsgTelefone" runat="server"></asp:Label>
            </td>
        </tr>
        </asp:Panel>

        <tr>
            <td><asp:Label ID="Label6" runat="server" Text="Endereço: "></asp:Label></td>
            <td><asp:TextBox ID="txtEndereco" runat="server" MaxLength="100" OnTextChanged="txtEndereco_TextChanged"></asp:TextBox>
            <asp:Label ID="lbMsgEndereco" runat="server"></asp:Label>
            </td>
        </tr>

        <asp:Panel ID="datanascimento" runat="server">
        <tr>
            <!-- -->

            <td><asp:Label ID="Label7" runat="server" Text="Data de Nascimento: "></asp:Label></td>
            <td><asp:TextBox ID="txtDataNascimento" runat="server" TextMode="Date" MaxLength="10" OnTextChanged="txtDataNascimento_TextChanged"></asp:TextBox>
            <asp:Label ID="lbMsgDataNascimento" runat="server"></asp:Label>
            </td>
        </tr>
        </asp:Panel>

        <tr>
            <td><asp:Label ID="Label8" runat="server" Text="Senha: "></asp:Label></td>
            <td><asp:TextBox ID="txtSenha" runat="server" TextMode="Password" MaxLength="30" OnTextChanged="txtSenha_TextChanged"></asp:TextBox>
            <asp:Label ID="lbMsgSenha" runat="server"></asp:Label>
            </td>
        </tr>

        <tr>
            <td><asp:Label ID="Label9" runat="server" Text="Confirmação de senha: "></asp:Label></td>
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
