using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace ProjetoPPI.PagMedico
{
    public partial class VerConsulta : System.Web.UI.Page
    {
        protected int codConsulta; //o resto esta no Session["consulta"]
        protected bool podeDeixarObservacoes;

        protected void Page_Load(object sender, EventArgs e)
        {
            // resto do OnLoad (o que nao da pra fazer no .aspx)
            AtributosConsultaCod atrConsulta = (AtributosConsultaCod)Session["consulta"];
            if (!this.podeDeixarObservacoes || !String.IsNullOrEmpty(atrConsulta.Observacoes))
            {
                this.txtObservacoes.Text = atrConsulta.Observacoes;
                if (this.podeDeixarObservacoes)
                {
                    if (String.IsNullOrEmpty(atrConsulta.Observacoes))
                        this.btnMandarObservacoes.Text = "Mandar Observações e Marcar Consulta como Ocorrida";
                    else
                        this.btnMandarObservacoes.Text = "Mudar Observações";
                }
                else
                    this.txtObservacoes.ReadOnly = true;
            }
        }

        protected void btnMandarObservacoes_Click(object sender, EventArgs e)
        {
            if (!this.podeDeixarObservacoes)
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