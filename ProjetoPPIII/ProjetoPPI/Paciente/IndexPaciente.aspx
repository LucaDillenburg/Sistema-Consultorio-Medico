<%@ Page Title="" Language="C#" MasterPageFile="~/Menu.Master" AutoEventWireup="true" CodeBehind="IndexPaciente.aspx.cs" Inherits="ProjetoPPI.PagPaciente.IndexPaciente" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="banner" id="indexPaciente">
        <h1>Paciente</h1>
    </div>

    <div class="gradient-1"></div>
    
    <%
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
                    <td colspan="3"><%=consultas[i].Proposito%></td>
                </tr>
                <tr>
                    <td style="font-weight: bold; color: black;">HORÁRIO: </td>
                    <td><%=consultas[i].Horario.ToString("dd-MM-yyyy HH:mm")%></td> 
                    <td style="font-weight: bold; color: black;">DURAÇÃO: </td>
                    <td><%=(consultas[i].UmaHora) ? "1 hora" : "30 minutos"%></td>
                </tr>
                <tr>
                    <td style="font-weight: bold; color: black;">MÉDICO: </td>
                    <td colspan="3"><%=ProjetoPPI.Medico.DeEmail(consultas[i].EmailMedico, (ProjetoPPI.ConexaoBD)Session["conexao"]).NomeCompleto%></td>
                </tr>
                <tr>
                    <td style="font-weight: bold; color: black;">STATUS:</td>
                    <td colspan="3">
                    <%
                        switch (consultas[i].Status)
                        {
                            case 'n':
                            %>Ainda não ocorreu</td><%
                                                       break;
                                                   case 'c':
                            %>Cancelada</td><%
                                               break;
                                           case 's':
                          %>
                            Ocorreu</td>
                        </tr>
                        <tr class="observacoes">
                            <td style="font-weight: bold;">OBSERVAÇÕES</td>
                            <td colspan="3">
                                <%=consultas[i].Observacoes%>
                          <%
                              if (consultas[i].Satisfacao >= 0)
                              {
                                %><br>Satisfação: <%=consultas[i].Satisfacao%> <br /><%
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
                    <asp:Button ID="btnFileUpload" runat="server" Text="Adicionar/Mudar foto" OnClick="btnFileUpload_Click" />
                    <asp:FileUpload CssClass="asp_button" ID="fileUpload" runat="server" />
                </div>
            </div>            
            <hr />
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
        </div>
    </div>
    <script src="/scriptPaginas.js"></script>
</asp:Content>

    

