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
        if (Session["usuario"] == null || Session["conexao"] == null || Session["usuario"].GetType() == typeof(ProjetoPPI.Secretaria))
        {
            Response.Redirect("/Index.aspx");
            return;
        }
        
        string url = HttpContext.Current.Request.Url.AbsoluteUri;
        // se passou codigo consulta pela url
        try
        {
            int index = url.LastIndexOf('?');
            if (index < 0)
                throw new Exception("");
            string codStr = url.Substring(index+1);
            int codConsulta = Convert.ToInt32(codStr);
            Session["consulta"] = ProjetoPPI.Consulta.DeCodigo(codConsulta, (ProjetoPPI.ConexaoBD)Session["conexao"]);
        }catch(Exception e)
        {
            Response.Redirect("Index.aspx");
            return;
        }
        

        ProjetoPPI.AtributosConsultaCod atrConsulta = (ProjetoPPI.AtributosConsultaCod)Session["consulta"];
        if(Session["usuario"].GetType() == typeof(ProjetoPPI.Paciente))
            if (atrConsulta.EmailPaciente != ((ProjetoPPI.Paciente)Session["usuario"]).Atributos.Email)
            {
                Session["consulta"] = null;
                Response.Redirect("Index.aspx");
                return;
            }

        this.codConsulta = atrConsulta.CodConsulta;
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
            <%= titulo %>
        <%
            }else
            {
                %> <%= titulo %> <%
            }
        %>    
    </h1>     
    
    <div class="secao">
        <h2><%if (Session["usuario"].GetType() == typeof(ProjetoPPI.Medico)) {%>
                Paciente
            <%} else{%>Médico<%}%>
        </h2>
        <p> 
            <%if (Session["usuario"].GetType() == typeof(ProjetoPPI.Medico)) {
                   %><%=ProjetoPPI.Medico.DeEmail(atrConsulta.EmailMedico, (ProjetoPPI.ConexaoBD)Session["conexao"]).NomeCompleto%><%}
              else{
                    %><%=ProjetoPPI.Paciente.DeEmail(atrConsulta.EmailPaciente, (ProjetoPPI.ConexaoBD)Session["conexao"]).NomeCompleto%>
            <%}%>
        </p>
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
        this.podeDeixarSatisfacao = atrConsulta.Satisfacao < 0;
        if (this.podeDeixarSatisfacao)
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
        if (this.podeDeixarSatisfacao)
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
        this.podeDeixarSatisfacao = false;
    %>
    </div>
</div>
</form>
</body>
</html>
