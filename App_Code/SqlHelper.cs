using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;

namespace MarineTravelAgency.App_Code
{
    public static class SqlHelper
    {
        private static readonly string _connectionString = ConfigurationManager.ConnectionStrings["MarineTravelDB"].ConnectionString;

        public static DataTable ExecuteQuery(string query, SqlParameter[] parameters = null, bool isStoredProcedure = false)
        {
            using (SqlConnection conn = new SqlConnection(_connectionString))
            {
                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    if (isStoredProcedure)
                        cmd.CommandType = CommandType.StoredProcedure;

                    if (parameters != null)
                    {
                        foreach (var param in parameters)
                        {
                            cmd.Parameters.Add((SqlParameter)((ICloneable)param).Clone());
                        }
                    }

                    using (SqlDataAdapter adapter = new SqlDataAdapter(cmd))
                    {
                        DataTable dt = new DataTable();
                        adapter.Fill(dt);
                        return dt;
                    }
                }
            }
        }

        public static int ExecuteNonQuery(string query, SqlParameter[] parameters = null, bool isStoredProcedure = false)
        {
            using (SqlConnection conn = new SqlConnection(_connectionString))
            {
                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    if (isStoredProcedure)
                        cmd.CommandType = CommandType.StoredProcedure;

                    if (parameters != null)
                    {
                        foreach (var param in parameters)
                        {
                            cmd.Parameters.Add((SqlParameter)((ICloneable)param).Clone());
                        }
                    }

                    conn.Open();
                    return cmd.ExecuteNonQuery();
                }
            }
        }

        public static object ExecuteScalar(string query, SqlParameter[] parameters = null, bool isStoredProcedure = false)
        {
            using (SqlConnection conn = new SqlConnection(_connectionString))
            {
                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                     if (isStoredProcedure)
                        cmd.CommandType = CommandType.StoredProcedure;

                    if (parameters != null)
                    {
                        foreach (var param in parameters)
                        {
                            cmd.Parameters.Add((SqlParameter)((ICloneable)param).Clone());
                        }
                    }

                    conn.Open();
                    return cmd.ExecuteScalar();
                }
            }
        }
    }
}
