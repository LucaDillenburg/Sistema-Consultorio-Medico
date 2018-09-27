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
            if (Session["usuario"] == null || Session["conexao"] == null || Session["usuario"].GetType() != typeof(Medico))
            {
                Response.Redirect("../Index.aspx");
                return;
            }

            if (Session["consulta"] == null)
            {
                Response.Redirect("Index.aspx");
                return;
            }

            //se a consulta nao eh desse medico
            AtributosConsultaCod atrConsulta = (AtributosConsultaCod)Session["consulta"];
            if (atrConsulta.EmailMedico != ((Medico)Session["usuario"]).Atributos.Email)
            {
                Session["consulta"] = null;
                Response.Redirect("Index.aspx");
                return;
            }

            // DIA/MES/ANO - PROPOSITO DA CONSULTA
            // (soh mostrar ano se for diferente do ano atual)
            this.lbTitulo.Text = atrConsulta.Horario.ToString("dd/MM" + (DateTime.Now.Year != atrConsulta.Horario.Year ? "/yyyy" : "") + " HH:mm") +
                " - " + atrConsulta.Proposito;

            this.lbPaciente.Text = "Paciente: " + Paciente.DeEmail(atrConsulta.EmailPaciente, (ConexaoBD)Session["conexao"]).NomeCompleto;
            this.lbDuracao.Text = "Duração: " + (atrConsulta.UmaHora ? "1 hora." : "30 minutos.");

            //n: ainda nao ocorrido, s: ocorrido, c: cancelado
            if (atrConsulta.Status == 'n')
            {
                this.lbStatus.Text = "Status: ainda não ocorreu";
                this.pnlOcorrido.Visible = false;
                this.podeDeixarObservacoes = false;
            }
            else
            if (atrConsulta.Status == 'c')
            {
                this.lbStatus.Text = "Status: CANCELADA";
                this.lbTitulo.Font.Strikeout = true;
                this.pnlOcorrido.Visible = false;
                this.podeDeixarObservacoes = false;
            }
            else
            {
                this.lbStatus.Text = "Status: já ocorreu";

                if (atrConsulta.Satisfacao < 0)
                    this.pnlObservacoes.Visible = false;
                else
                {
                    this.txtSatisfacao.Text = atrConsulta.Satisfacao + "";
                    this.lbSemSatisfacao.Visible = false;
                    if (String.IsNullOrEmpty(atrConsulta.Observacoes))
                        this.txtObservacoes.Visible = false;
                    else
                    {
                        this.txtObservacoes.Text = atrConsulta.Observacoes;
                        this.lbSemObservacoes.Visible = false;
                    }
                }
                
                //se ainda nao acabou o dia
                //o medico tem ateh o final do dia para fazer os comentarios das consultas do dia
                DateTime dataFinalDoDia = new DateTime(DateTime.Now.Year, DateTime.Now.Month, DateTime.Now.Day,
                    23, 59, 59);
                this.podeDeixarObservacoes = atrConsulta.Horario.CompareTo(dataFinalDoDia) < 0;

                this.txtObservacoes.Text = atrConsulta.Observacoes;
                if (this.podeDeixarObservacoes)
                {
                    this.lbSemObservacoes.Visible = false;
                    if (String.IsNullOrEmpty(atrConsulta.Observacoes))
                        this.btnMandarObservacoes.Text = "Mandar Observações";
                    else
                        this.btnMandarObservacoes.Text = "Mudar Observações";
                }else
                {
                    this.btnMandarObservacoes.Visible = false;
                    if (String.IsNullOrEmpty(atrConsulta.Observacoes))
                    {
                        this.lbSemObservacoes.Visible = true;
                        this.pnlObservacoes.Visible = false;
                    }else
                    {
                        this.lbSemObservacoes.Visible = false;
                        this.txtObservacoes.ReadOnly = true;
                    }
                }
            }

            this.codConsulta = atrConsulta.CodConsulta;
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

                // ADICIONAR OBSERVACAO
                ((Medico)Session["usuario"]).MudarObservacoes((AtributosConsultaCod)Session["consulta"]);

                this.lbMsgObservacoes.Text = "";
                this.lbMsg.Text = "Comentário e satisfação registradas...";

                this.btnMandarObservacoes.Text = "Mudar Observações";
            }
        }
    }
}