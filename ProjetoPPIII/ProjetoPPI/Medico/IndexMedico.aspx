<%@ Page Title="" Language="C#" MasterPageFile="~/Menu.Master" AutoEventWireup="true" CodeBehind="IndexMedico.aspx.cs" Inherits="ProjetoPPI.PagMedico.IndexMedico" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <h1 class="title-originais">ÁREA DO MÉDICO</h1>
    <hr class="hr-originais" />

    <% 
        string emailMedico = ((ProjetoPPI.Medico)Session["usuario"]).Atributos.Email;
        ProjetoPPI.AtributosConsultaCod[] consultas = ProjetoPPI.Consulta.ConsultasDe(emailMedico, true, false, (ProjetoPPI.ConexaoBD)Session["conexao"]);

        ProjetoPPI.Medico medico = (ProjetoPPI.Medico)Session["usuario"];
        ProjetoPPI.AtributosMedico atributos = medico.Atributos;
    %>
        
    <ul class="opcoes">
        <li class="ativo"  id="btnPerfil">Perfil</li>
        <li id="btnAgenda">Agenda</li>
        <li id="btnConsultaAtual">Sua consulta agora</li>        
    </ul>                        
        <div class="tab-paciente">                            
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
                <h2>Celular: <%=atributos.Celular %></h2>
                <hr />
                <h2>Telefone: <%=atributos.TelefoneResidencial %></h2>
                <hr />
                <h2>CRM: <%=atributos.CRM %></h2>
                <hr />
                <h2>Data de Nascimento: <%=atributos.DataNascimento %></h2>            
            </div>

             <%for (int i = 0; i<consultas.Length; i++)
              {%>
            <a href="/Paciente/VerConsulta.aspx?<%=consultas[i].CodConsulta %>">
            <table class="consultas-paciente">
            <tr class="proposito">
                <td>PROPÓSITO: </td>                
                <td colspan="4"><%=consultas[i].Proposito%></td>
            </tr>
            <tr>
                <td style="font-weight: bold; color: black;">HORÁRIO: </td>
                <td><%=consultas[i].Horario.ToString("dd-MM-yyyy HH:mm")%></td> 
                <td style="font-weight: bold; color: black;">DURAÇÃO: </td>
                <td colspan="2"><%=(consultas[i].UmaHora)?"1 hora":"30 minutos"%></td>
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
            </a>
             <%} %>        
            <div class="consulta-atual">Consulta Atual</div>
        </div>        
    <script src="/scriptPaginas.js"></script>
</asp:Content>
