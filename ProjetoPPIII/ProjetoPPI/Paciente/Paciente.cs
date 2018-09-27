﻿using System;
using System.Collections.Generic;
using System.Data;
using System.Globalization;
using System.Linq;
using System.Web;

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

            DataSet data = conexaoBD.ExecuteSelect("select nomeCompleto, celular, telefoneResidencial, endereco, dataDeNascimento, foto " +
                " from paciente where email='" + email + "' and senha='" + this.atributos.SenhaCriptografada + "'");
            if (data.Tables[0].Rows.Count <= 0)
                return false;

            this.atributos.Email = email;

            this.atributos.NomeCompleto = (string)data.Tables[0].Rows[0].ItemArray[0];
            this.atributos.Celular = (string)data.Tables[0].Rows[0].ItemArray[1];
            this.atributos.TelefoneResidencial = (string)data.Tables[0].Rows[0].ItemArray[2];
            this.atributos.Endereco = (string)data.Tables[0].Rows[0].ItemArray[3];
            this.atributos.DataNascimento = (DateTime)data.Tables[0].Rows[0].ItemArray[4];

            try
            { 
                byte[] vetorImagem = (byte[])data.Tables[0].Rows[0].ItemArray[5];
                this.atributos.Foto = ImageMethods.ImageFromBytes(vetorImagem);
            }catch(Exception e)
            { /*se entrou aqui eh porque era nulo (ele nao reconhece como nulo)*/ }

            return true;
        }


        //acoes de paciente
        public void RegistrarSatisfacao(AtributosConsultaCod atributosConsulta)
        {
            // ADICIONAR SATISFACAO (E TALVEZ COMENTARIO)
            if (String.IsNullOrEmpty(atributosConsulta.Comentario))
                this.conexaoBD.ExecuteInUpDel("update consulta set " +
                    " satisfacao = " + atributosConsulta.Satisfacao + ", medicoJahViuSatisfacao = 0, " +
                    " horarioSatisfacao = " + atributosConsulta.HorarioSatisfacao +
                    " where codConsulta=" + atributosConsulta.CodConsulta);
            else
                this.conexaoBD.ExecuteInUpDel("update consulta set comentario = '"
                    + atributosConsulta.Comentario + "', satisfacao = " + atributosConsulta.Satisfacao +
                    ", medicoJahViuSatisfacao = 0, horarioSatisfacao = " + atributosConsulta.HorarioSatisfacao +
                    " where codConsulta=" + atributosConsulta.CodConsulta);
        }


        //cadastro
        public static bool Existe(string email, ConexaoBD conexaoBD)
        {
            DataSet data = conexaoBD.ExecuteSelect("select * from paciente where email='" + email + "'");
            return data.Tables[0].Rows.Count > 0;
        }

        public static AtributosPaciente DeEmail(string email, ConexaoBD conexaoBD)
        {
            DataSet data = conexaoBD.ExecuteSelect("select nomeCompleto, crm, celular, telefoneResidencial, endereco, dataDeNascimento, foto " +
                " from medico where email='" + email + "'");
            if (data.Tables[0].Rows.Count <= 0)
                return null;

            AtributosPaciente atributos = new AtributosPaciente();
            atributos.Email = email;
            atributos.NomeCompleto = (string)data.Tables[0].Rows[0].ItemArray[0];
            atributos.Celular = (string)data.Tables[0].Rows[0].ItemArray[2];
            atributos.TelefoneResidencial = (string)data.Tables[0].Rows[0].ItemArray[3];
            atributos.Endereco = (string)data.Tables[0].Rows[0].ItemArray[4];
            atributos.DataNascimento = (DateTime)data.Tables[0].Rows[0].ItemArray[5];

            byte[] vetorImagem = (byte[])data.Tables[0].Rows[0].ItemArray[6];
            atributos.Foto = ImageMethods.ImageFromBytes(vetorImagem);

            return atributos;
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


        //getter
        public AtributosPaciente Atributos
        {
            get { return this.atributos; }
        }
    }
}