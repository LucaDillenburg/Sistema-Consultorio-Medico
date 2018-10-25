<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="VerConsulta.aspx.cs" Inherits="ProjetoPPI.PagSecretaria.VerConsulta" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title></title>
</head>
<body>
<form id="form1" runat="server">
<div>
    <%
        if (Session["usuario"] == null || Session["conexao"] == null || Session["usuario"].GetType() != typeof(ProjetoPPI.Secretaria))
        {
            Response.Redirect("../Index.aspx");
            return;
        }

        if (Session["consulta"] == null)
        {
            Response.Redirect("Index.aspx");
            return;
        }
            
        ProjetoPPI.AtributosConsultaCod atrConsulta = (ProjetoPPI.AtributosConsultaCod)Session["consulta"];
        this.txtProposito.Text = atrConsulta.Proposito;

        this.codConsulta = atrConsulta.CodConsulta;
    %>
    <!-- SECRETÁRIA -->

    <center>
        <asp:Label runat="server">Propósito: </asp:Label><asp:TextBox ID="txtProposito" runat="server"></asp:TextBox> <br />
        <asp:Label ID="lbMsgProposito" runat="server" Text=""></asp:Label> <br />
    </center>
    
    <br /><br />

    <asp:Label runat="server" Text="Médico: "></asp:Label> 
    <asp:DropDownList ID="ddlMedicos" runat="server" DataSourceID="SqlDataSourceMedicos" DataTextField="nomeCompleto" DataValueField="email">
    </asp:DropDownList>
    <asp:SqlDataSource ID="SqlDataSourceMedicos" runat="server" ConnectionString="<%$ ConnectionStrings:PR317188ConnectionString %>" SelectCommand="SELECT [email], [nomeCompleto] FROM [medico]"></asp:SqlDataSource>
    <br />
    <asp:Label ID="lbMsgMedico" runat="server" Text=""></asp:Label> <br />
    <%
        //selecionar medico no combobox
        foreach (ListItem item in this.ddlMedicos.Items)
            if (item.Value == atrConsulta.EmailMedico)
            {
                item.Selected = true;
                break;
            }
    %>

    <asp:Label ID="lbPaciente" runat="server" Text="Paciente: "></asp:Label> 
    <asp:DropDownList ID="ddlPacientes" runat="server" DataSourceID="SqlDataSourcePacientes" DataTextField="nomeCompleto" DataValueField="email">
    </asp:DropDownList>
    <asp:SqlDataSource ID="SqlDataSourcePacientes" runat="server" ConnectionString="<%$ ConnectionStrings:PR317188ConnectionString %>" SelectCommand="SELECT [email], [nomeCompleto] FROM [paciente]"></asp:SqlDataSource>
    <br />
    <asp:Label ID="lbMsgPaciente" runat="server" Text=""></asp:Label> <br />
    <%
        //selecionar paciente no combobox
        foreach (ListItem item in this.ddlPacientes.Items)
            if (item.Value == atrConsulta.EmailPaciente)
            {
                item.Selected = true;
                break;
            }
    %>

    <br />

    <asp:Label ID="lbHorario" runat="server" Text="Horário: "></asp:Label> <br />
    <label>Horário: </label> <asp:TextBox ID="txtDia" runat="server" TextMode="Date"></asp:TextBox> <asp:TextBox ID="txtHorario" runat="server"></asp:TextBox>
    <asp:Label ID="lbMsgHorario" runat="server" Text=""></asp:Label> <br />
    <%
        //horario
        this.txtDia.Text = atrConsulta.Horario.ToString("yyyy - MM - dd");
        this.txtHorario.Text = atrConsulta.Horario.ToString("HH:mm");
    %>

    <asp:Label ID="lbDuracao" runat="server" Text="Duração: "></asp:Label>
    <asp:DropDownList ID="ddlTempoConsulta" runat="server">
        <asp:ListItem Value="30">30 minutos</asp:ListItem>
        <asp:ListItem Value="60">1 hora</asp:ListItem>
    </asp:DropDownList>
    <%
        //duracao
        if (!atrConsulta.UmaHora) //se 30 min
            this.ddlTempoConsulta.Items[0].Selected = true;
        else
            this.ddlTempoConsulta.Items[1].Selected = true;
    %>
    <asp:Label ID="lbMsgDuracao" runat="server" Text=""></asp:Label> <br />
    <br />
    

    <br />

    <label>Status: </label>
    <!-- 's': ocorrido, 'n': ainda nao ocorrido, 'c': cancelado -->
    <asp:DropDownList ID="ddlStatus" runat="server">
        <asp:ListItem Value="s">Ocorrido</asp:ListItem>
        <asp:ListItem Value="n">Ainda não Ocorrido</asp:ListItem>
        <asp:ListItem Value="c">Cancelado</asp:ListItem>
    </asp:DropDownList>
    <asp:Label ID="lbMsgStatus" runat="server" Text=""></asp:Label> <br />
    <br />

    <%
        switch(atrConsulta.Status)
        {
            case 's':
                this.ddlStatus.Items[0].Selected = true;
                break;
            case 'n':
                this.ddlStatus.Items[1].Selected = true;
                break;
            case 'c':
                this.ddlStatus.Items[2].Selected = true;
                break;
        }
    %>

    <%
        if (atrConsulta.Status == 's' && atrConsulta.Satisfacao >= 0)
        {
            if (!String.IsNullOrEmpty(atrConsulta.Comentario))
            {
    %>
                <label>Comentário: </label>
                <textarea>
                    <%=atrConsulta.Observacoes%>
                </textarea> <br />
        <% }else { %>
                <label>O paciente não fez nenhum comentário...</label> <br />
        <% } %>

            <!-- ESTRELAS / SATISFACAO-->
            <label>Satisfação: </label>
            <label>
                <%=atrConsulta.Satisfacao%>
            </label>
    <%
        }else
        { 
    %>
            <asp:Label ID="lbSemSatisfacao" runat="server" Text="O paciente não registrou nenhuma satisfação..."></asp:Label> <br />
    <% } %>

    <%
    if (atrConsulta.Status == 's')
    {
    %>
        <br />
        
        <label>Observações: </label>
        <asp:TextBox ID="txtObservacoes" runat="server" TextMode="MultiLine"></asp:TextBox> <br />
        <asp:Label ID="lbMsgObservacoes" runat="server" Text=""></asp:Label>
        <% 
        this.txtObservacoes.Text = atrConsulta.Observacoes;
        if (String.IsNullOrEmpty(atrConsulta.Observacoes)) 
        { %>
            <asp:Label ID="lbSemObservacoes" runat="server" Text="Sem observações..."></asp:Label> 
        <% }
    }
    %>
    
    <br />
    <asp:Button ID="btnAtualizarDados" runat="server" Text="Atualizar dados consulta" OnClick="btnAtualizarDados_Click" /> <br /> 
    <asp:Label ID="lbMsg" runat="server" Text=""></asp:Label>
</div>
</form>
</body>
</html>
