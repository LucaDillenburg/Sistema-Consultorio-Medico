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
    public class Paciente
    {
        protected AtributosPaciente atributos;
        protected ConexaoBD conexaoBD;

        //inicializar
        public Paciente(string email, string senha, ConexaoBD conexaoBD)
        {
            if (!this.Login(email, senha, conexaoBD))
                throw new Exception("Email ou senha errado!");

            this.conexaoBD = conexaoBD;
        }

        protected bool Login(string email, string senha, ConexaoBD conexaoBD)
        {
            this.atributos = new AtributosPaciente();
            this.atributos.AdicionarSenha(senha);

            DataSet data = conexaoBD.ExecuteSelect("select email, nomeCompleto, celular, telefoneResidencial, endereco, dataDeNascimento, caminhoFoto " +
                " from paciente where email='" + email + "' and senha='" + this.atributos.SenhaCriptografada + "'");
            if (data.Tables[0].Rows.Count <= 0)
                return false;

            Paciente.ColocarAtributosFromDs(ref this.atributos, 0, data);
            return true;
        }


        //acoes de paciente
        public void RegistrarSatisfacao(AtributosConsultaCod atributosConsulta)
        {
            // ADICIONAR SATISFACAO (E TALVEZ COMENTARIO)
            if (String.IsNullOrEmpty(atributosConsulta.Comentario))
                this.conexaoBD.ExecuteInUpDel("update consulta set " +
                    " satisfacao = " + atributosConsulta.Satisfacao + ", medicoJahViuSatisfacao = 0, " +
                    " horarioSatisfacao = '" + atributosConsulta.HorarioSatisfacao +
                    "' where codConsulta=" + atributosConsulta.CodConsulta);
            else
                this.conexaoBD.ExecuteInUpDel("update consulta set comentario = '"
                    + atributosConsulta.Comentario + "', satisfacao = " + atributosConsulta.Satisfacao +
                    ", medicoJahViuSatisfacao = 0, horarioSatisfacao = '" + atributosConsulta.HorarioSatisfacao +
                    "' where codConsulta=" + atributosConsulta.CodConsulta);
        }

        public void AdicionarImagem(FileUpload fileUpload)
        { Usuario.AuxAdicionarImagem(this.atributos, true, fileUpload, this.conexaoBD); }

        //cadastro
        public static bool Existe(string email, ConexaoBD conexaoBD)
        {
            DataSet data = conexaoBD.ExecuteSelect("select * from paciente where email='" + email + "'");
            return data.Tables[0].Rows.Count > 0;
        }

        public static AtributosPaciente DeEmail(string email, ConexaoBD conexaoBD)
        {
            try
            {
                DataSet data = conexaoBD.ExecuteSelect("select email, nomeCompleto, celular, telefoneResidencial, endereco, dataDeNascimento, caminhoFoto " +
                    " from paciente where email='" + email + "'");
                if (data.Tables[0].Rows.Count <= 0)
                    return null;

                AtributosPaciente atributos = new AtributosPaciente();
                Paciente.ColocarAtributosFromDs(ref atributos, 0, data);
                return atributos;
            }
            catch (Exception e)
            {
                return null;
            }
        }

        //paciente especifico
        public static bool HorarioConsultaEhLivre(AtributosConsulta atrConsulta, ConexaoBD conexaoBD)
        {
            AtributosConsultaCod[] vetor = Consulta.ConsultasOcorrendoEmHorarioOutraConsulta(atrConsulta, null,
                atrConsulta.EmailPaciente, conexaoBD);
            return vetor == null;
        }

        //todos os pacientes
        public static string[,] GetTodosPacientes(ConexaoBD conexaoBD)
        {
            DataSet data = conexaoBD.ExecuteSelect("select email, nomeCompleto from paciente");

            string[,] ret = new string[data.Tables[0].Rows.Count, 2];
            for (int i = 0; i < data.Tables[0].Rows.Count; i++)
            {
                ret[i, 0] = (string)data.Tables[0].Rows[i].ItemArray[0];
                ret[i, 1] = (string)data.Tables[0].Rows[i].ItemArray[1];
            }

            return ret;
        }

        //aux
        protected static void ColocarAtributosFromDs(ref AtributosPaciente atributos, int i, DataSet data)
        {
            atributos.Email = (string)data.Tables[0].Rows[i].ItemArray[0];
            atributos.NomeCompleto = (string)data.Tables[0].Rows[i].ItemArray[1];
            atributos.Celular = (string)data.Tables[0].Rows[i].ItemArray[2];
            atributos.TelefoneResidencial = (string)data.Tables[0].Rows[i].ItemArray[3];
            atributos.Endereco = (string)data.Tables[0].Rows[i].ItemArray[4];
            atributos.DataNascimento = (DateTime)data.Tables[0].Rows[i].ItemArray[5];
            if (data.Tables[0].Rows[i].ItemArray[6] != System.DBNull.Value)
                atributos.CaminhoFoto = (string)data.Tables[0].Rows[i].ItemArray[6];
        }


        //getter
        public AtributosPaciente Atributos
        {
            get { return this.atributos; }
        }
    }
}
