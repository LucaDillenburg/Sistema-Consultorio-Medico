<%@ Page Title="" Language="C#" MasterPageFile="~/NMenu.Master" AutoEventWireup="true" CodeBehind="IndexPaciente.aspx.cs" Inherits="ProjetoPPI.IndexPaciente" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">     
    <h1 class="title-originais">ÁREA DO PACIENTE</h1>
    <hr class="hr-originais" />

    <ul class="opcoes">
        <li id="btnPerfilPaciente">Perfil</li>
        <li id="btnConsultasPaciente">Suas Consultas</li>        
    </ul>
    <div class="tab-paciente">
        <table class="consultas-paciente">
            <tr class="proposito">
                <td>PROPÓSITO: </td>                
                <td colspan="4">AAAAAAA</td>
            </tr>
            <tr>
                <td style="font-weight: bold; color: black;">HORÁRIO: </td>
                <td>BB:BB</td> 
                <td style="font-weight: bold; color: black;">DURAÇÃO: </td>
                <td>CChoras</td>
            </tr>
            <tr>
                <td style="font-weight: bold; color: black;">MÉDICO: </td>
                <td colspan="4">@Médico</td>
            </tr>
            <tr class="observacoes">
                <td style="font-weight: bold;">OBSERVAÇÕES</td>
                <td colspan="4">observamos que o que foi observado nos observou</td>
            </tr>
            <tr>
                <td colspan="4"> - </td>
            </tr>
        </table>
        <div class="perfil">
            perfil
        </div>
    </div>
    <script src="scriptPaginas.js"></script>
</asp:Content>

    

