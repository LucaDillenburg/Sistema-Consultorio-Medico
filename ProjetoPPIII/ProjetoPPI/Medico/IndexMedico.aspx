<%@ Page Title="" Language="C#" MasterPageFile="~/Menu.Master" AutoEventWireup="true" CodeBehind="IndexMedico.aspx.cs" Inherits="ProjetoPPI.PagMedico.IndexMedico" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <h1 class="title-originais">ÁREA DO MÉDICO</h1>
    <hr class="hr-originais" />

    <% 
        string emailMedico = ((ProjetoPPI.Medico)Session["usuario"]).Atributos.Email;    
        ProjetoPPI.AtributosConsultaCod[] consultas = ProjetoPPI.Consulta.ConsultasDe(emailMedico, true, false, (ProjetoPPI.ConexaoBD)Session["conexao"]);    
    %>
        
    <ul class="opcoes">
        <li id="btnConsultaAtual">Sua consulta agora</li>
        <li id="btnAgenda">Agenda</li>
        <li id="btnPerfil">Perfil</li>
    </ul>

    <div class="tab-paciente">        
         
             <%for (int i = 0; i<consultas.Length; i++)
              {%>
            <table class="consultas-paciente">
            <tr class="proposito">
                <td>PROPÓSITO: </td>                
                <td colspan="4"><%=consultas[i].Proposito%></td>
            </tr>
            <tr>
                <td style="font-weight: bold; color: black;">HORÁRIO: </td>
                <td><%=consultas[i].Horario.ToString("dd-MM-yyyy HH:mm")%></td> 
                <td style="font-weight: bold; color: black;">DURAÇÃO: </td>
                <td><%=(consultas[i].UmaHora)?"1 hora":"30 minutos"%></td>
            </tr>
            <tr>
                <td style="font-weight: bold; color: black;">PACIENTE: </td>
                <td colspan="4"><%=ProjetoPPI.Paciente.DeEmail(consultas[i].EmailPaciente, (ProjetoPPI.ConexaoBD)Session["conexaoBD"]).NomeCompleto%></td>
            </tr>
            <tr class="observacoes">
                <td style="font-weight: bold;">OBSERVAÇÕES</td>
                <td colspan="4">
                    <%
                    switch(consultas[i].Status)
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
                    }
                
                %>
                </td>
            </tr>
            </table>
            <br />
             <%} %>
        
        <div class="agenda">Agenda</div>
        <div class="perfil">Perfil</div>
    </div>
    <script src="scriptPaginas.js"></script>
</asp:Content>
