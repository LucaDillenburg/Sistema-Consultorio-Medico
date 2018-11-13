using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace ProjetoPPI.PagSecretaria
{
    public partial class AdicionarEspecialidade : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["usuario"] == null || Session["conexao"] == null || Session["usuario"].GetType() != typeof(ProjetoPPI.Secretaria))
            {
                Response.Redirect("/Index.aspx");
                return;
            }
        }

        protected void btnNovaEsp_Click(object sender, EventArgs e)
        {
            bool funcionou = ((Secretaria)Session["usuario"]).AdicionarEspecialidade(HttpUtility.HtmlEncode(this.txtEspecialidade.Text));
            if (funcionou)
            {
                this.lbMsgNovaEsp.Attributes["style"] = "color: green";
                this.lbMsgNovaEsp.Text = "Especialidade adicionada com sucesso";
            }
            else
            {
                this.lbMsgNovaEsp.Attributes["style"] = "color: red";
                this.lbMsgNovaEsp.Text = "Essa especialidade já existe!";
            }
        }
    }
}