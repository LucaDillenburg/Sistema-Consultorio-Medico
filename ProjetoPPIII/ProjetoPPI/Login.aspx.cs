using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Configuration;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace ProjetoPPI
{
    public enum TipoUsuario { medico, secretaria, paciente };

    public partial class Login : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["conexao"] == null)
                Session["conexao"] = new ConexaoBD(WebConfigurationManager.ConnectionStrings["conexaoBD"].ConnectionString);
        }

        protected void btnLogar_Click(object sender, EventArgs e)
        {
            if (String.IsNullOrEmpty(this.txtEmail.Text) || String.IsNullOrEmpty(this.txtSenha.Text))
            {
                this.lbMsg.Text = "Preencha todos os campos!";
                return;
            }

            this.lbMsg.Text = "";

            string email = HttpUtility.HtmlEncode(this.txtEmail.Text);
            string senha = HttpUtility.HtmlEncode(this.txtSenha.Text);
            switch ((ProjetoPPI.TipoUsuario)Session["tipoUsuario"])
            {
                case TipoUsuario.medico:
                    try
                    {
                        Session["usuario"] = new Medico(email, senha, (ConexaoBD)Session["conexao"]);
                        Acesso.AdicionarAcesso(email, TipoUsuario.medico, (ConexaoBD)Session["conexao"]);
                        Response.Redirect("Medico/IndexMedico.aspx");
                        return;
                    } catch(Exception err)
                    {
                        this.lbMsg.Text = "Senha ou email incorretos!";
                    }
                    break;
                case TipoUsuario.paciente:
                    try
                    {
                        Session["usuario"] = new Paciente(email, senha, (ConexaoBD)Session["conexao"]);
                        Acesso.AdicionarAcesso(email, TipoUsuario.paciente, (ConexaoBD)Session["conexao"]);
                        Response.Redirect("Paciente/IndexPaciente.aspx");
                        if (Session["usuario"] == null) { int i = 0; }
                        return;
                    }
                    catch (Exception err)
                    {
                        this.lbMsg.Text = "Senha ou email incorretos!";
                    }
                    break;
                case TipoUsuario.secretaria:
                    try
                    {
                        Session["usuario"] = new Secretaria(email, senha, (ConexaoBD)Session["conexao"]);
                        Acesso.AdicionarAcesso(email, TipoUsuario.secretaria, (ConexaoBD)Session["conexao"]);
                        Response.Redirect("/Secretaria/IndexSecretaria.aspx", false);
                        return;
                    }
                    catch (Exception err)
                    {
                        this.lbMsg.Text = "Senha ou email incorretos!";
                    }
                    break;
            }
        }
    }
}