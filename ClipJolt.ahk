#NoEnv
#SingleInstance force
SendMode Input
Process, Priority,, High
#Persistent
loop, 10
{
	if A_Index == 0
		continue
	IniRead, Clip%A_Index%, %A_ScriptDir%\Data.ini, ClipMng, Clip%A_Index%
}

Global ClipAll:=[]
Global NameClip:=[]
Loop, 10
{
	if !(Clip%A_Index% == "ERROR")
	{
		ClipAll[A_Index] := Var:=RegExReplace(Clip%A_Index%,"/<%~","`n")
	}
}
Menu, MyMenu, Add , temp, try

ReconstructClipboard()
	OnClipboardChange("ClipChanged")
return

;hotkey configurado
Ctrl & Capslock::
Gosub, OrderClipboard
return


ClipChanged(Type){
ReconstructClipboard()
}


ReconstructClipboard()
{
	Menu, MyMenu, Delete
	If (clipboard <> Clip1)
	{
		i:=10
		j:=i-1
		Loop, 9
		{
			ClipAll[i]:=ClipAll[j] , Temp:=RegExReplace(ClipAll[i],"(\n|\r)","/<%~")
			IniWrite, %Temp%, %A_ScriptDir%\Data.ini, ClipMng, Clip%i%
			j--
			i--
		}
		ClipAll[1]:=clipboard, Temp:=RegExReplace(clipboard,"(\n|\r)","/<%~")
		IniWrite, %Temp%, %A_ScriptDir%\Data.ini, ClipMng, Clip%i%
	}

	Loop, 10
	{
		if ((StrLen(ClipAll[A_Index])) >= 40){
			Name:=NameClip[A_Index] , Clip:=ClipAll[A_Index]
			StringLeft,  Name, Clip, 40
			Name.=" ..."
			Menu, MyMenu, Add , %Name%, PasteSelected
		} Else {
			Name:=ClipAll[A_Index]
			Menu, MyMenu, Add , %Name%, PasteSelected
		}

	}
}

OrderClipboard:
Menu, MyMenu, Show
return

try(){
 easter := 1
}

PasteSelected(x)
{
	Clipboard:=x
	Send, ^v
}
