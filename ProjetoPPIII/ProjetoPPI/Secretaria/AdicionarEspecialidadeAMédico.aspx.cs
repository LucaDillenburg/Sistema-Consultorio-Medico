using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace ProjetoPPI.PagSecretaria
{
    public partial class AdicionarEspecialidadeAMédico : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["usuario"] == null || Session["conexao"] == null || Session["usuario"].GetType() != typeof(ProjetoPPI.Secretaria))
            {
                Response.Redirect("/Index.aspx");
                return;
            }
        }

        protected void btnEspMed_Click(object sender, EventArgs e)
        {
            if (this.ddlEspecialidades.SelectedIndex < 0 || this.ddlMedicos.SelectedIndex < 0)
                return;

            bool funcionou = ((Secretaria)Session["usuario"]).AdicionarEspecialidadeMedico(this.ddlMedicos.SelectedValue, Convert.ToInt32(this.ddlEspecialidades.SelectedValue));
            if (funcionou)
            {
                this.lbMsgEspMed.Attributes["style"] = "color: green";
                this.lbMsgEspMed.Text = "Especialidade adicionada a médico com sucesso";
            }
            else
            {
                this.lbMsgEspMed.Attributes["style"] = "color: red";
                this.lbMsgEspMed.Text = "Esse médico já tem essa especialidade!";
            }
        }
    }
}