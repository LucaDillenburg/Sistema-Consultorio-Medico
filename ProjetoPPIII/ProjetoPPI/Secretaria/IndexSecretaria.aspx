<%@ Page Title="" Language="C#" MasterPageFile="~/Menu.Master" AutoEventWireup="true" CodeBehind="IndexSecretaria.aspx.cs" Inherits="ProjetoPPI.PagSecretaria.IndexSecretaria" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
     <%         
         ProjetoPPI.AtributosConsultaCod[] consultas = ProjetoPPI.Consulta.TodasAsConsultas((ProjetoPPI.ConexaoBD)Session["conexao"]);

    %>
    <h1 class="title-originais">ÁREA DA SECRETARIA</h1>
    <hr class="hr-originais" />

    <ul class="opcoes">        
        <li  class="ativo" id="btnAgendaSecretaria">Agenda</li>
        <li id="btnCadastros">Cadastrar</li>                
        <li><asp:Button CssClass="asp_button" ID="btnAgendarConsulta" runat="server" Text="Agendar Consulta" OnClick="btnAgendarConsulta_Click" /></li>
        <a href="Servidor.aspx"><li>Servidor</li></a>
    </ul>
    <ul id="subMenu-cadastros">
        <li><asp:Button CssClass="asp_button" ID="btnCadastrarMedico" runat="server" Text="Cadastrar Médico" OnClick="btnCadastrarMedico_Click" /></li>
        <li><asp:Button CssClass="asp_button" ID="btnCadastrarPaciente" runat="server" Text="Cadastrar Paciente" OnClick="btnCadastrarPaciente_Click" /></li>
        <li><asp:Button CssClass="asp_button" ID="btnCadastrarSecretaria" runat="server" Text="Cadastrar Secretaria" OnClick="btnCadastrarSecretaria_Click" /></li>
    </ul>
            
            

    <div class="tab-paciente">        
        <%            
            for (int i = 0; i<consultas.Length; i++)
            {%>
            <a href="VerConsulta.aspx?<%=consultas[i].CodConsulta %>">
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
                <td style="font-weight: bold; color: black;">MÉDICO: </td>
                <td colspan="4"><%= ProjetoPPI.Medico.DeEmail(consultas[i].EmailMedico, (ProjetoPPI.ConexaoBD)Session["conexao"]).NomeCompleto %></td>
            </tr>
            <tr>
                <td style="font-weight: bold; color: black;">PACIENTE: </td>
                <td colspan="4"><%=ProjetoPPI.Paciente.DeEmail(consultas[i].EmailPaciente, (ProjetoPPI.ConexaoBD)Session["conexao"]).NomeCompleto%></td>
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
                            Ocorreu
                            Observações: <%=consultas[i].Observacoes%>
                          <%
                            if (consultas[i].Satisfacao >= 0)
                            {
                                %>Satisfação: <%=consultas[i].Satisfacao%><%
                                if (!String.IsNullOrEmpty(consultas[i].Comentario))
                                    %>Comentário: <%=consultas[i].Comentario%><%
                            }
                            break;
                    }
                
                %>
                </td>
            </tr>
            </table> 
            </a>
             <%} %>
    </div>
    <script src="/scriptPaginas.js"></script>
</asp:Content>
