<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="AdicionarEspecialidadeAMédico.aspx.cs" Inherits="ProjetoPPI.PagSecretaria.AdicionarEspecialidadeAMédico" %>

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
    <a href="AdicionarEspecialidade.aspx" class="btnVoltar"><i class="glyphicon glyphicon-chevron-left"></i></a>
<div class="consulta">
    <h1 class="title-originais">ADICIONAR ESPECIALIDADE A MÉDICO</h1>

    <table class="tab-cadastro">
        <tr>
            <td>Médico:</td>
            <td>
                <asp:DropDownList ID="ddlMedicos" runat="server" DataSourceID="sqlDataSourceMedico" DataTextField="nomeCompleto" DataValueField="email"></asp:DropDownList>
                <asp:SqlDataSource ID="sqlDataSourceMedico" runat="server" ConnectionString="<%$ ConnectionStrings:PR317188ConnectionString %>" SelectCommand="SELECT [email], [nomeCompleto] FROM [medico]"></asp:SqlDataSource>
            </td>
        </tr>
        <tr>
            <td>Especialidade:</td>
            <td>
                <asp:DropDownList ID="ddlEspecialidades" runat="server" DataSourceID="sqlDataSourceEsp" DataTextField="nomeEspecialidade" DataValueField="codEspecialidade"></asp:DropDownList>
                <asp:SqlDataSource ID="sqlDataSourceEsp" runat="server" ConnectionString="<%$ ConnectionStrings:PR317188ConnectionString %>" SelectCommand="SELECT [codEspecialidade], [nomeEspecialidade] FROM [especialidade]"></asp:SqlDataSource>
            </td>
        </tr>
    </table>
    <div class="btnFinal">
        <asp:Label ID="lbMsgEspMed" runat="server" Text=""></asp:Label><br />
        <asp:button CssClass="asp_button" ID="btnEspMed" runat="server" text="Adicionar especialização ao médico" OnClick="btnEspMed_Click" />
    </div>

</div>
</form>
</body>
</html>
