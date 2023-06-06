using DevExpress.XtraReports.UI;
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
            HOTEN.Text = "Tài khoản: " + Program.mHoTen;
            NHOM.Text = "Quền: " + Program.mGroup;
            // Phân quyền
            ribbonPageNhapXuat.Visible = true;
            barButtonItemDangXuat.Enabled = true;
            barButtonItemDangNhap.Enabled = false;
            if (Program.mGroup == "USER")
            {
                btn_backup.Enabled = false;
                btn_restore.Enabled = false;
                ribbonPageBaoCao.Visible  = false;

            }
            else
            {
                ribbonPageBaoCao.Visible = true;
                btn_backup.Enabled = true;
                btn_restore.Enabled = true;
            }
        }


        private void ribbonControl1_Click(object sender, EventArgs e)
        {

        }

        private void barButtonItem7_ItemClick(object sender, DevExpress.XtraBars.ItemClickEventArgs e)
        {
            Form form = this.CheckExists(typeof(FormBackup));
            {
                if (form != null) form.Activate();
                else
                {
                    FormBackup f = new FormBackup();
                    f.MdiParent = this;
                    f.Show();
                }
            }
        }
        private void DangXuat()
        {
            foreach (Form f in this.MdiChildren)
            {
                f.Close();
                f.Dispose();
            }
            HOTEN.Text = "HOTEN";
            NHOM.Text = "NHOM";
            Program.conn.Close();

        }
        private void barButtonItem4_ItemClick(object sender, DevExpress.XtraBars.ItemClickEventArgs e)
        {

                DangXuat();
                ribbonPageBaoCao.Visible = ribbonPageNhapXuat.Visible = false;
                barButtonItemDangXuat.Enabled = btn_backup.Enabled= btn_restore.Enabled = false;
                barButtonItemDangNhap.Enabled = true;

     
        }

        private void strip_ItemClicked(object sender, ToolStripItemClickedEventArgs e)
        {

        }

        private void FormMain_Load(object sender, EventArgs e)
        {

        }

        private void dieukhac_tactuong_btn_ItemClick(object sender, DevExpress.XtraBars.ItemClickEventArgs e)
        {

        }



        private void barButtonItem10_ItemClick(object sender, DevExpress.XtraBars.ItemClickEventArgs e)
        {
            Form form = this.CheckExists(typeof(FormXuatXu));
            {
                if (form != null) form.Activate();
                else
                {
                    FormXuatXu f = new FormXuatXu();
                    f.MdiParent = this;
                    f.Show();
                }
            }
        }

        private void TacGia__btn_ItemClick(object sender, DevExpress.XtraBars.ItemClickEventArgs e)
        {
            Form form = this.CheckExists(typeof(FormTG));
            {
                if (form != null) form.Activate();
                else
                {
                    FormTG f = new FormTG();
                    f.MdiParent = this;
                    f.Show();
                }
            }
        }

        private void bosuutap_btn_ItemClick(object sender, DevExpress.XtraBars.ItemClickEventArgs e)
        {
            Form form = this.CheckExists(typeof(FormBoSuuTam));
            {
                if (form != null) form.Activate();
                else
                {
                    FormBoSuuTam f = new FormBoSuuTam();
                    f.MdiParent = this;
                    f.Show();
                }
            }
        }

        private void tp_nghethuat_btn_ItemClick(object sender, DevExpress.XtraBars.ItemClickEventArgs e)
        {
            Form form = this.CheckExists(typeof(FormTacPhamNgheThuat));
            {
                if (form != null) form.Activate();
                else
                {
                    FormTacPhamNgheThuat f = new FormTacPhamNgheThuat();
                    f.MdiParent = this;
                    f.Show();
                }
            }
        }

        private void trien_lam_btn_ItemClick(object sender, DevExpress.XtraBars.ItemClickEventArgs e)
        {
            Form form = this.CheckExists(typeof(FormTrienLam));
            {
                if (form != null) form.Activate();
                else
                {
                    FormTrienLam f = new FormTrienLam();
                    f.MdiParent = this;
                    f.Show();
                }
            }
        }

        private void rp_tacgia_ItemClick(object sender, DevExpress.XtraBars.ItemClickEventArgs e)
        {
            XtraReportTacGia rpt = new XtraReportTacGia();
            rpt.sqlTacGiaDS.Connection.ConnectionString = Program.connstr;
            ReportPrintTool print = new ReportPrintTool(rpt);
            print.ShowPreviewDialog();
        }

        private void rp_tpnt_ItemClick(object sender, DevExpress.XtraBars.ItemClickEventArgs e)
        {
            XtraReportTPNT rpt = new XtraReportTPNT();
            rpt.sqlTPNTDS.Connection.ConnectionString = Program.connstr;
            ReportPrintTool print = new ReportPrintTool(rpt);
            print.ShowPreviewDialog();
        }

        private void rp_trienlam_ItemClick(object sender, DevExpress.XtraBars.ItemClickEventArgs e)
        {
            Form form = this.CheckExists(typeof(FormReportTrienLam));
            {
                if (form != null) form.Activate();
                else
                {
                    FormReportTrienLam f = new FormReportTrienLam();
                    f.MdiParent = this;
                    f.Show();
                }
            }
        }

        private void btn_restore_ItemClick(object sender, DevExpress.XtraBars.ItemClickEventArgs e)
        {
            Form form = this.CheckExists(typeof(FormRestore));
            {
                if (form != null) form.Activate();
                else
                {
                    FormRestore f = new FormRestore();
                    f.MdiParent = this;
                    f.Show();
                }
            }
        }
    }
}
