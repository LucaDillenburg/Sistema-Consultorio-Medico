using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace ProjetoPPI.PagSecretaria
{
    public partial class AgendarConsultas : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["usuario"] == null || Session["conexao"] == null || Session["usuario"].GetType() != typeof(ProjetoPPI.Secretaria))
            {
                Response.Redirect("../Index.aspx");
                return;
            }
        }

        protected void btnAgendar_Click(object sender, EventArgs e)
        {
            AtributosConsulta atributos = new AtributosConsulta();
            bool podeIncluir = true;

            //proposito
            try
            {
                atributos.Proposito = HttpUtility.HtmlEncode(this.txtProposito.Text);
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
            {
                this.lbMsgTempoConsulta.Text = "Selecione um tempo para a consulta";
                podeIncluir = false;
            }
            else
            {
                this.lbMsgTempoConsulta.Text = "";
                atributos.UmaHora = this.ddlTempoConsulta.SelectedValue == "60";
            }

            if (podeIncluir)
            {
                try
                {
                    ((Secretaria)Session["usuario"]).CadastrarConsulta(atributos);
                }
                catch (Exception err)
                {
                    this.lbMsg.Attributes["style"] = "color: red";
                    this.lbMsg.Text = err.Message;
                    return;
                }

                this.txtProposito.Text = "";
                this.lbMsgProposito.Text = "";
                this.ddlMedicos.SelectedIndex = -1;
                this.lbMsgMedico.Text = "";
                this.ddlPacientes.SelectedIndex = -1;
                this.lbMsgPaciente.Text = "";
                this.txtDia.Text = "";
                this.txtHorario.Text = "";
                this.lbMsgHorario.Text = "";
                this.ddlTempoConsulta.SelectedIndex = 0;
                this.lbMsgTempoConsulta.Text = "";

                this.lbMsg.Attributes["style"] = "color: green";
                this.lbMsg.Text = "Consulta adicionada ao banco!";
            }
        }
    }
}