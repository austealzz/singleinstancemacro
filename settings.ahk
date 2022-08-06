#NoEnv
SetWorkingDir %A_ScriptDir%

; v0.1

; macro settings
global MessageBox := False ; option to toggle MessageBoxes while opening the macro
global savesDirectory := "E:\mmc-win32\MultiMC\instances\1.16.1\.minecraft\saves" ; saves folder **CASE SENSITIVE**
global launchPrograms := ["E:\speedrun\Ninjabrain-Bot-1.3.1.jar", "E:\speedrun\ModCheck-0.4.jar"] ; change this to whatever u want, if u dont want to launch programs just set this to []
global OpenMinecraftLauncher := False ; if you want to open multimc or the minecraft launcher automatically
global multiMCLocation := "" ; u dont need to fill this out, only if u want to launch ur minecraft launchers automatically
global countAttempts := True ; if u want to count ur resets in the macro
global readySound := False ; if u want to have a readySound on opening the macro
global ResetSetting := True ; if u want to Reset ur Settings

; in game settings (performance too)
global lowRender := 5
global renderDistance := 10
global FOV := 80 ; Normal = 70, Quake pro = 110
global entityDistance := 1 ; 50% = 0.5, 500% = 5


; preferences
global ResetSounds := False ; if you want to play the old reset sounds
global widthMultiplier := 3 ; how wide you want to widen minecraft
global fullscreen := True ; if u use fullscreen in Minecraft or not
global wideResets := True
