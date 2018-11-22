<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="VerConsulta.aspx.cs" Inherits="ProjetoPPI.PagSecretaria.VerConsulta" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="ajaxToolkit" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title>Ver Consulta</title>
    <link href="/estilo.css" rel="stylesheet" />
    <link href="https://fonts.googleapis.com/css?family=Baloo+Tammudu" rel="stylesheet"/>
    <link href="https://fonts.googleapis.com/css?family=Comfortaa" rel="stylesheet"/>
    <link href="https://fonts.googleapis.com/css?family=Pacifico" rel="stylesheet"/>
    <link href="/Content/bootstrap.css" rel="stylesheet" />
    <style>
        body {
            background-image: url('/imgs/charts-cup-of-coffee-desk-1345089.jpg');
            background-attachment: fixed;
            background-position: center;
            background-repeat: no-repeat;
            background-size: cover;
        }
    </style>
</head>
<body>
<form id="form1" runat="server">
<asp:scriptmanager runat="server"></asp:scriptmanager>

    <a href="IndexSecretaria.aspx" class="btnVoltar"><i class="glyphicon glyphicon-chevron-left"></i></a>

<div class="consulta">
    <%
        ProjetoPPI.AtributosConsultaCod atrConsulta = (ProjetoPPI.AtributosConsultaCod)Session["consulta"];
        if (this.colocarConsultaTela)
            this.ColocarConsultaTela();
    %>
    <!-- SECRETÁRIA -->

    <h1 class="title-originais">
        <label>Propósito: </label> <asp:TextBox ID="txtProposito" runat="server"></asp:TextBox>  <br />
        <asp:Label ID="lbMsgProposito" runat="server" Text=""></asp:Label>
    </h1>

    <div class="secao">
        <label>Médico: <%=ProjetoPPI.Medico.DeEmail(atrConsulta.EmailMedico, (ProjetoPPI.ConexaoBD)Session["conexao"]).NomeCompleto%></label> <br />
    </div>

    <div class="secao">
        <label>Paciente: <%=ProjetoPPI.Paciente.DeEmail(atrConsulta.EmailPaciente, (ProjetoPPI.ConexaoBD)Session["conexao"]).NomeCompleto%></label> <br />
    </div>

    <div class="secao">
        <label>Horário: </label> <asp:TextBox ID="txtDia" runat="server" TextMode="Date"></asp:TextBox>
        <asp:TextBox ID="txtHorario" runat="server"></asp:TextBox>
        <ajaxToolkit:MaskedEditExtender ID="MaskedEditExtender1" runat="server"
            TargetControlID="txtHorario"
            Mask="99:99"
            MaskType="Number"
            InputDirection="LeftToRight"
            ClearMaskOnLostFocus ="False" />
        <br />
        <asp:Label CssClass="lblErro" ID="lbMsgHorario" runat="server" Text=""></asp:Label>
    </div>

    <div class="secao">
        <label>Duração: </label>
        <asp:DropDownList ID="ddlTempoConsulta" runat="server">
            <asp:ListItem Value="30">30 minutos</asp:ListItem>
            <asp:ListItem Value="60">1 hora</asp:ListItem>
        </asp:DropDownList>
        <br />
        <asp:Label CssClass="lblErro" ID="lbMsgDuracao" runat="server" Text=""></asp:Label>
    </div>

    <div class="secao">
        <label>Status: </label>
        <!-- 's': ocorrido, 'n': ainda nao ocorrido, 'c': cancelado -->
        <asp:DropDownList ID="ddlStatus" runat="server">
            <asp:ListItem Value="s">Ocorrido</asp:ListItem>
            <asp:ListItem Value="n">Ainda não Ocorrido</asp:ListItem>
            <asp:ListItem Value="c">Cancelado</asp:ListItem>
        </asp:DropDownList>
        <br />
        <asp:Label CssClass="lblErro" ID="lbMsgStatus" runat="server" Text=""></asp:Label>
    </div>

    <%
    if (atrConsulta.Status == 's' && atrConsulta.Satisfacao >= 0)
    {
        if (!String.IsNullOrEmpty(atrConsulta.Comentario))
        {
    %>
            <label>Comentário: </label>
            <textarea><%=atrConsulta.Comentario%></textarea> <br />
        <% }else { %>
            <label>O paciente não fez nenhum comentário...</label> <br />
        <% } %>

        <!-- ESTRELAS / SATISFACAO-->
        <label>Satisfação: </label>
        <label><%=atrConsulta.Satisfacao%></label>
    <%
    }else
    {
    %>
        <asp:Label CssClass="lblErro" ID="lbSemSatisfacao" runat="server" Text="O paciente não registrou nenhuma satisfação..."></asp:Label> <br />
    <% } %>


    <br />
    <label>Observações: </label>
    <asp:TextBox ID="txtObservacoes" runat="server" TextMode="MultiLine"></asp:TextBox> <br />
    <asp:Label ID="lbMsgObservacoes" runat="server" Text=""></asp:Label>
    <% if (String.IsNullOrEmpty(atrConsulta.Observacoes)) { %>
        <asp:Label ID="lbSemObservacoes" runat="server" Text="Sem observações..."></asp:Label>
    <% } %>

    <div class="btnFinal">
        <asp:Button CssClass="asp_button" ID="btnAtualizarDados" runat="server" Text="Atualizar dados consulta" OnClick="btnAtualizarDados_Click" /> <br />
        <asp:Label CssClass="lblErro" ID="lbMsg" runat="server" Text=""></asp:Label>
    </div>
</div>
</form>
</body>
</html>
