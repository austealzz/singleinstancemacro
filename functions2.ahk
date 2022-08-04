#NoEnv
SendMode Input
SetWorkingDir %A_ScriptDir%

#Include %A_ScriptDir%\settings.ahk

; v0.1

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
        settings["key_CreateNewWorld"] := "f6"
}

CountReset(resetType) {
    filePath := Format("../resets/{1}.txt", resetType)
    if (!FileExist(filePath))
        FileAppend, 0, %filePath%
    file := FileOpen(filePath, "a -rw")
    if (!IsObject(file)) {
        cr := Func("CountReset").Bind(resetType)
        SetTimer, %cr%, -500
    }
    file.Seek(0)
    num := file.Read()
    num += 1
    file.Seek(0)
    file.Write(num)
}


WideResetting(){
    if (WideResets){
        ControlSend, {F11}, Minecraft* ; GetControls() cant find the fullscreen button
        WinMaximize, Minecraft*
        Sleep, 200
        Widen()
    }
    if (CheckJoinedWorld()){
        ControlSend,, {F3 Down}{Esc}{F3 Up}, Minecraft*
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
    atumResetKey := settings["key_CreateNewWorld"]
    Log("Minecraft saves dir is: " . savesDirectory)
    Log("mod dir is: " . modir)
    Log("AHK Version is: " . A_AhkVersion)
    Log("Script Directory is: " . A_ScriptDir)
    Log("these are the settings: ")
    Log("renderDistance is: " . renderDistance)
    Log("FOV is: " . FOV)
    Log("entityDistance is: " . entityDistance)
    Log("lowRender is: " . lowRender)
    Log("atumResetKey is: " . atumResetKey)
    Log("performanceMethod is: " . performanceMethod)
}
