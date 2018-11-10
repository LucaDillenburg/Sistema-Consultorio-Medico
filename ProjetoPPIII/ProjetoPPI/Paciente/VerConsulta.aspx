<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="VerConsulta.aspx.cs" Inherits="ProjetoPPI.PagPaciente.VerConsulta" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <link rel="stylesheet" href="/estilo.css" />
    <link href="https://fonts.googleapis.com/css?family=Baloo+Tammudu" rel="stylesheet"/>
    <link href="https://fonts.googleapis.com/css?family=Comfortaa" rel="stylesheet"/>
    <link href="https://fonts.googleapis.com/css?family=Pacifico" rel="stylesheet"/>
    <link href="/Content/bootstrap.min.css" rel="stylesheet" />
    <script src="/Scripts/jquery-1.10.2.min.js"></script>
    <title></title>
</head>
<body id="body-verConsulta">
<form id="form1" runat="server">
<div>
    <%
        ProjetoPPI.AtributosConsultaCod atrConsulta = (ProjetoPPI.AtributosConsultaCod)Session["consulta"];
        if (atrConsulta.EmailPaciente != ((ProjetoPPI.Paciente)Session["usuario"]).Atributos.Email)
        {
            Session["consulta"] = null;
            Response.Redirect("Index.aspx");
            return;
        }
    %>

    <!-- DIA\MES(SE NAO EH ESSE ANO:\ANO?) PROPOSITO -->
    <!-- (soh mostrar ano se for diferente do ano atual) -->
    <% string titulo =  atrConsulta.Proposito + 
                " - " + atrConsulta.Horario.ToString("dd/MM" + (DateTime.Now.Year != atrConsulta.Horario.Year ? "/yyyy" : "") + " HH:mm"); %>
    <div class="consulta">
    
    <h1 class="title-originais">
        <%  if (atrConsulta.Status == 'c')
            { 
        %>
            <strike><%= titulo %></strike>
        <%
            }else
            {
                %> <%= titulo %> <%
            }
        %>    
    </h1>     
    
    <div class="secao">
        <h2>Médico</h2>
        <p> <%=ProjetoPPI.Medico.DeEmail(atrConsulta.EmailMedico, (ProjetoPPI.ConexaoBD)Session["conexao"]).NomeCompleto %></p>
    </div>    
    <div class="secao">
        <h2>Duração</h2>
        <p><%=(atrConsulta.UmaHora?"1 hora.":"30 minutos.") %></p>
    </div>       
    <div class="secao">
        <h2>Status</h2>
        <p><% 
            switch(atrConsulta.Status)
            {
                case 'n':
                    %>Ainda não ocorreu<%
                    break;
                case 'c':
                    %>CANCELADA<%
                    break;
                default:
                    %>Já ocorreu<%
                    break;
            }
        %></p>
    </div>    

    <%
    bool podeDeixarSatisfacao;
    if (atrConsulta.Status == 's')
    {
    %>
        <div id="pnlOcorrido">
        <%
        if (!String.IsNullOrEmpty(atrConsulta.Observacoes))
        { 
        %>
            <div id="pnlObservacoes"> 
                <label id="lbObservacoes"">Observações: </label>
                <textarea readonly><%= atrConsulta.Observacoes%></textarea>
            </div>
        <%
        }else
        {
        %>
            <asp:Label ID="lbSemObservacoes" runat="server" Text="O médico não fez observações..."></asp:Label> <br />
        <%
        }
        %>
        <br />
        <%
        podeDeixarSatisfacao = atrConsulta.Satisfacao < 0;
        if (podeDeixarSatisfacao)
        {
        %>
            <label>Comentário: </label>
            <asp:TextBox ID="txtComentario" runat="server" TextMode="MultiLine"></asp:TextBox> <br />
            <asp:Label ID="lbMsgComentario" runat="server" Text=""></asp:Label>
        <%
        }else
        if (!String.IsNullOrEmpty(atrConsulta.Comentario))
        {
        %>
            <label>Comentário: </label>
            <textarea readonly><%= atrConsulta.Comentario%></textarea>
        <%
        }else
        {
        %>
            <label>Não há nenhum comentário...</label>
        <%
        }
        %>
        <br />
        <!-- ESTRELAS / SATISFACAO-->
        <label>Satisfação: </label>
        <%
        if (podeDeixarSatisfacao)
        {
        %>
            <asp:TextBox ID="txtSatisfacao" runat="server"></asp:TextBox> <br />
            <asp:Label ID="lbMsgSatisfacao" runat="server" Text=""></asp:Label>
            <br />
            <asp:Button ID="btnRegistrarSatisfacao" runat="server" Text="Registrar Avaliação" OnClick="btnRegistrarSatisfacao_Click" /> <br /> 
            <asp:Label ID="lbMsg" runat="server" Text=""></asp:Label>
        <%
        }else
        {
        %>
            <textarea readonly><%= atrConsulta.Satisfacao%></textarea>
        <%
        }
        %>
        </div>
    <%
    } else
        podeDeixarSatisfacao = false;
    Session["podeDeixarSatisfacao"] = podeDeixarSatisfacao;
    %>
    </div>
</div>
</form>
</body>
</html>
