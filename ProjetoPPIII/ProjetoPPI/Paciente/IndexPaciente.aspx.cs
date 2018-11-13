using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace ProjetoPPI.PagPaciente
{
    public partial class IndexPaciente: System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["usuario"] == null || Session["conexao"] == null || Session["usuario"].GetType() != typeof(ProjetoPPI.Paciente))
            {
                Response.Redirect("../Index.aspx");
                return;
            }
        }

        protected void btnFileUpload_Click(object sender, EventArgs e)
        {
            if (this.fileUpload.HasFile && ImageMethods.EhImagem(this.fileUpload.FileName))
            {
                ((Paciente)Session["usuario"]).AdicionarImagem(this.fileUpload);
                Response.Redirect("IndexPaciente.aspx");
            }
        }
    }
}