<%@ Page Title="" Language="C#" MasterPageFile="~/Menu.Master" AutoEventWireup="true" CodeBehind="IndexSecretaria.aspx.cs" Inherits="ProjetoPPI.PagSecretaria.IndexSecretaria" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="banner" id="indexSecretaria">
        <h1>Secretária</h1>
    </div>

    <div class="gradient-1"></div>    

    <ul class="opcoes">        
        <li  class="ativo" id="btnAgendaSecretaria">Agenda</li>
        <li id="btnCadastros">Cadastrar</li>             
        <a href="AdicionarEspecialidade.aspx"><li>Adicionar Especialidade</li></a>
        <li><asp:Button CssClass="asp_button" ID="btnAgendarConsulta" runat="server" Text="Agendar Consulta" OnClick="btnAgendarConsulta_Click" /></li>
        <a href="Servidor.aspx"><li>Servidor</li></a>
        <a href="Relatorios.aspx"><li>Relatórios</li></a>
    </ul>
    <ul id="subMenu-cadastros">
        <li><asp:Button CssClass="asp_button" ID="btnCadastrarMedico" runat="server" Text="Cadastrar Médico" OnClick="btnCadastrarMedico_Click" /></li>
        <li><asp:Button CssClass="asp_button" ID="btnCadastrarPaciente" runat="server" Text="Cadastrar Paciente" OnClick="btnCadastrarPaciente_Click" /></li>
        <li><asp:Button CssClass="asp_button" ID="btnCadastrarSecretaria" runat="server" Text="Cadastrar Secretaria" OnClick="btnCadastrarSecretaria_Click" /></li>
    </ul>
                        
    <div class="filtrar">
        <label>Filtrar por: </label>
        <ul class="filtros">
            <li>Paciente: <asp:TextBox CssClass="asp_textbox" ID="txtPesqPac" runat="server"></asp:TextBox></li>
            <li>Médico: <asp:TextBox CssClass="asp_textbox" ID="txtPesqMed" runat="server"></asp:TextBox></li>
            <li>Dia: <asp:TextBox CssClass="asp_textbox" ID="txtPesqDia" runat="server" TextMode="Date"></asp:TextBox> 
                <asp:DropDownList ID="ddlTipoDia" runat="server">
                    <asp:ListItem Value="-1">Antes</asp:ListItem>
                    <asp:ListItem Selected="True" Value="0">No dia</asp:ListItem>
                    <asp:ListItem Value="1">Depois</asp:ListItem>
                </asp:DropDownList>
            </li>
        </ul>
        <asp:Button CssClass="asp_button" ID="btnPesquisar" runat="server" Text="Pesquisar" OnClick="btnPesquisar_Click" />
    </div>

    <div class="tab-paciente">        
            <%
            string data = "";
            try
            {
                data = DateTime.ParseExact(this.txtPesqDia.Text, "yyyy-MM-dd", System.Globalization.CultureInfo.InvariantCulture).ToString("dd/MM/yyyy");
            }catch (Exception e) { }
            object[,] infoConsultas = ((ProjetoPPI.Secretaria)Session["usuario"]).PesquisarConsultas(HttpUtility.HtmlEncode(this.txtPesqMed.Text), HttpUtility.HtmlEncode(this.txtPesqPac.Text), data, Convert.ToInt32(this.ddlTipoDia.SelectedValue));

            for (int i = 0; i<infoConsultas.GetLength(0); i++)
            {%>
            <a href="VerConsulta.aspx?<%=((ProjetoPPI.AtributosConsultaCod)infoConsultas[i,0]).CodConsulta %>">
            <table class="consultas-paciente">
            <tr class="proposito">
                <td>PROPÓSITO: </td>                
                <td colspan="4"><%=((ProjetoPPI.AtributosConsultaCod)infoConsultas[i,0]).Proposito%></td>
            </tr>
            <tr>
                <td style="font-weight: bold; color: black;">HORÁRIO: </td>
                <td><%=((ProjetoPPI.AtributosConsultaCod)infoConsultas[i,0]).Horario.ToString("dd-MM-yyyy HH:mm")%></td> 
                <td style="font-weight: bold; color: black;">DURAÇÃO: </td>
                <td><%=(((ProjetoPPI.AtributosConsultaCod)infoConsultas[i,0]).UmaHora)?"1 hora":"30 minutos"%></td>
            </tr>
            <tr>
                <td style="font-weight: bold; color: black;">PACIENTE: </td>
                <td colspan="4"><%=((string)infoConsultas[i,1])%></td>
            </tr>
            <tr>
                <td style="font-weight: bold; color: black;">MÉDICO: </td>
                <td colspan="4"><%=((string)infoConsultas[i,2])%></td>
            </tr>
            <tr class="observacoes">
                <td style="font-weight: bold;">OBSERVAÇÕES</td>
                <td colspan="4">
                    <%
                    switch(((ProjetoPPI.AtributosConsultaCod)infoConsultas[i,0]).Status)
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
                            Observações: <%=((ProjetoPPI.AtributosConsultaCod)infoConsultas[i,0]).Observacoes%>
                          <%
                            if (((ProjetoPPI.AtributosConsultaCod)infoConsultas[i,0]).Satisfacao >= 0)
                            {
                                %>Satisfação: <%=((ProjetoPPI.AtributosConsultaCod)infoConsultas[i,0]).Satisfacao%><%
                                if (!String.IsNullOrEmpty(((ProjetoPPI.AtributosConsultaCod)infoConsultas[i,0]).Comentario))
                                    %>Comentário: <%=((ProjetoPPI.AtributosConsultaCod)infoConsultas[i,0]).Comentario%><%
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
