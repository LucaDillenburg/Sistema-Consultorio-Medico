<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Index.aspx.cs" Inherits="ProjetoPPI.PagSecretaria.Index" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
        <div>
            <asp:Button ID="btnCadastrarMedico" runat="server" Text="Cadastrar Médico" OnClick="btnCadastrarMedico_Click" />
            <asp:Button ID="btnCadastrarPaciente" runat="server" Text="Cadastrar Paciente" OnClick="btnCadastrarPaciente_Click" />
            <asp:Button ID="btnCadastrarSecretaria" runat="server" Text="Cadastrar Secretaria" OnClick="btnCadastrarSecretaria_Click" />

            <asp:Button ID="btnAgendarConsulta" runat="server" Text="Agendar Consulta" OnClick="btnAgendarConsulta_Click" />
            <asp:Button ID="btnAgenda" runat="server" Text="Agenda" OnClick="btnAgenda_Click" />
        </div>
    </form>
</body>
</html>
