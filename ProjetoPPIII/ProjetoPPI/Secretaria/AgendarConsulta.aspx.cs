using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace ProjetoPPI
{
    public partial class AgendarConsulta : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["usuario"] == null || Session["conexao"] == null || Session["usuario"].GetType() != typeof(Secretaria))
            {
                Response.Redirect("../Index.aspx");
                return;
            }

            /* string[,] emailNomeMedicos = Medico.GetTodosMedicos((ConexaoBD)Session["conexao"]);
            for (int i = 0; i < emailNomeMedicos.GetLength(0); i++)
                this.cbxMedicos.Items.Add(new ListItem(emailNomeMedicos[i, 1], emailNomeMedicos[i, 0]));

            string[,] emailNomePacientes = Paciente.GetTodosPacientes((ConexaoBD)Session["conexao"]);
            for (int i = 0; i < emailNomePacientes.GetLength(0); i++)
                this.cbxPacientes.Items.Add(new ListItem(emailNomePacientes[i, 1], emailNomePacientes[i, 0])); */
        }
        
        protected void btnAgendar_Click(object sender, EventArgs e)
        {
            AtributosConsulta atributos = new AtributosConsulta();
            bool podeIncluir = true;

            //proposito
            try
            {
                atributos.Proposito = this.txtProposito.Text;
            }catch(Exception err)
            { this.lbMsgProposito.Text = err.Message; podeIncluir = false; }

            //email medico
            try
            {
                if (this.ddlMedicos.SelectedIndex < 0)
                    throw new Exception("Selecione um médico!");
                atributos.SetEmailMedico(this.ddlMedicos.SelectedValue, (ConexaoBD)Session["conexao"]);
            }catch(Exception err)
            { this.lbMsgMedico.Text = err.Message; podeIncluir = false; }

            //email paciente
            try
            {
                if (this.ddlPacientes.SelectedIndex < 0)
                    throw new Exception("Selecione um paciente!");
                atributos.SetEmailPaciente(this.ddlPacientes.SelectedValue, (ConexaoBD)Session["conexao"]);
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
                        "dd/MM/yyyy HH:mm", System.Globalization.CultureInfo.InvariantCulture);
                }catch(Exception err)
                { throw new Exception("Formato de data inválido!"); }

                atributos.SetHorario(data, (ConexaoBD)Session["conexao"]);
            }
            catch (Exception err)
            { this.lbMsgHorario.Text = err.Message; podeIncluir = false; }

            //30 minutos ou 1 hora
            if (this.ddlTempoConsulta.SelectedIndex < 0)
                this.lbMsgTempoConsulta.Text = "Selecione um tempo para a consulta";
            else
                atributos.UmaHora = this.ddlTempoConsulta.SelectedValue == "60";

            if (podeIncluir)
            {
                try
                {
                    ((Secretaria)Session["usuario"]).CadastrarConsulta(atributos);
                }catch (Exception err)
                {
                    this.lbMsg.Attributes["style"] = "color: red";
                    this.lbMsg.Text = err.Message;
                    return;
                }

                this.ddlMedicos.SelectedIndex = -1;
                this.lbMsgMedico.Text = "";
                this.ddlPacientes.SelectedIndex = -1;
                this.lbMsgPaciente.Text = "";
                this.txtDia.Text = "";
                this.txtHorario.Text = "";
                this.lbMsgHorario.Text = "";
                this.ddlTempoConsulta.SelectedIndex = 0;
                this.lbMsgHorario.Text = "";
                
                this.lbMsg.Attributes["style"] = "color: green";
                this.lbMsg.Text = "Consulta adicionado ao banco!";
            }
        }
    }
}