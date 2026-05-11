#NoTrayIcon
#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>
#include <ListViewConstants.au3>
#include <GuiListView.au3>
#include <File.au3>
#include <Array.au3>

; ============================================================
;  MIDI PLAYER v2.0 - Interface sombre
;  F1 = Start / Stop
; ============================================================

; Couleurs
Global Const $C_BG      = 0x1A1A2E
Global Const $C_PANEL   = 0x16213E
Global Const $C_ACCENT  = 0x0F3460
Global Const $C_BLUE    = 0x4FC3F7
Global Const $C_RED     = 0xEF5350
Global Const $C_GREEN   = 0x66BB6A
Global Const $C_TEXT    = 0xE0E0E0
Global Const $C_GREY    = 0x757575
Global Const $C_DARK    = 0x0D0D1A

; Mapping MIDI -> clavier QWERTY
Global $aNoteMap[21][2]
$aNoteMap[0][0]  = 48 : $aNoteMap[0][1]  = "z"
$aNoteMap[1][0]  = 50 : $aNoteMap[1][1]  = "x"
$aNoteMap[2][0]  = 52 : $aNoteMap[2][1]  = "c"
$aNoteMap[3][0]  = 53 : $aNoteMap[3][1]  = "v"
$aNoteMap[4][0]  = 55 : $aNoteMap[4][1]  = "b"
$aNoteMap[5][0]  = 57 : $aNoteMap[5][1]  = "n"
$aNoteMap[6][0]  = 59 : $aNoteMap[6][1]  = "m"
$aNoteMap[7][0]  = 60 : $aNoteMap[7][1]  = "a"
$aNoteMap[8][0]  = 62 : $aNoteMap[8][1]  = "s"
$aNoteMap[9][0]  = 64 : $aNoteMap[9][1]  = "d"
$aNoteMap[10][0] = 65 : $aNoteMap[10][1] = "f"
$aNoteMap[11][0] = 67 : $aNoteMap[11][1] = "g"
$aNoteMap[12][0] = 69 : $aNoteMap[12][1] = "h"
$aNoteMap[13][0] = 71 : $aNoteMap[13][1] = "j"
$aNoteMap[14][0] = 72 : $aNoteMap[14][1] = "q"
$aNoteMap[15][0] = 74 : $aNoteMap[15][1] = "w"
$aNoteMap[16][0] = 76 : $aNoteMap[16][1] = "e"
$aNoteMap[17][0] = 77 : $aNoteMap[17][1] = "r"
$aNoteMap[18][0] = 79 : $aNoteMap[18][1] = "t"
$aNoteMap[19][0] = 81 : $aNoteMap[19][1] = "y"
$aNoteMap[20][0] = 83 : $aNoteMap[20][1] = "u"

; Variables
Global $bPlaying    = False
Global $bTestMode   = False
Global $bShuffle    = False
Global $bLoop       = False
Global $iCurrentIdx = -1
Global $iTotalMs    = 0
Global $iPlayStart  = 0
Global $aFiles[0]
Global $sLayout     = "AZERTY"
Global $iPausePos   = -1   ; position en ms lors de la pause (-1 = pas de pause)
Global $iOffsetActif = 0   ; offset en cours pour la barre de progression

; ============================================================
;  MAPPINGS PAR LAYOUT
; ============================================================
; Notes MIDI communes aux 3 layouts : 48 50 52 53 55 57 59 / 60 62 64 65 67 69 71 / 72 74 76 77 79 81 83
; Les touches changent selon le clavier

Func _ChargerLayout($sL)
    $sLayout = $sL
    If $sL = "AZERTY" Then
        ; Rangee 1 : W X C V B N , (virgule)
        ; Rangee 2 : Q S D F G H J
        ; Rangee 3 : A Z E R T Y U
        $aNoteMap[0][1]  = "w"
        $aNoteMap[1][1]  = "x"
        $aNoteMap[2][1]  = "c"
        $aNoteMap[3][1]  = "v"
        $aNoteMap[4][1]  = "b"
        $aNoteMap[5][1]  = "n"
        $aNoteMap[6][1]  = ","
        $aNoteMap[7][1]  = "q"
        $aNoteMap[8][1]  = "s"
        $aNoteMap[9][1]  = "d"
        $aNoteMap[10][1] = "f"
        $aNoteMap[11][1] = "g"
        $aNoteMap[12][1] = "h"
        $aNoteMap[13][1] = "j"
        $aNoteMap[14][1] = "a"
        $aNoteMap[15][1] = "z"
        $aNoteMap[16][1] = "e"
        $aNoteMap[17][1] = "r"
        $aNoteMap[18][1] = "t"
        $aNoteMap[19][1] = "y"
        $aNoteMap[20][1] = "u"
    ElseIf $sL = "QWERTZ" Then
        ; Comme QWERTY mais Y et Z inverses
        $aNoteMap[0][1]  = "y"
        $aNoteMap[1][1]  = "x"
        $aNoteMap[2][1]  = "c"
        $aNoteMap[3][1]  = "v"
        $aNoteMap[4][1]  = "b"
        $aNoteMap[5][1]  = "n"
        $aNoteMap[6][1]  = "m"
        $aNoteMap[7][1]  = "a"
        $aNoteMap[8][1]  = "s"
        $aNoteMap[9][1]  = "d"
        $aNoteMap[10][1] = "f"
        $aNoteMap[11][1] = "g"
        $aNoteMap[12][1] = "h"
        $aNoteMap[13][1] = "j"
        $aNoteMap[14][1] = "q"
        $aNoteMap[15][1] = "w"
        $aNoteMap[16][1] = "e"
        $aNoteMap[17][1] = "r"
        $aNoteMap[18][1] = "t"
        $aNoteMap[19][1] = "z"
        $aNoteMap[20][1] = "u"
    Else ; QWERTY par defaut
        $aNoteMap[0][1]  = "z"
        $aNoteMap[1][1]  = "x"
        $aNoteMap[2][1]  = "c"
        $aNoteMap[3][1]  = "v"
        $aNoteMap[4][1]  = "b"
        $aNoteMap[5][1]  = "n"
        $aNoteMap[6][1]  = "m"
        $aNoteMap[7][1]  = "a"
        $aNoteMap[8][1]  = "s"
        $aNoteMap[9][1]  = "d"
        $aNoteMap[10][1] = "f"
        $aNoteMap[11][1] = "g"
        $aNoteMap[12][1] = "h"
        $aNoteMap[13][1] = "j"
        $aNoteMap[14][1] = "q"
        $aNoteMap[15][1] = "w"
        $aNoteMap[16][1] = "e"
        $aNoteMap[17][1] = "r"
        $aNoteMap[18][1] = "t"
        $aNoteMap[19][1] = "y"
        $aNoteMap[20][1] = "u"
    EndIf
EndFunc

; ============================================================
;  GUI PRINCIPALE
; ============================================================
Global $hGUI = GUICreate("MIDI Player  -  F1 Play/Pause  |  F2 Stop", 700, 580)
GUISetBkColor($C_BG)

; ---- TITRE ----
GUICtrlCreateLabel("MIDI PLAYER", 20, 15, 300, 28)
GUICtrlSetFont(-1, 16, 800, 0, "Segoe UI")
GUICtrlSetColor(-1, $C_BLUE)

GUICtrlCreateLabel("v2.0  -  F1 Play/Pause  |  F2 Stop", 20, 44, 300, 16)
GUICtrlSetFont(-1, 8, 400, 0, "Segoe UI")
GUICtrlSetColor(-1, $C_GREY)

; ---- BOUTONS NAV (vrais boutons standards) ----
Global $hNavPlayer   = GUICtrlCreateButton("Player",     330, 15, 90, 28)
Global $hNavSettings = GUICtrlCreateButton("Parametres", 425, 15, 90, 28)
Global $hNavAbout    = GUICtrlCreateButton("A propos",   520, 15, 90, 28)

; Separateur
GUICtrlCreateLabel("", 0, 65, 700, 2)
GUICtrlSetBkColor(-1, $C_ACCENT)

; ---- NOW PLAYING ----
GUICtrlCreateLabel("", 10, 75, 680, 90)
GUICtrlSetBkColor(-1, $C_PANEL)

GUICtrlCreateLabel("EN LECTURE", 25, 82, 200, 14)
GUICtrlSetFont(-1, 7, 700, 0, "Segoe UI")
GUICtrlSetColor(-1, $C_GREY)
GUICtrlSetBkColor(-1, $C_PANEL)

Global $hLblTitre = GUICtrlCreateLabel("Aucun fichier selectionne", 25, 98, 650, 22)
GUICtrlSetFont(-1, 12, 700, 0, "Segoe UI")
GUICtrlSetColor(-1, $C_TEXT)
GUICtrlSetBkColor(-1, $C_PANEL)

Global $hLblSous = GUICtrlCreateLabel("Ajoute un fichier MIDI dans la playlist", 25, 122, 650, 16)
GUICtrlSetFont(-1, 8, 400, 0, "Segoe UI")
GUICtrlSetColor(-1, $C_GREY)
GUICtrlSetBkColor(-1, $C_PANEL)

; Barre progression
GUICtrlCreateLabel("", 25, 146, 640, 4)
GUICtrlSetBkColor(-1, $C_ACCENT)
Global $hProgBg = GUICtrlCreateLabel("", 25, 140, 640, 14)
GUICtrlSetBkColor(-1, $C_PANEL)
GUICtrlCreateLabel("", 25, 146, 640, 4)
GUICtrlSetBkColor(-1, $C_ACCENT)
Global $hProgBar = GUICtrlCreateLabel("", 25, 146, 0, 4)
GUICtrlSetBkColor(-1, $C_BLUE)

Global $hLblTemps = GUICtrlCreateLabel("0:00", 25, 153, 60, 14)
GUICtrlSetFont(-1, 7, 400, 0, "Segoe UI")
GUICtrlSetColor(-1, $C_GREY)
GUICtrlSetBkColor(-1, $C_PANEL)

Global $hLblTotal = GUICtrlCreateLabel("0:00", 600, 153, 60, 14)
GUICtrlSetFont(-1, 7, 400, 0, "Segoe UI")
GUICtrlSetColor(-1, $C_GREY)
GUICtrlSetBkColor(-1, $C_PANEL)

; ---- CONTROLES ----
GUICtrlCreateLabel("", 0, 172, 700, 2)
GUICtrlSetBkColor(-1, $C_ACCENT)

; Boutons : Aleat. | |<< | PLAY | PAUSE | STOP | >>| | Boucle
; Positions calculees pour ne pas se superposer (zone 0-700px)
Global $hBtnShuffle = GUICtrlCreateButton("Aleat.", 10,  184, 58, 30)
Global $hBtnPrev    = GUICtrlCreateButton("|<<",    76,  182, 46, 34)
Global $hBtnPlay    = GUICtrlCreateButton("PLAY",   130, 177, 76, 44)
Global $hBtnPause   = GUICtrlCreateButton("PAUSE",  214, 177, 76, 44)
Global $hBtnStop    = GUICtrlCreateButton("STOP",   298, 177, 76, 44)
Global $hBtnNext    = GUICtrlCreateButton(">>|",    382, 182, 46, 34)
Global $hBtnLoop    = GUICtrlCreateButton("Boucle", 436, 184, 58, 30)

GUICtrlSetFont($hBtnPlay,  10, 800, 0, "Segoe UI")
GUICtrlSetBkColor($hBtnPlay,  $C_BLUE)
GUICtrlSetColor($hBtnPlay,  $C_DARK)

GUICtrlSetFont($hBtnPause, 10, 800, 0, "Segoe UI")
GUICtrlSetBkColor($hBtnPause, $C_ACCENT)
GUICtrlSetColor($hBtnPause, $C_TEXT)

GUICtrlSetFont($hBtnStop,  10, 800, 0, "Segoe UI")
GUICtrlSetBkColor($hBtnStop,  $C_RED)
GUICtrlSetColor($hBtnStop,  $C_DARK)

; ---- PLAYLIST ----
GUICtrlCreateLabel("", 0, 228, 700, 2)
GUICtrlSetBkColor(-1, $C_ACCENT)

GUICtrlCreateLabel("PLAYLIST", 20, 238, 200, 18)
GUICtrlSetFont(-1, 10, 700, 0, "Segoe UI")
GUICtrlSetColor(-1, $C_TEXT)

Global $hBtnAjouter  = GUICtrlCreateButton("+ Ajouter",  470, 234, 90, 24)
Global $hBtnRetirer  = GUICtrlCreateButton("- Retirer",  565, 234, 90, 24)
Global $hBtnVider    = GUICtrlCreateButton("Vider tout", 335, 234, 90, 24)

Global $hLV = GUICtrlCreateListView("#|Titre|Duree", 10, 264, 680, 240, $LVS_SINGLESEL + $LVS_SHOWSELALWAYS)
GUICtrlSetBkColor(-1, $C_PANEL)
GUICtrlSetColor(-1, $C_TEXT)
GUICtrlSetFont(-1, 9, 400, 0, "Segoe UI")
_GUICtrlListView_SetColumnWidth($hLV, 0, 35)
_GUICtrlListView_SetColumnWidth($hLV, 1, 560)
_GUICtrlListView_SetColumnWidth($hLV, 2, 65)

; ---- STATUT + BOUTONS BAS ----
GUICtrlCreateLabel("", 0, 530, 700, 1)
GUICtrlSetBkColor(-1, $C_ACCENT)

Global $hLblStatus = GUICtrlCreateLabel("  Pret.  Ajoute des fichiers MIDI pour commencer.", 0, 534, 380, 18)
GUICtrlSetFont(-1, 8, 400, 0, "Segoe UI")
GUICtrlSetColor(-1, $C_GREY)

; ---- MODE TEST ----
Global $hBtnTest = GUICtrlCreateButton("Mode Test: OFF", 385, 532, 150, 22)
GUICtrlSetFont(-1, 7, 400, 0, "Segoe UI")
GUICtrlSetBkColor($hBtnTest, $C_ACCENT)
GUICtrlSetColor($hBtnTest, $C_TEXT)

; ---- TOUJOURS AU PREMIER PLAN ----
Global $hBtnTop = GUICtrlCreateButton("Tjrs visible: OFF", 540, 532, 150, 22)
GUICtrlSetFont(-1, 7, 400, 0, "Segoe UI")
GUICtrlSetBkColor($hBtnTop, $C_ACCENT)
GUICtrlSetColor($hBtnTop, $C_TEXT)
Global $bOnTop = False

HotKeySet("{F1}", "_TogglePlay")
HotKeySet("{F2}", "_StopPlay")
_ChargerLayout($sLayout) ; Charge le layout par defaut au demarrage
AdlibRegister("_UpdateProg", 200)
GUIRegisterMsg($WM_LBUTTONDOWN, "_ClicProgression")

GUISetState(@SW_SHOW, $hGUI)

; ============================================================
;  BOUCLE PRINCIPALE
; ============================================================
While 1
    Local $msg = GUIGetMsg()
    Switch $msg
        Case $GUI_EVENT_CLOSE
            _StopPlay()
            Exit

        Case $hBtnAjouter
            _Ajouter()

        Case $hBtnRetirer
            _Retirer()

        Case $hBtnVider
            _Vider()

        Case $hBtnPlay
            _StartPlay()

        Case $hBtnPause
            _PausePlay()

        Case $hBtnStop
            _StopPlay()

        Case $hBtnPrev
            _Prev()

        Case $hBtnNext
            _Next()

        Case $hBtnShuffle
            $bShuffle = Not $bShuffle
            If $bShuffle Then
                GUICtrlSetBkColor($hBtnShuffle, $C_BLUE)
                GUICtrlSetColor($hBtnShuffle, $C_DARK)
                _Statut("Lecture aleatoire activee")
            Else
                GUICtrlSetBkColor($hBtnShuffle, -2)
                GUICtrlSetColor($hBtnShuffle, $C_TEXT)
                _Statut("Lecture aleatoire desactivee")
            EndIf

        Case $hBtnLoop
            $bLoop = Not $bLoop
            If $bLoop Then
                GUICtrlSetBkColor($hBtnLoop, $C_BLUE)
                GUICtrlSetColor($hBtnLoop, $C_DARK)
                _Statut("Repetition activee")
            Else
                GUICtrlSetBkColor($hBtnLoop, -2)
                GUICtrlSetColor($hBtnLoop, $C_TEXT)
                _Statut("Repetition desactivee")
            EndIf

        Case $hBtnTest
            $bTestMode = Not $bTestMode
            If $bTestMode Then
                GUICtrlSetData($hBtnTest, "Mode Test: ON")
                GUICtrlSetBkColor($hBtnTest, $C_GREEN)
                GUICtrlSetColor($hBtnTest, $C_DARK)
                _Statut("[MODE TEST] Les touches ne seront PAS envoyees")
            Else
                GUICtrlSetData($hBtnTest, "Mode Test: OFF")
                GUICtrlSetBkColor($hBtnTest, $C_ACCENT)
                GUICtrlSetColor($hBtnTest, $C_TEXT)
                _Statut("Mode Test desactive - les touches sont envoyees")
            EndIf

        Case $hNavPlayer
            _Statut("Page Player")

        Case $hNavSettings
            _PageParametres()

        Case $hNavAbout
            _PageAPropos()

        Case $hBtnTop
            $bOnTop = Not $bOnTop
            If $bOnTop Then
                WinSetOnTop($hGUI, "", 1)
                GUICtrlSetData($hBtnTop, "Toujours visible: ON")
                GUICtrlSetBkColor($hBtnTop, $C_BLUE)
                GUICtrlSetColor($hBtnTop, $C_DARK)
                _Statut("Fenetre toujours au premier plan")
            Else
                WinSetOnTop($hGUI, "", 0)
                GUICtrlSetData($hBtnTop, "Toujours visible: OFF")
                GUICtrlSetBkColor($hBtnTop, $C_ACCENT)
                GUICtrlSetColor($hBtnTop, $C_TEXT)
                _Statut("Fenetre normale")
            EndIf
    EndSwitch
WEnd

; ============================================================
;  FONCTIONS PLAYLIST
; ============================================================
Func _Ajouter()
    Local $s = FileOpenDialog("Choisir fichiers MIDI", "", "MIDI (*.mid;*.midi)|Tous (*.*)", 1 + 4)
    If @error Then Return
    Local $a = StringSplit($s, "|")
    If $a[0] = 1 Then
        _AjouterFichier($a[1])
    Else
        For $i = 2 To $a[0]
            _AjouterFichier($a[1] & "\" & $a[$i])
        Next
    EndIf
EndFunc

Func _AjouterFichier($sPath)
    If Not FileExists($sPath) Then Return
    Local $sNom = StringRegExpReplace(StringRegExpReplace($sPath, ".*\\", ""), "\.[^.]+$", "")
    Local $n = _GUICtrlListView_GetItemCount($hLV) + 1
    GUICtrlCreateListViewItem($n & "|" & $sNom & "|--:--", $hLV)
    ReDim $aFiles[UBound($aFiles) + 1]
    $aFiles[UBound($aFiles) - 1] = $sPath
    _Statut("Ajoute : " & $sNom)
EndFunc

Func _Retirer()
    If $bPlaying Then _StopPlay()
    Local $iS = _GUICtrlListView_GetSelectedIndices($hLV)
    If $iS = "" Then Return
    Local $i = Int($iS)
    _GUICtrlListView_DeleteItem($hLV, $i)
    For $j = $i To UBound($aFiles) - 2
        $aFiles[$j] = $aFiles[$j + 1]
    Next
    ReDim $aFiles[UBound($aFiles) - 1]
    If $iCurrentIdx = $i Then $iCurrentIdx = -1
    _Statut("Fichier retire")
EndFunc

Func _Vider()
    If $bPlaying Then _StopPlay()
    _GUICtrlListView_DeleteAllItems($hLV)
    ReDim $aFiles[0]
    $iCurrentIdx = -1
    GUICtrlSetData($hLblTitre, "Aucun fichier selectionne")
    GUICtrlSetData($hLblSous, "Ajoute un fichier MIDI dans la playlist")
    _Statut("Playlist videe")
EndFunc

; ============================================================
;  LECTURE
; ============================================================
Func _TogglePlay()
    If $bPlaying Then
        _PausePlay()
    Else
        _StartPlay()
    EndIf
EndFunc

; Demarre ou reprend la lecture (appele par bouton PLAY ou F1 quand arrete)
Func _StartPlay()
    _Lire()
EndFunc

; Met a jour l'apparence des 3 boutons selon l'etat
Func _SetBtnState($sEtat)
    ; sEtat = "playing" | "paused" | "stopped"
    If $sEtat = "playing" Then
        GUICtrlSetBkColor($hBtnPlay,  $C_BLUE)
        GUICtrlSetColor($hBtnPlay,    $C_DARK)
        GUICtrlSetBkColor($hBtnPause, $C_ACCENT)
        GUICtrlSetColor($hBtnPause,   $C_TEXT)
        GUICtrlSetBkColor($hBtnStop,  $C_RED)
        GUICtrlSetColor($hBtnStop,    $C_DARK)
    ElseIf $sEtat = "paused" Then
        GUICtrlSetBkColor($hBtnPlay,  $C_GREEN)
        GUICtrlSetColor($hBtnPlay,    $C_DARK)
        GUICtrlSetBkColor($hBtnPause, $C_BLUE)
        GUICtrlSetColor($hBtnPause,   $C_DARK)
        GUICtrlSetBkColor($hBtnStop,  $C_RED)
        GUICtrlSetColor($hBtnStop,    $C_DARK)
    Else ; stopped
        GUICtrlSetBkColor($hBtnPlay,  $C_BLUE)
        GUICtrlSetColor($hBtnPlay,    $C_DARK)
        GUICtrlSetBkColor($hBtnPause, $C_ACCENT)
        GUICtrlSetColor($hBtnPause,   $C_TEXT)
        GUICtrlSetBkColor($hBtnStop,  $C_ACCENT)
        GUICtrlSetColor($hBtnStop,    $C_TEXT)
    EndIf
EndFunc

Func _PausePlay()
    If Not $bPlaying Then Return  ; deja en pause ou arrete, ne rien faire
    ; Sauvegarde la position actuelle (temps ecoule + offset de depart)
    $iPausePos = TimerDiff($iPlayStart) + $iOffsetActif
    $bPlaying = False
    If $bTestMode Then _TestSonArreter()
    _SetBtnState("paused")
    GUICtrlSetData($hLblSous, "En pause  -  PLAY pour reprendre")
    _Statut("En pause  -  clique sur PLAY pour reprendre")
EndFunc

Func _Lire()
    Local $n = _GUICtrlListView_GetItemCount($hLV)
    If $n = 0 Then
        _Statut("Playlist vide - clique sur + Ajouter")
        Return
    EndIf

    Local $iIdx = 0

    ; Si on reprend depuis une pause, on force la meme piste
    If $iPausePos > 0 And $iCurrentIdx >= 0 Then
        $iIdx = $iCurrentIdx
    Else
        ; Toujours lire la selection visuelle en priorite
        Local $iSel = _GUICtrlListView_GetSelectedIndices($hLV)
        If $iSel <> "" Then
            $iIdx = Int($iSel)
        ElseIf $iCurrentIdx >= 0 Then
            $iIdx = $iCurrentIdx
        EndIf
        ; Si on change de piste (ou si aucune piste precedente), remet la pause a zero
        If $iIdx <> $iCurrentIdx Then
            $iPausePos = -1
            $iOffsetActif = 0
        EndIf
    EndIf

    If $iIdx >= UBound($aFiles) Then $iIdx = 0

    Local $sPath = $aFiles[$iIdx]
    If Not FileExists($sPath) Then
        _Statut("Fichier introuvable : " & $sPath)
        Return
    EndIf

    Local $aEvts = _ParseMidi($sPath)
    If @error Or UBound($aEvts) = 0 Then
        _Statut("Erreur de lecture MIDI - fichier invalide ?")
        Return
    EndIf

    $iCurrentIdx = $iIdx
    $iTotalMs    = $aEvts[UBound($aEvts) - 1][0] + 300
    $bPlaying    = True

    ; Reprise depuis la pause ou debut
    Local $iOffsetMs = 0
    If $iPausePos > 0 Then
        $iOffsetMs = $iPausePos
        $iPausePos = -1
    EndIf

    ; Timer repart de zero, on compensera avec $iOffsetMs dans la boucle
    $iPlayStart = TimerInit()
    $iOffsetActif = $iOffsetMs

    _GUICtrlListView_SetItemText($hLV, $iIdx, _T($iTotalMs), 2)
    _GUICtrlListView_SetItemSelected($hLV, $iIdx, True)

    Local $sNom = StringRegExpReplace(StringRegExpReplace($sPath, ".*\\", ""), "\.[^.]+$", "")
    GUICtrlSetData($hLblTitre, $sNom)
    GUICtrlSetData($hLblSous, "En lecture" & ($bTestMode ? "  [MODE TEST]" : ""))
    GUICtrlSetData($hLblTotal, _T($iTotalMs))
    _SetBtnState("playing")
    _Statut(($iOffsetMs > 0 ? "Reprise : " : "Lecture : ") & $sNom)

    If $bTestMode Then _TestSonDemarrer($sPath)

    Local $tStart = TimerInit()
    For $i = 0 To UBound($aEvts) - 1
        If Not $bPlaying Then ExitLoop

        ; Temps cible de cette note relativement au debut de la piste
        Local $iTempsNote = $aEvts[$i][0]

        ; Saute les notes deja passees (reprise apres pause)
        If $iTempsNote < $iOffsetMs Then ContinueLoop

        ; Attend le bon moment (temps ecoule + offset)
        While (TimerDiff($tStart) + $iOffsetMs) < $iTempsNote
            If Not $bPlaying Then ExitLoop
            Sleep(1)
            _ProcMsg()
            If Not $bPlaying Then ExitLoop
        WEnd
        If Not $bPlaying Then ExitLoop

        If Not $bTestMode Then
            Local $k = _NoteVersKey($aEvts[$i][1])
            If $k <> "" Then Send($k)
        EndIf

        _ProcMsg()
    Next

    If $bPlaying Then
        _StopPlay()
        If $bLoop Then
            Sleep(200)
            _Lire()
        ElseIf $bShuffle Then
            $iCurrentIdx = Random(0, _GUICtrlListView_GetItemCount($hLV) - 1, 1)
            _GUICtrlListView_SetItemSelected($hLV, $iCurrentIdx, True)
            Sleep(200)
            _Lire()
        Else
            _Next()
        EndIf
    EndIf
EndFunc

Func _ProcMsg()
    Local $m = GUIGetMsg()
    Switch $m
        Case $GUI_EVENT_CLOSE
            _StopPlay()
            Exit
        Case $hBtnPlay
            _StartPlay()
        Case $hBtnPause
            _PausePlay()
        Case $hBtnStop
            _StopPlay()
        Case $hBtnNext
            $bPlaying = False
            _Next()
        Case $hBtnPrev
            $bPlaying = False
            _Prev()
        Case $hBtnAjouter
            _Ajouter()
        Case $hBtnRetirer
            _Retirer()
        Case $hBtnTest
            $bTestMode = Not $bTestMode
            If $bTestMode Then
                GUICtrlSetData($hBtnTest, "Mode Test: ON")
                GUICtrlSetBkColor($hBtnTest, $C_GREEN)
                GUICtrlSetColor($hBtnTest, $C_DARK)
            Else
                GUICtrlSetData($hBtnTest, "Mode Test: OFF")
                GUICtrlSetBkColor($hBtnTest, $C_ACCENT)
                GUICtrlSetColor($hBtnTest, $C_TEXT)
            EndIf
        Case $hBtnTop
            $bOnTop = Not $bOnTop
            If $bOnTop Then
                WinSetOnTop($hGUI, "", 1)
                GUICtrlSetData($hBtnTop, "Toujours visible: ON")
                GUICtrlSetBkColor($hBtnTop, $C_BLUE)
                GUICtrlSetColor($hBtnTop, $C_DARK)
            Else
                WinSetOnTop($hGUI, "", 0)
                GUICtrlSetData($hBtnTop, "Toujours visible: OFF")
                GUICtrlSetBkColor($hBtnTop, $C_ACCENT)
                GUICtrlSetColor($hBtnTop, $C_TEXT)
            EndIf
    EndSwitch
EndFunc

Func _StopPlay()
    $bPlaying = False
    $iPausePos = -1
    $iOffsetActif = 0
    $iPlayStart = 0
    If $bTestMode Then _TestSonArreter()
    _SetBtnState("stopped")
    GUICtrlSetData($hLblSous, "Arrete  -  PLAY pour relancer")
    GUICtrlSetPos($hProgBar, 25, 146, 0, 4)
    GUICtrlSetData($hLblTemps, "0:00")
    _Statut("Arrete")
EndFunc

Func _Next()
    Local $n = _GUICtrlListView_GetItemCount($hLV)
    If $n = 0 Then Return
    Local $iN = $iCurrentIdx + 1
    If $iN >= $n Then $iN = 0
    $iCurrentIdx = $iN
    _GUICtrlListView_SetItemSelected($hLV, $iN, True)
    _GUICtrlListView_EnsureVisible($hLV, $iN)
    Sleep(100)
    _Lire()
EndFunc

Func _Prev()
    Local $n = _GUICtrlListView_GetItemCount($hLV)
    If $n = 0 Then Return
    Local $iP = $iCurrentIdx - 1
    If $iP < 0 Then $iP = $n - 1
    $iCurrentIdx = $iP
    _GUICtrlListView_SetItemSelected($hLV, $iP, True)
    _GUICtrlListView_EnsureVisible($hLV, $iP)
    Sleep(100)
    _Lire()
EndFunc

; ============================================================
;  PROGRESSION
; ============================================================
Func _UpdateProg()
    If Not $bPlaying Or $iPlayStart = 0 Or $iTotalMs = 0 Then Return
    Local $el = TimerDiff($iPlayStart) + $iOffsetActif
    If $el > $iTotalMs Then $el = $iTotalMs
    GUICtrlSetPos($hProgBar, 25, 146, Int(640 * $el / $iTotalMs), 4)
    GUICtrlSetData($hLblTemps, _T($el))
EndFunc

Func _ClicProgression($hWin, $Msg, $wParam, $lParam)
    ; Verifie qu'on clique dans la zone de la barre (X: 25-665, Y: 140-154)
    Local $iX = BitAND($lParam, 0xFFFF)
    Local $iY = BitShift($lParam, 16)
    If $iX >= 25 And $iX <= 665 And $iY >= 136 And $iY <= 158 Then
        If $iTotalMs > 0 Then
            ; Calcule la position en ms selon le clic
            Local $iNouvellePos = Int(($iX - 25) / 640 * $iTotalMs)
            If $iNouvellePos < 0 Then $iNouvellePos = 0
            If $iNouvellePos > $iTotalMs Then $iNouvellePos = $iTotalMs
            ; Sauvegarde comme nouvelle position de pause
            $iPausePos = $iNouvellePos
            ; Si en lecture : reprend depuis la nouvelle position
            If $bPlaying Then
                $bPlaying = False
                If $bTestMode Then _TestSonArreter()
                Sleep(50)
                _Lire()
            Else
                ; Si en pause : met a jour la barre visuellement
                $iOffsetActif = $iNouvellePos
                GUICtrlSetPos($hProgBar, 25, 146, Int(640 * $iNouvellePos / $iTotalMs), 4)
                GUICtrlSetData($hLblTemps, _T($iNouvellePos))
                _Statut("Position : " & _T($iNouvellePos) & " / " & _T($iTotalMs) & "  -  F1 pour reprendre")
            EndIf
        EndIf
    EndIf
    Return $GUI_RUNDEFMSG
EndFunc

Func _T($ms)
    Local $s = Int($ms / 1000)
    Return Int($s / 60) & ":" & StringFormat("%02d", Mod($s, 60))
EndFunc

Func _Statut($s)
    GUICtrlSetData($hLblStatus, "  " & $s)
EndFunc

; ============================================================
;  PAGES
; ============================================================
Func _PageParametres()
    Local $w = GUICreate("Parametres", 400, 320, -1, -1, -1, -1, $hGUI)
    GUISetBkColor($C_BG)

    GUICtrlCreateLabel("Parametres", 20, 15, 360, 26)
    GUICtrlSetFont(-1, 14, 700, 0, "Segoe UI")
    GUICtrlSetColor(-1, $C_BLUE)

    GUICtrlCreateLabel("", 0, 50, 400, 2)
    GUICtrlSetBkColor(-1, $C_ACCENT)

    GUICtrlCreateLabel("Disposition du clavier", 20, 65, 200, 16)
    GUICtrlSetFont(-1, 9, 700, 0, "Segoe UI")
    GUICtrlSetColor(-1, $C_TEXT)

    Local $hCombo = GUICtrlCreateCombo($sLayout, 20, 85, 160, 24)
    GUICtrlSetData($hCombo, "AZERTY|QWERTY|QWERTZ")

    Local $hLblTouches = GUICtrlCreateLabel(_GetTouchesInfo(), 20, 120, 360, 80)
    GUICtrlSetFont(-1, 8, 400, 0, "Courier New")
    GUICtrlSetColor(-1, $C_BLUE)

    GUICtrlCreateLabel("Les notes hors plage sont transposees automatiquement.", 20, 210, 360, 14)
    GUICtrlSetFont(-1, 7, 400, 0, "Segoe UI")
    GUICtrlSetColor(-1, $C_GREY)

    GUICtrlCreateLabel("", 0, 232, 400, 1)
    GUICtrlSetBkColor(-1, $C_ACCENT)

    GUICtrlCreateLabel("Mode Test : ecoute le MIDI avec le son Windows (sans envoyer de touches).", 20, 244, 360, 28)
    GUICtrlSetFont(-1, 7, 400, 0, "Segoe UI")
    GUICtrlSetColor(-1, $C_GREY)

    Local $hOK = GUICtrlCreateButton("Enregistrer", 120, 278, 110, 28)
    GUICtrlSetBkColor($hOK, $C_BLUE)
    GUICtrlSetColor($hOK, $C_DARK)
    GUICtrlSetFont($hOK, 9, 700, 0, "Segoe UI")

    GUISetState(@SW_SHOW, $w)
    While 1
        Local $m = GUIGetMsg()
        If $m = $GUI_EVENT_CLOSE Then ExitLoop
        If $m = $hOK Then
            Local $sNewLayout = GUICtrlRead($hCombo)
            If $sNewLayout <> $sLayout Then
                _ChargerLayout($sNewLayout)
                GUICtrlSetData($hLblTouches, _GetTouchesInfo())
                _Statut("Layout change : " & $sNewLayout)
            EndIf
            ExitLoop
        EndIf
    WEnd
    GUIDelete($w)
EndFunc

Func _PageAPropos()
    Local $w = GUICreate("A propos", 360, 220, -1, -1, -1, -1, $hGUI)
    GUISetBkColor($C_BG)

    GUICtrlCreateLabel("MIDI Player v3.0 by DannSKiller", 20, 20, 320, 26)
    GUICtrlSetFont(-1, 14, 700, 0, "Segoe UI")
    GUICtrlSetColor(-1, $C_BLUE)

    GUICtrlCreateLabel("Script AutoIt - Lecteur MIDI universel", 20, 50, 320, 16)
    GUICtrlSetFont(-1, 9, 400, 0, "Segoe UI")
    GUICtrlSetColor(-1, $C_TEXT)

    GUICtrlCreateLabel("- Lit les fichiers .mid et envoie les touches clavier", 20, 80, 320, 16)
    GUICtrlSetFont(-1, 8, 400, 0, "Segoe UI")
    GUICtrlSetColor(-1, $C_GREY)

    GUICtrlCreateLabel("- Fonctionne sur n'importe quelle fenetre active", 20, 100, 320, 16)
    GUICtrlSetFont(-1, 8, 400, 0, "Segoe UI")
    GUICtrlSetColor(-1, $C_GREY)

    GUICtrlCreateLabel("- F1 pour demarrer / arreter la lecture", 20, 120, 320, 16)
    GUICtrlSetFont(-1, 8, 400, 0, "Segoe UI")
    GUICtrlSetColor(-1, $C_GREY)

    GUICtrlCreateLabel("- Mode Test : lecture sans envoi de touches", 20, 140, 320, 16)
    GUICtrlSetFont(-1, 8, 400, 0, "Segoe UI")
    GUICtrlSetColor(-1, $C_GREY)

    Local $hOK = GUICtrlCreateButton("OK", 135, 175, 90, 28)
    GUICtrlSetBkColor($hOK, $C_BLUE)
    GUICtrlSetColor($hOK, $C_DARK)
    GUICtrlSetFont($hOK, 9, 700, 0, "Segoe UI")

    GUISetState(@SW_SHOW, $w)
    While 1
        Local $m = GUIGetMsg()
        If $m = $GUI_EVENT_CLOSE Or $m = $hOK Then ExitLoop
    WEnd
    GUIDelete($w)
EndFunc

; ============================================================
;  NOTE -> TOUCHE
; ============================================================
Func _NoteVersKey($iNote)
    While $iNote < 48
        $iNote += 12
    WEnd
    While $iNote > 83
        $iNote -= 12
    WEnd
    For $i = 0 To 20
        If $aNoteMap[$i][0] = $iNote Then Return $aNoteMap[$i][1]
    Next
    Local $iBest = 0, $iMin = 999
    For $i = 0 To 20
        Local $d = Abs($aNoteMap[$i][0] - $iNote)
        If $d < $iMin Then
            $iMin = $d
            $iBest = $i
        EndIf
    Next
    Return $aNoteMap[$iBest][1]
EndFunc

; ============================================================
;  PARSER MIDI
; ============================================================
Func _ParseMidi($sFile)
    Local $h = FileOpen($sFile, 16)
    If $h = -1 Then Return SetError(1, 0, 0)
    Local $bin = FileRead($h)
    FileClose($h)
    Local $sHex = StringTrimLeft($bin, 2)

    If StringLeft($sHex, 8) <> "4D546864" Then Return SetError(2, 0, 0)

    Local $nTracks = _H($sHex, 21, 4)
    Local $iDiv    = _H($sHex, 25, 4)
    Local $iTempo  = 500000
    Local $iPos    = 29
    Local $aRes[0][2]
    Local $nEv     = 0

    For $t = 1 To $nTracks
        If StringMid($sHex, $iPos, 8) <> "4D54726B" Then ExitLoop
        $iPos += 8
        Local $iLen = _H($sHex, $iPos, 8)
        $iPos += 8
        Local $iEnd = $iPos + ($iLen * 2)
        Local $iTick = 0, $iLastSt = 0

        While $iPos < $iEnd And $iPos < StringLen($sHex)
            Local $dt = 0, $b = 0
            Do
                If $iPos + 2 > StringLen($sHex) Then ExitLoop 2
                $b    = _H($sHex, $iPos, 2)
                $iPos += 2
                $dt   = BitOR(BitShift($dt, -7), BitAND($b, 0x7F))
            Until Not BitAND($b, 0x80)
            $iTick += $dt
            Local $ms = ($iTick * $iTempo) / ($iDiv * 1000)

            If $iPos + 2 > StringLen($sHex) Then ExitLoop
            Local $st = _H($sHex, $iPos, 2)
            If $st < 0x80 Then
                $st = $iLastSt
            Else
                $iLastSt = $st
                $iPos += 2
            EndIf
            Local $tp = BitAND($st, 0xF0)

            If $tp = 0x90 Then
                Local $note = _H($sHex, $iPos, 2)
                Local $vel  = _H($sHex, $iPos + 2, 2)
                $iPos += 4
                If $vel > 0 Then
                    ReDim $aRes[$nEv + 1][2]
                    $aRes[$nEv][0] = $ms
                    $aRes[$nEv][1] = $note
                    $nEv += 1
                EndIf
            ElseIf $tp = 0x80 Then
                $iPos += 4
            ElseIf $st = 0xFF Then
                Local $mt = _H($sHex, $iPos, 2)
                $iPos += 2
                Local $ml = _VL($sHex, $iPos)
                If $mt = 0x51 Then $iTempo = _H($sHex, $iPos, $ml * 2)
                $iPos += $ml * 2
            ElseIf $st = 0xF0 Or $st = 0xF7 Then
                $iPos += _VL($sHex, $iPos) * 2
            ElseIf $tp = 0xC0 Or $tp = 0xD0 Then
                $iPos += 2
            Else
                $iPos += 4
            EndIf
        WEnd
        $iPos = $iEnd
    Next

    If $nEv = 0 Then Return SetError(3, 0, 0)
    _ArraySort($aRes, 0, 0, 0, 0)
    Return $aRes
EndFunc

Func _VL($sHex, ByRef $iPos)
    Local $v = 0, $b = 0
    Do
        $b    = _H($sHex, $iPos, 2)
        $iPos += 2
        $v    = BitOR(BitShift($v, -7), BitAND($b, 0x7F))
    Until Not BitAND($b, 0x80)
    Return $v
EndFunc

Func _H($sHex, $pos, $len)
    Return Number("0x" & StringMid($sHex, $pos, $len))
EndFunc

; ============================================================
;  INFOS TOUCHES SELON LAYOUT ACTIF
; ============================================================
Func _GetTouchesInfo()
    Local $r1 = StringUpper($aNoteMap[0][1]) & "  " & StringUpper($aNoteMap[1][1]) & "  " & StringUpper($aNoteMap[2][1]) & "  " & StringUpper($aNoteMap[3][1]) & "  " & StringUpper($aNoteMap[4][1]) & "  " & StringUpper($aNoteMap[5][1]) & "  " & StringUpper($aNoteMap[6][1])
    Local $r2 = StringUpper($aNoteMap[7][1]) & "  " & StringUpper($aNoteMap[8][1]) & "  " & StringUpper($aNoteMap[9][1]) & "  " & StringUpper($aNoteMap[10][1]) & "  " & StringUpper($aNoteMap[11][1]) & "  " & StringUpper($aNoteMap[12][1]) & "  " & StringUpper($aNoteMap[13][1])
    Local $r3 = StringUpper($aNoteMap[14][1]) & "  " & StringUpper($aNoteMap[15][1]) & "  " & StringUpper($aNoteMap[16][1]) & "  " & StringUpper($aNoteMap[17][1]) & "  " & StringUpper($aNoteMap[18][1]) & "  " & StringUpper($aNoteMap[19][1]) & "  " & StringUpper($aNoteMap[20][1])
    Return "Layout : " & $sLayout & @CRLF & "Rangee 1 : " & $r1 & "  (C3-B3)" & @CRLF & "Rangee 2 : " & $r2 & "  (C4-B4)" & @CRLF & "Rangee 3 : " & $r3 & "  (C5-B5)"
EndFunc

; ============================================================
;  SON MODE TEST - Lecture MIDI via Windows MCI
; ============================================================
Func _TestSonDemarrer($sPath)
    ; Ferme si deja ouvert
    DllCall("winmm.dll", "DWORD", "mciSendStringW", "wstr", "close testmidi", "wstr", "", "uint", 0, "hwnd", 0)
    ; Ouvre et joue le fichier MIDI
    DllCall("winmm.dll", "DWORD", "mciSendStringW", "wstr", "open """ & $sPath & """ type sequencer alias testmidi", "wstr", "", "uint", 0, "hwnd", 0)
    DllCall("winmm.dll", "DWORD", "mciSendStringW", "wstr", "play testmidi", "wstr", "", "uint", 0, "hwnd", 0)
EndFunc

Func _TestSonArreter()
    DllCall("winmm.dll", "DWORD", "mciSendStringW", "wstr", "stop testmidi", "wstr", "", "uint", 0, "hwnd", 0)
    DllCall("winmm.dll", "DWORD", "mciSendStringW", "wstr", "close testmidi", "wstr", "", "uint", 0, "hwnd", 0)
EndFunc
