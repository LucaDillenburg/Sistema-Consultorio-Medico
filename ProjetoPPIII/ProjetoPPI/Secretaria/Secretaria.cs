using System;
using System.Collections.Generic;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Web;

namespace ProjetoPPI
{
    public class Secretaria
    {
        protected AtributosSecretaria atributos;
        protected ConexaoBD conexaoBD;
        
        public Secretaria(string email, string senha, ConexaoBD conexaoBD)
        {
            if (!this.Login(email, senha, conexaoBD))
                throw new Exception("Email ou senha errado!");

            this.conexaoBD = conexaoBD;
        }

        protected bool Login(string email, string senha, ConexaoBD conexaoBD)
        {
            this.atributos = new AtributosSecretaria();
            this.atributos.AdicionarSenha(senha);

            DataSet data = conexaoBD.ExecuteSelect("select nomeCompleto, endereco " +
                " from secretaria where email='" + email + "' and senha='" + this.atributos.SenhaCriptografada + "'");
            if (data.Tables[0].Rows.Count <= 0)
                return false;
            
            this.atributos.NomeCompleto = data.Tables[0].Rows[0].ItemArray[0].ToString();
            this.atributos.Endereco = data.Tables[0].Rows[0].ItemArray[1].ToString();

            return true;
        }

        public void CadastrarMedico(AtributosMedico atrMedico)
        {
            if (String.IsNullOrEmpty(atrMedico.Email) || String.IsNullOrEmpty(atrMedico.NomeCompleto) || String.IsNullOrEmpty(atrMedico.CRM) ||
                String.IsNullOrEmpty(atrMedico.Celular) || String.IsNullOrEmpty(atrMedico.TelefoneResidencial) || String.IsNullOrEmpty(atrMedico.Endereco) ||
                atrMedico.DataNascimento == null || String.IsNullOrEmpty(atrMedico.SenhaCriptografada))
                throw new Exception("Atributos do medico invalido! Faltando dados!");

            this.conexaoBD.ExecuteInUpDel("insert into medico(email, nomeCompleto, crm, celular, " +
                "telefoneResidencial, endereco, dataDeNascimento, senha) values('" + atrMedico.Email + "', '" +
                atrMedico.NomeCompleto + "', '" + atrMedico.CRM + "', '" + atrMedico.Celular + "', '" + atrMedico.TelefoneResidencial + "', '" +
                atrMedico.Endereco + "', '" + atrMedico.DataNascimento + "', '" + atrMedico.SenhaCriptografada + "')");
        }

        public void CadastrarPaciente(AtributosPaciente atrPaciente)
        {
            if (String.IsNullOrEmpty(atrPaciente.Email) || String.IsNullOrEmpty(atrPaciente.NomeCompleto) || String.IsNullOrEmpty(atrPaciente.Celular) 
                || String.IsNullOrEmpty(atrPaciente.TelefoneResidencial) || String.IsNullOrEmpty(atrPaciente.Endereco) ||
                atrPaciente.DataNascimento == null || String.IsNullOrEmpty(atrPaciente.SenhaCriptografada))
                throw new Exception("Atributos do paciente invalido! Faltando dados!");

            this.conexaoBD.ExecuteInUpDel("insert into paciente(email, nomeCompleto, celular, " +
                "telefoneResidencial, endereco, dataDeNascimento, senha) values('" + atrPaciente.Email + "', '" +
                atrPaciente.NomeCompleto + "', '" + atrPaciente.Celular + "', '" + atrPaciente.TelefoneResidencial + "', '" +
                atrPaciente.Endereco + "', '" + atrPaciente.DataNascimento + "', '" + atrPaciente.SenhaCriptografada + "')");
        }

        public void CadastrarSecretaria(AtributosSecretaria atrSecretaria)
        {
            if (String.IsNullOrEmpty(atrSecretaria.Email) || String.IsNullOrEmpty(atrSecretaria.NomeCompleto) || String.IsNullOrEmpty(atrSecretaria.Endereco) ||
                String.IsNullOrEmpty(atrSecretaria.SenhaCriptografada))
                throw new Exception("Atributos da secretaria invalido! Faltando dados!");

            this.conexaoBD.ExecuteInUpDel("insert into secretaria(email, nomeCompleto, endereco, senha) values('" + 
                atrSecretaria.Email + "', '" + atrSecretaria.NomeCompleto + "', '" + atrSecretaria.Endereco + "', '" + atrSecretaria.SenhaCriptografada + "')");
        }

        public void CadastrarConsulta(AtributosConsulta atrConsulta)
        {
            if (!String.IsNullOrEmpty(atrConsulta.Observacoes) || !String.IsNullOrEmpty(atrConsulta.Comentario)
                || atrConsulta.Satisfacao != -1)
                throw new Exception("Atributos da consulta invalido! Dados demais!");
            if ((atrConsulta.Status!='n' && atrConsulta.Status != 's' && atrConsulta.Status != 'c') || String.IsNullOrEmpty(atrConsulta.Proposito) 
                || atrConsulta.Horario == null || String.IsNullOrEmpty(atrConsulta.EmailMedico) || 
                String.IsNullOrEmpty(atrConsulta.EmailPaciente) || String.IsNullOrEmpty(atrConsulta.Proposito))
                throw new Exception("Atributos da consulta invalido! Faltando dados!");

            //proposito, horario, umaHora, observacoes, status, emailMedico, emailPac
            this.conexaoBD.ExecuteInUpDel("insert into consulta(proposito, horario, umaHora, status, emailMedico, emailPac) " + 
                "values('" + atrConsulta.Proposito + "', '" + atrConsulta.Horario + "', '" + (atrConsulta.UmaHora?"1":"0") + "', '" + 
                atrConsulta.Status + "', '" + atrConsulta.EmailMedico + "', '" + atrConsulta.EmailPaciente + "')");
        }
    }
}