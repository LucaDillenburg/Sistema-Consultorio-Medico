<%@ Page Title="" Language="C#" MasterPageFile="~/Menu.Master" AutoEventWireup="true" CodeBehind="IndexSecretaria.aspx.cs" Inherits="ProjetoPPI.PagSecretaria.IndexSecretaria" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <h1 class="title-originais">ÁREA DA SECRETARIA</h1>
    <hr class="hr-originais" />

    <ul class="opcoes">        
        <li class="ativo">Cadastrar</li>
        <li><asp:Button CssClass="asp_button" ID="btnAgenda" runat="server" Text="Agenda" OnClick="btnAgenda_Click" /></li>        
        <li><asp:Button CssClass="asp_button" ID="btnAgendarConsulta" runat="server" Text="Agendar Consulta" OnClick="btnAgendarConsulta_Click" /></li>
    </ul>

    <div class="tab-paciente">
        <div class="cadastros">
            <ul>
                <li><asp:Button CssClass="asp_button" ID="btnCadastrarMedico" runat="server" Text="Cadastrar Médico" OnClick="btnCadastrarMedico_Click" /></li>
                <li><asp:Button CssClass="asp_button" ID="btnCadastrarPaciente" runat="server" Text="Cadastrar Paciente" OnClick="btnCadastrarPaciente_Click" /></li>
                <li><asp:Button CssClass="asp_button" ID="btnCadastrarSecretaria" runat="server" Text="Cadastrar Secretaria" OnClick="btnCadastrarSecretaria_Click" /></li>
            </ul>                                    
        </div>                        
    </div>
</asp:Content>
