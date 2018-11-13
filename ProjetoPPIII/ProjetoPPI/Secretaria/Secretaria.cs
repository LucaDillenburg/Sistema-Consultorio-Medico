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
            
            this.atributos.NomeCompleto = (string)data.Tables[0].Rows[0].ItemArray[0];
            this.atributos.Endereco = (string)data.Tables[0].Rows[0].ItemArray[1];

            return true;
        }


        //CADASTRAR USUARIOS
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


        //CONSULTAS
        protected const int MINUTOS_DE_TOLERANCIA = 5;
        public void CadastrarConsulta(AtributosConsulta atrConsulta)
        {
            if (!String.IsNullOrEmpty(atrConsulta.Observacoes) || !String.IsNullOrEmpty(atrConsulta.Comentario)
                || atrConsulta.Satisfacao != -1)
                throw new Exception("Atributos da consulta invalido! Dados demais!");
            if ((atrConsulta.Status!='n' && atrConsulta.Status != 's' && atrConsulta.Status != 'c') || String.IsNullOrEmpty(atrConsulta.Proposito) 
                || atrConsulta.Horario == null || String.IsNullOrEmpty(atrConsulta.EmailMedico) || 
                String.IsNullOrEmpty(atrConsulta.EmailPaciente))
                throw new Exception("Atributos da consulta invalido! Faltando dados!");

            //a consulta tem que ser marcada antes para depois realiza-la (5 minutos de tolerancia)
            DateTime agoraComTolerancia;
            if (DateTime.Now.Minute < MINUTOS_DE_TOLERANCIA)
                agoraComTolerancia = new DateTime(DateTime.Now.Year, DateTime.Now.Month, DateTime.Now.Day,
                  DateTime.Now.Hour - 1, 60 - MINUTOS_DE_TOLERANCIA + DateTime.Now.Minute, DateTime.Now.Second);
            else
                agoraComTolerancia = new DateTime(DateTime.Now.Year, DateTime.Now.Month, DateTime.Now.Day,
                  DateTime.Now.Hour, DateTime.Now.Minute - MINUTOS_DE_TOLERANCIA, DateTime.Now.Second);
            if (atrConsulta.Horario.CompareTo(DateTime.Now) < 0)
                throw new Exception("Consulta tem que ser depois do horário atual! Tolerância: " + MINUTOS_DE_TOLERANCIA + " minutos.");

            if (!Medico.HorarioConsultaEhLivre(atrConsulta, this.conexaoBD))
                throw new Exception("Médico estará em outra consulta!");
            if (!Paciente.HorarioConsultaEhLivre(atrConsulta, this.conexaoBD))
                throw new Exception("Paciente estará em outra consulta!");

            //proposito, horario, umaHora, observacoes, status, emailMedico, emailPac
            this.conexaoBD.ExecuteInUpDel("insert into consulta(proposito, horario, umaHora, status, emailMedico, emailPac, jahMandouEmailSMS) " + 
                "values('" + atrConsulta.Proposito + "', '" + atrConsulta.Horario + "', " + (atrConsulta.UmaHora?"1":"0") + ", '" + 
                atrConsulta.Status + "', '" + atrConsulta.EmailMedico + "', '" + atrConsulta.EmailPaciente + "', 0)");
        }

        public void AtualizarDadosConsulta(AtributosConsultaCod atributos)
        {
            if (atributos.Status=='s') //consulta ocorreu
            {
                if (String.IsNullOrEmpty(atributos.Observacoes)) //nao tem observacoes
                    throw new Exception("Uma consulta que ocorreu precisa ter observações!");
            }
            else //consulta nao ocorreu
                if(!String.IsNullOrEmpty(atributos.Observacoes)) //tem observacoes
                throw new Exception("Observações tem que ser vazia se consulta ainda não ocorreu.");

            if ((atributos.Status != 'n' && atributos.Status != 's' && atributos.Status != 'c') || String.IsNullOrEmpty(atributos.Proposito)
                || atributos.Horario == null || String.IsNullOrEmpty(atributos.EmailMedico) ||
                String.IsNullOrEmpty(atributos.EmailPaciente))
                throw new Exception("Atributos da consulta invalido! Faltando dados!");

            //proposito, medico, paciente, horario, duracao, status, observações
            this.conexaoBD.ExecuteInUpDel("update consulta set proposito='" + atributos.Proposito + "', emailMedico='" + atributos.EmailMedico + "', " +
                "emailPaciente='" + atributos.EmailPaciente + "', horario='" + atributos.Horario + "', umaHora= " + (atributos.UmaHora ? "1" : "0") + ", " +
                "status='" + atributos.Status + "', observacoes='" + atributos.Observacoes + "' " +
                "where codConsulta = " + atributos.CodConsulta);
        }

        public object[,] PesquisarConsultas(string medico, string paciente, string data, int tipoData)
        //0: consulta, 1: paciente, 2:medico
        {
            string cmd_s = "select c.codConsulta, c.proposito, c.horario, c.umaHora, c.observacoes, c.status, " +
                "c.emailMedico, c.emailPac, c.satisfacao, c.comentario, c.horarioSatisfacao, c.medicoJahViuSatisfacao, " +
                "m.nomeCompleto, p.nomeCompleto from " +
                "consulta as c, " +
                "medico as m, " +
                "paciente as p " +
                "where " +
                "c.emailMedico = m.email and " +
                "m.nomeCompleto like '%" + medico + "%' and " +
                "c.emailPac = p.email and " +
                "p.nomeCompleto like '%" + paciente + "%' ";
        
            if (!String.IsNullOrEmpty(data))
            {
                cmd_s += " and ";
                if (tipoData < 0)
                    cmd_s += " c.horario <";
                else
                if (tipoData > 0)
                    cmd_s += " c.horario >";
                else
                    cmd_s += " CONVERT(VARCHAR(10), c.horario, 103) = "; // dd/mm/yyyy
                cmd_s += "'"+ data + "'";
            }

            cmd_s += " order by c.horario desc";
            DataSet ds = this.conexaoBD.ExecuteSelect(cmd_s);
            object[,] ret = new object[ds.Tables[0].Rows.Count, 3];
            for (int i = 0; i < ds.Tables[0].Rows.Count; i++)
            {
                ret[i, 0] = Consulta.AtributosConsultaFromDataSet(ds, i, this.conexaoBD);
                ret[i, 1] = (string)ds.Tables[0].Rows[i].ItemArray[13];
                ret[i, 2] = (string)ds.Tables[0].Rows[i].ItemArray[12];
            }
                
            return ret;
        }


        //especialidade
        public bool AdicionarEspecialidade(string nomeEspecialidade)
        {
            if (this.EspecialidadeExiste(nomeEspecialidade))
                return false;
            this.conexaoBD.ExecuteInUpDel("insert into especialidade(nomeEspecialidade) values('" + nomeEspecialidade + "')");
            return true;
        }
        protected bool EspecialidadeExiste(string nomeEspecialidade)
        {
            return ((int)this.conexaoBD.ExecuteScalarSelect("select count(*) from especialidade where " +
                "nomeEspecialidade = '" + nomeEspecialidade + "'")) > 0;
        }

        public bool AdicionarEspecialidadeMedico(string emailMedico, int codEspecialidade)
        {
            if (this.EspecialidadeMedicoExiste(emailMedico, codEspecialidade))
                return false;
            this.conexaoBD.ExecuteInUpDel("insert into especialidadeMedico values('" + emailMedico + "', "
                + codEspecialidade + ")");
            return true;
        }
        protected bool EspecialidadeMedicoExiste(string emailMedico, int codEspecialidade)
        {
            return ((int)this.conexaoBD.ExecuteScalarSelect("select count(*) from especialidadeMedico where " +
                "emailMedico = '" + emailMedico+ "' and codEspecialidade=" + codEspecialidade)) > 0;
        }
    }
}