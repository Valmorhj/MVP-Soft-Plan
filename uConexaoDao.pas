unit uConexaoDao;

interface

uses
  System.SysUtils, System.Classes, FireDAC.Comp.Client, FireDAC.Stan.Def,
  FireDAC.Stan.Async, FireDAC.Phys, FireDAC.Phys.FB, FireDAC.Phys.FBDef,
  FireDAC.UI.Intf, FireDAC.VCLUI.Wait, FireDAC.Comp.UI, uViaCEPClient, System.Generics.Collections;

type
  TConexaoDAO = class
  private
    FConnection: TFDConnection;
  public
    constructor Create;
    destructor Destroy; override;

    function GetConnection: TFDConnection;
    function Connected: Boolean;
    procedure InserirListaViaCEP(ALista: TObjectList<TViaCEP>);
    procedure InserirViaCEP(AViaCEP: TViaCEP;prAtualiza : Boolean);
  end;


implementation

{ TConexaoDAO }

constructor TConexaoDAO.Create;
begin
  FConnection := TFDConnection.Create(nil);

  // Parâmetros de conexão
  FConnection.DriverName := 'FB';
  FConnection.Params.DriverID := 'FB';
  FConnection.Params.Database := 'C:\Nova pasta\MVPDB.fdb';
  FConnection.Params.UserName := 'SYSDBA';
  FConnection.Params.Password := 'masterkey';
  FConnection.Params.Add('CharacterSet=win1252');

  try
    FConnection.Connected := True;
  except
    on E: Exception do
      raise Exception.Create('Erro ao conectar ao banco: ' + E.Message);
  end;
end;

destructor TConexaoDAO.Destroy;
begin
  FConnection.Free;
  inherited;
end;

function TConexaoDAO.GetConnection: TFDConnection;
begin
  Result := FConnection;
end;

function TConexaoDAO.Connected: Boolean;
begin
  Result := FConnection.Connected;
end;

procedure  TConexaoDAO.InserirViaCEP( AViaCEP: TViaCEP;prAtualiza : Boolean);
var
  Query: TFDQuery;
begin
  Query := TFDQuery.Create(nil);
  try
    Query.Connection := FConnection;
    if prAtualiza then
      Query.SQL.Text :=
        'UPDATE TCONSULTASVIACEP SET ' +
        'BDLOGRADOURO = :logradouro, BDCOMPLEMENTO = :complemento, BDBAIRRO = :BAIRRO, ' +
        'BDLOCALIDADE = :LOCALIDADE, BDUF = :UF ' +
        'WHERE bdcep= :CEP'
    else
       Query.SQL.Text :=
       'INSERT INTO TCONSULTASVIACEP (BDCEP, BDLOGRADOURO, BDCOMPLEMENTO, BDBAIRRO, BDLOCALIDADE, BDUF) ' +
       'VALUES (:cep, :logradouro, :complemento, :bairro, :localidade, :uf)';
    Query.Params.ParamByName('cep').AsString := AViaCEP.cep;
    Query.Params.ParamByName('logradouro').AsString := AViaCEP.logradouro;
    Query.Params.ParamByName('complemento').AsString := AViaCEP.complemento;
    Query.Params.ParamByName('bairro').AsString := AViaCEP.bairro;
    Query.Params.ParamByName('localidade').AsString := AViaCEP.localidade;
    Query.Params.ParamByName('uf').AsString := AViaCEP.uf;
    Query.ExecSQL;
  finally
    Query.Free;
  end;
end;

procedure  TConexaoDAO.InserirListaViaCEP( ALista: TObjectList<TViaCEP>);
var
  ViaCEP: TViaCEP;
begin
  for ViaCEP in ALista do
    InserirViaCEP(ViaCEP,False);
end;

end.

