﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace ProjetoPPI.PagMedico
{
    public partial class VerConsulta : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["usuario"] == null || Session["conexao"] == null || Session["usuario"].GetType() != typeof(Medico))
            {
                Response.Redirect("../Index.aspx");
                return;
            }
            if (Session["consulta"] == null)
            {
                string url = HttpContext.Current.Request.Url.AbsolutePath;
                // se passou codigo consulta pela url
                try
                {
                    string codStr = url.Substring(url.LastIndexOf('?') + 1);
                    Int32.TryParse(codStr, out int codConsulta);
                    Session["consulta"] = Consulta.DeCodigo(codConsulta, (ConexaoBD)Session["conexao"]);
                }
                catch (Exception err)
                {
                    Response.Redirect("Index.aspx");
                    return;
                }
            }
        }

        protected void btnMandarObservacoes_Click(object sender, EventArgs e)
        {
            if (!(bool)Session["podeDeixarObservacoes"])
            {
                this.btnMandarObservacoes.Visible = false;
                return;
            }

            bool tudoCerto = true;

            //observacoes
            try
            {
                new AtributosConsulta().Observacoes = this.txtObservacoes.Text;
            }
            catch (Exception err)
            { this.lbMsgObservacoes.Text = "Observações inválido!"; tudoCerto = false; }

            if (tudoCerto)
            {
                //colocar no session da consulta 
                ((AtributosConsultaCod)Session["consulta"]).Observacoes = this.txtObservacoes.Text;
                //marcar consulta como ocorrida
                ((AtributosConsultaCod)Session["consulta"]).Status = 's';

                // ADICIONAR OBSERVACAO
                ((Medico)Session["usuario"]).MudarObservacoes((AtributosConsultaCod)Session["consulta"]);

                this.lbMsgObservacoes.Text = "";
                this.lbMsg.Text = "Comentário e satisfação registradas... Consulta marcada como ocorrida.";

                this.btnMandarObservacoes.Text = "Mudar Observações";
            }
        }
    }
}