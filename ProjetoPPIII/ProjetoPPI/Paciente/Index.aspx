<%@ Page Title="" Language="C#" MasterPageFile="~/Menu.Master" AutoEventWireup="true" CodeBehind="Index.aspx.cs" Inherits="ProjetoPPI.PagPaciente.Index" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">     
    <h1 class="title-originais">ÁREA DO PACIENTE</h1>
    <hr class="hr-originais" />
    <%
        if (Session["usuario"] == null || Session["conexao"] == null || Session["usuario"].GetType() != typeof(ProjetoPPI.Paciente))
        {
            Response.Redirect("../Index.aspx");
            return;
        }

        string emailPaciente = ((ProjetoPPI.Paciente)Session["usuario"]).Atributos.Email;
        ProjetoPPI.AtributosConsultaCod[] consultas = ProjetoPPI.Consulta.ConsultasDe(emailPaciente, false, false, (ProjetoPPI.ConexaoBD)Session["conexao"]);

        ProjetoPPI.Paciente paciente = (ProjetoPPI.Paciente)Session["usuario"];
        ProjetoPPI.AtributosPaciente atributos = paciente.Atributos;
    %>
    <ul class="opcoes">
        <li id="btnPerfilPaciente">Perfil</li>
        <li id="btnConsultasPaciente">Suas Consultas</li>        
    </ul>
    <div class="tab-paciente">
        <%
        if (consultas != null)
            for (int i = 0; i < consultas.Length; i++)
            {%>
        <a href="VerConsulta.aspx?<%=consultas[i].CodConsulta%>">
            <table class="consultas-paciente">                                
                <tr class="proposito">
                    <td>PROPÓSITO: </td>                
                    <td colspan="4"><%=consultas[i].Proposito%></td>
                </tr>
                <tr>
                    <td style="font-weight: bold; color: black;">HORÁRIO: </td>
                    <td><%=consultas[i].Horario.ToString("dd-MM-yyyy HH:mm")%></td> 
                    <td style="font-weight: bold; color: black;">DURAÇÃO: </td>
                    <td><%=(consultas[i].UmaHora) ? "1 hora" : "30 minutos"%></td>
                </tr>
                <tr>
                    <td style="font-weight: bold; color: black;">MÉDICO: </td>
                    <td colspan="4"><%=ProjetoPPI.Medico.DeEmail(consultas[i].EmailMedico, (ProjetoPPI.ConexaoBD)Session["conexao"]).NomeCompleto%></td>
                </tr>
                <tr class="observacoes">
                    <td style="font-weight: bold;">OBSERVAÇÕES</td>
                    <td colspan="4">
                    <%
                        switch (consultas[i].Status)
                        {
                            case 'n':
                            %>Ainda não ocorreu<%
                                                       break;
                                                   case 'c':
                            %>Cancelada<%
                                               break;
                                           case 's':
                          %>
                            Ocorreu <br />
                            Observações: <%=consultas[i].Observacoes%> <br />
                          <%
                              if (consultas[i].Satisfacao >= 0)
                              {
                                %>Satisfação: <%=consultas[i].Satisfacao%> <br /><%
                                                                                     if (!String.IsNullOrEmpty(consultas[i].Comentario))
                                    %>Comentário: <%=consultas[i].Comentario%> <br /> <%
                              }
                              break;
                        }%>
                    </td>
                 </tr>                
            </table>
            </a>
          <%} else
            { %>
            <table class="consultas-paciente"><tr><td colspan="5">Você ainda não possui nenhuma consulta</td></tr></table>
            <%} %>
        <div class="perfil">
            <div id="cabecalho">
                <h1><%=atributos.NomeCompleto %></h1>
                <div id="imagem"></div>
            </div>            
            <hr />
            <h2>Email: <%=atributos.Email %></h2>
            <hr />
            <h2>Endereço: <%=atributos.Endereco %></h2>
            <hr />
            <h2>Telefone: <%=atributos.TelefoneResidencial %></h2>
        </div>
    </div>
    <script src="/scriptPaginas.js"></script>
</asp:Content>

    

