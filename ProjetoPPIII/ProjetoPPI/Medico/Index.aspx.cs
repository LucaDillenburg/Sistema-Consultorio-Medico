using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace ProjetoPPI.PagMedico
{
    public partial class PaginaMedico : System.Web.UI.Page
    {
        protected ConexaoBD conexaoBD;
        protected AtributosConsulta consultaAtual;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["usuario"] == null || Session["conexao"] == null || Session["usuario"].GetType() != typeof(Medico))
            {
                Response.Redirect("../Index.aspx");
                return;
            }
                
            this.conexaoBD = (ConexaoBD)Session["conexao"];

            //ve se há consulta agora e coloca a satisfacao media
            tmrConsultaAtual_Tick(null, null);
        }
        
        protected AtributosConsulta ConsultaAtual()
        {
            DateTime agora = DateTime.Now;
            DateTime consultaMeiaHora = new DateTime(agora.Year, agora.Month, agora.Day,
                agora.Hour, (agora.Minute < 30)?0:30, 0);
            DateTime consultaUmaHora;
            if (agora.Minute < 30)
                consultaUmaHora = new DateTime(agora.Year, agora.Month, agora.Day,
                    agora.Hour-1, 30, 0);
            else
                consultaUmaHora = new DateTime(agora.Year, agora.Month, agora.Day,
                    agora.Hour, 0, 0);

            DataSet dadosConsulta = this.conexaoBD.ExecuteSelect("select codConsulta, proposito, horario, umaHora, observacoes, " +
                " status, emailMedico, emailPac, satisfacao, comentario from consulta " +
                " where emailMedico = " + ((Medico)Session["usuario"]).Atributos.Email + " and " +
                " ( horario = " + consultaMeiaHora.ToString(AtributosConsulta.FORMATO_HORARIO) + 
                " or (horario = " + consultaUmaHora.ToString(AtributosConsulta.FORMATO_HORARIO) + 
                " and umaHora = 1) )");
            if (dadosConsulta.Tables[0].Rows.Count <= 0)
                return null;

            object[] auxDados = dadosConsulta.Tables[0].Rows[0].ItemArray;
            AtributosConsultaCod consulta = new AtributosConsultaCod();
            //codConsulta, proposito, horario, umaHora, observacoes, status, emailMedico, emailPac, 
            //satisfacao, comentario
            consulta.CodConsulta = Convert.ToInt32(auxDados[0]);
            consulta.Proposito = auxDados[1].ToString();
            consulta.SetHorario(Convert.ToDateTime(auxDados[2]), (ConexaoBD)Session["conexao"]);
            consulta.UmaHora = Convert.ToInt32(auxDados[3])==1;
            consulta.Observacoes = auxDados[4].ToString();
            consulta.Status = Convert.ToChar(auxDados[5]);
            consulta.SetEmailMedico(auxDados[6].ToString(), (ConexaoBD)Session["conexao"]);
            consulta.SetEmailPaciente(auxDados[7].ToString(), (ConexaoBD)Session["conexao"]);
            consulta.Satisfacao = Convert.ToInt32(auxDados[8]);
            consulta.Comentario = auxDados[9].ToString();

            return consulta;
        }

        protected void tmrConsultaAtual_Tick(object sender, EventArgs e)
        {
            AtributosConsulta atributosConsulta = this.ConsultaAtual();
            this.consultaAtual = atributosConsulta;
            this.btnConsultaAtual.Visible = atributosConsulta == null;

            this.lbSatisfacaoMedia.Text = "Satisfação Média: " + Medico.SatisfacaoMedia(((Medico)Session["usuario"]).Atributos.Email, 
                (ConexaoBD)Session["conexao"]) + "/5";
        }

        protected void btnConsultaAtual_Click(object sender, EventArgs e)
        {
            if (this.consultaAtual == null)
                this.btnConsultaAtual.Visible = false;
            else
            {
                Session["consulta"] = this.consultaAtual;
                Response.Redirect("VerConsulta.aspx");
                return;
            }
        }
    }
}