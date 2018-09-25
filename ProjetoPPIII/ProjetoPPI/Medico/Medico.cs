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
            
            this.atributos.NomeCompleto = data.Tables[0].Rows[0].ItemArray[0].ToString();
            this.atributos.CRM = data.Tables[0].Rows[0].ItemArray[1].ToString();
            this.atributos.Celular = data.Tables[0].Rows[0].ItemArray[2].ToString();
            this.atributos.TelefoneResidencial = data.Tables[0].Rows[0].ItemArray[3].ToString();
            this.atributos.Endereco = data.Tables[0].Rows[0].ItemArray[4].ToString();
            this.atributos.DataNascimento = Convert.ToDateTime(data.Tables[0].Rows[0].ItemArray[5]);

            byte[] vetorImagem = (byte[])data.Tables[0].Rows[0].ItemArray[6];
            this.atributos.Foto = ImageMethods.ImageFromBytes(vetorImagem);

            return true;
        }

        
        //cadastro
        public static bool Existe(string email, ConexaoBD conexaoBD)
        {
            DataSet data = conexaoBD.ExecuteSelect("select * from medico where email='" + email + "'");
            return data.Tables[0].Rows.Count > 0;
        }


        //outros dados de medicos especificos
        public static AtributosMedico DeEmail(string email, ConexaoBD conexaoBD)
        {
            DataSet data = conexaoBD.ExecuteSelect("select nomeCompleto, crm, celular, telefoneResidencial, endereco, dataDeNascimento, foto " +
                " from medico where email='" + email + "'");
            if (data.Tables[0].Rows.Count <= 0)
                throw new Exception("Esse medico nao existe!");

            AtributosMedico atributos = new AtributosMedico();
            atributos.Email = email;
            atributos.NomeCompleto = data.Tables[0].Rows[0].ItemArray[0].ToString();
            atributos.CRM = data.Tables[0].Rows[0].ItemArray[1].ToString();
            atributos.Celular = data.Tables[0].Rows[0].ItemArray[2].ToString();
            atributos.TelefoneResidencial = data.Tables[0].Rows[0].ItemArray[3].ToString();
            atributos.Endereco = data.Tables[0].Rows[0].ItemArray[4].ToString();
            atributos.DataNascimento = Convert.ToDateTime(data.Tables[0].Rows[0].ItemArray[5].ToString());

            byte[] vetorImagem = (byte[])data.Tables[0].Rows[0].ItemArray[6];
            atributos.Foto = ImageMethods.ImageFromBytes(vetorImagem);

            return atributos;
        }

        public static int SatisfacaoMedia(string email, ConexaoBD conexaoBD)
        {
            //os termos nulos sao ignorados (nao sao contados como zeros)
            return (int)conexaoBD.ExecuteScalarSelect("select avg(satisfacao) from consulta where emailMedico = '" 
                + email + "'");
        }


        //todos os medicos
        public static string[,] GetTodosMedicos(ConexaoBD conexaoBD)
        {
            DataSet data = conexaoBD.ExecuteSelect("select email, nomeCompleto from medico");

            string[,] ret = new string[data.Tables[0].Rows.Count, 2];
            for (int i = 0; i< data.Tables[0].Rows.Count; i++)
            {
                ret[i,0] = data.Tables[0].Rows[i].ItemArray[0].ToString();
                ret[i,1] = data.Tables[0].Rows[i].ItemArray[1].ToString();
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