<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="AdicionarEspecialidade.aspx.cs" Inherits="ProjetoPPI.PagSecretaria.AdicionarEspecialidade" %>

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
<body style="background-image: url('../assistant-beard-boss-630836.jpg');background-attachment: fixed; background-position: center; background-size: cover; background-repeat: no-repeat; overflow-y: hidden;">
<form id="form1" runat="server">
    <a href="/Secretaria/IndexSecretaria" class="btnVoltar"><i class="glyphicon glyphicon-chevron-left"></i></a>
<div class="consulta">    
    <h1 class="title-originais">NOVA ESPECIALIDADE:</h1>

    <table class="tab-cadastro">
        <tr>
            <td>Nome nova especialidade: </td>
            <td> <asp:TextBox ID="txtEspecialidade" runat="server" MaxLength="30"></asp:TextBox> </td>
            <td> 
                <div class="btnFinal"><asp:button CssClass="asp_button" ID="btnNovaEsp" runat="server" text="Nova Especialização" OnClick="btnNovaEsp_Click" /></div>
            </td>
        </tr>
    </table>
    <asp:Label ID="lbMsgNovaEsp" runat="server" Text=""></asp:Label>

    <br /><br />

    <a href="AdicionarEspecialidadeAMédico.aspx">Adicionar especialidade a médico</a>
</div>
</form>
</body>
</html>