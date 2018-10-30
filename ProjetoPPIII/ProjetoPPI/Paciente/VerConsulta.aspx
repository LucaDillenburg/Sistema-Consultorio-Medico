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
    <%
        if (Session["usuario"] == null || Session["conexao"] == null || Session["usuario"].GetType() != typeof(ProjetoPPI.Paciente))
        {
            Response.Redirect("../Index.aspx");
            return;
        }

        if (Session["consulta"] == null)
        {
            string url = HttpContext.Current.Request.Url.AbsolutePath;
            // se passou codigo consulta pela url
            try
            {
                string codStr = url.Substring(url.LastIndexOf('?')+1);
                Int32.TryParse(codStr, out int codConsulta);
                Session["consulta"] = ProjetoPPI.Consulta.DeCodigo(codConsulta, (ProjetoPPI.ConexaoBD)Session["conexao"]);
            }catch(Exception e)
            {
                Response.Redirect("Index.aspx");
                return;
            }
        }

        ProjetoPPI.AtributosConsultaCod atrConsulta = (ProjetoPPI.AtributosConsultaCod)Session["consulta"];
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
    <% string titulo = atrConsulta.Horario.ToString("dd/MM" + (DateTime.Now.Year != atrConsulta.Horario.Year ? "/yyyy" : "") + " HH:mm") + 
                " - " + atrConsulta.Proposito; %>
    <center><h1>
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
    </h1></center>
    
    <br /><br />

    <label id="lbMedico">
        <%= "Médico: " + ProjetoPPI.Medico.DeEmail(atrConsulta.EmailMedico, (ProjetoPPI.ConexaoBD)Session["conexao"]).NomeCompleto %>
    </label> <br />
    <label id="lbDuracao"">
        <%= "Duração: " + (atrConsulta.UmaHora?"1 hora.":"30 minutos.") %>
    </label> <br />

    <br />

    <label id="lbStatus">
        <% 
            switch(atrConsulta.Status)
            {
                case 'n':
                    %>Status: ainda não ocorreu<%
                    break;
                case 'c':
                    %>Status: CANCELADA<%
                    break;
                default:
                    %>Status: já ocorreu<%
                    break;
            }
        %>
    </label> <br />

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
</form>
</body>
</html>
