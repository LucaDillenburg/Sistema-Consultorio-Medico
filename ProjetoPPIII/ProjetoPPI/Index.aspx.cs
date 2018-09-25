using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Configuration;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace ProjetoPPI
{
    public partial class Index : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            Session["usuario"] = null;
            if (Session["conexao"] == null)
                Session["conexao"] = new ConexaoBD(WebConfigurationManager.ConnectionStrings["conexaoBD"].ConnectionString);
        }

        protected void btnMenuMedico_Click(object sender, EventArgs e)
        {
            Session["tipoUsuario"] = TipoUsuario.medico;
            Response.Redirect("Login.aspx");
        }

        protected void btnMenuSecretaria_Click(object sender, EventArgs e)
        {
            Session["tipoUsuario"] = TipoUsuario.secretaria;
            Response.Redirect("Login.aspx");
        }

        protected void btnMenuPaciente_Click(object sender, EventArgs e)
        {
            Session["tipoUsuario"] = TipoUsuario.paciente;
            Response.Redirect("Login.aspx");
        }
    }
}