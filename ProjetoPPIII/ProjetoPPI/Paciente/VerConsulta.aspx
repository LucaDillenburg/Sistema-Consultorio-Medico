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
    <a href="/Paciente/IndexPaciente" class="btnVoltar"><i class="glyphicon glyphicon-chevron-left"></i></a>
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
                <div class="secao">
                    <h2 id="lbObservacoes"">Observações</h2>
                    <textarea readonly><%= atrConsulta.Observacoes%></textarea>
                </div>
            </div>
        <%
        }else
        {
        %>
            <div class="secao">
                <h2>Observações</h2>
                <asp:Label ID="lbSemObservacoes" runat="server" Text="O médico não fez observações..."></asp:Label>
            </div>
        <%
        }
        %>

        <%
        podeDeixarSatisfacao = atrConsulta.Satisfacao < 0;
        if (podeDeixarSatisfacao)
        {
        %>
            <div class="secao">
                <h2>Deixe um Comentário</h2>
                <asp:TextBox ID="txtComentario" runat="server" TextMode="MultiLine"></asp:TextBox> <br />
                <asp:Label ID="lbMsgComentario" runat="server" Text=""></asp:Label>
            </div>
        <%
        }else
        if (!String.IsNullOrEmpty(atrConsulta.Comentario))
        {
        %>
            <div class="secao">
                <h2>Comentário</h2>
                <textarea readonly><%= atrConsulta.Comentario%></textarea>
            </div>
        <%
        }else
        {
        %>
            <div class="secao">
                <h2>Comentário</h2>
                <p>Não há nenhum comentário...</p>
            </div>
        <%
        }
        %>
        
        <!-- ESTRELAS / SATISFACAO-->
        <div class="secao">
        <h2>Satisfação: </h2>
        <%
        if (podeDeixarSatisfacao)
        {
        %>
            <asp:DropDownList ID="ddlSatisfacao" runat="server">
                <asp:ListItem Selected="True">5</asp:ListItem>
                <asp:ListItem>4</asp:ListItem>
                <asp:ListItem>3</asp:ListItem>
                <asp:ListItem>2</asp:ListItem>
                <asp:ListItem>1</asp:ListItem>
                <asp:ListItem>0</asp:ListItem>
            </asp:DropDownList>
            <br />
            <asp:Label ID="lbMsgSatisfacao" runat="server" Text=""></asp:Label>
            <br />
        <% }else { %>
            <label><%=atrConsulta.Satisfacao%> Estrelas</label>
        <% } %>
        </div>

        <% if (podeDeixarSatisfacao) { %>
            <asp:Button ID="btnRegistrarSatisfacao" runat="server" Text="Registrar Avaliação" OnClick="btnRegistrarSatisfacao_Click" /> <br /> 
            <asp:Label ID="lbMsg" runat="server" Text=""></asp:Label>
        <% } %>
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
