using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Drawing;
using System.Globalization;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.UI.WebControls;

namespace ProjetoPPI
{
    public class Medico
    {
        protected AtributosMedico atributos;
        protected ConexaoBD conexaoBD;

        //inicializar
        public Medico(string email, string senha, ConexaoBD conexaoBD)
        {
            if (!this.Login(email, senha, conexaoBD))
                throw new Exception("Email ou senha errado!");

            this.conexaoBD = conexaoBD;
        }

        protected bool Login(string email, string senha, ConexaoBD conexaoBD)
        {
            this.atributos = new AtributosMedico();
            this.atributos.AdicionarSenha(senha);

            DataSet data = conexaoBD.ExecuteSelect("select email, nomeCompleto, crm, celular, telefoneResidencial, endereco, dataDeNascimento, caminhoFoto " +
                " from medico where email='" + email + "' and senha='" + this.atributos.SenhaCriptografada + "'");
            if (data.Tables[0].Rows.Count <= 0)
                return false;

            Medico.ColocarAtributosFromDs(ref this.atributos, 0, data);
            return true;
        }


        //cadastro
        public static bool Existe(string email, ConexaoBD conexaoBD)
        {
            DataSet data = conexaoBD.ExecuteSelect("select * from medico where email='" + email + "'");
            return data.Tables[0].Rows.Count > 0;
        }


        //acoes medico
        public void MudarObservacoes(AtributosConsultaCod atributosConsulta)
        {
            this.conexaoBD.ExecuteInUpDel("update consulta set observacoes = '"
                + atributosConsulta.Observacoes + "', status='s' " +
                "where codConsulta=" + atributosConsulta.CodConsulta);
        }

        public void AdicionarImagem(FileUpload fileUpload)
        { Usuario.AuxAdicionarImagem(this.atributos, false, fileUpload, this.conexaoBD); }

        public void ViuNovasSatisfacoes()
        {
            this.conexaoBD.ExecuteInUpDel("update consulta set medicoJahViuSatisfacao = 1 " +
                " where emailMedico= '" + this.Atributos.Email + "' and medicoJahViuSatisfacao = 0");
        }

        public AtributosConsultaCod ConsultaAtual()
        {
            AtributosConsultaCod[] vetor = Consulta.ConsultasOcorrendoEmHorarioEspecifico(DateTime.Now, this.Atributos.Email, null,
                this.conexaoBD);
            if (vetor == null)
                return null;
            return vetor[0];
        }


        //atributos medico
        public int QtdNovasSatisfacoes
        {
            get
            {
                return (int)this.conexaoBD.ExecuteScalarSelect("select count(*) from consulta " +
                "where emailMedico = '" + this.Atributos.Email + "' and medicoJahViuSatisfacao = 0");
            }
        }

        public string[] Especialidades()
        {
            DataSet ds = this.conexaoBD.ExecuteSelect(
                "select e.nomeEspecialidade from " +
                "especialidade as e," +
                "especialidadeMedico as em " +
                "where " +
                "e.codEspecialidade = em.codEspecialidade and " +
                "em.emailMedico = '" + this.Atributos.Email + "'");
            string[] ret = new string[ds.Tables[0].Rows.Count];
            for (int i = 0; i < ret.Length; i++)
                ret[i] = (string)ds.Tables[0].Rows[i].ItemArray[0];
            return ret;
        }


        //outros dados de medicos especificos (STATIC)
        public static AtributosMedico DeEmail(string email, ConexaoBD conexaoBD)
        {
            DataSet data = conexaoBD.ExecuteSelect("select email, nomeCompleto, crm, celular, telefoneResidencial, endereco, dataDeNascimento, caminhoFoto " +
                " from medico where email='" + email + "'");
            if (data.Tables[0].Rows.Count <= 0)
                throw new Exception("Esse medico nao existe!");

            AtributosMedico atributos = new AtributosMedico();
            Medico.ColocarAtributosFromDs(ref atributos, 0, data);
            return atributos;
        }

        public double SatisfacaoMedia()
        {
            try
            {
                return (double)this.conexaoBD.ExecuteScalarSelect("select avg(Cast(satisfacao as Float)) from consulta where emailMedico = '"
                + this.Atributos.Email + "'");
            }
            catch(Exception e)
            {
                return -1;
            }
            //os termos nulos sao ignorados (nao sao contados como zeros)
        }

        public static bool HorarioConsultaEhLivre(AtributosConsulta atrConsulta, ConexaoBD conexaoBD)
        {
            AtributosConsultaCod[] vetor = Consulta.ConsultasOcorrendoEmHorarioOutraConsulta(atrConsulta,
                atrConsulta.EmailMedico, null, conexaoBD);
            return vetor == null;
        }


        //todos os medicos
        public static string[,] GetTodosMedicos(ConexaoBD conexaoBD)
        {
            DataSet data = conexaoBD.ExecuteSelect("select email, nomeCompleto from medico");

            string[,] ret = new string[data.Tables[0].Rows.Count, 2];
            for (int i = 0; i< data.Tables[0].Rows.Count; i++)
            {
                ret[i,0] = (string)data.Tables[0].Rows[i].ItemArray[0];
                ret[i,1] = (string)data.Tables[0].Rows[i].ItemArray[1];
            }

            return ret;
        }

        //aux
        protected static void ColocarAtributosFromDs(ref AtributosMedico atributos, int i, DataSet data)
        {
            atributos.Email = (string)data.Tables[0].Rows[i].ItemArray[0];
            atributos.NomeCompleto = (string)data.Tables[0].Rows[i].ItemArray[1];
            atributos.CRM = (string)data.Tables[0].Rows[i].ItemArray[2];
            atributos.Celular = (string)data.Tables[0].Rows[i].ItemArray[3];
            atributos.TelefoneResidencial = (string)data.Tables[0].Rows[i].ItemArray[4];
            atributos.Endereco = (string)data.Tables[0].Rows[i].ItemArray[5];
            atributos.DataNascimento = (DateTime)data.Tables[0].Rows[i].ItemArray[6];
            if (data.Tables[0].Rows[i].ItemArray[7] != System.DBNull.Value)
                atributos.CaminhoFoto = (string)data.Tables[0].Rows[i].ItemArray[7];
        }

        //getter
        public AtributosMedico Atributos
        {
            get { return this.atributos; }
        }
    }
}
