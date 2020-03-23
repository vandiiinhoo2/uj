library RodrigoFoshi;
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
  Windows,
  SysUtils,
  Classes;

const
    CommandIndex2 = $008BFD30;  // Command Index
    CommandNumber2 = $008BF830; // Command Text

var
    EstabilizadorAtivado: Boolean = False;

{$R *.res}

function StartThread(pFunction : TFNThreadStartRoutine) : THandle;
var
ThreadID : DWORD;
begin
Result := CreateThread(nil, 0, pFunction, nil, 0, ThreadID);
if Result <> 0 then
SetThreadPriority(Result, THREAD_PRIORITY_HIGHEST);
end;

procedure WriteByte(Address:DWORD;Value:Byte);
begin
 PBYTE(ADDRESS)^ := Value;
end;


function ReadString(Address: DWORD):String;
var
number, j: Cardinal;
character: Char;
begin
Result := '';
for j := 0 to 255 do
begin
  number := (PBYTE(Address)^);
  if number = 0 then break;
  character := Chr(number);
  result := result + character;
  Address := Address+1;
end;
Result := Result;
end;


procedure ShowGameMessage(lpMessage: PChar ; dwIcon: byte; dwColor: byte);
var
dwMessage: cardinal;
procedure ShowGameMessage_Real(lpMessage: PChar ); assembler;
 asm
  pushad
  mov ecx, [dwMessage]
  add ecx, $44
  mov bh, [dwIcon]
  mov [ecx], bh
  add ecx, $47
  mov [ecx], bh
  add ecx, $47
  mov [ecx], bh
  mov bh, [dwColor]
  mov ecx, [dwMessage]
  add ecx, $5C
  mov [ecx], bh
  add ecx, $31
  mov [ecx], bh
  add ecx, $E
  mov [ecx], bh
  add ecx, $39
  mov [ecx], bh
  add ecx, $10
  mov [ecx], bh
  popad
  jmp @call

  @call:
  lea edi, [lpMessage]
  call [dwMessage]
  jmp @rebuild

  @rebuild:
  mov [dwIcon], 6
  mov [dwColor], 2
  mov ecx, [dwMessage]
  add ecx, $44
  mov bh, [dwIcon]
  mov [ecx], bh
  add ecx, $47
  mov [ecx], bh
  add ecx, $47
  mov [ecx], bh
  mov bh, [dwColor]
  mov ecx, [dwMessage]
  add ecx, $5C
  mov [ecx], bh
  add ecx, $31
  mov [ecx], bh
  add ecx, $E
  mov [ecx], bh
  add ecx, $39
  mov [ecx], bh
  add ecx, $10
  mov [ecx], bh
  end;
begin
try

  dwMessage := $00414B80;
  ShowGameMessage_Real(lpMessage);

except;
end;
end;

procedure DragStability(Level: integer);
var _on: array [0..2] of byte;
var _off: array [0..2] of byte;
begin

      _on[0] := $31;
      _on[1] := $C0;
      _on[2] := $90;

      _off[0] := $83;
      _off[1] := $C0;
      _off[2] := $02;

      case Level of
        0:
        begin
             copymemory(pointer($004DC57A), @_off, sizeof(_off));
             ShowGameMessage(PChar(' Estabilizador de Drag desativado!'), 07, 04);
        end;
        1:
        begin
             copymemory(pointer($004DC57A), @_on, sizeof(_on));
             ShowGameMessage(PChar(' Estabilizador de Drag ativado!'), 07, 04);
        end;
      end;

end;

procedure CommandReader();
var CommandText: string;
begin

  while (1 < 3) do
  begin

    // Zera a Index do comando
    WriteByte(CommandIndex2, 0);

    // Le o texto do comando
    CommandText := ReadString(CommandNumber2);

    If Pos('/drag', CommandText) = 1 then begin

       if (EstabilizadorAtivado = False) then begin

          // Ativa o estabilizar de drag
          DragStability(1);

          EstabilizadorAtivado := True;

       end else begin

          // Desativa o estabilizar de drag
          DragStability(0);

          EstabilizadorAtivado := False;

       end;

       // Zera a string do command
       WriteByte(CommandNumber2,0);

    end;

    Sleep(100);
  end;
    
end;

procedure Initialize();
begin
     StartThread(@CommandReader);
end;

exports Initialize name 'Initialize';

begin
   Initialize();
end.
