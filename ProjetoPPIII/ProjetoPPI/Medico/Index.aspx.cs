﻿using System;
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

            //verifica elementos que precisam ser atualizados
            this.AtualizarPagina();
        }


        //timer: ficar atualizando a pagina
        //ve se há consulta agora, coloca a satisfacao media e verifica novas notificacoes
        protected void timer_Tick(object sender, EventArgs e)
        { /*o timer faz a pagina reloadar e no reload eh chamado o atualizar pagina*/ }

        protected void AtualizarPagina()
        {
            AtributosConsulta atributosConsulta = ((Medico)Session["usuario"]).ConsultaAtual();
            this.consultaAtual = atributosConsulta;
            this.btnConsultaAtual.Visible = atributosConsulta == null;

            this.lbSatisfacaoMedia.Text = "Satisfação Média: " + Medico.SatisfacaoMedia(((Medico)Session["usuario"]).Atributos.Email,
                (ConexaoBD)Session["conexao"]).ToString("0.0") + "/5";

            this.btnNotificacoes.Text = "Notificações (" + ((Medico)Session["usuario"]).QtdNovasSatisfacoes + ")";
        }


        //botoes
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

        protected void btnNotificacoes_Click(object sender, EventArgs e)
        {
            AtributosConsultaCod[] atributosConsulta = ((Medico)Session["usuario"]).UltimasSatisfacoes;
            
            //mostrar notificacoes

            //atualizar banco
            ((Medico)Session["usuario"]).ViuNovasSatisfacoes();
            this.btnNotificacoes.Text = "Notificações (0)";
        }
    }
}