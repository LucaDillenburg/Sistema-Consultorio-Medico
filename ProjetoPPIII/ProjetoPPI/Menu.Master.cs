using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.Configuration;

namespace ProjetoPPI
{
    public partial class NMenu : System.Web.UI.MasterPage
    {
        //PARA TUDO
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["conexao"] == null)
                Session["conexao"] = new ConexaoBD(WebConfigurationManager.ConnectionStrings["conexaoBD"].ConnectionString);
        }
        protected void btnLoginLogout_Click(object sender, EventArgs e)
        {
            if (Session["usuario"] == null)
                this.btnMenuPaciente_Click(null, null);
            else
            {
                Session["usuario"] = null;
                Response.Redirect("/Index.aspx");
            }
        }

        //AINDA SEM LOGAR
        protected void btnMenuMedico_Click(object sender, EventArgs e)
        {
            Session["tipoUsuario"] = TipoUsuario.medico;
            Response.Redirect("/Login.aspx");
        }

        protected void btnMenuSecretaria_Click(object sender, EventArgs e)
        {
            Session["tipoUsuario"] = TipoUsuario.secretaria;
            Response.Redirect("/Login.aspx");
        }

        protected void btnMenuPaciente_Click(object sender, EventArgs e)
        {
            Session["tipoUsuario"] = TipoUsuario.paciente;
            Response.Redirect("/Login.aspx");
        }

    }
}