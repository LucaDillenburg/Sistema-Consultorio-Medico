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
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["usuario"] == null || Session["conexao"] == null || Session["usuario"].GetType() != typeof(ProjetoPPI.Paciente))
            {
                Response.Redirect("../Index.aspx");
                return;
            }

            string url = HttpContext.Current.Request.Url.AbsoluteUri;
            // se passou codigo consulta pela url
            try
            {
                int index = url.LastIndexOf('?');
                if (index < 0)
                    throw new Exception("");
                string codStr = url.Substring(index + 1);
                int codConsulta = Convert.ToInt32(codStr);
                Session["consulta"] = ProjetoPPI.Consulta.DeCodigo(codConsulta, (ProjetoPPI.ConexaoBD)Session["conexao"]);
            }
            catch (Exception err)
            {
                Response.Redirect("Index.aspx");
                return;
            }
        }

        protected void btnRegistrarSatisfacao_Click(object sender, EventArgs e)
        {
            if (!(bool)Session["podeDeixarSatisfacao"])
            {
                this.btnRegistrarSatisfacao.Visible = false;
                return;
            }

            bool tudoCerto = true;

            string comentario = HttpUtility.HtmlEncode(this.txtComentario.Text);
            if (!String.IsNullOrEmpty(comentario))
                //comentario
                try
                {
                    new AtributosConsulta().Comentario = comentario;
                }catch(Exception err)
                { this.lbMsgComentario.Text = "Comentário inválido!"; tudoCerto = false; }

            int satisfacao = -1;
            //satisfacao
            try
            {
                satisfacao = Convert.ToInt32(this.ddlSatisfacao.SelectedValue);
                new AtributosConsulta().Satisfacao = satisfacao;
            }
            catch (Exception err)
            { this.lbMsgSatisfacao.Text = "Satisfação inválida!"; tudoCerto = false; }
            
            if (tudoCerto)
            {
                //colocar no session da consulta 
                if (!String.IsNullOrEmpty(comentario))
                    ((AtributosConsultaCod)Session["consulta"]).Comentario = comentario;
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