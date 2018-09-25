using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;

namespace ProjetoPPI
{
    public class ConexaoBD
    {
        private SqlConnection con;
        private string connectionString;

        //CRIAR/INICIAR
        public ConexaoBD()
        { }

        public ConexaoBD(string connectionStr)
        {
            this.connectionString = connectionStr;
            this.AbrirConexao();
        }

        public string ConnectionString
        {
            get
            {
                return this.connectionString;
            }
        }

        protected void AbrirConexao()
        {
            if (this.con == null || this.con.ConnectionString != this.connectionString)
                con = new SqlConnection(this.connectionString);
            con.Open();
        }


        //GETTERS and SETTERS
        public SqlConnection Connection
        {
            get
            {
                return this.con;
            }
        }


        //CONSULTAS
        public DataSet ExecuteSelect(string sql)
        {
            if (String.IsNullOrEmpty(sql))
                throw new Exception("Comando SQL vazio.");

            if (this.con == null || this.con.State == ConnectionState.Closed)
                throw new Exception("Conexao fechada");

            SqlCommand cmd = new SqlCommand(sql, this.con);
            SqlDataAdapter adapt = new SqlDataAdapter(cmd);
            DataSet ds = new DataSet();

            adapt.Fill(ds);

            return ds;
        }
        
        public object ExecuteScalarSelect(string sqlStr)
        {
            if (String.IsNullOrEmpty(sqlStr))
                throw new Exception("Comando vazio");

            if (this.con == null || this.con.State == ConnectionState.Closed)
                throw new Exception("Conexao fechada");

            SqlCommand cmd = new SqlCommand(sqlStr, this.con);

            try
            {
                return cmd.ExecuteScalar();
            }
            catch (Exception e)
            {
                return -1;
            }
        }

        public int ExecuteInUpDel(string sql)
        {
            if (String.IsNullOrEmpty(sql))
                throw new Exception("Comando nulo");

            if (this.con == null || this.con.State == ConnectionState.Closed)
                throw new Exception("Conexao fechada");

            SqlCommand cmd = new SqlCommand(sql, this.con);
            try
            {
                return cmd.ExecuteNonQuery();
            }
            catch (Exception e)
            {
                return -1;
            }
        }


        //FECHAR
        public void FecharConexao()
        {
            this.con.Close();
        }

    }
}