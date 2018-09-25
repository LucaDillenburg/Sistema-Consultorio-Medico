using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace ProjetoPPI.PagPaciente
{
    public partial class VerConsulta : System.Web.UI.Page
    {
        protected int codConsulta; //o resto esta no Session["consulta"]
        protected bool podeDeixarSatisfacao;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["usuario"] == null || Session["conexao"] == null || Session["usuario"].GetType() != typeof(Paciente))
            {
                Response.Redirect("../Index.aspx");
                return;
            }

            if (Session["consulta"] == null)
            {
                Response.Redirect("Index.aspx");
                return;
            }

            AtributosConsultaCod atrConsulta = (AtributosConsultaCod)Session["consulta"];
            if (atrConsulta.EmailPaciente != ((Paciente)Session["usuario"]).Atributos.Email)
            {
                Session["consulta"] = null;
                Response.Redirect("Index.aspx");
                return;
            }

            // DIA/MES/ANO - PROPOSITO DA CONSULTA
            // (soh mostrar ano se for diferente do ano atual)
            this.lbTitulo.Text = atrConsulta.Horario.ToString("dd/MM" + (DateTime.Now.Year != atrConsulta.Horario.Year ? "/yyyy" : "") + " HH:mm") + 
                " - " + atrConsulta.Proposito;

            this.lbMedico.Text = "Médico: " + Medico.DeEmail(atrConsulta.EmailMedico, (ConexaoBD)Session["conexao"]).NomeCompleto;
            this.lbDuracao.Text = "Duração: " + (atrConsulta.UmaHora?"1 hora.":"30 minutos.");

            //n: ainda nao ocorrido, s: ocorrido, c: cancelado
            if (atrConsulta.Status == 'n')
            {
                this.lbStatus.Text = "Status: ainda não ocorreu";
                this.pnlOcorrido.Visible = false;
                this.podeDeixarSatisfacao = false;
            }
            else
            if (atrConsulta.Status == 'c')
            {
                this.lbStatus.Text = "Status: CANCELADA";
                this.lbTitulo.Font.Strikeout = true;
                this.pnlOcorrido.Visible = false;
                this.podeDeixarSatisfacao = false;
            }
            else
            {
                this.lbStatus.Text = "Status: já ocorreu";

                if (String.IsNullOrEmpty(atrConsulta.Observacoes))
                    this.pnlObservacoes.Visible = false;
                else
                {
                    this.txtObservacoes.Text = atrConsulta.Observacoes;
                    this.lbSemObservacoes.Visible = false;
                }

                if (atrConsulta.Satisfacao < 0)
                    this.podeDeixarSatisfacao = true;
                else
                {
                    this.txtComentario.Text = atrConsulta.Comentario;
                    this.txtComentario.ReadOnly = true;
                    this.txtSatisfacao.Text = atrConsulta.Satisfacao + "";
                    this.txtSatisfacao.ReadOnly = true;

                    this.btnRegistrarSatisfacao.Visible = false;
                    this.podeDeixarSatisfacao = false;
                }
            }

            this.codConsulta = atrConsulta.CodConsulta;
        }

        protected void btnRegistrarSatisfacao_Click(object sender, EventArgs e)
        {
            if (!this.podeDeixarSatisfacao)
            {
                this.btnRegistrarSatisfacao.Visible = false;
                return;
            }

            bool tudoCerto = true;

            if (!String.IsNullOrEmpty(this.txtComentario.Text))
                //comentario
                try
                {
                    new AtributosConsulta().Comentario = this.txtComentario.Text;
                }catch(Exception err)
                { this.lbMsgComentario.Text = "Comentário inválido!"; tudoCerto = false; }

            int satisfacao = -1;
            //satisfacao
            try
            {
                satisfacao = Convert.ToInt32(this.txtSatisfacao.Text);
                new AtributosConsulta().Satisfacao = satisfacao;
            }
            catch (Exception err)
            { this.lbMsgSatisfacao.Text = "Satisfação inválida!"; tudoCerto = false; }
            
            if (tudoCerto)
            {
                // ADICIONAR SATISFACAO (E TALVEZ COMENTARIO)
                if (String.IsNullOrEmpty(this.txtComentario.Text))
                    ((ConexaoBD)Session["conexao"]).ExecuteInUpDel("update consulta set " + 
                        " satisfacao = " + satisfacao + " where codConsulta=" + this.codConsulta);
                else
                    ((ConexaoBD)Session["conexao"]).ExecuteInUpDel("update consulta set comentario = '"
                        + this.txtComentario.Text + "', satisfacao = " + satisfacao +
                        " where codConsulta=" + this.codConsulta);

                this.txtComentario.ReadOnly = true;
                this.btnRegistrarSatisfacao.Visible = false;

                this.lbMsgComentario.Text = "";
                this.lbMsgSatisfacao.Text = "";
                this.lbMsg.Text = "Comentário e satisfação registradas...";

                //colocar no session da consulta 
                ((AtributosConsultaCod)Session["consulta"]).Comentario = this.txtComentario.Text;
                ((AtributosConsultaCod)Session["consulta"]).Satisfacao = satisfacao;
            }
        }
    }
}