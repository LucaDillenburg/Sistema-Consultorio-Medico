<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Relatorios.aspx.cs" Inherits="ProjetoPPI.Relatorios" %>

<%@ Register assembly="System.Web.DataVisualization, Version=4.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35" namespace="System.Web.UI.DataVisualization.Charting" tagprefix="asp" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title></title>
    <link rel="stylesheet" href="/estilo.css" />    
    <link href="https://fonts.googleapis.com/css?family=Baloo+Tammudu" rel="stylesheet"/>
    <link href="https://fonts.googleapis.com/css?family=Comfortaa" rel="stylesheet"/>
    <link href="https://fonts.googleapis.com/css?family=Pacifico" rel="stylesheet"/>
    <script src="/Scripts/jquery-1.10.2.min.js"></script>
    <link href="/Content/bootstrap.css" rel="stylesheet" />   
</head>
<body id="bodyRelatorios">
    <a href="IndexSecretaria.aspx" class="btnVoltar"><i class="glyphicon glyphicon-chevron-left"></i></a>
    <form id="form1" runat="server">
        <div class="consulta">
            <h1 class="title-originais">Relatórios de Gestão de Qualidade</h1>
            
            <div class="secao">
                <h2>Gráfico Mensal de Consultas por Médico</h2>
                <asp:SqlDataSource ID="BDPR317188" runat="server" ConnectionString="<%$ ConnectionStrings:conexaoBD %>" SelectCommand="select m.nomeCompleto, count(c.codConsulta) from Consulta c, Medico m where MONTH(c.horario) = MONTH(GETDATE()) and c.emailMedico = m.email and c.status = 'c' group by m.nomeCompleto"></asp:SqlDataSource>
                <asp:Chart ID="Chart1" runat="server" DataSourceID="SqlDataSource1">
                    <Series>
                        <asp:Series Name="Series1" XValueMember="NomeCompleto" YValueMembers="Column1">
                        </asp:Series>
                    </Series>
                    <ChartAreas>
                        <asp:ChartArea Name="ChartArea1">
                        </asp:ChartArea>
                    </ChartAreas>
                </asp:Chart>
            </div>

            <div class="secao">
                <h2>Gráfico de Atendimento Diário por Especialidade</h2>
                <asp:SqlDataSource ID="SqlDataSource1" runat="server" ConnectionString="<%$ ConnectionStrings:conexaoBD %>" SelectCommand="select m.NomeCompleto, count(c.codConsulta) from Consulta c, Medico m where c.emailMedico = m.email and MONTH(c.horario) = MONTH(GETDATE()) group by m.NomeCompleto"></asp:SqlDataSource>
                <asp:Chart ID="Chart2" runat="server" DataSourceID="SQLGraficoPizza">
                    <Series>
                        <asp:Series ChartType="Pie" Name="Series1" XValueMember="NomeEspecialidade" YValueMembers="Column1">
                        </asp:Series>
                    </Series>
                    <ChartAreas>
                        <asp:ChartArea Name="ChartArea1">
                        </asp:ChartArea>
                    </ChartAreas>
                </asp:Chart>
            </div>

            <div class="secao">
                <h2>Gráfico de Pacientes por Médico</h2>
                <asp:SqlDataSource ID="SQLGraficoPizza" runat="server" ConnectionString="<%$ ConnectionStrings:conexaoBD %>" SelectCommand="Select e.NomeEspecialidade, count(c.codConsulta) FROM Medico m, Consulta c, Especialidade e, EspecialidadeMedico em  WHERE c.emailMedico = m.email and em.emailMedico = m.email and em.codEspecialidade = e.codEspecialidade and  MONTH(c.horario) = MONTH(GETDATE()) group by e.NomeEspecialidade"></asp:SqlDataSource>
                <asp:Chart ID="Chart3" runat="server" DataSourceID="SQLPacientesPorMedico">
                    <Series>
                        <asp:Series ChartType="Bar" Name="Series1" XValueMember="NomeCompleto" YValueMembers="Column1">
                        </asp:Series>
                    </Series>
                    <ChartAreas>
                        <asp:ChartArea Name="ChartArea1">
                        </asp:ChartArea>
                    </ChartAreas>
                </asp:Chart>
            </div>

            <div class="secao">
                <h2>Gráfico de Consultas Cancelas por Médico Mensalmente</h2>
                <asp:SqlDataSource ID="SQLPacientesPorMedico" runat="server" ConnectionString="<%$ ConnectionStrings:conexaoBD %>" SelectCommand="SELECT m.NomeCompleto, count(distinct c.emailPac) from Consulta c, Paciente p, Medico m where c.emailMedico = m.email and c.emailPac = p.email group by m.NomeCompleto"></asp:SqlDataSource>
                <asp:Chart ID="Chart4" runat="server" DataSourceID="BDPR317188">
                    <Series>
                        <asp:Series Name="Series1" XValueMember="nomeCompleto" YValueMembers="Column1">
                        </asp:Series>
                    </Series>
                    <ChartAreas>
                        <asp:ChartArea Name="ChartArea1">
                        </asp:ChartArea>
                    </ChartAreas>
                </asp:Chart>
            </div>
        </div>
    </form>
</body>
</html>
