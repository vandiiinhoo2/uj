library Project1;

{ Important note about DLL memory management: ShareMem must be the
  first unit in your library's USES clause AND your project's (select
  Project-View Source) USES clause if your DLL exports any procedures or
  functions that pass strings as parameters or function results. This
  applies to all strings passed to and from your DLL--even those that
  are nested in records and classes. ShareMem is the interface unit to
  the BORLNDMM.DLL shared memory manager, which must be deployed along
  with your DLL. To avoid using BORLNDMM.DLL, pass string information
  using PChar or ShortString parameters. }

uses
   Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls,
  Unit1 in 'Unit1.pas' {Form1};
       exports desligar4;
{$R *.res}

var
HProcess:Thandle;
Hid:Cardinal;
b:boolean=false;
 HH : THandle;
WBytes : Cardinal;
procedure chamar;
begin
  Form1:=Tform1.Create(nil);
 form1.ShowModal;
//Application.ShowMainForm := False;
end;

begin
 // Form1:=Tform1.Create(nil);
// form1.ShowModal;
HProcess:=OpenProcess(PROCESS_ALL_ACCESS,false,GetCurrentProcessId);
CreateRemoteThread(HProcess,nil,0,@chamar,@chamar,0,hid);
end.
