using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Drawing;
using System.Globalization;
using System.Linq;
using System.Web;

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
            
            DataSet data = conexaoBD.ExecuteSelect("select nomeCompleto, crm, celular, telefoneResidencial, endereco, dataDeNascimento, foto " +
                " from medico where email='" + email + "' and senha='" + this.atributos.SenhaCriptografada + "'");
            if (data.Tables[0].Rows.Count <= 0)
                return false;
            
            this.atributos.Email = email;
            
            this.atributos.NomeCompleto = (string)data.Tables[0].Rows[0].ItemArray[0];
            this.atributos.CRM = (string)data.Tables[0].Rows[0].ItemArray[1];
            this.atributos.Celular = (string)data.Tables[0].Rows[0].ItemArray[2];
            this.atributos.TelefoneResidencial = (string)data.Tables[0].Rows[0].ItemArray[3];
            this.atributos.Endereco = (string)data.Tables[0].Rows[0].ItemArray[4];
            this.atributos.DataNascimento = (DateTime)data.Tables[0].Rows[0].ItemArray[5];

            if (data.Tables[0].Rows[0].ItemArray[6] != System.DBNull.Value)
            {
                byte[] vetorImagem = (byte[])data.Tables[0].Rows[0].ItemArray[6];
                this.atributos.Foto = ImageMethods.ImageFromBytes(vetorImagem);
            }

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
        

        //outros dados de medicos especificos (STATIC)
        public static AtributosMedico DeEmail(string email, ConexaoBD conexaoBD)
        {
            DataSet data = conexaoBD.ExecuteSelect("select nomeCompleto, crm, celular, telefoneResidencial, endereco, dataDeNascimento, foto " +
                " from medico where email='" + email + "'");
            if (data.Tables[0].Rows.Count <= 0)
                throw new Exception("Esse medico nao existe!");

            AtributosMedico atributos = new AtributosMedico();
            atributos.Email = email;
            atributos.NomeCompleto = (string)data.Tables[0].Rows[0].ItemArray[0];
            atributos.CRM = (string)data.Tables[0].Rows[0].ItemArray[1];
            atributos.Celular = (string)data.Tables[0].Rows[0].ItemArray[2];
            atributos.TelefoneResidencial = (string)data.Tables[0].Rows[0].ItemArray[3];
            atributos.Endereco = (string)data.Tables[0].Rows[0].ItemArray[4];
            atributos.DataNascimento = (DateTime)data.Tables[0].Rows[0].ItemArray[5];

            if (data.Tables[0].Rows[0].ItemArray[6] != System.DBNull.Value)
            {
                byte[] vetorImagem = (byte[])data.Tables[0].Rows[0].ItemArray[6];
                atributos.Foto = ImageMethods.ImageFromBytes(vetorImagem);
            }

            return atributos;
        }

        public static double SatisfacaoMedia(string email, ConexaoBD conexaoBD)
        {
            //os termos nulos sao ignorados (nao sao contados como zeros)
            return (double)conexaoBD.ExecuteScalarSelect("select avg(Cast(satisfacao as Float)) from consulta where emailMedico = '"
                + email + "'");
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


        //getter
        public AtributosMedico Atributos
        {
            get { return this.atributos; }
        }
    }
}