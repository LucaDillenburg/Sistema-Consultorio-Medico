using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;

namespace ProjetoPPI
{
    public class Consulta
    {
        public static AtributosConsultaCod DeCodigo(int codConsulta, ConexaoBD conexaoBD)
        {
            DataSet dataSet = conexaoBD.ExecuteSelect("select proposito, horario, umaHora, observacoes, status, " +
                "emailMedico, emailPac, satisfacao, comentario, horarioSatisfacao, medicoJahViuSatisfacao " +
                "from consulta where codConsulta = " + codConsulta);

            if (dataSet.Tables[0].Rows.Count != 1)
                return null;

            AtributosConsultaCod atributos = new AtributosConsultaCod();
            atributos.CodConsulta = codConsulta;
            atributos.Proposito = (string)dataSet.Tables[0].Rows[0].ItemArray[0];
            atributos.SetHorario((DateTime)dataSet.Tables[0].Rows[0].ItemArray[1], conexaoBD);
            atributos.UmaHora = (bool)dataSet.Tables[0].Rows[0].ItemArray[2];
            atributos.Observacoes = (string)dataSet.Tables[0].Rows[0].ItemArray[3];
            atributos.Status = (char)dataSet.Tables[0].Rows[0].ItemArray[4];
            atributos.SetEmailMedico((string)dataSet.Tables[0].Rows[0].ItemArray[5], conexaoBD);
            atributos.SetEmailPaciente((string)dataSet.Tables[0].Rows[0].ItemArray[6], conexaoBD);
            atributos.Satisfacao = (int)dataSet.Tables[0].Rows[0].ItemArray[7];
            atributos.Comentario = (string)dataSet.Tables[0].Rows[0].ItemArray[8];
            atributos.HorarioSatisfacao = (DateTime)dataSet.Tables[0].Rows[0].ItemArray[9];
            atributos.MedicoJahViuSatisfacao = (bool)dataSet.Tables[0].Rows[0].ItemArray[10];

            return atributos;
        }

        public static AtributosConsultaCod[] ConsultasOcorrendoEmHorarioEspecifico(DateTime horario, 
            string emailMedico, string emailPaciente, ConexaoBD conexaoBD)
        {
            DateTime horarioRedondo = new DateTime(horario.Year, horario.Month, horario.Day,
                horario.Hour, (horario.Minute < 30) ? 0 : 30, 0);
            return Consulta.AuxConsultasOcorrendoEmHorario(horarioRedondo, false, emailMedico, emailPaciente, conexaoBD);
        }

        public static AtributosConsultaCod[] ConsultasOcorrendoEmHorarioOutraConsulta(AtributosConsulta atributosConsulta,
            string emailMedico, string emailPaciente, ConexaoBD conexaoBD)
        {
            return Consulta.AuxConsultasOcorrendoEmHorario(atributosConsulta.Horario, atributosConsulta.UmaHora, 
                emailMedico, emailPaciente, conexaoBD);
        }

        protected static AtributosConsultaCod[] AuxConsultasOcorrendoEmHorario(DateTime horarioRedondo, bool umaHora, 
            string emailMedico, string emailPaciente, ConexaoBD conexaoBD)
        {
            DateTime horarioConsultaDe1HAntes;
            if (horarioRedondo.Minute == 0)
                horarioConsultaDe1HAntes = new DateTime(horarioRedondo.Year, horarioRedondo.Month, 
                    horarioRedondo.Day, horarioRedondo.Hour - 1, 30, 0);
            else
                horarioConsultaDe1HAntes = new DateTime(horarioRedondo.Year, horarioRedondo.Month,
                    horarioRedondo.Day, horarioRedondo.Hour, 0, 0);

            string cmdSelect = "select codConsulta, proposito, horario, umaHora, observacoes, status, " +
                "emailMedico, emailPac, satisfacao, comentario, horarioSatisfacao from consulta where ";
            if (!String.IsNullOrEmpty(emailMedico))
                cmdSelect += " emailMedico = '" + emailMedico + "' and ";
            if (!String.IsNullOrEmpty(emailPaciente))
                cmdSelect += " emailPac = '" + emailPaciente + "' and ";
            cmdSelect += " (horario = '" + horarioRedondo + "' " +
            " or (horario = '" + horarioConsultaDe1HAntes + "' and umaHora = 1)";
            if (umaHora)
            {
                DateTime horarioConsultaDe1HoraDepois = new DateTime(horarioRedondo.Year, horarioRedondo.Month,
                    horarioRedondo.Day, (horarioRedondo.Minute==0)?horarioRedondo.Hour:horarioRedondo.Hour+1,
                    (horarioRedondo.Minute==0)?30:0, 0);
                cmdSelect += " or horario = '" + horarioConsultaDe1HoraDepois + "'";
            }
            cmdSelect += ")";

            DataSet dadosConsulta = conexaoBD.ExecuteSelect(cmdSelect);
            if (dadosConsulta.Tables[0].Rows.Count <= 0)
                return null;

            AtributosConsultaCod[] atributosConsultas = new AtributosConsultaCod[dadosConsulta.Tables[0].Rows.Count];
            for (int i = 0; i<dadosConsulta.Tables[0].Rows.Count; i++)
            {
                atributosConsultas[i] = new AtributosConsultaCod();
                atributosConsultas[i].CodConsulta = (int)dadosConsulta.Tables[0].Rows[i].ItemArray[0];
                atributosConsultas[i].Proposito = (string)dadosConsulta.Tables[0].Rows[i].ItemArray[1];
                atributosConsultas[i].SetHorario((DateTime)dadosConsulta.Tables[0].Rows[i].ItemArray[2], conexaoBD);
                atributosConsultas[i].UmaHora = (bool)dadosConsulta.Tables[0].Rows[i].ItemArray[3];
                atributosConsultas[i].Observacoes = (string)dadosConsulta.Tables[0].Rows[i].ItemArray[4];
                atributosConsultas[i].Status = (char)dadosConsulta.Tables[0].Rows[i].ItemArray[5];
                atributosConsultas[i].SetEmailMedico((string)dadosConsulta.Tables[0].Rows[i].ItemArray[6], conexaoBD);
                atributosConsultas[i].SetEmailPaciente((string)dadosConsulta.Tables[0].Rows[i].ItemArray[7], conexaoBD);
                atributosConsultas[i].Satisfacao = (int)dadosConsulta.Tables[0].Rows[i].ItemArray[8];
                atributosConsultas[i].Comentario = (string)dadosConsulta.Tables[0].Rows[i].ItemArray[9];
                atributosConsultas[i].HorarioSatisfacao = (DateTime)dadosConsulta.Tables[0].Rows[i].ItemArray[10];
            }

            return atributosConsultas;
        }

        public static AtributosConsultaCod[] ConsultasDe(string email, bool ehMedico, bool ordenarPorSatisfacao, ConexaoBD conexaoBD)
        {
            DataSet dataSet = conexaoBD.ExecuteSelect("select codConsulta, proposito, horario, umaHora, observacoes, status, " +
                "emailMedico, emailPac, satisfacao, comentario, horarioSatisfacao, medicoJahViuSatisfacao from consulta " +
                "where " + (ehMedico?"emailMedico":"emailPac") +" = '" + email + "' order by "
                + (ordenarPorSatisfacao? "horarioSatisfacao" : "horario") + " desc");

            if (dataSet.Tables[0].Rows.Count <= 0)
                return null;

            AtributosConsultaCod[] atributos = new AtributosConsultaCod[dataSet.Tables[0].Rows.Count];
            for (int i = 0; i<atributos.Length; i++)
            {
                atributos[i] = new AtributosConsultaCod();
                atributos[i].CodConsulta = (int)dataSet.Tables[0].Rows[0].ItemArray[0];
                atributos[i].Proposito = (string)dataSet.Tables[0].Rows[0].ItemArray[1];
                atributos[i].SetHorario((DateTime)dataSet.Tables[0].Rows[0].ItemArray[2], conexaoBD);
                atributos[i].UmaHora = (bool)dataSet.Tables[0].Rows[0].ItemArray[3];
                if (dataSet.Tables[0].Rows[0].ItemArray[4] != System.DBNull.Value)
                    atributos[i].Observacoes = (string)dataSet.Tables[0].Rows[0].ItemArray[4];
                atributos[i].Status = ((string)dataSet.Tables[0].Rows[0].ItemArray[5])[0];
                atributos[i].SetEmailMedico((string)dataSet.Tables[0].Rows[0].ItemArray[6], conexaoBD);
                atributos[i].SetEmailPaciente((string)dataSet.Tables[0].Rows[0].ItemArray[7], conexaoBD);
                if (dataSet.Tables[0].Rows[0].ItemArray[8] != System.DBNull.Value)
                    atributos[i].Satisfacao = (int)dataSet.Tables[0].Rows[0].ItemArray[8];
                if (dataSet.Tables[0].Rows[0].ItemArray[9] != System.DBNull.Value)
                    atributos[i].Comentario = (string)dataSet.Tables[0].Rows[0].ItemArray[9];
                if (dataSet.Tables[0].Rows[0].ItemArray[10] != System.DBNull.Value)
                    atributos[i].HorarioSatisfacao = (DateTime)dataSet.Tables[0].Rows[0].ItemArray[10];
                if (dataSet.Tables[0].Rows[0].ItemArray[11] != System.DBNull.Value)
                    atributos[i].MedicoJahViuSatisfacao = (bool)dataSet.Tables[0].Rows[0].ItemArray[11];
            }

            return atributos;
        }

    }
}