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

        //PACIENTE
        protected void btnPrincPac_Click(object sender, EventArgs e)
        { Response.Redirect("/Paciente/IndexPaciente.aspx"); }

        //MEDICO
        protected void btnPrincMed_Click(object sender, EventArgs e)
        { Response.Redirect("/Medico/IndexMedico.aspx"); }

        //SECRETARIA
        protected void btnPrincSec_Click(object sender, EventArgs e)
        { Response.Redirect("/Secretaria/IndexSecretaria.aspx"); }
        protected void btnAgendarConsulta_Click(object sender, EventArgs e)
        { Response.Redirect("/Secretaria/AgendarConsultas.aspx"); }
        protected void btnServidor_Click(object sender, EventArgs e)
        { Response.Redirect("/Secretaria/Servidor.aspx"); }
        protected void btnRelatórios_Click(object sender, EventArgs e)
        { Response.Redirect("/Secretaria/Relatorios.aspx"); }
    }
}