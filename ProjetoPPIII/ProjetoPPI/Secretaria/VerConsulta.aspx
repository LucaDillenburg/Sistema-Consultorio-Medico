<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="VerConsulta.aspx.cs" Inherits="ProjetoPPI.PagSecretaria.VerConsulta" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title></title>
    <link href="/estilo.css" rel="stylesheet" />
    <link href="https://fonts.googleapis.com/css?family=Baloo+Tammudu" rel="stylesheet"/>
    <link href="https://fonts.googleapis.com/css?family=Comfortaa" rel="stylesheet"/>
    <link href="https://fonts.googleapis.com/css?family=Pacifico" rel="stylesheet"/>
    <link href="/Content/bootstrap.css" rel="stylesheet" />
    <style>
        body {
            background-image: url('/charts-cup-of-coffee-desk-1345089.jpg');
            background-attachment: fixed;
            background-position: center;
            background-repeat: no-repeat;
            background-size: cover;
        }
    </style>
</head>
<body>
<form id="form1" runat="server">
    <a href="/Secretaria/IndexSecretaria" class="btnVoltar"><i class="glyphicon glyphicon-chevron-left"></i></a>
<div class="consulta">
    <%
        ProjetoPPI.AtributosConsultaCod atrConsulta = (ProjetoPPI.AtributosConsultaCod)Session["consulta"];
        if(Session["usuario"].GetType() == typeof(ProjetoPPI.Paciente) &&
            atrConsulta.EmailPaciente != ((ProjetoPPI.Paciente)Session["usuario"]).Atributos.Email)
        {
            Session["consulta"] = null;
            Response.Redirect("Index.aspx");
            return;
        }
        
    %>    
    <!-- SECRETÁRIA -->

    <h1 class="title-originais">
        Propósito: <asp:TextBox ID="txtProposito" runat="server"></asp:TextBox>
        <% this.txtProposito.Text = atrConsulta.Proposito; %>
        <asp:Label ID="lbMsgProposito" runat="server" Text=""></asp:Label>
    </h1>

    <div class="secao">
        <asp:Label runat="server" Text="Médico: "></asp:Label> 
        <asp:DropDownList ID="ddlMedicos" runat="server" DataSourceID="SqlDataSourceMedicos" DataTextField="nomeCompleto" DataValueField="email">
        </asp:DropDownList>
        <asp:SqlDataSource ID="SqlDataSourceMedicos" runat="server" ConnectionString="<%$ ConnectionStrings:PR317188ConnectionString %>" SelectCommand="SELECT [email], [nomeCompleto] FROM [medico]"></asp:SqlDataSource>
        <br />
        <asp:Label ID="lbMsgMedico" runat="server" Text=""></asp:Label> <br />
    </div>

    <div class="secao">
    <asp:Label ID="lbPaciente" runat="server" Text="Paciente: "></asp:Label> 
    <asp:DropDownList ID="ddlPacientes" runat="server" DataSourceID="SqlDataSourcePacientes" DataTextField="nomeCompleto" DataValueField="email">
    </asp:DropDownList>
    <asp:SqlDataSource ID="SqlDataSourcePacientes" runat="server" ConnectionString="<%$ ConnectionStrings:PR317188ConnectionString %>" SelectCommand="SELECT [email], [nomeCompleto] FROM [paciente]"></asp:SqlDataSource>
    <br />
    <asp:Label ID="lbMsgPaciente" runat="server" Text=""></asp:Label> <br />
    <br />
    </div>

    <%
        //selecionar medico no combobox
        for (int i = 0; i<this.ddlMedicos.Items.Count; i++)
            if (this.ddlMedicos.Items[i].Value == atrConsulta.EmailMedico)
            {
                this.ddlMedicos.Items[i].Selected = true;
                break;
            }else
                this.ddlMedicos.Items[i].Selected = false;

        //selecionar paciente no combobox
        for (int i = 0; i<this.ddlPacientes.Items.Count; i++)
            if (this.ddlPacientes.Items[i].Value == atrConsulta.EmailPaciente)
            {
                this.ddlPacientes.Items[i].Selected = true;
                break;
            }else
                this.ddlPacientes.Items[i].Selected = false;
    %>

    <div class="secao">
    <asp:Label ID="lbHorario" runat="server" Text="Horário: "></asp:Label> <br />
    <label>Horário: </label> <asp:TextBox ID="txtDia" runat="server" TextMode="Date"></asp:TextBox> <asp:TextBox ID="txtHorario" runat="server"></asp:TextBox>
    <asp:Label ID="lbMsgHorario" runat="server" Text=""></asp:Label> <br />
    <%
    //horario
    this.txtDia.Text = atrConsulta.Horario.ToString("yyyy - MM - dd");
    this.txtHorario.Text = atrConsulta.Horario.ToString("HH:mm");
    %>
    </div>

    <div class="secao">
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
    </div>
        
    <div class="secao">
    <label>Status: </label>
    <!-- 's': ocorrido, 'n': ainda nao ocorrido, 'c': cancelado -->
    <asp:DropDownList ID="ddlStatus" runat="server">
        <asp:ListItem Value="s">Ocorrido</asp:ListItem>
        <asp:ListItem Value="n">Ainda não Ocorrido</asp:ListItem>
        <asp:ListItem Value="c">Cancelado</asp:ListItem>
    </asp:DropDownList>
    <asp:Label ID="lbMsgStatus" runat="server" Text=""></asp:Label> <br />   
     </div>
    <%
    switch (atrConsulta.Status)
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
    
    <div class="btnFinal">
        <asp:Button CssClass="asp_button" ID="btnAtualizarDados" runat="server" Text="Atualizar dados consulta" OnClick="btnAtualizarDados_Click" /> <br /> 
        <asp:Label ID="lbMsg" runat="server" Text=""></asp:Label>
    </div>
</div>
</form>
</body>
</html>
