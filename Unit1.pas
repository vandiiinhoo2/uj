unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, IdBaseComponent, IdComponent, IdTCPConnection,
  IdTCPClient, IdHTTP;

type
  TForm1 = class(TForm)
    Timer1: TTimer;
    Edit1: TEdit;
    Label1: TLabel;
    IdHTTP1: TIdHTTP;
    Memo1: TMemo;
    procedure Timer1Timer(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;
 procedure Desligar4;   External'Project1.dll';
var
  Form1: TForm1;

implementation

{$R *.dfm}
    Function Crypt(Action, Src: String): String;
Label Fim;
var
  KeyLen : Integer;
  KeyPos : Integer;
  OffSet : Integer;
  Dest, Key : String;
  SrcPos : Integer;
  SrcAsc : Integer;
  TmpSrcAsc : Integer;
  Range : Integer;
  vRange: Pointer;
  vMemory: TMemoryStream;
begin
  if (Src = '') Then
  begin
    Result:= '';
  Goto Fim;
  end;
  vMemory := TMemoryStream.Create;
  vRange  := vMemory.Memory;
  Key := 'YUQL23KL23DF90WI5E1JAS467NMCXXL6JAOAUWWMCL0AOMM4A4VZYW9KHJUI2347EJHJKD'+
  'F3424SKL K3LAKDJSL9RTIKJ';
  Dest := '';
  KeyLen := Length(Key + vMemory.MethodName(vRange));
  // KeyLen := Length(Key);
  KeyPos := 0;
  SrcPos := 0;
  SrcAsc := 0;
  Range := 256;
  if (Action = UpperCase('C')) then
  begin
    Randomize;
    OffSet := Random(Range);
    Dest := Format('%1.2x',[OffSet]);
    for SrcPos := 1 to Length(Src) do
    begin
      //Application.ProcessMessages;
      SrcAsc := (Ord(Src[SrcPos]) + OffSet) Mod 255;
      if KeyPos < KeyLen then
        KeyPos := KeyPos + 1
      else
        KeyPos := 1;
      SrcAsc := SrcAsc Xor Ord(Key[KeyPos]);
      Dest   := Dest + Format('%1.2x',[SrcAsc]);
      OffSet := SrcAsc;
    end;
  end
  else if (Action = UpperCase('D')) then
  begin
    OffSet := StrToInt('$'+ copy(Src,1,2));
    SrcPos := 3;
    repeat
      SrcAsc := StrToInt('$'+ copy(Src,SrcPos,2));
    if (KeyPos < KeyLen) then
      KeyPos := KeyPos + 1
    else
      KeyPos := 1;
    TmpSrcAsc := SrcAsc xor Ord(Key[KeyPos]);
    if TmpSrcAsc <= OffSet then
      TmpSrcAsc := 255 + TmpSrcAsc - OffSet
    else TmpSrcAsc := TmpSrcAsc - OffSet;
      Dest := Dest + Chr(TmpSrcAsc);
    OffSet := SrcAsc;
    SrcPos := SrcPos + 2;
    until (SrcPos >= Length(Src));
  end;
  Result:= Dest;
  Fim:
end;
procedure TForm1.Timer1Timer(Sender: TObject);
var
   num:integer;
   Memory: DWORD;
value: dword;
begin
edit1.Clear;
memo1.Lines.Clear;
//sleep(1000);
  randomize;
  num := Round(random(99999999)); // 99999 é o limite do numero randomico
  Edit1.text:=IntToStr(num);
  Memo1.Lines.Add(Edit1.text);
    Memo1.Lines.Text := Crypt('C',Memo1.Text);
  Memo1.Lines.SaveToFile('C:\AppServ\www\anthack\versao.txt');

 Value:=strtoint(Edit1.Text);
PDWORD($004969CC)^:=Value;
end;

end.
