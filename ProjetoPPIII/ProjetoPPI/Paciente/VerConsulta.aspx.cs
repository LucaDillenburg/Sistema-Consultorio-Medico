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
            //OnLoad estah direto no .aspx
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
                //colocar no session da consulta 
                ((AtributosConsultaCod)Session["consulta"]).Comentario = this.txtComentario.Text;
                ((AtributosConsultaCod)Session["consulta"]).Satisfacao = satisfacao;
                ((AtributosConsultaCod)Session["consulta"]).HorarioSatisfacao = DateTime.Now;
                ((AtributosConsultaCod)Session["consulta"]).MedicoJahViuSatisfacao = false;

                ((Paciente)Session["usuario"]).RegistrarSatisfacao((AtributosConsultaCod)Session["consulta"]);

                this.txtComentario.ReadOnly = true;
                this.btnRegistrarSatisfacao.Visible = false;

                this.lbMsgComentario.Text = "";
                this.lbMsgSatisfacao.Text = "";
                this.lbMsg.Text = "Comentário e satisfação registradas...";
            }
        }
    }
}