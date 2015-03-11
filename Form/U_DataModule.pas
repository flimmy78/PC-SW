unit U_DataModule;

interface

uses
  SysUtils, Classes, DB, ADODB;

type
  TF_DataModule = class(TDataModule)
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  F_DataModule: TF_DataModule;

implementation

{$R *.dfm}

end.
