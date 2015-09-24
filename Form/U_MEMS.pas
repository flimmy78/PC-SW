unit U_MEMS;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Grids, Buttons, ExtCtrls;

type
  TF_MEMS = class(TForm)
    scrlbx1: TScrollBox;
    scrlbx3: TGroupBox;
    lbl_hard: TLabel;
    lbl_soft: TLabel;
    btn_restore_defaults: TBitBtn;
    edt_sys_time: TEdit;
    btn_write_para: TButton;
    chk_sys_time: TCheckBox;
    chk_version: TCheckBox;
    edt_hardware_version: TEdit;
    edt_software_version: TEdit;
    chk_all: TCheckBox;
    scrlbx2: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    edt_cal_read_grp2: TEdit;
    edt_cal_write_grp1: TEdit;
    edt_cal_read_grp4: TEdit;
    edt_cal_read_grp3: TEdit;
    edt_cal_read_grp1: TEdit;
    edt_cal_write_grp2: TEdit;
    edt_cal_write_grp3: TEdit;
    edt_cal_write_grp4: TEdit;
    btn_cal_save_grp1: TButton;
    btn_cal_save_grp2: TButton;
    btn_cal_save_grp3: TButton;
    btn_cal_save_grp4: TButton;
    Label5: TLabel;
    edt_cal_read_grp5: TEdit;
    edt_cal_write_grp5: TEdit;
    btn_cal_save_grp5: TButton;
    btn_cal_read_para: TBitBtn;
    btn_read_para: TBitBtn;
    GroupBox1: TGroupBox;
    btn_load: TButton;
    btn_cancel: TButton;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  F_MEMS: TF_MEMS;

implementation

{$R *.dfm}

end.
