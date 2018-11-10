using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Net.Mail;
using System.Text;
using System.Threading;
using System.Web;
using System.Web.Configuration;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace ProjetoPPI.PagSecretaria
{
    public partial class Servidor : System.Web.UI.Page
    {
        protected SqlConnection con = new SqlConnection(WebConfigurationManager.ConnectionStrings["conexaoBD"].ConnectionString);

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["usuario"] == null || Session["conexao"] == null || Session["usuario"].GetType() != typeof(Secretaria))
            {
                Response.Redirect("../Index.aspx");
                return;
            }

            this.con.Open();

            this.lbxComandos.Items.Insert(0, "Funcionando...");

            new Thread(new ThreadStart(LoopMandarEmailSMS)).Start();
            new Thread(new ThreadStart(CancelarConsultasNaoOcorreram)).Start();
        }

        //CANCELAR CONSULTAS
        protected void CancelarConsultasNaoOcorreram()
        {
            // se consulta jah era pra ter ocorrido mas nao ocorreu
            string cmd_s = "update consulta set status = 'c' where CONVERT(char(10), horario, 103) < CONVERT(char(10), GETDATE(), 103) and status = 'n'";
            SqlCommand cmd = new SqlCommand(cmd_s, this.con);
            for (; ; )
            {
                try
                {
                    int res = cmd.ExecuteNonQuery();
                    if (res > 0)
                        this.lbxComandos.Items.Insert(0, res + " consultas canceladas.");
                }
                catch (Exception e)
                { }
            }
        }

        //MANDAR EMAIL
        protected void LoopMandarEmailSMS()
        {
            for (; ; )
                this.MandarEmailSMSs();
        }
        protected void MandarEmailSMSs()
        {
            string whereCmd = "";
            DataRowCollection emailCollection = this.EmailsAindaNaoMandouEmailSMS();
            if (emailCollection != null)
            {
                foreach (DataRow dr in emailCollection)
                {
                    //mandar email
                    try
                    {
                        DateTime horario = (DateTime)dr.ItemArray[3];
                        string emailPac = (string)dr.ItemArray[1];
                        bool hoje = horario.Day == DateTime.Now.Day;
                        //se consulta ainda nao comecou
                        if (horario.CompareTo(DateTime.Now) < 0)
                            this.MandarEmail(emailPac, (string)dr.ItemArray[2],
                                (string)dr.ItemArray[4], (string)dr.ItemArray[5], horario, hoje);

                        whereCmd += ((String.IsNullOrEmpty(whereCmd)) ? "" : ", ") + dr.ItemArray[0];
                        string texto = "Email enviado para " + emailPac + ", consulta " + (hoje ? "hoje" : "amanhã") +
                            " às " + horario.ToString("HH:mm");
                        this.lbxComandos.Items.Insert(0, texto);
                    }
                    catch (Exception err)
                    { }
                }

                //falar que mandou email
                if (!String.IsNullOrEmpty(whereCmd))
                {
                    SqlCommand cmd = new SqlCommand("update consulta set jahMandouEmailSMS = 1 where codConsulta in ("
                    + whereCmd + ")", this.con);
                    cmd.ExecuteNonQuery();
                }
            }
        }
        protected void MandarEmail(string emailPaciente, string nomePaciente, string proposito, string nomeMedico, DateTime horario, bool hoje)
        {
            string horarioEmTexto = horario.ToString("HH:mm");
            string diaEscrito;
            if (hoje)
                diaEscrito = "Hoje";
            else
                diaEscrito = "Amanhã";

            SmtpClient client = new SmtpClient();
            client.Port = 587;
            client.Host = "smtp.gmail.com";
            client.EnableSsl = true;
            client.Timeout = 10000;
            client.DeliveryMethod = SmtpDeliveryMethod.Network;
            client.UseDefaultCredentials = false;
            client.Credentials = new System.Net.NetworkCredential("clinica.maxima.pp@gmail.com", "PR317188");

            MailMessage message = new MailMessage("clinica.maxima.pp@gmail.com", "luca.assumpcao.dillenburg@gmail.com",
                "Clínica Máxima: Você tem uma consulta " + diaEscrito + " às " + horarioEmTexto,
                "Olá " + nomePaciente + "! Estamos aqui apenas para te lembrar que você tem uma consulta marcada para " +
                diaEscrito + " às " + horarioEmTexto + ".\nVocê será consultado pelo nosso médico de excelência " + nomeMedico + " e o " +
                "propósito da consulta é " + proposito + ".\n\nObrigado por escolher a Clínica Máxima, até " +
                (hoje ? "daqui a pouco" : "amanhã") + "!");
            message.BodyEncoding = UTF8Encoding.UTF8;
            message.DeliveryNotificationOptions = DeliveryNotificationOptions.OnFailure;

            client.Send(message);
        }
        protected DataRowCollection EmailsAindaNaoMandouEmailSMS()
        {
            try
            {
                SqlCommand cmd = new SqlCommand(
                " select c.codConsulta, c.emailPac, p.nomeCompleto, c.horario, c.proposito, m.nomeCompleto from" +
                " medico as m, " +
                " consulta as c," +
                " paciente as p " +
                " where " +
                " c.jahMandouEmailSMS = 0 and c.status = 'n' " +
                " and " +
                    "(convert(char(10), c.horario, 111) = convert(char(10), dateadd(DAY, 1, GETDATE()), 111) or " +
                    //a consulta vai ser amanha
                    "convert(char(10), c.horario, 111) = convert(char(10), GETDATE(), 111))" +
                //a consulta vai ser hoje
                " and c.emailMedico = m.email " +
                " and c.emailPac = p.email "
                , this.con);

                SqlDataAdapter adapt = new SqlDataAdapter(cmd);
                DataSet ds = new DataSet();

                adapt.Fill(ds);

                return ds.Tables[0].Rows;
            }
            catch (Exception e)
            { return null; }
        }
    }
}