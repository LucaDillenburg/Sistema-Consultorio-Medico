<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="UltimasConsultas.aspx.cs" Inherits="ProjetoPPI.PagPaciente.UltimasConsultas" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title></title>
</head>
<body>
<form id="form1" runat="server">
    <%
        if (Session["usuario"] == null || Session["conexao"] == null || Session["usuario"].GetType() != typeof(ProjetoPPI.Paciente))
        {
            Response.Redirect("../Index.aspx");
            return;
        }
    %>

    <h1><center>Últimas Consultas</center></h1>

    <%
        //se a consulta nao eh desse medico
        string emailPaciente = ((ProjetoPPI.Paciente)Session["usuario"]).Atributos.Email;
        ProjetoPPI.AtributosConsultaCod[] consultas = ProjetoPPI.Consulta.UltimasConsultasDe(emailPaciente, false, (ProjetoPPI.ConexaoBD)Session["conexao"]);

        %> <hr /> <%
        for (int i = 0; i<consultas.Length; i++)
        {
            %>
               <hr />
                Propósito: <%=consultas[i].Proposito%><br />
                Horário: <%=consultas[i].Horario.ToString("dd-MM-yyyy HH:mm")%> durante <%=(consultas[i].UmaHora)?"1 hora":"30 minutos"%> <br />
                Médico: <%=ProjetoPPI.Medico.DeEmail(consultas[i].EmailMedico, (ProjetoPPI.ConexaoBD)Session["conexaoBD"]).NomeCompleto%> <br />
                Status: 
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
                
                %><a href="VerConsulta.aspx?<%=consultas[i].CodConsulta%>">Ver mais..."></a><%
        }
    %>    
</form>
</body>
</html>
