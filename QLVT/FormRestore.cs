using DevExpress.CodeParser;
using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace QLVT
{
    public partial class FormRestore : Form
    {
        public FormRestore()
        {
            InitializeComponent();
        }

        private void FormRestore_Load(object sender, EventArgs e)
        {
            // TODO: This line of code loads data into the 'bAOTANGDataSet.RESTORE' table. You can move, or remove it, as needed.
            this.RSTA.Fill(this.BAOTANGDS.RESTORE);
            BAOTANGDS.EnforceConstraints = false;
            this.RSTA.Connection.ConnectionString = Program.connstr;
            this.RSTA.Fill(this.BAOTANGDS.RESTORE);
            if (RSBS.Count > 0)
            {
                DataRowView dt = ((DataRowView)RSBS[0]);
                String restore_date = dt["restore_date"].ToString();
                Console.WriteLine(restore_date);
                labelLS.Text = "(Lịch sử gần nhất:" + restore_date + ")";
            }

        }

        private void historyRS_Click(object sender, EventArgs e)
        {
            if (restoreGridControl.Visible) historyRS.Text = "Xem lịch sử";
            else historyRS.Text = "Đóng lịch sử";
            restoreGridControl.Visible = !restoreGridControl.Visible;
        }

        private void RESTORE_Click(object sender, EventArgs e)
        {
            string path = @"D:\STUDY\HK6\TTCS\baotang.bak";
            if (!File.Exists(path))
            {
                MessageBox.Show("Không tìm thấy file backup với đường dẫn D:\\STUDY\\HK6\\TTCS\\baotang.bak","", MessageBoxButtons.OK);
                return;
            }
            if (MessageBox.Show("Nếu thành công app sẽ tắt. Bạn có thực sự muốn RESTORE không!", "Xác nhận", MessageBoxButtons.OKCancel)
                 == DialogResult.OK)
            {
                try
                {
                    this.Enabled = false;
                    String query = "exec sp_Restore";
                    Program.ExecSqlNonQuery(query);
                    MessageBox.Show("Restore thành công. XONG! ", "", MessageBoxButtons.OK);
                    this.RSTA.Fill(this.BAOTANGDS.RESTORE);
                    DataRowView dt = ((DataRowView)RSBS[0]);
                    String restore_date = dt["restore_date"].ToString();
                    Console.WriteLine(restore_date);
                    labelLS.Text = "(Lịch sử gần nhất:" + restore_date + ")";
                    Application.Exit();
                    this.Enabled = true;
                }
                catch (Exception ex)
                {
                    this.Enabled = true;
                    MessageBox.Show("Lỗi restore. \n" + ex.Message, "", MessageBoxButtons.OK);
                    return;
                }
            }
        }
    }
}
