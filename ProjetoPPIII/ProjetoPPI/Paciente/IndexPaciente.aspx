<%@ Page Title="" Language="C#" MasterPageFile="~/NMenu.Master" AutoEventWireup="true" CodeBehind="IndexPaciente.aspx.cs" Inherits="ProjetoPPI.IndexPaciente" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">     
    <h1 class="title-originais">ÁREA DO PACIENTE</h1>
    <hr class="hr-originais" />
    <%
        string emailPaciente = ((ProjetoPPI.Paciente)Session["usuario"]).Atributos.Email;
        ProjetoPPI.AtributosConsultaCod[] consultas = ProjetoPPI.Consulta.UltimasConsultasDe(emailPaciente, false, (ProjetoPPI.ConexaoBD)Session["conexao"]);    
    %>
    <ul class="opcoes">
        <li id="btnPerfilPaciente">Perfil</li>
        <li id="btnConsultasPaciente">Suas Consultas</li>        
    </ul>
    <div class="tab-paciente">
        <table class="consultas-paciente">
            <%for (int i = 0; i<consultas.Length; i++)
              {%>
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
                <td style="font-weight: bold; color: black;">MÉDICO: </td>
                <td colspan="4"><%=ProjetoPPI.Medico.DeEmail(consultas[i].EmailMedico, (ProjetoPPI.ConexaoBD)Session["conexaoBD"]).NomeCompleto%></td>
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
            <tr>
                <td colspan="4"> - </td>
            </tr>
            <%} %>
        </table>
        <div class="perfil">
            perfil
        </div>
    </div>
    <script src="scriptPaginas.js"></script>
</asp:Content>

    

