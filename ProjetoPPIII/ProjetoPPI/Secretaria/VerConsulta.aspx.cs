﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace ProjetoPPI.PagSecretaria
{
    public partial class VerConsulta : System.Web.UI.Page
    {
        protected int codConsulta; //o resto esta no Session["consulta"]

        protected void Page_Load(object sender, EventArgs e)
        {
            //tudo no .aspx
        }

        protected void btnAtualizarDados_Click(object sender, EventArgs e)
        {
            AtributosConsultaCod atributos = new AtributosConsultaCod();
            bool podeIncluir = true;

            atributos.CodConsulta = this.codConsulta;

            //proposito
            try
            {
                atributos.Proposito = this.txtProposito.Text;
                this.lbMsgProposito.Text = "";
            }
            catch (Exception err)
            { this.lbMsgProposito.Text = err.Message; podeIncluir = false; }

            //email medico
            try
            {
                if (this.ddlMedicos.SelectedIndex < 0)
                    throw new Exception("Selecione um médico!");
                atributos.SetEmailMedico(this.ddlMedicos.SelectedValue, (ConexaoBD)Session["conexao"]);
                this.lbMsgMedico.Text = "";
            }
            catch (Exception err)
            { this.lbMsgMedico.Text = err.Message; podeIncluir = false; }

            //email paciente
            try
            {
                if (this.ddlPacientes.SelectedIndex < 0)
                    throw new Exception("Selecione um paciente!");
                atributos.SetEmailPaciente(this.ddlPacientes.SelectedValue, (ConexaoBD)Session["conexao"]);
                this.lbMsgPaciente.Text = "";
            }
            catch (Exception err)
            { this.lbMsgPaciente.Text = err.Message; podeIncluir = false; }

            //horario
            try
            {
                DateTime data;
                try
                {
                    data = DateTime.ParseExact(this.txtDia.Text + " " + this.txtHorario.Text,
                        "yyyy-MM-dd HH:mm", System.Globalization.CultureInfo.InvariantCulture);
                }
                catch (Exception err)
                { throw new Exception("Formato de data inválido!"); }

                atributos.SetHorario(data, (ConexaoBD)Session["conexao"]);
                this.lbMsgHorario.Text = "";
            }
            catch (Exception err)
            { this.lbMsgHorario.Text = err.Message; podeIncluir = false; }

            //30 minutos ou 1 hora
            if (this.ddlTempoConsulta.SelectedIndex < 0)
                this.lbMsgDuracao.Text = "Selecione um tempo para a consulta";
            else
            {
                this.lbMsgDuracao.Text = "";
                atributos.UmaHora = this.ddlTempoConsulta.SelectedValue == "60";
            }

            //status
            if (this.ddlTempoConsulta.SelectedIndex < 0)
                this.lbMsgStatus.Text = "Selecione um status!";
            else
            {
                this.lbMsgStatus.Text = "";
                atributos.Status = this.ddlStatus.SelectedValue[0];
            }

            if (String.IsNullOrWhiteSpace(this.txtObservacoes.Text))
                this.txtObservacoes.Text = "";
            //observacoes
            if (!String.IsNullOrEmpty(this.txtObservacoes.Text))
                try
                {
                    atributos.Observacoes = this.txtObservacoes.Text;
                }
                catch (Exception err)
                { this.lbMsgObservacoes.Text = err.Message; podeIncluir = false; }

            if (podeIncluir)
            {
                try
                {
                    ((Secretaria)Session["usuario"]).AtualizarDadosConsulta(atributos);
                }
                catch (Exception err)
                {
                    this.lbMsg.Attributes["style"] = "color: red";
                    this.lbMsg.Text = err.Message;
                    return;
                }
                
                this.lbMsgProposito.Text = "";
                this.lbMsgMedico.Text = "";
                this.lbMsgPaciente.Text = "";
                this.lbMsgHorario.Text = "";
                this.lbMsgDuracao.Text = "";
                this.lbMsgStatus.Text = "";
                this.lbMsgObservacoes.Text = "";

                this.lbMsg.Attributes["style"] = "color: green";
                this.lbMsg.Text = "Dados da consulta alterada!";
            }
        }
    }
}