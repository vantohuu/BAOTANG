using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Windows.Forms;



namespace QLVT
{
    public partial class FormMain : DevExpress.XtraBars.Ribbon.RibbonForm
    {
        public FormMain()
        {
            InitializeComponent();
        }

        private void toolStripStatusLabel1_Click(object sender, EventArgs e)
        {

        }

        private void barEditItem1_ItemClick(object sender, DevExpress.XtraBars.ItemClickEventArgs e)
        {

        }

        private Form CheckExists(Type ftype)
        {
            foreach (Form f in this.MdiChildren)
                if (f.GetType() == ftype)
                    return f;
            return null;
        }
        private void barButtonItem3_ItemClick(object sender, DevExpress.XtraBars.ItemClickEventArgs e)
        {
            Form form = this.CheckExists(typeof(FormDangNhap));
            {
                if (form != null) form.Activate();
                else
                {
                    FormDangNhap f = new FormDangNhap();
                    f.MdiParent = this;
                    f.Show();
                }
            }
        }

        public void HienThiMenu()
        {
            MANV.Text = "Mã NV: " + Program.username;
            HOTEN.Text = "Họ tên nhân viên: " + Program.mHoTen;
            NHOM.Text = "Nhóm: " + Program.mGroup;
            // Phân quyền
            ribbonPageBaoCao.Visible = ribbonPageNhapXuat.Visible = true;

            /// tiep tuc phan quuyen ....
        }
 

        private void ribbonControl1_Click(object sender, EventArgs e)
        {

        }

        private void barButtonItem7_ItemClick(object sender, DevExpress.XtraBars.ItemClickEventArgs e)
        {

        }

        private void barButtonItem4_ItemClick(object sender, DevExpress.XtraBars.ItemClickEventArgs e)
        {

        }

        private void strip_ItemClicked(object sender, ToolStripItemClickedEventArgs e)
        {

        }
    }
}
