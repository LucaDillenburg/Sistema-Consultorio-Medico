using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace ProjetoPPI.PagSecretaria
{
    public partial class IndexSecretaria : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["usuario"] == null || Session["conexao"] == null || Session["usuario"].GetType() != typeof(Secretaria))
            {
                Response.Redirect("/Index.aspx");
                return;
            }
        }

        protected void btnCadastrarMedico_Click(object sender, EventArgs e)
        {
            Session["tipoUsCadastrar"] = TipoUsuario.medico;
            Response.Redirect("CadastroUsuarios.aspx");
        }

        protected void btnCadastrarPaciente_Click(object sender, EventArgs e)
        {
            Session["tipoUsCadastrar"] = TipoUsuario.paciente;
            Response.Redirect("CadastroUsuarios.aspx");
        }

        protected void btnCadastrarSecretaria_Click(object sender, EventArgs e)
        {
            Session["tipoUsCadastrar"] = TipoUsuario.secretaria;
            Response.Redirect("CadastroUsuarios.aspx");
        }

        protected void btnAgendarConsulta_Click(object sender, EventArgs e)
        { Response.Redirect("AgendarConsulta.aspx"); }
        protected void btnAgenda_Click(object sender, EventArgs e)
        { Response.Redirect("Agenda.aspx"); }
    }
}