#NoEnv
SendMode Input
SetWorkingDir %A_ScriptDir%
#SingleInstance Force
#Include %A_ScriptDir%\functions2.ahk


; Credits: austealzz, ronkzinho, Ravalle/Joe for leting me use most of the code :D
; Version 0.1

#Include %A_ScriptDir%\settings.ahk


; Please dont touch this
global onpreview := 0
global lastReset := 0
global mcDir := StrReplace(savesDirectory, "saves\", "")
global settings := []


savesDirectory := RegExReplace(savesDirectory, "saves(\/|\\)*", "saves\")

SetKeyDelay, 0

if !FileExist("pastLogs")
    Log("pastLogs folder missing! creating one")
    FileCreateDir, %A_ScriptDir%\pastLogs

IfNotExist, %savesDirectory%
   msgBox, Please set your saves directory!!!

IfNotExist, %savesDirectory%_oldWorlds
FileCreateDir, %savesDirectory%_oldWorlds

Icon = %A_ScriptDir%/media/3x.ico
if (FileExist(Icon))
    Menu, Tray, Icon, %Icon%
    Menu, Tray, Tip, SingleInstance Macro Manager

If (MessageBox){
   MsgBox, Press Control P to widen your game, Control L to make your game tall to fix your blockentities
   WinActivate, Minecraft* 1.16.1
}

GetControls()
GetSettings()
StartupLog()

OnExit("IfExit")

IfExit(){
    Log("Exited by user")
    FileMoveDir, log.log, %A_ScriptDir%\pastLogs\%A_Now%.log, R
}


Widen() {
    newHeight := Floor(A_ScreenHeight / 2.5)
    yPos := (A_ScreenHeight/2) - (newHeight/2)
    WinMaximize, Minecraft*
    WinRestore, Minecraft*
    Sleep, 200
    WinMove, Minecraft*,, 0, %yPos%, %A_ScreenWidth%, %newHeight%
}


CheckLogs(key)
{
   logFile := StrReplace(savesDirectory, "saves\", "logs\latest.log")
   numLines := 0
   found := False
   
   Loop, Read, %logFile%
   {
      numLines += 1
   }
   Loop, Read, %logFile%
   {
      if ((numLines - A_Index) < 1)
      {
         if (InStr(A_LoopReadLine, key)){
            found := True
         }
      }
   }

   return found
}

CheckJoinedWorld()
{
      WinGetTitle, McTitle, Minecraft*
      return InStr(McTitle, "-")
}

Tallen() {
    newHeight := (A_ScreenHeight / 2.5)
    yPos := (A_ScreenHeight / 110) - (newHeight / 110)
    WinMove, Minecraft*,, 0,%yPos%, %newHeight%, %A_ScreenWidth%
}

Reset()
{
    atumResetKey := settings["key_CreateNewWorld"]
    lastReset := A_NowUTC
    SetTimer, waitForGame, Off
    ControlSend,, {%atumResetKey%}, Minecraft
    Log("Reset triggered by user")
    CountReset("ATTEMPTS_DAY")
    CountReset("ATTEMPTS_WHOLE")
    if (ResetSounds){
        ResetSound()
    }
}


CheckPreview()
{
   return CheckLogs("Starting Preview at ")
}

Move()
{
	Loop, Files, %savesDirectory%*, D
   {
     _Check :=SubStr(A_LoopFileName,1,1)
      If (_Check!="_")
      {
        FileMoveDir, %savesDirectory%%A_LoopFileName%, %savesDirectory%_oldWorlds\%A_LoopFileName%%A_NowUTC%, R
      }
   }
}


inFullscreen()
{
   optionsFile := StrReplace(savesDirectory, "saves\", "options.txt")
   FileReadLine, fullscreenLine, %optionsFile%, 17
   if (InStr(fullscreenLine, "true"))
      return 1
   else
      return 0
}


Setup()
{  
   SetTimer, waitForGame, Off
   Loop
   {
      if (A_NowUTC - lastReset >= 20)
      {
         SetTimer, waitForGame, Off
         onpreview := False
         break
         return
      }
      if (CheckPreview()){
         onpreview := True
         ControlSend,, {F3 down}{Esc}{F3 up}, Minecraft
         SetTimer, waitForGame, 20
         break
      }
      else if (A_NowUTC - lastReset >= 5 && CheckJoinedWorld()){
         WideResetting()
         break
         return
      }
   }
   Until onpreview
}


GetSettings() {
    Loop, Read, %mcDir%/options.txt
    {
        line := A_LoopReadLine
        if (!InStr(line, "key")) {
            kv := StrSplit(line, ":")
            if (kv.MaxIndex() == 2) {
                key := kv[1]
                value := kv[2]
                StringReplace, key, key, %A_Space%,, All
                StringReplace, value, value, %A_Space%,, All
                settings[key] := value
            }
        }
    }
}


ResetSound()
{
   SoundPlay, %A_ScriptDir%\media\reset.wav
}


ResetUsingLan()
{
   ControlSend,, {Esc}{Tab 7}{Enter}{Tab 4}{Enter}{Tab}{Enter}, Minecraft
   ControlSend,, {f3 down}{n}{f3 up}, Minecraft
   Sleep, 100
   Send, {t}
   Sleep, 100
   Send, {/}
   Send, locate buried_treasure{Enter}
   Sleep, 100
   Send, {t}
   Sleep, 100
   Send, {/}
   Send, locate shipwreck{Enter}
}

if (readySound){
    SoundPlay, %A_ScriptDir%\media\ready.wav
    Sleep, 500
    Log("Macro Ready and probably properly working")
}

waitForGame:
   if (lastReset == "") {
      SetTimer, waitForGame, Off
      return
   }
   if (A_NowUTC - lastReset >= 60)
   {
      onpreview := False
      SetTimer, waitForGame, Off
   }
   if (CheckJoinedWorld() && onpreview)
   {
      WideResetting()
      Log("World Gen Finished & onpreview := 0")
      onpreview := False
   }
   return

SetTimer, waitForGame, Off

#Include, hotkeys.ahk
