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
            DataSet dataSet = conexaoBD.ExecuteSelect("select codConsulta, proposito, horario, umaHora, observacoes, status, " +
                "emailMedico, emailPac, satisfacao, comentario, horarioSatisfacao, medicoJahViuSatisfacao " +
                "from consulta where codConsulta = " + codConsulta);

            if (dataSet.Tables[0].Rows.Count != 1)
                return null;

            AtributosConsultaCod atributos = Consulta.AtributosConsultaFromDataSet(dataSet, 0, conexaoBD);

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
                atributosConsultas[i] = Consulta.AtributosConsultaFromDataSet(dadosConsulta, i, conexaoBD);

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
                atributos[i] = Consulta.AtributosConsultaFromDataSet(dataSet, i, conexaoBD);

            return atributos;
        }

        public static AtributosConsultaCod[] TodasAsConsultas (ConexaoBD conexaoBD)
        {
            DataSet dataSet = conexaoBD.ExecuteSelect("select codConsulta, proposito, horario, umaHora, observacoes, status, " +
               "emailMedico, emailPac, satisfacao, comentario, horarioSatisfacao, medicoJahViuSatisfacao from consulta " +
                "order by horario desc");

            if (dataSet.Tables[0].Rows.Count <= 0)
                return null;

            AtributosConsultaCod[] atributos = new AtributosConsultaCod[dataSet.Tables[0].Rows.Count];
            for (int i = 0; i < atributos.Length; i++)                        
                atributos[i] = Consulta.AtributosConsultaFromDataSet(dataSet, i, conexaoBD);                                

            return atributos;
        }

        protected static AtributosConsultaCod AtributosConsultaFromDataSet(DataSet dataSet, int i, ConexaoBD conexaoBD)
        {
            AtributosConsultaCod atributos = new AtributosConsultaCod();
            atributos.CodConsulta = (int)dataSet.Tables[0].Rows[i].ItemArray[0];
            atributos.Proposito = (string)dataSet.Tables[0].Rows[i].ItemArray[1];
            atributos.SetHorario((DateTime)dataSet.Tables[0].Rows[i].ItemArray[2], conexaoBD);
            atributos.UmaHora = (bool)dataSet.Tables[0].Rows[i].ItemArray[3];
            if (dataSet.Tables[0].Rows[i].ItemArray[4] != System.DBNull.Value)
                atributos.Observacoes = (string)dataSet.Tables[0].Rows[i].ItemArray[4];
            atributos.Status = ((string)dataSet.Tables[0].Rows[i].ItemArray[5])[0];
            atributos.SetEmailMedico((string)dataSet.Tables[0].Rows[i].ItemArray[6], conexaoBD);
            atributos.SetEmailPaciente((string)dataSet.Tables[0].Rows[i].ItemArray[7], conexaoBD);
            if (dataSet.Tables[0].Rows[i].ItemArray[8] != System.DBNull.Value)
                atributos.Satisfacao = (int)dataSet.Tables[0].Rows[i].ItemArray[8];
            if (dataSet.Tables[0].Rows[i].ItemArray[9] != System.DBNull.Value)
                atributos.Comentario = (string)dataSet.Tables[0].Rows[i].ItemArray[9];
            if (dataSet.Tables[0].Rows[i].ItemArray[10] != System.DBNull.Value)
                atributos.HorarioSatisfacao = (DateTime)dataSet.Tables[0].Rows[i].ItemArray[10];
            if (dataSet.Tables[0].Rows[i].ItemArray[11] != System.DBNull.Value)
                atributos.MedicoJahViuSatisfacao = (bool)dataSet.Tables[0].Rows[i].ItemArray[11];

            return atributos;
        }

    }
}