﻿<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="VerConsulta.aspx.cs" Inherits="ProjetoPPI.PagMedico.VerConsulta" %>

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
        if (Session["usuario"] == null || Session["conexao"] == null || Session["usuario"].GetType() != typeof(ProjetoPPI.Medico))
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

        //se a consulta nao eh desse medico
        ProjetoPPI.AtributosConsultaCod atrConsulta = (ProjetoPPI.AtributosConsultaCod)Session["consulta"];
        if (atrConsulta.EmailMedico != ((ProjetoPPI.Medico)Session["usuario"]).Atributos.Email)
        {
            Session["consulta"] = null;
            Response.Redirect("Index.aspx");
            return;
        }

        this.codConsulta = atrConsulta.CodConsulta;
    %>

    <!-- MEDICO -->

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

    <label id="lbPaciente"> 
        <%= "Paciente: " + ProjetoPPI.Paciente.DeEmail(atrConsulta.EmailPaciente, (ProjetoPPI.ConexaoBD)Session["conexao"]).NomeCompleto %> 
    </label> <br />
    <label id="lbDuracao">
        <%= "Duração: " + (atrConsulta.UmaHora ? "1 hora." : "30 minutos.") %>
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
        <% if (atrConsulta.Satisfacao >= 0) { %>
            <div id="pnlComentario"> 
                <% if (!String.IsNullOrEmpty(atrConsulta.Comentario)) { %>
                    <label id="lbComentario">Comentário: </label>
                    <input type="text" id="txtComentario" value="
                        <%= atrConsulta.Comentario%>
                        " readonly> <br />
                <% } else {  %>
                    <label id="lbSemComentario">O paciente não fez nenhum comentário...</label> <br />
                <% } %>

                <!-- ESTRELAS / SATISFACAO-->
                Satisfação: <label id="txtSatisfacao"> <%= atrConsulta.Satisfacao + "" %> </label>
            </div>
        <% } else {  %>
            <label id="lbSemSatisfacao">O paciente não registrou nenhuma satisfação...</label> <br />
        <% } %>

        <br />
        
        <%
        //se ainda nao acabou o dia
        //o medico tem ateh o final do dia para fazer os comentarios das consultas do dia
        DateTime dataFinalDoDia = new DateTime(DateTime.Now.Year, DateTime.Now.Month, DateTime.Now.Day,
                23, 59, 59);
        this.podeDeixarObservacoes = atrConsulta.Horario.CompareTo(dataFinalDoDia) < 0;

        this.txtObservacoes.Text = atrConsulta.Observacoes;
        if (this.podeDeixarObservacoes || !String.IsNullOrEmpty(atrConsulta.Observacoes))
        {
        %>
            <div id="pnlObservacoes">
                <label id="lbObservacoes">Observações: </label>
                <asp:TextBox ID="txtObservacoes" runat="server" TextMode="MultiLine"></asp:TextBox>
                
                <% if (this.podeDeixarObservacoes) { %> <br />
                    <label>Para confirmar que a consulta ocorreu, faça um comentário sobre a mesma.</label> <br />
                    <asp:Label ID="lbMsgObservacoes" runat="server" Text=""></asp:Label>
                <% } %>
            </div>
            
            <% if (this.podeDeixarObservacoes) { %>
                <br />
                <asp:Button ID="btnMandarObservacoes" runat="server" Text="Mandar Observações" OnClick="btnMandarObservacoes_Click" /> <br /> 
                <asp:Label ID="lbMsg" runat="server" Text=""></asp:Label>
            <% } %>
            </div>
        <% } else { %>
            <label id="lbSemObservacoes">Sem observações...</label>
        <% } %>
    <%
    } else
        this.podeDeixarObservacoes = false;
    %>
</div>
</form>
</body>
</html>
