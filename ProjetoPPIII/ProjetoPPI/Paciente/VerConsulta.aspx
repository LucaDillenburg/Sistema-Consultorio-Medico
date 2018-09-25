<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="VerConsulta.aspx.cs" Inherits="ProjetoPPI.PagPaciente.VerConsulta" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title></title>
</head>
<body>
<form id="form1" runat="server">
<div>
    <!-- DIA\MES(SE NAO EH ESSE ANO:\ANO?) PROPOSITO -->
    <center><asp:Label ID="lbTitulo" runat="server" Text=""></asp:Label></center>
    
    <br /><br />

    <asp:Label ID="lbMedico" runat="server" Text="Médico: "></asp:Label> <br />
    <asp:Label ID="lbDuracao" runat="server" Text="Duração: "></asp:Label> <br />

    <br />

    <asp:Label ID="lbStatus" runat="server" Text=""></asp:Label> <br />

    <asp:Panel ID="pnlOcorrido" runat="server">
        <asp:Panel ID="pnlObservacoes" runat="server"> 
            <asp:Label ID="lbObservacoes" runat="server" Text="Observações: "></asp:Label>
            <asp:TextBox ID="txtObservacoes" runat="server" ReadOnly="True" TextMode="MultiLine"></asp:TextBox>
        </asp:Panel>
        <asp:Label ID="lbSemObservacoes" runat="server" Text="O médico não fez observações..."></asp:Label> <br />

        <br />

        <asp:Label ID="lbComentario" runat="server" Text="Comentário: "></asp:Label>
        <asp:TextBox ID="txtComentario" runat="server" TextMode="MultiLine"></asp:TextBox> <br />
        <asp:Label ID="lbMsgComentario" runat="server" Text=""></asp:Label>

        <!-- ESTRELAS / SATISFACAO-->
        Satisfação: <asp:TextBox ID="txtSatisfacao" runat="server"></asp:TextBox>
        <asp:Label ID="lbMsgSatisfacao" runat="server" Text=""></asp:Label>
    
        <br />
        <asp:Button ID="btnRegistrarSatisfacao" runat="server" Text="Registrar Avaliação" OnClick="btnRegistrarSatisfacao_Click" /> <br /> 
        <asp:Label ID="lbMsg" runat="server" Text=""></asp:Label>
    </asp:Panel>
</div>
</form>
</body>
</html>
