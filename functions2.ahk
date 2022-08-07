#NoEnv
SendMode Input
SetWorkingDir %A_ScriptDir%

#Include %A_ScriptDir%\settings.ahk

; v0.1
global settings := []
WinGet, pid, PID, Minecraft*
global rawPid := pid
mcDir := GetMcDir(rawPid)

global savesDirectory := mcDir . "saves\"

GetControls()
GetSettings()

Log(message){
            FileAppend, [%A_YYYY%-%A_MM%-%A_DD% %A_Hour%:%A_Min%:%A_Sec%] %message% `n, log.log
}

OnpreviewCheck(){ ; surely this is useful
    if (CheckJoinedWorld() && (!CheckPreview())){
        onpreview := 0
    }
    if (CheckPreview() && (!CheckJoinedWorld())){
        onpreview := 1
    }
}


for each, program in launchPrograms {
    SplitPath, program, filename, dir
    isOpen := False
    for proc in ComObjGet("winmgmts:").ExecQuery(Format("Select * from Win32_Process where CommandLine like ""%{1}%""", filename)) {
        isOpen := True
        break
    } 
    if (!isOpen)
        Run, %filename%, %dir%
}

if (OpenMinecraftLauncher)
SplitPath, filename, dir
isOpen := False
for proc in ComObjGet("winmgmts:").ExecQuery(Format("Select * from Win32_Process where CommandLine like ""%{1}%""", filename)) {
    isOpen := True
    break
} 
if (!isOpen)
    Run, %filename%, %dir%

if (FileExist(multiMCLocation . "MultiMC.exe")) {
            Run, %multiMCLocation%MultiMC.exe
} else {
   if (OpenMinecraftLauncher)
    Run, "C:\Program Files (x86)\Minecraft Launcher\Minecraft Launcher.exe"
}


GetControls() {
    atumKeyFound := False
    Loop, Read, %mcDir%/options.txt
    {
        line = %A_LoopReadLine%
        if (InStr(line, "key")) {
            kv := StrSplit(line, ":")
            if (kv.MaxIndex() == 2) {
                key = % kv[1]
                value = % kv[2]
                StringReplace, key, key, %A_Space%,, All
                StringReplace, value, value, %A_Space%,, All
                settings[key] := TranslateKey(value)
                if (key == "key_CreateNewWorld")
                    atumKeyFound := True
            }
        }
    }
    if (!atumKeyFound)
        settings["key_CreateNewWorld"] := "F6"
}

CountAttempts(attemptType) {
  file := attemptType . ".txt"
  FileRead, WorldNumber, %file%
  if (ErrorLevel)
    WorldNumber = 0
  else
    FileDelete, %file%
  WorldNumber += 1
  FileAppend, %WorldNumber%, %file%
}

VerifyMods() { ; shoutout mach
  moddir := mcDir . "mods\"
  optionsFile := mcDir . "options.txt"
  atum := false
  wp := false
  standardSettings := false
  fastReset := false
  sleepBg := false
  sodium := false
  srigt := false
  Loop, Files, %moddir%*.jar
  {
    if (InStr(A_LoopFileName, "atum"))
      atum := true
    else if (InStr(A_LoopFileName, "worldpreview"))
      wp := true
    else if (InStr(A_LoopFileName, "standardsettings"))
      standardSettings := true
    else if (InStr(A_LoopFileName, "fast-reset"))
      fastReset := true
    else if (InStr(A_LoopFileName, "sleepbackground"))
      sleepBg := true
    else if (InStr(A_LoopFileName, "sodium"))
      sodium := true
    else if (InStr(A_LoopFileName, "SpeedRunIGT"))
      srigt := true
    else if (InStr(A_LoopFileName, "krypton")) {
      Log("Directory " . moddir " has krypton, macro might slow down")
    }
  }
  if !atum {
    MsgBox, Directory %moddir% missing required mod: atum. Macro will not work. Download: https://github.com/VoidXWalker/Atum/releases
    Log("Directory " . moddir  " missing required mod: atum. Macro will not work. Download: https://github.com/VoidXWalker/Atum/releases")
  }
  if !wp {
    MsgBox, Directory %moddir% missing required mod: World Preview. Macro will likely not work. Download: https://github.com/VoidXWalker/WorldPreview/releases
    Log("Directory " . moddir  " missing required mod: World Preview. Macro will likely not work. Download: https://github.com/VoidXWalker/WorldPreview/releases")
  }
  if !standardSettings {
    MsgBox, Directory %moddir% missing highly recommended mod: standardsettings. Download: https://github.com/KingContaria/StandardSettings/releases
    Log("Directory " . moddir  " missing highly recommended mod: standardsettings. Download: https://github.com/KingContaria/StandardSettings/releases")
  }
  if !fastReset {
    Log("Directory " . moddir  " missing recommended mod fast-reset. Download: https://github.com/jan-leila/FastReset/releases")
    MsgBox, Directory %moddir% missing recommended mod fast-reset. Download: https://github.com/jan-leila/FastReset/releases
}
  if !sleepBg {
    Log("Directory " . moddir  " missing recommended mod sleepbackground. Download: https://github.com/RedLime/SleepBackground/releases")
    MsgBox, Directory %moddir% missing recommended mod sleepbackground. Download: https://github.com/RedLime/SleepBackground/releases
  }
  if !sodium {
    Log("Directory " . moddir  " missing recommended mod sodium. Download: https://github.com/jan-leila/sodium-fabric/releases")
    MsgBox, Directory %moddir% missing recommended mod sodium. Download: https://github.com/jan-leila/sodium-fabric/releases
  }
  if !srigt {
    Log("Directory " . moddir  " recommended mod SpeedRunIGT. Download: https://redlime.github.io/SpeedRunIGT/")
    MsgBox, Directory %moddir% recommended mod SpeedRunIGT. Download: https://redlime.github.io/SpeedRunIGT/
  }
}


WideResetting(){
    if (WideResets){
        WinMaximize, Minecraft*
        Sleep, 200
    }
    if (CheckJoinedWorld()){
        ControlSend,, {F3 Down}{Esc}{F3 Up}, Minecraft*
        WinMaximize, Minecraft*
        Sleep, 200
        Tallen()
    }
}

TranslateKey(mcKey) {
    static keyArray := Object("key.keyboard.f1", "F1"
    ,"key.keyboard.f2", "F2"
    ,"key.keyboard.f3", "F3"
    ,"key.keyboard.f4", "F4"
    ,"key.keyboard.f5", "F5"
    ,"key.keyboard.f6", "F6"
    ,"key.keyboard.f7", "F7"
    ,"key.keyboard.f8", "F8"
    ,"key.keyboard.f9", "F9"
    ,"key.keyboard.f10", "F10"
    ,"key.keyboard.f11", "F11"
    ,"key.keyboard.f12", "F12"
    ,"key.keyboard.f13", "F13"
    ,"key.keyboard.f14", "F14"
    ,"key.keyboard.f15", "F15"
    ,"key.keyboard.f16", "F16"
    ,"key.keyboard.f17", "F17"
    ,"key.keyboard.f18", "F18"
    ,"key.keyboard.f19", "F19"
    ,"key.keyboard.f20", "F20"
    ,"key.keyboard.f21", "F21"
    ,"key.keyboard.f22", "F22"
    ,"key.keyboard.f23", "F23"
    ,"key.keyboard.f24", "F24"
    ,"key.keyboard.q", "q"
    ,"key.keyboard.w", "w"
    ,"key.keyboard.e", "e"
    ,"key.keyboard.r", "r"
    ,"key.keyboard.t", "t"
    ,"key.keyboard.y", "y"
    ,"key.keyboard.u", "u"
    ,"key.keyboard.i", "i"
    ,"key.keyboard.o", "o"
    ,"key.keyboard.p", "p"
    ,"key.keyboard.a", "a"
    ,"key.keyboard.s", "s"
    ,"key.keyboard.d", "d"
    ,"key.keyboard.f", "f"
    ,"key.keyboard.g", "g"
    ,"key.keyboard.h", "h"
    ,"key.keyboard.j", "j"
    ,"key.keyboard.k", "k"
    ,"key.keyboard.l", "l"
    ,"key.keyboard.z", "z"
    ,"key.keyboard.x", "x"
    ,"key.keyboard.c", "c"
    ,"key.keyboard.v", "v"
    ,"key.keyboard.b", "b"
    ,"key.keyboard.n", "n"
    ,"key.keyboard.m", "m"
    ,"key.keyboard.1", "1"
    ,"key.keyboard.2", "2"
    ,"key.keyboard.3", "3"
    ,"key.keyboard.4", "4"
    ,"key.keyboard.5", "5"
    ,"key.keyboard.6", "6"
    ,"key.keyboard.7", "7"
    ,"key.keyboard.8", "8"
    ,"key.keyboard.9", "9"
    ,"key.keyboard.0", "0"
    ,"key.keyboard.tab", "Tab"
    ,"key.keyboard.left.bracket", "["
    ,"key.keyboard.right.bracket", "]"
    ,"key.keyboard.backspace", "Backspace"
    ,"key.keyboard.equal", "="
    ,"key.keyboard.minus", "-"
    ,"key.keyboard.grave.accent", "`"
    ,"key.keyboard.slash", "/"
    ,"key.keyboard.space", "Space"
    ,"key.keyboard.left.alt", "LAlt"
    ,"key.keyboard.right.alt", "RAlt"
    ,"key.keyboard.print.screen", "PrintScreen"
    ,"key.keyboard.insert", "Insert"
    ,"key.keyboard.scroll.lock", "ScrollLock"
    ,"key.keyboard.pause", "Pause"
    ,"key.keyboard.right.control", "RControl"
    ,"key.keyboard.left.control", "LControl"
    ,"key.keyboard.right.shift", "RShift"
    ,"key.keyboard.left.shift", "LShift"
    ,"key.keyboard.comma", ","
    ,"key.keyboard.period", "."
    ,"key.keyboard.home", "Home"
    ,"key.keyboard.end", "End"
    ,"key.keyboard.page.up", "PgUp"
    ,"key.keyboard.page.down", "PgDn"
    ,"key.keyboard.delete", "Delete"
    ,"key.keyboard.left.win", "LWin"
    ,"key.keyboard.right.win", "RWin"
    ,"key.keyboard.menu", "AppsKey"
    ,"key.keyboard.backslash", "\"
    ,"key.keyboard.caps.lock", "CapsLock"
    ,"key.keyboard.semicolon", ";"
    ,"key.keyboard.apostrophe", "'"
    ,"key.keyboard.enter", "Enter"
    ,"key.keyboard.up", "Up"
    ,"key.keyboard.down", "Down"
    ,"key.keyboard.left", "Left"
    ,"key.keyboard.right", "Right"
    ,"key.keyboard.keypad.0", "Numpad0"
    ,"key.keyboard.keypad.1", "Numpad1"
    ,"key.keyboard.keypad.2", "Numpad2"
    ,"key.keyboard.keypad.3", "Numpad3"
    ,"key.keyboard.keypad.4", "Numpad4"
    ,"key.keyboard.keypad.5", "Numpad5"
    ,"key.keyboard.keypad.6", "Numpad6"
    ,"key.keyboard.keypad.7", "Numpad7"
    ,"key.keyboard.keypad.8", "Numpad8"
    ,"key.keyboard.keypad.9", "Numpad9"
    ,"key.keyboard.keypad.decimal", "NumpadDot"
    ,"key.keyboard.keypad.enter", "NumpadEnter"
    ,"key.keyboard.keypad.add", "NumpadAdd"
    ,"key.keyboard.keypad.subtract", "NumpadSub"
    ,"key.keyboard.keypad.multiply", "NumpadMult"
    ,"key.keyboard.keypad.divide", "NumpadDiv"
    ,"key.mouse.left", "LButton"
    ,"key.mouse.right", "RButton"
    ,"key.mouse.middle", "MButton"
    ,"key.mouse.4", "XButton1"
    ,"key.mouse.5", "XButton2")
    return keyArray[mcKey]
}

StartupLog(){
    leavePreview := settings["key_LeavePreview"]
    atumResetKey := settings["key_CreateNewWorld"]
    Log("Minecraft saves dir is: " . savesDirectory)
    Log("Minecraft dir is: " . mcDir)
    Log("AHK Version is: " . A_AhkVersion)
    Log("Script Directory is: " . A_ScriptDir)
    Log("these are the settings: ")
    Log("renderDistance is: " . renderDistance)
    Log("FOV is: " . FOV)
    Log("entityDistance is: " . entityDistance)
    Log("lowRender is: " . lowRender)
    Log("atumResetKey is: " . atumResetKey)
    Log("leavePreviewKey is: " . leavePreview)
}

RunHide(Command)
{
  dhw := A_DetectHiddenWindows
  DetectHiddenWindows, On
  Run, %ComSpec%,, Hide, cPid
  WinWait, ahk_pid %cPid%
  DetectHiddenWindows, %dhw%
  DllCall("AttachConsole", "uint", cPid)

  Shell := ComObjCreate("WScript.Shell")
  Exec := Shell.Exec(Command)
  Result := Exec.StdOut.ReadAll()

  DllCall("FreeConsole")
  Process, Close, %cPid%
  Return Result
}

GetMcDir(pid)
{
  command := Format("powershell.exe $x = Get-WmiObject Win32_Process -Filter \""ProcessId = {1}\""; $x.CommandLine", pid)
  rawOut := RunHide(command)
  if (InStr(rawOut, "--gameDir")) {
    strStart := RegExMatch(rawOut, "P)--gameDir (?:""(.+?)""|([^\s]+))", strLen, 1)
    return SubStr(rawOut, strStart+10, strLen-10) . "\"
  } else {
    strStart := RegExMatch(rawOut, "P)(?:-Djava\.library\.path=(.+?) )|(?:\""-Djava\.library.path=(.+?)\"")", strLen, 1)
    if (SubStr(rawOut, strStart+20, 1) == "=") {
      strLen -= 1
      strStart += 1
    }
    return StrReplace(SubStr(rawOut, strStart+20, strLen-28) . ".minecraft\", "/", "\")
  }
}
