<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="VerConsulta.aspx.cs" Inherits="ProjetoPPI.PagMedico.VerConsulta" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title></title>
    <link href="https://fonts.googleapis.com/css?family=Baloo+Tammudu" rel="stylesheet"/>
    <link href="https://fonts.googleapis.com/css?family=Comfortaa" rel="stylesheet"/>
    <link href="https://fonts.googleapis.com/css?family=Pacifico" rel="stylesheet"/>
    <link href="/Content/bootstrap.css" rel="stylesheet" />
    <script src="/Scripts/jquery-1.10.2.min.js"></script>    
    <link rel="stylesheet" href="/estilo.css" />
</head>
<body id="bodyVerConsultaMedico">
<form id="form1" runat="server">
    <a href="/Medico/IndexMedico" class="btnVoltar"><i class="glyphicon glyphicon-chevron-left"></i></a>
<div class="consulta">
    <%        
        //se a consulta nao eh desse medico
        ProjetoPPI.AtributosConsultaCod atrConsulta = (ProjetoPPI.AtributosConsultaCod)Session["consulta"];
        if (atrConsulta.EmailMedico != ((ProjetoPPI.Medico)Session["usuario"]).Atributos.Email)
        {
            Session["consulta"] = null;
            Response.Redirect("Index.aspx");
            return;
        }
    %>

    <!-- MEDICO -->

    <!-- DIA\MES(SE NAO EH ESSE ANO:\ANO?) PROPOSITO -->
    <!-- (soh mostrar ano se for diferente do ano atual) -->
    <% string titulo = atrConsulta.Horario.ToString("dd/MM" + (DateTime.Now.Year != atrConsulta.Horario.Year ? "/yyyy" : "") + " HH:mm") +
                  " - " + atrConsulta.Proposito; %>
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
        <h2>Paciente</h2>
        <p id="lbPaciente"> 
            <%=ProjetoPPI.Paciente.DeEmail(atrConsulta.EmailPaciente, (ProjetoPPI.ConexaoBD)Session["conexao"]).NomeCompleto %> 
        </p>
    </div>

    <div class="secao">
        <h2>Duração</h2>
        <p id="lbDuracao">
            <%=(atrConsulta.UmaHora ? "1 hora." : "30 minutos.") %>
        </p>
    </div>
   
    <div class="secao">
        <h2>Status</h2>
        <p id="lbStatus">
            <% 
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
            %>
        </p>
    </div>

    <%
    //se ainda nao acabou o dia
    //o medico tem ateh o final do dia para fazer os comentarios das consultas do dia
    bool podeDeixarObservacoes = (atrConsulta.Status == 's' || atrConsulta.Status == 'n') &&
            atrConsulta.Horario.CompareTo(new DateTime(DateTime.Now.Year, DateTime.Now.Month, DateTime.Now.Day,
            23, 59, 59)) < 0;
    if (podeDeixarObservacoes)
    {
    %>
        <div id="pnlOcorrido">
        <% if (atrConsulta.Satisfacao >= 0) { %>
            <div id="pnlComentario"> 
                <% if (!String.IsNullOrEmpty(atrConsulta.Comentario)) { %>
                    <div class="secao">
                        <h2 id="lbComentario">Comentário</h2>
                        <p id="txtComentario" >
                            "<%= atrConsulta.Comentario%>"
                        </p>
                    </div>
                <% } else {  %>
                    <div class="secao">
                        <h2>Comentário</h2>
                        <p id="lbSemComentario">O paciente não fez nenhum comentário...</p>
                    </div>
                <% } %>

                <!-- ESTRELAS / SATISFACAO-->
                <div class="secao">
                    <h2>Satisfação</h2>
                    <p id="txtSatisfacao"> <%= atrConsulta.Satisfacao + "" %> </p>
                </div>
            </div>
        <% } else {  %>
            <div class="secao">
                <h2>Satisfação</h2>
                <p id="lbSemSatisfacao">O paciente não registrou nenhuma satisfação...</p>
            </div>
            
        <% } %>
        
        
        <%
        

        this.txtObservacoes.Text = atrConsulta.Observacoes;
        if (podeDeixarObservacoes || !String.IsNullOrEmpty(atrConsulta.Observacoes))
        {
        %>
            <div id="pnlObservacoes">
                <div class="secao">
                    <h2 id="lbObservacoes">Observações: </h2>
                    <asp:TextBox ID="txtObservacoes" runat="server" TextMode="MultiLine"></asp:TextBox>
                </div>
                <%
                this.txtObservacoes.Text = atrConsulta.Observacoes;
                if (podeDeixarObservacoes) { %> <br />
                    <label>Para confirmar que a consulta ocorreu, faça um comentário sobre a mesma.</label> <br />
                    <asp:Label ID="lbMsgObservacoes" runat="server" Text=""></asp:Label>
                <% } %>
            </div>

            <%
            this.txtObservacoes.ReadOnly = !podeDeixarObservacoes;
            if (podeDeixarObservacoes) { %>
                <div class="btnFinal">
                    <asp:Button CssClass="asp_button" ID="btnMandarObservacoes" runat="server" Text="Mandar Observações" OnClick="btnMandarObservacoes_Click" /> <br /> 
                    <asp:Label ID="lbMsg" runat="server" Text=""></asp:Label>
                </div>
            <%
                if (String.IsNullOrEmpty(atrConsulta.Observacoes))
                    this.btnMandarObservacoes.Text = "Mandar Observações e Marcar Consulta como Ocorrida";
                else
                    this.btnMandarObservacoes.Text = "Mudar Observações";
            } %>
            </div>
        <% } else { %>
            <label id="lbSemObservacoes">Sem observações...</label>
        <% } %>
    <%
    }

    Session["podeDeixarObservacoes"] = podeDeixarObservacoes;
    %>
</div>
</form>
</body>
</html>
