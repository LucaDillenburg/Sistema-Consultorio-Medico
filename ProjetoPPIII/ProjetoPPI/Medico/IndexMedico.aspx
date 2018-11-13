<%@ Page Title="" Language="C#" MasterPageFile="~/Menu.Master" AutoEventWireup="true" CodeBehind="IndexMedico.aspx.cs" Inherits="ProjetoPPI.PagMedico.IndexMedico" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="banner" id="indexMedico">
        <h1>Médico</h1>
    </div>

    <div class="gradient-1"></div>
        

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
                    <div id="imagem">
                        <% if (!String.IsNullOrEmpty(atributos.CaminhoFoto)) { %>
                            <script>
                            $(document).ready(function () {
                                $("#imagem").css("background-image", "url('<%=atributos.CaminhoFoto%>')");
                            });
                        </script>
                        <%
                        } else { %>
                            Sem Foto
                        <% } %>
                    </div>
                    <div class="btnsUpload">                        
                        <asp:Button CssClass="asp_button" ID="btnFileUpload" runat="server" Text="Adicionar/Mudar foto" OnClick="btnFileUpload_Click" />
                        <asp:FileUpload CssClass="asp_button" ID="fileUpload" runat="server" />
                    </div>
                </div>
                <% 
                    double satisfMedia = ((ProjetoPPI.Medico)Session["usuario"]).SatisfacaoMedia();
                    if (satisfMedia < 0)
                    { 
                        %> <h4>Você não tem satisfações...</h4><%
                    }else {
                        %><h4>Satisfação Média: <%=satisfMedia%></h4><% }
                %>
                <hr />
                <h2>Email: <%=atributos.Email %></h2>
                <hr />
                <h2>Endereço: <%=atributos.Endereco %></h2>
                <hr />
                <h2>Celular: <%=atributos.Celular %></h2>
                <hr />
                <h2>Telefone: <%=atributos.TelefoneResidencial %></h2>
                <hr />
                <h2>Data de Nascimento: <%=atributos.DataNascimento.ToString("dd/MM/yyyy") %></h2>
                <hr />
                <h2>CRM: <%=atributos.CRM %></h2>
                <hr />
                <h2>Especialidades: 
                    <% 
                        string strEsp = "";
                        string[] especialidades = ((ProjetoPPI.Medico)Session["usuario"]).Especialidades();
                        for (int i = 0; i < especialidades.Length; i++)
                            strEsp += especialidades[i] + ((i==especialidades.Length-1)?".":", ");
                    %>
                    <%=strEsp%>
                </h2>
            </div>

             <%for (int i = 0; i<consultas.Length; i++)
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
