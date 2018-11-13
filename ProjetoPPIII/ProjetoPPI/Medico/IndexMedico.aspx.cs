using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace ProjetoPPI.PagMedico
{
    public partial class IndexMedico: System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["usuario"] == null || Session["conexao"] == null || Session["usuario"].GetType() != typeof(ProjetoPPI.Medico))
            {
                Response.Redirect("../Index.aspx");
                return;
            }
        }

        protected void btnFileUpload_Click(object sender, EventArgs e)
        {
            if (this.fileUpload.HasFile)
            {
                ((Medico)Session["usuario"]).AdicionarImagem(this.fileUpload);
                Response.Redirect("IndexMedico.aspx");
            }
        }
    }
}