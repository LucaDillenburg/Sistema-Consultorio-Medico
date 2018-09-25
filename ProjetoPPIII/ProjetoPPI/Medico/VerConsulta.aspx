<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="VerConsulta.aspx.cs" Inherits="ProjetoPPI.PagMedico.VerConsulta" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title></title>
</head>
<body>
<form id="form1" runat="server">
<div>
    <!-- MEDICO -->

    <!-- DIA\MES(SE NAO EH ESSE ANO:\ANO?) PROPOSITO -->
    <center><asp:Label ID="lbTitulo" runat="server" Text=""></asp:Label></center>
    
    <br /><br />

    <asp:Label ID="lbPaciente" runat="server" Text="Paciente: "></asp:Label> <br />
    <asp:Label ID="lbDuracao" runat="server" Text="Duração: "></asp:Label> <br />

    <br />

    <asp:Label ID="lbStatus" runat="server" Text=""></asp:Label> <br />

    <asp:Panel ID="pnlOcorrido" runat="server">
        <asp:Panel ID="pnlComentario" runat="server"> 
            <asp:Label ID="lbComentario" runat="server" Text="Comentário: "></asp:Label>
            <asp:TextBox ID="txtComentario" runat="server" TextMode="MultiLine" ReadOnly="True"></asp:TextBox> <br />
            <asp:Label ID="lbSemComentario" runat="server" Text="O paciente não fez nenhum comentário..."></asp:Label> <br />

            <!-- ESTRELAS / SATISFACAO-->
            Satisfação: <asp:TextBox ID="txtSatisfacao" runat="server" ReadOnly="True"></asp:TextBox>
        </asp:Panel>
        <asp:Label ID="lbSemSatisfacao" runat="server" Text="O paciente não registrou nenhuma satisfação..."></asp:Label> <br />

        <br />
        
        <asp:Panel ID="pnlObservacoes" runat="server">
            <asp:Label ID="lbObservacoes" runat="server" Text="Observações: "></asp:Label>
            <asp:TextBox ID="txtObservacoes" runat="server" TextMode="MultiLine"></asp:TextBox> <br />
            <asp:Label ID="lbMsgObservacoes" runat="server" Text=""></asp:Label>
        </asp:Panel>
        <asp:Label ID="lbSemObservacoes" runat="server" Text="Sem observações..."></asp:Label>
    
        <br />
        <asp:Button ID="btnMandarObservacoes" runat="server" Text="Mandar Observações" OnClick="btnMandarObservacoes_Click" /> <br /> 
        <asp:Label ID="lbMsg" runat="server" Text=""></asp:Label>
    </asp:Panel>
</div>
</form>
</body>
</html>
