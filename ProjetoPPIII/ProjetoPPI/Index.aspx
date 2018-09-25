<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Index.aspx.cs" Inherits="ProjetoPPI.Index" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title></title>
    <link rel="stylesheet" href="estilo.css" />
    <link href="Content/bootstrap.css" rel="stylesheet" />
</head>
<body>
    <form id="form1" runat="server">
        <div class="leftnav">
            <a href="Index.aspx">HOME</a>
            <asp:Button ID="btnMenuPaciente" runat="server" Text="PACIENTE" OnClick="btnMenuPaciente_Click" />
            <asp:Button ID="btnMenuMedico" runat="server" Text="MEDICO" OnClick="btnMenuMedico_Click" />
            <asp:Button ID="btnMenuSecretaria" runat="server" Text="SECRETARIA" OnClick="btnMenuSecretaria_Click" />
        </div>

        <div class="content">
            <h1 id="bemvindo">BEM VINDO!</h1>
        </div>
        
        <div>
        </div>
    </form>
</body>
</html>
