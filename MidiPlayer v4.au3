#NoTrayIcon
#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>
#include <ListViewConstants.au3>
#include <GuiListView.au3>
#include <File.au3>
#include <Array.au3>

; ============================================================
;  MIDI PLAYER v4.0 - Dark Interface - Multi-language
;  F1 = Play / Pause  |  F2 = Stop
;  Languages: English (default), French, Spanish, German, Portuguese
; ============================================================

; --- Color constants ---
Global Const $C_BG      = 0x1A1A2E
Global Const $C_PANEL   = 0x16213E
Global Const $C_ACCENT  = 0x0F3460
Global Const $C_BLUE    = 0x4FC3F7
Global Const $C_RED     = 0xEF5350
Global Const $C_GREEN   = 0x66BB6A
Global Const $C_TEXT    = 0xE0E0E0
Global Const $C_GREY    = 0x757575
Global Const $C_DARK    = 0x0D0D1A

; ============================================================
;  LANGUAGE SYSTEM
;  5 languages: EN=0  FR=1  ES=2  DE=3  PT=4
;  Each translation array holds all UI strings.
; ============================================================

; Current language index (0 = English by default)
Global $iLang = 0

; String key indices (constants for readability)
Global Const $STR_TITLE          = 0
Global Const $STR_SUBTITLE       = 1
Global Const $STR_BTN_PLAYER     = 2
Global Const $STR_BTN_SETTINGS   = 3
Global Const $STR_BTN_ABOUT      = 4
Global Const $STR_NOW_PLAYING    = 5
Global Const $STR_NO_FILE        = 6
Global Const $STR_ADD_HINT       = 7
Global Const $STR_PLAYLIST       = 8
Global Const $STR_BTN_ADD        = 9
Global Const $STR_BTN_REMOVE     = 10
Global Const $STR_BTN_CLEAR      = 11
Global Const $STR_BTN_SHUFFLE    = 12
Global Const $STR_BTN_LOOP       = 13
Global Const $STR_TESTMODE_OFF   = 14
Global Const $STR_TESTMODE_ON    = 15
Global Const $STR_ALWAYS_ON_OFF  = 16
Global Const $STR_ALWAYS_ON_ON   = 17
Global Const $STR_READY          = 18
Global Const $STR_STOPPED        = 19
Global Const $STR_PAUSED         = 20
Global Const $STR_PAUSED_HINT    = 21
Global Const $STR_PLAYING        = 22
Global Const $STR_PLAYING_TEST   = 23
Global Const $STR_RESUME         = 24
Global Const $STR_ADDED          = 25
Global Const $STR_REMOVED        = 26
Global Const $STR_CLEARED        = 27
Global Const $STR_SHUFFLE_ON     = 28
Global Const $STR_SHUFFLE_OFF    = 29
Global Const $STR_LOOP_ON        = 30
Global Const $STR_LOOP_OFF       = 31
Global Const $STR_TESTMODE_ON_S  = 32
Global Const $STR_TESTMODE_OFF_S = 33
Global Const $STR_ONTOP_ON       = 34
Global Const $STR_ONTOP_OFF      = 35
Global Const $STR_FILE_NOT_FOUND = 36
Global Const $STR_MIDI_ERROR     = 37
Global Const $STR_PLAYLIST_EMPTY = 38
Global Const $STR_POSITION       = 39
Global Const $STR_RESUME_F1      = 40
Global Const $STR_LAYOUT_CHANGED = 41
Global Const $STR_WIN_TITLE      = 42
Global Const $STR_SETTINGS_TITLE = 43
Global Const $STR_KEYBOARD_LABEL = 44
Global Const $STR_LAYOUT_ROW1    = 45
Global Const $STR_LAYOUT_ROW2    = 46
Global Const $STR_LAYOUT_ROW3    = 47
Global Const $STR_TRANSPOSE_NOTE = 48
Global Const $STR_TEST_EXPLAIN   = 49
Global Const $STR_SAVE_BTN       = 50
Global Const $STR_ABOUT_TITLE    = 51
Global Const $STR_ABOUT_SUB      = 52
Global Const $STR_ABOUT_L1       = 53
Global Const $STR_ABOUT_L2       = 54
Global Const $STR_ABOUT_L3       = 55
Global Const $STR_ABOUT_L4       = 56
Global Const $STR_OK_BTN         = 57
Global Const $STR_LV_COL1        = 58
Global Const $STR_LV_COL2        = 59
Global Const $STR_LV_COL3        = 60
Global Const $STR_LANG_LABEL     = 61
Global Const $STR_PAGE_PLAYER    = 62

Global Const $LANG_COUNT = 5
Global Const $STR_COUNT  = 63

; Build the translation table [language][string_index]
Global $aLang[$LANG_COUNT][$STR_COUNT]

; --- English (0) ---
$aLang[0][$STR_TITLE]          = "MIDI PLAYER"
$aLang[0][$STR_SUBTITLE]       = "v4.0  -  F1 Play/Pause  |  F2 Stop"
$aLang[0][$STR_BTN_PLAYER]     = "Player"
$aLang[0][$STR_BTN_SETTINGS]   = "Settings"
$aLang[0][$STR_BTN_ABOUT]      = "About"
$aLang[0][$STR_NOW_PLAYING]    = "NOW PLAYING"
$aLang[0][$STR_NO_FILE]        = "No file selected"
$aLang[0][$STR_ADD_HINT]       = "Add a MIDI file to the playlist"
$aLang[0][$STR_PLAYLIST]       = "PLAYLIST"
$aLang[0][$STR_BTN_ADD]        = "+ Add"
$aLang[0][$STR_BTN_REMOVE]     = "- Remove"
$aLang[0][$STR_BTN_CLEAR]      = "Clear all"
$aLang[0][$STR_BTN_SHUFFLE]    = "Shuffle"
$aLang[0][$STR_BTN_LOOP]       = "Loop"
$aLang[0][$STR_TESTMODE_OFF]   = "Test Mode: OFF"
$aLang[0][$STR_TESTMODE_ON]    = "Test Mode: ON"
$aLang[0][$STR_ALWAYS_ON_OFF]  = "Always on top: OFF"
$aLang[0][$STR_ALWAYS_ON_ON]   = "Always on top: ON"
$aLang[0][$STR_READY]          = "  Ready. Add MIDI files to start."
$aLang[0][$STR_STOPPED]        = "Stopped"
$aLang[0][$STR_PAUSED]         = "Paused  -  Press PLAY to resume"
$aLang[0][$STR_PAUSED_HINT]    = "Paused  -  Click PLAY to resume"
$aLang[0][$STR_PLAYING]        = "Playing"
$aLang[0][$STR_PLAYING_TEST]   = "Playing  [TEST MODE]"
$aLang[0][$STR_RESUME]         = "Resume: "
$aLang[0][$STR_ADDED]          = "Added: "
$aLang[0][$STR_REMOVED]        = "File removed"
$aLang[0][$STR_CLEARED]        = "Playlist cleared"
$aLang[0][$STR_SHUFFLE_ON]     = "Shuffle enabled"
$aLang[0][$STR_SHUFFLE_OFF]    = "Shuffle disabled"
$aLang[0][$STR_LOOP_ON]        = "Loop enabled"
$aLang[0][$STR_LOOP_OFF]       = "Loop disabled"
$aLang[0][$STR_TESTMODE_ON_S]  = "[TEST MODE] Keys will NOT be sent"
$aLang[0][$STR_TESTMODE_OFF_S] = "Test Mode off - keys are sent"
$aLang[0][$STR_ONTOP_ON]       = "Window always on top"
$aLang[0][$STR_ONTOP_OFF]      = "Normal window"
$aLang[0][$STR_FILE_NOT_FOUND] = "File not found: "
$aLang[0][$STR_MIDI_ERROR]     = "MIDI read error - invalid file?"
$aLang[0][$STR_PLAYLIST_EMPTY] = "Playlist empty - click + Add"
$aLang[0][$STR_POSITION]       = "Position: "
$aLang[0][$STR_RESUME_F1]      = "  -  F1 to resume"
$aLang[0][$STR_LAYOUT_CHANGED] = "Layout changed: "
$aLang[0][$STR_WIN_TITLE]      = "MIDI Player  -  F1 Play/Pause  |  F2 Stop"
$aLang[0][$STR_SETTINGS_TITLE] = "Settings"
$aLang[0][$STR_KEYBOARD_LABEL] = "Keyboard layout"
$aLang[0][$STR_LAYOUT_ROW1]    = "Row 1 : "
$aLang[0][$STR_LAYOUT_ROW2]    = "Row 2 : "
$aLang[0][$STR_LAYOUT_ROW3]    = "Row 3 : "
$aLang[0][$STR_TRANSPOSE_NOTE] = "Notes outside range are transposed automatically."
$aLang[0][$STR_TEST_EXPLAIN]   = "Test Mode: plays MIDI with Windows sound (no keys sent)."
$aLang[0][$STR_SAVE_BTN]       = "Save"
$aLang[0][$STR_ABOUT_TITLE]    = "MIDI Player v4.0 by DannSKiller"
$aLang[0][$STR_ABOUT_SUB]      = "AutoIt Script - Universal MIDI Player"
$aLang[0][$STR_ABOUT_L1]       = "- Reads .mid files and sends keyboard keys"
$aLang[0][$STR_ABOUT_L2]       = "- Works on any active window"
$aLang[0][$STR_ABOUT_L3]       = "- F1 to start / stop playback"
$aLang[0][$STR_ABOUT_L4]       = "- Test Mode: play without sending keys"
$aLang[0][$STR_OK_BTN]         = "OK"
$aLang[0][$STR_LV_COL1]        = "#"
$aLang[0][$STR_LV_COL2]        = "Title"
$aLang[0][$STR_LV_COL3]        = "Duration"
$aLang[0][$STR_LANG_LABEL]     = "Language"
$aLang[0][$STR_PAGE_PLAYER]    = "Player page"

; --- French (1) ---
$aLang[1][$STR_TITLE]          = "MIDI PLAYER"
$aLang[1][$STR_SUBTITLE]       = "v4.0  -  F1 Play/Pause  |  F2 Stop"
$aLang[1][$STR_BTN_PLAYER]     = "Lecteur"
$aLang[1][$STR_BTN_SETTINGS]   = "Parametres"
$aLang[1][$STR_BTN_ABOUT]      = "A propos"
$aLang[1][$STR_NOW_PLAYING]    = "EN LECTURE"
$aLang[1][$STR_NO_FILE]        = "Aucun fichier selectionne"
$aLang[1][$STR_ADD_HINT]       = "Ajoute un fichier MIDI dans la playlist"
$aLang[1][$STR_PLAYLIST]       = "PLAYLIST"
$aLang[1][$STR_BTN_ADD]        = "+ Ajouter"
$aLang[1][$STR_BTN_REMOVE]     = "- Retirer"
$aLang[1][$STR_BTN_CLEAR]      = "Vider tout"
$aLang[1][$STR_BTN_SHUFFLE]    = "Aleat."
$aLang[1][$STR_BTN_LOOP]       = "Boucle"
$aLang[1][$STR_TESTMODE_OFF]   = "Mode Test: OFF"
$aLang[1][$STR_TESTMODE_ON]    = "Mode Test: ON"
$aLang[1][$STR_ALWAYS_ON_OFF]  = "Tjrs visible: OFF"
$aLang[1][$STR_ALWAYS_ON_ON]   = "Toujours visible: ON"
$aLang[1][$STR_READY]          = "  Pret. Ajoute des fichiers MIDI pour commencer."
$aLang[1][$STR_STOPPED]        = "Arrete"
$aLang[1][$STR_PAUSED]         = "En pause  -  PLAY pour reprendre"
$aLang[1][$STR_PAUSED_HINT]    = "En pause  -  clique sur PLAY pour reprendre"
$aLang[1][$STR_PLAYING]        = "En lecture"
$aLang[1][$STR_PLAYING_TEST]   = "En lecture  [MODE TEST]"
$aLang[1][$STR_RESUME]         = "Reprise : "
$aLang[1][$STR_ADDED]          = "Ajoute : "
$aLang[1][$STR_REMOVED]        = "Fichier retire"
$aLang[1][$STR_CLEARED]        = "Playlist videe"
$aLang[1][$STR_SHUFFLE_ON]     = "Lecture aleatoire activee"
$aLang[1][$STR_SHUFFLE_OFF]    = "Lecture aleatoire desactivee"
$aLang[1][$STR_LOOP_ON]        = "Repetition activee"
$aLang[1][$STR_LOOP_OFF]       = "Repetition desactivee"
$aLang[1][$STR_TESTMODE_ON_S]  = "[MODE TEST] Les touches ne seront PAS envoyees"
$aLang[1][$STR_TESTMODE_OFF_S] = "Mode Test desactive - les touches sont envoyees"
$aLang[1][$STR_ONTOP_ON]       = "Fenetre toujours au premier plan"
$aLang[1][$STR_ONTOP_OFF]      = "Fenetre normale"
$aLang[1][$STR_FILE_NOT_FOUND] = "Fichier introuvable : "
$aLang[1][$STR_MIDI_ERROR]     = "Erreur de lecture MIDI - fichier invalide ?"
$aLang[1][$STR_PLAYLIST_EMPTY] = "Playlist vide - clique sur + Ajouter"
$aLang[1][$STR_POSITION]       = "Position : "
$aLang[1][$STR_RESUME_F1]      = "  -  F1 pour reprendre"
$aLang[1][$STR_LAYOUT_CHANGED] = "Layout change : "
$aLang[1][$STR_WIN_TITLE]      = "MIDI Player  -  F1 Play/Pause  |  F2 Stop"
$aLang[1][$STR_SETTINGS_TITLE] = "Parametres"
$aLang[1][$STR_KEYBOARD_LABEL] = "Disposition du clavier"
$aLang[1][$STR_LAYOUT_ROW1]    = "Rangee 1 : "
$aLang[1][$STR_LAYOUT_ROW2]    = "Rangee 2 : "
$aLang[1][$STR_LAYOUT_ROW3]    = "Rangee 3 : "
$aLang[1][$STR_TRANSPOSE_NOTE] = "Les notes hors plage sont transposees automatiquement."
$aLang[1][$STR_TEST_EXPLAIN]   = "Mode Test : ecoute le MIDI avec le son Windows (sans envoyer de touches)."
$aLang[1][$STR_SAVE_BTN]       = "Enregistrer"
$aLang[1][$STR_ABOUT_TITLE]    = "MIDI Player v4.0 by DannSKiller"
$aLang[1][$STR_ABOUT_SUB]      = "Script AutoIt - Lecteur MIDI universel"
$aLang[1][$STR_ABOUT_L1]       = "- Lit les fichiers .mid et envoie les touches clavier"
$aLang[1][$STR_ABOUT_L2]       = "- Fonctionne sur n'importe quelle fenetre active"
$aLang[1][$STR_ABOUT_L3]       = "- F1 pour demarrer / arreter la lecture"
$aLang[1][$STR_ABOUT_L4]       = "- Mode Test : lecture sans envoi de touches"
$aLang[1][$STR_OK_BTN]         = "OK"
$aLang[1][$STR_LV_COL1]        = "#"
$aLang[1][$STR_LV_COL2]        = "Titre"
$aLang[1][$STR_LV_COL3]        = "Duree"
$aLang[1][$STR_LANG_LABEL]     = "Langue"
$aLang[1][$STR_PAGE_PLAYER]    = "Page Lecteur"

; --- Spanish (2) ---
$aLang[2][$STR_TITLE]          = "MIDI PLAYER"
$aLang[2][$STR_SUBTITLE]       = "v4.0  -  F1 Play/Pausa  |  F2 Stop"
$aLang[2][$STR_BTN_PLAYER]     = "Reproductor"
$aLang[2][$STR_BTN_SETTINGS]   = "Ajustes"
$aLang[2][$STR_BTN_ABOUT]      = "Acerca de"
$aLang[2][$STR_NOW_PLAYING]    = "REPRODUCIENDO"
$aLang[2][$STR_NO_FILE]        = "Ningun archivo seleccionado"
$aLang[2][$STR_ADD_HINT]       = "Agrega un archivo MIDI a la lista"
$aLang[2][$STR_PLAYLIST]       = "LISTA"
$aLang[2][$STR_BTN_ADD]        = "+ Agregar"
$aLang[2][$STR_BTN_REMOVE]     = "- Quitar"
$aLang[2][$STR_BTN_CLEAR]      = "Borrar todo"
$aLang[2][$STR_BTN_SHUFFLE]    = "Aleat."
$aLang[2][$STR_BTN_LOOP]       = "Bucle"
$aLang[2][$STR_TESTMODE_OFF]   = "Modo Test: OFF"
$aLang[2][$STR_TESTMODE_ON]    = "Modo Test: ON"
$aLang[2][$STR_ALWAYS_ON_OFF]  = "Siempre visible: OFF"
$aLang[2][$STR_ALWAYS_ON_ON]   = "Siempre visible: ON"
$aLang[2][$STR_READY]          = "  Listo. Agrega archivos MIDI para empezar."
$aLang[2][$STR_STOPPED]        = "Detenido"
$aLang[2][$STR_PAUSED]         = "Pausado  -  PLAY para continuar"
$aLang[2][$STR_PAUSED_HINT]    = "Pausado  -  Haz clic en PLAY para continuar"
$aLang[2][$STR_PLAYING]        = "Reproduciendo"
$aLang[2][$STR_PLAYING_TEST]   = "Reproduciendo  [MODO TEST]"
$aLang[2][$STR_RESUME]         = "Retomar: "
$aLang[2][$STR_ADDED]          = "Agregado: "
$aLang[2][$STR_REMOVED]        = "Archivo eliminado"
$aLang[2][$STR_CLEARED]        = "Lista vaciada"
$aLang[2][$STR_SHUFFLE_ON]     = "Reproduccion aleatoria activada"
$aLang[2][$STR_SHUFFLE_OFF]    = "Reproduccion aleatoria desactivada"
$aLang[2][$STR_LOOP_ON]        = "Repeticion activada"
$aLang[2][$STR_LOOP_OFF]       = "Repeticion desactivada"
$aLang[2][$STR_TESTMODE_ON_S]  = "[MODO TEST] Las teclas NO seran enviadas"
$aLang[2][$STR_TESTMODE_OFF_S] = "Modo Test desactivado - teclas enviadas"
$aLang[2][$STR_ONTOP_ON]       = "Ventana siempre encima"
$aLang[2][$STR_ONTOP_OFF]      = "Ventana normal"
$aLang[2][$STR_FILE_NOT_FOUND] = "Archivo no encontrado: "
$aLang[2][$STR_MIDI_ERROR]     = "Error de lectura MIDI - archivo invalido?"
$aLang[2][$STR_PLAYLIST_EMPTY] = "Lista vacia - haz clic en + Agregar"
$aLang[2][$STR_POSITION]       = "Posicion: "
$aLang[2][$STR_RESUME_F1]      = "  -  F1 para continuar"
$aLang[2][$STR_LAYOUT_CHANGED] = "Disposicion cambiada: "
$aLang[2][$STR_WIN_TITLE]      = "MIDI Player  -  F1 Play/Pausa  |  F2 Stop"
$aLang[2][$STR_SETTINGS_TITLE] = "Ajustes"
$aLang[2][$STR_KEYBOARD_LABEL] = "Disposicion del teclado"
$aLang[2][$STR_LAYOUT_ROW1]    = "Fila 1 : "
$aLang[2][$STR_LAYOUT_ROW2]    = "Fila 2 : "
$aLang[2][$STR_LAYOUT_ROW3]    = "Fila 3 : "
$aLang[2][$STR_TRANSPOSE_NOTE] = "Las notas fuera de rango se transponen automaticamente."
$aLang[2][$STR_TEST_EXPLAIN]   = "Modo Test: reproduce MIDI con sonido Windows (sin enviar teclas)."
$aLang[2][$STR_SAVE_BTN]       = "Guardar"
$aLang[2][$STR_ABOUT_TITLE]    = "MIDI Player v4.0 by DannSKiller"
$aLang[2][$STR_ABOUT_SUB]      = "Script AutoIt - Reproductor MIDI universal"
$aLang[2][$STR_ABOUT_L1]       = "- Lee archivos .mid y envia teclas del teclado"
$aLang[2][$STR_ABOUT_L2]       = "- Funciona en cualquier ventana activa"
$aLang[2][$STR_ABOUT_L3]       = "- F1 para iniciar / detener la reproduccion"
$aLang[2][$STR_ABOUT_L4]       = "- Modo Test: reproduce sin enviar teclas"
$aLang[2][$STR_OK_BTN]         = "OK"
$aLang[2][$STR_LV_COL1]        = "#"
$aLang[2][$STR_LV_COL2]        = "Titulo"
$aLang[2][$STR_LV_COL3]        = "Duracion"
$aLang[2][$STR_LANG_LABEL]     = "Idioma"
$aLang[2][$STR_PAGE_PLAYER]    = "Pagina Reproductor"

; --- German (3) ---
$aLang[3][$STR_TITLE]          = "MIDI PLAYER"
$aLang[3][$STR_SUBTITLE]       = "v4.0  -  F1 Abspielen/Pause  |  F2 Stop"
$aLang[3][$STR_BTN_PLAYER]     = "Player"
$aLang[3][$STR_BTN_SETTINGS]   = "Einstellungen"
$aLang[3][$STR_BTN_ABOUT]      = "Info"
$aLang[3][$STR_NOW_PLAYING]    = "WIRD GESPIELT"
$aLang[3][$STR_NO_FILE]        = "Keine Datei ausgewaehlt"
$aLang[3][$STR_ADD_HINT]       = "MIDI-Datei zur Wiedergabeliste hinzufuegen"
$aLang[3][$STR_PLAYLIST]       = "WIEDERGABELISTE"
$aLang[3][$STR_BTN_ADD]        = "+ Hinzu"
$aLang[3][$STR_BTN_REMOVE]     = "- Entfernen"
$aLang[3][$STR_BTN_CLEAR]      = "Alles leeren"
$aLang[3][$STR_BTN_SHUFFLE]    = "Zufaellig"
$aLang[3][$STR_BTN_LOOP]       = "Schleifen"
$aLang[3][$STR_TESTMODE_OFF]   = "Testmodus: AUS"
$aLang[3][$STR_TESTMODE_ON]    = "Testmodus: EIN"
$aLang[3][$STR_ALWAYS_ON_OFF]  = "Immer sichtbar: AUS"
$aLang[3][$STR_ALWAYS_ON_ON]   = "Immer sichtbar: EIN"
$aLang[3][$STR_READY]          = "  Bereit. MIDI-Dateien hinzufuegen."
$aLang[3][$STR_STOPPED]        = "Gestoppt"
$aLang[3][$STR_PAUSED]         = "Pausiert  -  PLAY zum Fortfahren"
$aLang[3][$STR_PAUSED_HINT]    = "Pausiert  -  PLAY klicken zum Fortfahren"
$aLang[3][$STR_PLAYING]        = "Wird gespielt"
$aLang[3][$STR_PLAYING_TEST]   = "Wird gespielt  [TESTMODUS]"
$aLang[3][$STR_RESUME]         = "Weiter: "
$aLang[3][$STR_ADDED]          = "Hinzugefuegt: "
$aLang[3][$STR_REMOVED]        = "Datei entfernt"
$aLang[3][$STR_CLEARED]        = "Liste geleert"
$aLang[3][$STR_SHUFFLE_ON]     = "Zufallswiedergabe aktiviert"
$aLang[3][$STR_SHUFFLE_OFF]    = "Zufallswiedergabe deaktiviert"
$aLang[3][$STR_LOOP_ON]        = "Schleife aktiviert"
$aLang[3][$STR_LOOP_OFF]       = "Schleife deaktiviert"
$aLang[3][$STR_TESTMODE_ON_S]  = "[TESTMODUS] Tasten werden NICHT gesendet"
$aLang[3][$STR_TESTMODE_OFF_S] = "Testmodus deaktiviert - Tasten werden gesendet"
$aLang[3][$STR_ONTOP_ON]       = "Fenster immer im Vordergrund"
$aLang[3][$STR_ONTOP_OFF]      = "Normales Fenster"
$aLang[3][$STR_FILE_NOT_FOUND] = "Datei nicht gefunden: "
$aLang[3][$STR_MIDI_ERROR]     = "MIDI-Lesefehler - ungueltige Datei?"
$aLang[3][$STR_PLAYLIST_EMPTY] = "Liste leer - klicke + Hinzu"
$aLang[3][$STR_POSITION]       = "Position: "
$aLang[3][$STR_RESUME_F1]      = "  -  F1 zum Fortfahren"
$aLang[3][$STR_LAYOUT_CHANGED] = "Layout geaendert: "
$aLang[3][$STR_WIN_TITLE]      = "MIDI Player  -  F1 Play/Pause  |  F2 Stop"
$aLang[3][$STR_SETTINGS_TITLE] = "Einstellungen"
$aLang[3][$STR_KEYBOARD_LABEL] = "Tastaturlayout"
$aLang[3][$STR_LAYOUT_ROW1]    = "Reihe 1 : "
$aLang[3][$STR_LAYOUT_ROW2]    = "Reihe 2 : "
$aLang[3][$STR_LAYOUT_ROW3]    = "Reihe 3 : "
$aLang[3][$STR_TRANSPOSE_NOTE] = "Noten ausserhalb des Bereichs werden automatisch transponiert."
$aLang[3][$STR_TEST_EXPLAIN]   = "Testmodus: spielt MIDI mit Windows-Sound (keine Tasten gesendet)."
$aLang[3][$STR_SAVE_BTN]       = "Speichern"
$aLang[3][$STR_ABOUT_TITLE]    = "MIDI Player v4.0 by DannSKiller"
$aLang[3][$STR_ABOUT_SUB]      = "AutoIt-Skript - Universeller MIDI-Player"
$aLang[3][$STR_ABOUT_L1]       = "- Liest .mid-Dateien und sendet Tastatureingaben"
$aLang[3][$STR_ABOUT_L2]       = "- Funktioniert in jedem aktiven Fenster"
$aLang[3][$STR_ABOUT_L3]       = "- F1 zum Starten / Stoppen der Wiedergabe"
$aLang[3][$STR_ABOUT_L4]       = "- Testmodus: Wiedergabe ohne Tasten senden"
$aLang[3][$STR_OK_BTN]         = "OK"
$aLang[3][$STR_LV_COL1]        = "#"
$aLang[3][$STR_LV_COL2]        = "Titel"
$aLang[3][$STR_LV_COL3]        = "Dauer"
$aLang[3][$STR_LANG_LABEL]     = "Sprache"
$aLang[3][$STR_PAGE_PLAYER]    = "Player-Seite"

; --- Portuguese (4) ---
$aLang[4][$STR_TITLE]          = "MIDI PLAYER"
$aLang[4][$STR_SUBTITLE]       = "v4.0  -  F1 Play/Pausa  |  F2 Stop"
$aLang[4][$STR_BTN_PLAYER]     = "Reprodutor"
$aLang[4][$STR_BTN_SETTINGS]   = "Definicoes"
$aLang[4][$STR_BTN_ABOUT]      = "Sobre"
$aLang[4][$STR_NOW_PLAYING]    = "A TOCAR"
$aLang[4][$STR_NO_FILE]        = "Nenhum ficheiro selecionado"
$aLang[4][$STR_ADD_HINT]       = "Adiciona um ficheiro MIDI a lista"
$aLang[4][$STR_PLAYLIST]       = "LISTA"
$aLang[4][$STR_BTN_ADD]        = "+ Adicionar"
$aLang[4][$STR_BTN_REMOVE]     = "- Remover"
$aLang[4][$STR_BTN_CLEAR]      = "Limpar tudo"
$aLang[4][$STR_BTN_SHUFFLE]    = "Aleat."
$aLang[4][$STR_BTN_LOOP]       = "Repetir"
$aLang[4][$STR_TESTMODE_OFF]   = "Modo Teste: OFF"
$aLang[4][$STR_TESTMODE_ON]    = "Modo Teste: ON"
$aLang[4][$STR_ALWAYS_ON_OFF]  = "Sempre visivel: OFF"
$aLang[4][$STR_ALWAYS_ON_ON]   = "Sempre visivel: ON"
$aLang[4][$STR_READY]          = "  Pronto. Adiciona ficheiros MIDI para comecar."
$aLang[4][$STR_STOPPED]        = "Parado"
$aLang[4][$STR_PAUSED]         = "Pausado  -  PLAY para retomar"
$aLang[4][$STR_PAUSED_HINT]    = "Pausado  -  Clica em PLAY para retomar"
$aLang[4][$STR_PLAYING]        = "A tocar"
$aLang[4][$STR_PLAYING_TEST]   = "A tocar  [MODO TESTE]"
$aLang[4][$STR_RESUME]         = "Retomar: "
$aLang[4][$STR_ADDED]          = "Adicionado: "
$aLang[4][$STR_REMOVED]        = "Ficheiro removido"
$aLang[4][$STR_CLEARED]        = "Lista limpa"
$aLang[4][$STR_SHUFFLE_ON]     = "Reproducao aleatoria ativada"
$aLang[4][$STR_SHUFFLE_OFF]    = "Reproducao aleatoria desativada"
$aLang[4][$STR_LOOP_ON]        = "Repeticao ativada"
$aLang[4][$STR_LOOP_OFF]       = "Repeticao desativada"
$aLang[4][$STR_TESTMODE_ON_S]  = "[MODO TESTE] Teclas NAO serao enviadas"
$aLang[4][$STR_TESTMODE_OFF_S] = "Modo Teste desativado - teclas enviadas"
$aLang[4][$STR_ONTOP_ON]       = "Janela sempre em cima"
$aLang[4][$STR_ONTOP_OFF]      = "Janela normal"
$aLang[4][$STR_FILE_NOT_FOUND] = "Ficheiro nao encontrado: "
$aLang[4][$STR_MIDI_ERROR]     = "Erro de leitura MIDI - ficheiro invalido?"
$aLang[4][$STR_PLAYLIST_EMPTY] = "Lista vazia - clica em + Adicionar"
$aLang[4][$STR_POSITION]       = "Posicao: "
$aLang[4][$STR_RESUME_F1]      = "  -  F1 para retomar"
$aLang[4][$STR_LAYOUT_CHANGED] = "Disposicao alterada: "
$aLang[4][$STR_WIN_TITLE]      = "MIDI Player  -  F1 Play/Pausa  |  F2 Stop"
$aLang[4][$STR_SETTINGS_TITLE] = "Definicoes"
$aLang[4][$STR_KEYBOARD_LABEL] = "Disposicao do teclado"
$aLang[4][$STR_LAYOUT_ROW1]    = "Linha 1 : "
$aLang[4][$STR_LAYOUT_ROW2]    = "Linha 2 : "
$aLang[4][$STR_LAYOUT_ROW3]    = "Linha 3 : "
$aLang[4][$STR_TRANSPOSE_NOTE] = "Notas fora do intervalo sao transpostas automaticamente."
$aLang[4][$STR_TEST_EXPLAIN]   = "Modo Teste: toca MIDI com som Windows (sem enviar teclas)."
$aLang[4][$STR_SAVE_BTN]       = "Guardar"
$aLang[4][$STR_ABOUT_TITLE]    = "MIDI Player v4.0 by DannSKiller"
$aLang[4][$STR_ABOUT_SUB]      = "Script AutoIt - Reprodutor MIDI universal"
$aLang[4][$STR_ABOUT_L1]       = "- Le ficheiros .mid e envia teclas do teclado"
$aLang[4][$STR_ABOUT_L2]       = "- Funciona em qualquer janela ativa"
$aLang[4][$STR_ABOUT_L3]       = "- F1 para iniciar / parar a reproducao"
$aLang[4][$STR_ABOUT_L4]       = "- Modo Teste: reproducao sem enviar teclas"
$aLang[4][$STR_OK_BTN]         = "OK"
$aLang[4][$STR_LV_COL1]        = "#"
$aLang[4][$STR_LV_COL2]        = "Titulo"
$aLang[4][$STR_LV_COL3]        = "Duracao"
$aLang[4][$STR_LANG_LABEL]     = "Idioma"
$aLang[4][$STR_PAGE_PLAYER]    = "Pagina Reprodutor"

; --- Language name list displayed in the combo (same order as indices) ---
Global Const $sLangNames = "English|Francais|Espanol|Deutsch|Portugues"

; ============================================================
;  HELPER: return the translated string for the current language
; ============================================================
Func _L($iKey)
    Return $aLang[$iLang][$iKey]
EndFunc

; ============================================================
;  MIDI -> KEYBOARD MAPPING
;  21 notes, 3 rows of 7 keys
; ============================================================
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

; --- Playback and UI state ---
Global $bPlaying    = False
Global $bTestMode   = False
Global $bShuffle    = False
Global $bLoop       = False
Global $iCurrentIdx = -1
Global $iTotalMs    = 0
Global $iPlayStart  = 0
Global $aFiles[0]
Global $sLayout     = "QWERTY"     ; default layout (QWERTY as per requirement)
Global $iPausePos   = -1           ; pause position in ms (-1 = not paused)
Global $iOffsetActif = 0           ; active offset for the progress bar

; ============================================================
;  KEYBOARD LAYOUT MAPPINGS
;  MIDI notes shared by all layouts: 48 50 52 53 55 57 59 /
;  60 62 64 65 67 69 71 / 72 74 76 77 79 81 83
;  Only the key assignments differ per layout.
; ============================================================
Func _LoadLayout($sL)
    $sLayout = $sL
    If $sL = "AZERTY" Then
        ; Row 1: W X C V B N ,
        ; Row 2: Q S D F G H J
        ; Row 3: A Z E R T Y U
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
        ; Like QWERTY but Y and Z are swapped
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
    Else ; QWERTY (default)
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
;  MAIN GUI  (700 x 580)
; ============================================================
Global $hGUI = GUICreate(_L($STR_WIN_TITLE), 700, 580)
GUISetBkColor($C_BG)

; --- Title label ---
GUICtrlCreateLabel(_L($STR_TITLE), 20, 15, 300, 28)
GUICtrlSetFont(-1, 16, 800, 0, "Segoe UI")
GUICtrlSetColor(-1, $C_BLUE)

; --- Subtitle / hotkey reminder ---
GUICtrlCreateLabel(_L($STR_SUBTITLE), 20, 44, 300, 16)
GUICtrlSetFont(-1, 8, 400, 0, "Segoe UI")
GUICtrlSetColor(-1, $C_GREY)

; ---- NAV BUTTONS (Player / Settings / About) ----
; Shifted left to leave room for the language combo on the right
Global $hNavPlayer   = GUICtrlCreateButton(_L($STR_BTN_PLAYER),   330, 15, 80, 28)
Global $hNavSettings = GUICtrlCreateButton(_L($STR_BTN_SETTINGS), 415, 15, 80, 28)
Global $hNavAbout    = GUICtrlCreateButton(_L($STR_BTN_ABOUT),    500, 15, 80, 28)

; ---- LANGUAGE COMBO  (right side, no overlap with nav buttons) ----
; The first parameter of GUICtrlCreateCombo sets the initial visible text AND
; makes GUICtrlRead() return it immediately — critical for polling to work.
; Remaining languages are appended with GUICtrlSetData (no third parameter =
; no forced re-selection, so "English" stays selected at startup).
; We poll the raw Windows message CB_GETCURSEL (0x0147) via SendMessage to get
; a reliable integer index — reading the text string can return "" on some builds.
Global $hLangCombo     = GUICtrlCreateCombo("English", 590, 18, 100, 130)
GUICtrlSetData($hLangCombo, "Francais|Espanol|Deutsch|Portugues")
GUICtrlSetFont(-1, 8, 400, 0, "Segoe UI")
Global $hLangComboHWND = GUICtrlGetHandle($hLangCombo)   ; raw HWND for SendMessage
Global $iLastLangIdx   = 0   ; last known index (0=EN 1=FR 2=ES 3=DE 4=PT)

; --- Horizontal separator ---
GUICtrlCreateLabel("", 0, 65, 700, 2)
GUICtrlSetBkColor(-1, $C_ACCENT)

; ---- NOW PLAYING panel ----
GUICtrlCreateLabel("", 10, 75, 680, 90)
GUICtrlSetBkColor(-1, $C_PANEL)

Global $hLblNowPlaying = GUICtrlCreateLabel(_L($STR_NOW_PLAYING), 25, 82, 200, 14)
GUICtrlSetFont(-1, 7, 700, 0, "Segoe UI")
GUICtrlSetColor(-1, $C_GREY)
GUICtrlSetBkColor(-1, $C_PANEL)

Global $hLblTitre = GUICtrlCreateLabel(_L($STR_NO_FILE), 25, 98, 650, 22)
GUICtrlSetFont(-1, 12, 700, 0, "Segoe UI")
GUICtrlSetColor(-1, $C_TEXT)
GUICtrlSetBkColor(-1, $C_PANEL)

Global $hLblSous = GUICtrlCreateLabel(_L($STR_ADD_HINT), 25, 122, 650, 16)
GUICtrlSetFont(-1, 8, 400, 0, "Segoe UI")
GUICtrlSetColor(-1, $C_GREY)
GUICtrlSetBkColor(-1, $C_PANEL)

; --- Progress bar (background track + filled bar) ---
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

; ---- TRANSPORT CONTROLS separator ---
GUICtrlCreateLabel("", 0, 172, 700, 2)
GUICtrlSetBkColor(-1, $C_ACCENT)

; Buttons layout (x positions chosen so nothing overlaps):
;  Shuffle | |<< | [PLAY] | [PAUSE] | [STOP] | >>| | Loop
Global $hBtnShuffle = GUICtrlCreateButton(_L($STR_BTN_SHUFFLE), 10,  184, 58, 30)
Global $hBtnPrev    = GUICtrlCreateButton("|<<",                76,  182, 46, 34)
Global $hBtnPlay    = GUICtrlCreateButton("PLAY",              130,  177, 76, 44)
Global $hBtnPause   = GUICtrlCreateButton("PAUSE",             214,  177, 76, 44)
Global $hBtnStop    = GUICtrlCreateButton("STOP",              298,  177, 76, 44)
Global $hBtnNext    = GUICtrlCreateButton(">>|",               382,  182, 46, 34)
Global $hBtnLoop    = GUICtrlCreateButton(_L($STR_BTN_LOOP),   436,  184, 58, 30)

GUICtrlSetFont($hBtnPlay,  10, 800, 0, "Segoe UI")
GUICtrlSetBkColor($hBtnPlay,  $C_BLUE)
GUICtrlSetColor($hBtnPlay,  $C_DARK)

GUICtrlSetFont($hBtnPause, 10, 800, 0, "Segoe UI")
GUICtrlSetBkColor($hBtnPause, $C_ACCENT)
GUICtrlSetColor($hBtnPause, $C_TEXT)

GUICtrlSetFont($hBtnStop,  10, 800, 0, "Segoe UI")
GUICtrlSetBkColor($hBtnStop,  $C_RED)
GUICtrlSetColor($hBtnStop,  $C_DARK)

; ---- PLAYLIST section ----
GUICtrlCreateLabel("", 0, 228, 700, 2)
GUICtrlSetBkColor(-1, $C_ACCENT)

Global $hLblPlaylist = GUICtrlCreateLabel(_L($STR_PLAYLIST), 20, 238, 200, 18)
GUICtrlSetFont(-1, 10, 700, 0, "Segoe UI")
GUICtrlSetColor(-1, $C_TEXT)

Global $hBtnAjouter  = GUICtrlCreateButton(_L($STR_BTN_ADD),    470, 234, 90, 24)
Global $hBtnRetirer  = GUICtrlCreateButton(_L($STR_BTN_REMOVE), 565, 234, 90, 24)
Global $hBtnVider    = GUICtrlCreateButton(_L($STR_BTN_CLEAR),  335, 234, 90, 24)

Global $hLV = GUICtrlCreateListView(_L($STR_LV_COL1) & "|" & _L($STR_LV_COL2) & "|" & _L($STR_LV_COL3), 10, 264, 680, 240, $LVS_SINGLESEL + $LVS_SHOWSELALWAYS)
GUICtrlSetBkColor(-1, $C_PANEL)
GUICtrlSetColor(-1, $C_TEXT)
GUICtrlSetFont(-1, 9, 400, 0, "Segoe UI")
_GUICtrlListView_SetColumnWidth($hLV, 0, 35)
_GUICtrlListView_SetColumnWidth($hLV, 1, 560)
_GUICtrlListView_SetColumnWidth($hLV, 2, 65)

; ---- STATUS BAR + bottom buttons ----
GUICtrlCreateLabel("", 0, 530, 700, 1)
GUICtrlSetBkColor(-1, $C_ACCENT)

Global $hLblStatus = GUICtrlCreateLabel(_L($STR_READY), 0, 534, 380, 18)
GUICtrlSetFont(-1, 8, 400, 0, "Segoe UI")
GUICtrlSetColor(-1, $C_GREY)

; ---- TEST MODE toggle button ----
Global $hBtnTest = GUICtrlCreateButton(_L($STR_TESTMODE_OFF), 385, 532, 150, 22)
GUICtrlSetFont(-1, 7, 400, 0, "Segoe UI")
GUICtrlSetBkColor($hBtnTest, $C_ACCENT)
GUICtrlSetColor($hBtnTest, $C_TEXT)

; ---- ALWAYS ON TOP toggle button ----
Global $hBtnTop = GUICtrlCreateButton(_L($STR_ALWAYS_ON_OFF), 540, 532, 150, 22)
GUICtrlSetFont(-1, 7, 400, 0, "Segoe UI")
GUICtrlSetBkColor($hBtnTop, $C_ACCENT)
GUICtrlSetColor($hBtnTop, $C_TEXT)
Global $bOnTop = False

; ---- Register hotkeys, adlib timer and window message handler ----
HotKeySet("{F1}", "_TogglePlay")
HotKeySet("{F2}", "_StopPlay")
_LoadLayout($sLayout)       ; load default keyboard layout on startup
AdlibRegister("_UpdateProg", 200)
GUIRegisterMsg($WM_LBUTTONDOWN, "_ClickProgress")

GUISetState(@SW_SHOW, $hGUI)

; ============================================================
;  MAIN EVENT LOOP
; ============================================================
While 1
    Local $msg = GUIGetMsg()
    Switch $msg
        Case $GUI_EVENT_CLOSE
            _StopPlay()
            Exit

        Case $hBtnAjouter
            _AddFiles()

        Case $hBtnRetirer
            _RemoveFile()

        Case $hBtnVider
            _ClearPlaylist()

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
            ; Toggle shuffle mode and update button appearance
            $bShuffle = Not $bShuffle
            If $bShuffle Then
                GUICtrlSetBkColor($hBtnShuffle, $C_BLUE)
                GUICtrlSetColor($hBtnShuffle, $C_DARK)
                _Status(_L($STR_SHUFFLE_ON))
            Else
                GUICtrlSetBkColor($hBtnShuffle, -2)
                GUICtrlSetColor($hBtnShuffle, $C_TEXT)
                _Status(_L($STR_SHUFFLE_OFF))
            EndIf

        Case $hBtnLoop
            ; Toggle loop mode and update button appearance
            $bLoop = Not $bLoop
            If $bLoop Then
                GUICtrlSetBkColor($hBtnLoop, $C_BLUE)
                GUICtrlSetColor($hBtnLoop, $C_DARK)
                _Status(_L($STR_LOOP_ON))
            Else
                GUICtrlSetBkColor($hBtnLoop, -2)
                GUICtrlSetColor($hBtnLoop, $C_TEXT)
                _Status(_L($STR_LOOP_OFF))
            EndIf

        Case $hBtnTest
            ; Toggle test mode (audio preview without key sending)
            $bTestMode = Not $bTestMode
            If $bTestMode Then
                GUICtrlSetData($hBtnTest, _L($STR_TESTMODE_ON))
                GUICtrlSetBkColor($hBtnTest, $C_GREEN)
                GUICtrlSetColor($hBtnTest, $C_DARK)
                _Status(_L($STR_TESTMODE_ON_S))
            Else
                GUICtrlSetData($hBtnTest, _L($STR_TESTMODE_OFF))
                GUICtrlSetBkColor($hBtnTest, $C_ACCENT)
                GUICtrlSetColor($hBtnTest, $C_TEXT)
                _Status(_L($STR_TESTMODE_OFF_S))
            EndIf

        Case $hNavPlayer
            _Status(_L($STR_PAGE_PLAYER))

        Case $hNavSettings
            _PageSettings()

        Case $hNavAbout
            _PageAbout()

        Case $hBtnTop
            ; Toggle always-on-top window flag
            $bOnTop = Not $bOnTop
            If $bOnTop Then
                WinSetOnTop($hGUI, "", 1)
                GUICtrlSetData($hBtnTop, _L($STR_ALWAYS_ON_ON))
                GUICtrlSetBkColor($hBtnTop, $C_BLUE)
                GUICtrlSetColor($hBtnTop, $C_DARK)
                _Status(_L($STR_ONTOP_ON))
            Else
                WinSetOnTop($hGUI, "", 0)
                GUICtrlSetData($hBtnTop, _L($STR_ALWAYS_ON_OFF))
                GUICtrlSetBkColor($hBtnTop, $C_ACCENT)
                GUICtrlSetColor($hBtnTop, $C_TEXT)
                _Status(_L($STR_ONTOP_OFF))
            EndIf

    EndSwitch

    ; --- Language combo polling (main loop) ---
    ; CB_GETCURSEL (0x0147) returns the selected index directly from Windows —
    ; more reliable than GUICtrlRead which can return "" with some combo styles.
    Local $iCurIdx = DllCall("user32.dll","lresult","SendMessageW","hwnd",$hLangComboHWND,"uint",0x0147,"wparam",0,"lparam",0)[0]
    If $iCurIdx >= 0 And $iCurIdx <> $iLastLangIdx Then
        $iLastLangIdx = $iCurIdx
        $iLang = $iCurIdx
        _RefreshUILanguage()
    EndIf

WEnd

; ============================================================
;  LANGUAGE APPLICATION
;  Reads the combo selection, updates $iLang, then refreshes
;  every translatable label/button in the main window.
; ============================================================
Func _ApplyLanguageFromCombo()
    ; Read index via CB_GETCURSEL for reliability, fall back to text matching
    Local $iIdx = DllCall("user32.dll","lresult","SendMessageW","hwnd",$hLangComboHWND,"uint",0x0147,"wparam",0,"lparam",0)[0]
    If $iIdx >= 0 And $iIdx <= 4 Then
        $iLang = $iIdx
    Else
        ; Fallback: match by text
        Local $sSelected = GUICtrlRead($hLangCombo)
        Select
            Case $sSelected = "English"   : $iLang = 0
            Case $sSelected = "Francais"  : $iLang = 1
            Case $sSelected = "Espanol"   : $iLang = 2
            Case $sSelected = "Deutsch"   : $iLang = 3
            Case $sSelected = "Portugues" : $iLang = 4
            Case Else                     : $iLang = 0
        EndSelect
    EndIf
    $iLastLangIdx = $iLang
    _RefreshUILanguage()
EndFunc

Func _RefreshUILanguage()
    ; Update all translatable controls in the main window
    WinSetTitle($hGUI, "", _L($STR_WIN_TITLE))
    GUICtrlSetData($hNavPlayer,   _L($STR_BTN_PLAYER))
    GUICtrlSetData($hNavSettings, _L($STR_BTN_SETTINGS))
    GUICtrlSetData($hNavAbout,    _L($STR_BTN_ABOUT))
    GUICtrlSetData($hLblNowPlaying, _L($STR_NOW_PLAYING))
    ; Only reset now-playing labels if nothing is currently loaded
    If Not $bPlaying And $iCurrentIdx = -1 Then
        GUICtrlSetData($hLblTitre, _L($STR_NO_FILE))
        GUICtrlSetData($hLblSous,  _L($STR_ADD_HINT))
    EndIf
    GUICtrlSetData($hLblPlaylist, _L($STR_PLAYLIST))
    GUICtrlSetData($hBtnAjouter,  _L($STR_BTN_ADD))
    GUICtrlSetData($hBtnRetirer,  _L($STR_BTN_REMOVE))
    GUICtrlSetData($hBtnVider,    _L($STR_BTN_CLEAR))
    GUICtrlSetData($hBtnShuffle,  _L($STR_BTN_SHUFFLE))
    GUICtrlSetData($hBtnLoop,     _L($STR_BTN_LOOP))
    ; Test mode button keeps its ON/OFF state
    If $bTestMode Then
        GUICtrlSetData($hBtnTest, _L($STR_TESTMODE_ON))
    Else
        GUICtrlSetData($hBtnTest, _L($STR_TESTMODE_OFF))
    EndIf
    ; Always-on-top button keeps its ON/OFF state
    If $bOnTop Then
        GUICtrlSetData($hBtnTop, _L($STR_ALWAYS_ON_ON))
    Else
        GUICtrlSetData($hBtnTop, _L($STR_ALWAYS_ON_OFF))
    EndIf
    _Status(_L($STR_READY))
EndFunc

; ============================================================
;  PLAYLIST FUNCTIONS
; ============================================================
Func _AddFiles()
    ; Open a multi-file dialog to pick MIDI files
    Local $s = FileOpenDialog("MIDI", "", "MIDI (*.mid;*.midi)|All (*.*)", 1 + 4)
    If @error Then Return
    Local $a = StringSplit($s, "|")
    If $a[0] = 1 Then
        _AddSingleFile($a[1])
    Else
        For $i = 2 To $a[0]
            _AddSingleFile($a[1] & "\" & $a[$i])
        Next
    EndIf
EndFunc

Func _AddSingleFile($sPath)
    If Not FileExists($sPath) Then Return
    Local $sName = StringRegExpReplace(StringRegExpReplace($sPath, ".*\\", ""), "\.[^.]+$", "")
    Local $n = _GUICtrlListView_GetItemCount($hLV) + 1
    GUICtrlCreateListViewItem($n & "|" & $sName & "|--:--", $hLV)
    ReDim $aFiles[UBound($aFiles) + 1]
    $aFiles[UBound($aFiles) - 1] = $sPath
    _Status(_L($STR_ADDED) & $sName)
EndFunc

Func _RemoveFile()
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
    _Status(_L($STR_REMOVED))
EndFunc

Func _ClearPlaylist()
    If $bPlaying Then _StopPlay()
    _GUICtrlListView_DeleteAllItems($hLV)
    ReDim $aFiles[0]
    $iCurrentIdx = -1
    GUICtrlSetData($hLblTitre, _L($STR_NO_FILE))
    GUICtrlSetData($hLblSous,  _L($STR_ADD_HINT))
    _Status(_L($STR_CLEARED))
EndFunc

; ============================================================
;  PLAYBACK FUNCTIONS
; ============================================================
Func _TogglePlay()
    ; F1 hotkey: play if stopped, pause if playing
    If $bPlaying Then
        _PausePlay()
    Else
        _StartPlay()
    EndIf
EndFunc

Func _StartPlay()
    _Play()
EndFunc

Func _SetButtonState($sState)
    ; Update visual state of Play/Pause/Stop buttons
    ; $sState: "playing" | "paused" | "stopped"
    If $sState = "playing" Then
        GUICtrlSetBkColor($hBtnPlay,  $C_BLUE)
        GUICtrlSetColor($hBtnPlay,    $C_DARK)
        GUICtrlSetBkColor($hBtnPause, $C_ACCENT)
        GUICtrlSetColor($hBtnPause,   $C_TEXT)
        GUICtrlSetBkColor($hBtnStop,  $C_RED)
        GUICtrlSetColor($hBtnStop,    $C_DARK)
    ElseIf $sState = "paused" Then
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
    If Not $bPlaying Then Return   ; already paused or stopped
    ; Save current playback position before stopping
    $iPausePos = TimerDiff($iPlayStart) + $iOffsetActif
    $bPlaying = False
    If $bTestMode Then _StopTestSound()
    _SetButtonState("paused")
    GUICtrlSetData($hLblSous, _L($STR_PAUSED))
    _Status(_L($STR_PAUSED_HINT))
EndFunc

Func _Play()
    ; Core playback function: loads MIDI, sends key events in real time
    Local $n = _GUICtrlListView_GetItemCount($hLV)
    If $n = 0 Then
        _Status(_L($STR_PLAYLIST_EMPTY))
        Return
    EndIf

    Local $iIdx = 0

    ; Resume from pause on the same track
    If $iPausePos > 0 And $iCurrentIdx >= 0 Then
        $iIdx = $iCurrentIdx
    Else
        ; Prefer the visually selected row
        Local $iSel = _GUICtrlListView_GetSelectedIndices($hLV)
        If $iSel <> "" Then
            $iIdx = Int($iSel)
        ElseIf $iCurrentIdx >= 0 Then
            $iIdx = $iCurrentIdx
        EndIf
        ; Switching tracks: reset pause position
        If $iIdx <> $iCurrentIdx Then
            $iPausePos = -1
            $iOffsetActif = 0
        EndIf
    EndIf

    If $iIdx >= UBound($aFiles) Then $iIdx = 0

    Local $sPath = $aFiles[$iIdx]
    If Not FileExists($sPath) Then
        _Status(_L($STR_FILE_NOT_FOUND) & $sPath)
        Return
    EndIf

    Local $aEvts = _ParseMidi($sPath)
    If @error Or UBound($aEvts) = 0 Then
        _Status(_L($STR_MIDI_ERROR))
        Return
    EndIf

    $iCurrentIdx = $iIdx
    $iTotalMs    = $aEvts[UBound($aEvts) - 1][0] + 300
    $bPlaying    = True

    ; Determine resume offset (0 = fresh start)
    Local $iOffsetMs = 0
    If $iPausePos > 0 Then
        $iOffsetMs = $iPausePos
        $iPausePos = -1
    EndIf

    $iPlayStart  = TimerInit()
    $iOffsetActif = $iOffsetMs

    _GUICtrlListView_SetItemText($hLV, $iIdx, _T($iTotalMs), 2)
    _GUICtrlListView_SetItemSelected($hLV, $iIdx, True)

    Local $sName = StringRegExpReplace(StringRegExpReplace($sPath, ".*\\", ""), "\.[^.]+$", "")
    GUICtrlSetData($hLblTitre, $sName)
    GUICtrlSetData($hLblSous,  $bTestMode ? _L($STR_PLAYING_TEST) : _L($STR_PLAYING))
    GUICtrlSetData($hLblTotal, _T($iTotalMs))
    _SetButtonState("playing")
    _Status(($iOffsetMs > 0 ? _L($STR_RESUME) : "") & $sName)

    If $bTestMode Then _StartTestSound($sPath)

    Local $tStart = TimerInit()
    For $i = 0 To UBound($aEvts) - 1
        If Not $bPlaying Then ExitLoop

        Local $iNoteTime = $aEvts[$i][0]

        ; Skip notes already passed (resume after pause)
        If $iNoteTime < $iOffsetMs Then ContinueLoop

        ; Wait until the right moment
        While (TimerDiff($tStart) + $iOffsetMs) < $iNoteTime
            If Not $bPlaying Then ExitLoop
            Sleep(1)
            _ProcMsg()
            If Not $bPlaying Then ExitLoop
        WEnd
        If Not $bPlaying Then ExitLoop

        ; Send key unless in test mode
        If Not $bTestMode Then
            Local $k = _NoteToKey($aEvts[$i][1])
            If $k <> "" Then Send($k)
        EndIf

        _ProcMsg()
    Next

    ; End of track: stop, then loop/shuffle/advance as configured
    If $bPlaying Then
        _StopPlay()
        If $bLoop Then
            Sleep(200)
            _Play()
        ElseIf $bShuffle Then
            $iCurrentIdx = Random(0, _GUICtrlListView_GetItemCount($hLV) - 1, 1)
            _GUICtrlListView_SetItemSelected($hLV, $iCurrentIdx, True)
            Sleep(200)
            _Play()
        Else
            _Next()
        EndIf
    EndIf
EndFunc

Func _ProcMsg()
    ; Process GUI messages during the playback loop so the UI stays responsive
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
            _AddFiles()
        Case $hBtnRetirer
            _RemoveFile()
        Case $hBtnTest
            ; Toggle test mode while a track is playing
            $bTestMode = Not $bTestMode
            If $bTestMode Then
                GUICtrlSetData($hBtnTest, _L($STR_TESTMODE_ON))
                GUICtrlSetBkColor($hBtnTest, $C_GREEN)
                GUICtrlSetColor($hBtnTest, $C_DARK)
            Else
                GUICtrlSetData($hBtnTest, _L($STR_TESTMODE_OFF))
                GUICtrlSetBkColor($hBtnTest, $C_ACCENT)
                GUICtrlSetColor($hBtnTest, $C_TEXT)
            EndIf
        Case $hBtnTop
            ; Toggle always-on-top while playing
            $bOnTop = Not $bOnTop
            If $bOnTop Then
                WinSetOnTop($hGUI, "", 1)
                GUICtrlSetData($hBtnTop, _L($STR_ALWAYS_ON_ON))
                GUICtrlSetBkColor($hBtnTop, $C_BLUE)
                GUICtrlSetColor($hBtnTop, $C_DARK)
            Else
                WinSetOnTop($hGUI, "", 0)
                GUICtrlSetData($hBtnTop, _L($STR_ALWAYS_ON_OFF))
                GUICtrlSetBkColor($hBtnTop, $C_ACCENT)
                GUICtrlSetColor($hBtnTop, $C_TEXT)
            EndIf
    EndSwitch
    ; Polling inside playback loop — same CB_GETCURSEL approach
    Local $iPollIdx = DllCall("user32.dll","lresult","SendMessageW","hwnd",$hLangComboHWND,"uint",0x0147,"wparam",0,"lparam",0)[0]
    If $iPollIdx >= 0 And $iPollIdx <> $iLastLangIdx Then
        $iLastLangIdx = $iPollIdx
        $iLang = $iPollIdx
        _RefreshUILanguage()
    EndIf
EndFunc

Func _StopPlay()
    $bPlaying    = False
    $iPausePos   = -1
    $iOffsetActif = 0
    $iPlayStart  = 0
    If $bTestMode Then _StopTestSound()
    _SetButtonState("stopped")
    GUICtrlSetData($hLblSous, _L($STR_STOPPED) & "  -  PLAY")
    GUICtrlSetPos($hProgBar, 25, 146, 0, 4)
    GUICtrlSetData($hLblTemps, "0:00")
    _Status(_L($STR_STOPPED))
EndFunc

Func _Next()
    ; Jump to the next track in the playlist
    Local $n = _GUICtrlListView_GetItemCount($hLV)
    If $n = 0 Then Return
    Local $iN = $iCurrentIdx + 1
    If $iN >= $n Then $iN = 0
    $iCurrentIdx = $iN
    _GUICtrlListView_SetItemSelected($hLV, $iN, True)
    _GUICtrlListView_EnsureVisible($hLV, $iN)
    Sleep(100)
    _Play()
EndFunc

Func _Prev()
    ; Jump to the previous track in the playlist
    Local $n = _GUICtrlListView_GetItemCount($hLV)
    If $n = 0 Then Return
    Local $iP = $iCurrentIdx - 1
    If $iP < 0 Then $iP = $n - 1
    $iCurrentIdx = $iP
    _GUICtrlListView_SetItemSelected($hLV, $iP, True)
    _GUICtrlListView_EnsureVisible($hLV, $iP)
    Sleep(100)
    _Play()
EndFunc

; ============================================================
;  PROGRESS BAR
; ============================================================
Func _UpdateProg()
    ; Called every 200 ms by AdlibRegister to refresh the progress bar
    If Not $bPlaying Or $iPlayStart = 0 Or $iTotalMs = 0 Then Return
    Local $el = TimerDiff($iPlayStart) + $iOffsetActif
    If $el > $iTotalMs Then $el = $iTotalMs
    GUICtrlSetPos($hProgBar, 25, 146, Int(640 * $el / $iTotalMs), 4)
    GUICtrlSetData($hLblTemps, _T($el))
EndFunc

Func _ClickProgress($hWin, $Msg, $wParam, $lParam)
    ; Handle a click on the progress bar to seek to a position
    Local $iX = BitAND($lParam, 0xFFFF)
    Local $iY = BitShift($lParam, 16)
    If $iX >= 25 And $iX <= 665 And $iY >= 136 And $iY <= 158 Then
        If $iTotalMs > 0 Then
            Local $iNewPos = Int(($iX - 25) / 640 * $iTotalMs)
            If $iNewPos < 0 Then $iNewPos = 0
            If $iNewPos > $iTotalMs Then $iNewPos = $iTotalMs
            $iPausePos = $iNewPos
            If $bPlaying Then
                ; Restart from the new position
                $bPlaying = False
                If $bTestMode Then _StopTestSound()
                Sleep(50)
                _Play()
            Else
                ; Just move the progress indicator visually
                $iOffsetActif = $iNewPos
                GUICtrlSetPos($hProgBar, 25, 146, Int(640 * $iNewPos / $iTotalMs), 4)
                GUICtrlSetData($hLblTemps, _T($iNewPos))
                _Status(_L($STR_POSITION) & _T($iNewPos) & " / " & _T($iTotalMs) & _L($STR_RESUME_F1))
            EndIf
        EndIf
    EndIf
    Return $GUI_RUNDEFMSG
EndFunc

; ============================================================
;  PAGES (Settings / About)
; ============================================================
Func _PageSettings()
    ; Settings popup: keyboard layout selector with live key preview
    Local $w = GUICreate(_L($STR_SETTINGS_TITLE), 400, 320, -1, -1, -1, -1, $hGUI)
    GUISetBkColor($C_BG)

    GUICtrlCreateLabel(_L($STR_SETTINGS_TITLE), 20, 15, 360, 26)
    GUICtrlSetFont(-1, 14, 700, 0, "Segoe UI")
    GUICtrlSetColor(-1, $C_BLUE)

    GUICtrlCreateLabel("", 0, 50, 400, 2)
    GUICtrlSetBkColor(-1, $C_ACCENT)

    GUICtrlCreateLabel(_L($STR_KEYBOARD_LABEL), 20, 65, 200, 16)
    GUICtrlSetFont(-1, 9, 700, 0, "Segoe UI")
    GUICtrlSetColor(-1, $C_TEXT)

    ; Keyboard layout combo (AZERTY / QWERTY / QWERTZ)
    Local $hCombo = GUICtrlCreateCombo($sLayout, 20, 85, 160, 24)
    GUICtrlSetData($hCombo, "AZERTY|QWERTY|QWERTZ")

    ; Live key-map display label
    Local $hLblKeys = GUICtrlCreateLabel(_GetKeyInfo(), 20, 120, 360, 80)
    GUICtrlSetFont(-1, 8, 400, 0, "Courier New")
    GUICtrlSetColor(-1, $C_BLUE)

    GUICtrlCreateLabel(_L($STR_TRANSPOSE_NOTE), 20, 210, 360, 14)
    GUICtrlSetFont(-1, 7, 400, 0, "Segoe UI")
    GUICtrlSetColor(-1, $C_GREY)

    GUICtrlCreateLabel("", 0, 232, 400, 1)
    GUICtrlSetBkColor(-1, $C_ACCENT)

    GUICtrlCreateLabel(_L($STR_TEST_EXPLAIN), 20, 244, 360, 28)
    GUICtrlSetFont(-1, 7, 400, 0, "Segoe UI")
    GUICtrlSetColor(-1, $C_GREY)

    Local $hOK = GUICtrlCreateButton(_L($STR_SAVE_BTN), 120, 278, 110, 28)
    GUICtrlSetBkColor($hOK, $C_BLUE)
    GUICtrlSetColor($hOK, $C_DARK)
    GUICtrlSetFont($hOK, 9, 700, 0, "Segoe UI")

    GUISetState(@SW_SHOW, $w)
    While 1
        Local $m = GUIGetMsg()
        If $m = $GUI_EVENT_CLOSE Then ExitLoop
        If $m = $hOK Then
            ; Apply the chosen layout and refresh the key display
            Local $sNewLayout = GUICtrlRead($hCombo)
            If $sNewLayout <> $sLayout Then
                _LoadLayout($sNewLayout)
                GUICtrlSetData($hLblKeys, _GetKeyInfo())
                _Status(_L($STR_LAYOUT_CHANGED) & $sNewLayout)
            EndIf
            ExitLoop
        EndIf
    WEnd
    GUIDelete($w)
EndFunc

Func _PageAbout()
    ; About popup with version and feature list
    Local $w = GUICreate(_L($STR_BTN_ABOUT), 360, 220, -1, -1, -1, -1, $hGUI)
    GUISetBkColor($C_BG)

    GUICtrlCreateLabel(_L($STR_ABOUT_TITLE), 20, 20, 320, 26)
    GUICtrlSetFont(-1, 14, 700, 0, "Segoe UI")
    GUICtrlSetColor(-1, $C_BLUE)

    GUICtrlCreateLabel(_L($STR_ABOUT_SUB), 20, 50, 320, 16)
    GUICtrlSetFont(-1, 9, 400, 0, "Segoe UI")
    GUICtrlSetColor(-1, $C_TEXT)

    GUICtrlCreateLabel(_L($STR_ABOUT_L1), 20, 80, 320, 16)
    GUICtrlSetFont(-1, 8, 400, 0, "Segoe UI")
    GUICtrlSetColor(-1, $C_GREY)

    GUICtrlCreateLabel(_L($STR_ABOUT_L2), 20, 100, 320, 16)
    GUICtrlSetFont(-1, 8, 400, 0, "Segoe UI")
    GUICtrlSetColor(-1, $C_GREY)

    GUICtrlCreateLabel(_L($STR_ABOUT_L3), 20, 120, 320, 16)
    GUICtrlSetFont(-1, 8, 400, 0, "Segoe UI")
    GUICtrlSetColor(-1, $C_GREY)

    GUICtrlCreateLabel(_L($STR_ABOUT_L4), 20, 140, 320, 16)
    GUICtrlSetFont(-1, 8, 400, 0, "Segoe UI")
    GUICtrlSetColor(-1, $C_GREY)

    Local $hOK = GUICtrlCreateButton(_L($STR_OK_BTN), 135, 175, 90, 28)
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
;  NOTE -> KEY CONVERSION
; ============================================================
Func _NoteToKey($iNote)
    ; Transpose note into the supported range (C3-B5, MIDI 48-83)
    While $iNote < 48
        $iNote += 12
    WEnd
    While $iNote > 83
        $iNote -= 12
    WEnd
    ; Exact match first
    For $i = 0 To 20
        If $aNoteMap[$i][0] = $iNote Then Return $aNoteMap[$i][1]
    Next
    ; Nearest key fallback (should not normally happen after transposition)
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
;  MIDI FILE PARSER
;  Reads binary MIDI, extracts note-on events with timing in ms.
;  Returns a 2D array [event_index][0=ms, 1=note].
; ============================================================
Func _ParseMidi($sFile)
    Local $h = FileOpen($sFile, 16)
    If $h = -1 Then Return SetError(1, 0, 0)
    Local $bin = FileRead($h)
    FileClose($h)
    Local $sHex = StringTrimLeft($bin, 2)

    ; Verify MThd header
    If StringLeft($sHex, 8) <> "4D546864" Then Return SetError(2, 0, 0)

    Local $nTracks = _H($sHex, 21, 4)
    Local $iDiv    = _H($sHex, 25, 4)
    Local $iTempo  = 500000       ; default tempo: 120 BPM
    Local $iPos    = 29
    Local $aRes[0][2]
    Local $nEv     = 0

    For $t = 1 To $nTracks
        If StringMid($sHex, $iPos, 8) <> "4D54726B" Then ExitLoop   ; MTrk marker
        $iPos += 8
        Local $iLen = _H($sHex, $iPos, 8)
        $iPos += 8
        Local $iEnd = $iPos + ($iLen * 2)
        Local $iTick = 0, $iLastSt = 0

        While $iPos < $iEnd And $iPos < StringLen($sHex)
            ; Read variable-length delta time
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
                $st = $iLastSt   ; running status
            Else
                $iLastSt = $st
                $iPos += 2
            EndIf
            Local $tp = BitAND($st, 0xF0)

            If $tp = 0x90 Then
                ; Note-On event
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
                ; Note-Off event (skip 2 data bytes)
                $iPos += 4
            ElseIf $st = 0xFF Then
                ; Meta event
                Local $mt = _H($sHex, $iPos, 2)
                $iPos += 2
                Local $ml = _VL($sHex, $iPos)
                If $mt = 0x51 Then $iTempo = _H($sHex, $iPos, $ml * 2)   ; Set Tempo
                $iPos += $ml * 2
            ElseIf $st = 0xF0 Or $st = 0xF7 Then
                ; SysEx event
                $iPos += _VL($sHex, $iPos) * 2
            ElseIf $tp = 0xC0 Or $tp = 0xD0 Then
                ; Program Change / Channel Pressure (1 data byte)
                $iPos += 2
            Else
                ; All other 2-byte events (Control Change, Pitch Bend, etc.)
                $iPos += 4
            EndIf
        WEnd
        $iPos = $iEnd
    Next

    If $nEv = 0 Then Return SetError(3, 0, 0)
    _ArraySort($aRes, 0, 0, 0, 0)
    Return $aRes
EndFunc

; --- Variable-length quantity reader (MIDI standard) ---
Func _VL($sHex, ByRef $iPos)
    Local $v = 0, $b = 0
    Do
        $b    = _H($sHex, $iPos, 2)
        $iPos += 2
        $v    = BitOR(BitShift($v, -7), BitAND($b, 0x7F))
    Until Not BitAND($b, 0x80)
    Return $v
EndFunc

; --- Hex substring to integer helper ---
Func _H($sHex, $pos, $len)
    Return Number("0x" & StringMid($sHex, $pos, $len))
EndFunc

; ============================================================
;  KEY MAP INFO STRING  (used in the Settings window)
; ============================================================
Func _GetKeyInfo()
    Local $r1 = StringUpper($aNoteMap[0][1])  & "  " & StringUpper($aNoteMap[1][1])  & "  " & StringUpper($aNoteMap[2][1])  & "  " & StringUpper($aNoteMap[3][1])  & "  " & StringUpper($aNoteMap[4][1])  & "  " & StringUpper($aNoteMap[5][1])  & "  " & StringUpper($aNoteMap[6][1])
    Local $r2 = StringUpper($aNoteMap[7][1])  & "  " & StringUpper($aNoteMap[8][1])  & "  " & StringUpper($aNoteMap[9][1])  & "  " & StringUpper($aNoteMap[10][1]) & "  " & StringUpper($aNoteMap[11][1]) & "  " & StringUpper($aNoteMap[12][1]) & "  " & StringUpper($aNoteMap[13][1])
    Local $r3 = StringUpper($aNoteMap[14][1]) & "  " & StringUpper($aNoteMap[15][1]) & "  " & StringUpper($aNoteMap[16][1]) & "  " & StringUpper($aNoteMap[17][1]) & "  " & StringUpper($aNoteMap[18][1]) & "  " & StringUpper($aNoteMap[19][1]) & "  " & StringUpper($aNoteMap[20][1])
    Return "Layout : " & $sLayout & @CRLF & _L($STR_LAYOUT_ROW1) & $r1 & "  (C3-B3)" & @CRLF & _L($STR_LAYOUT_ROW2) & $r2 & "  (C4-B4)" & @CRLF & _L($STR_LAYOUT_ROW3) & $r3 & "  (C5-B5)"
EndFunc

; ============================================================
;  TEST MODE SOUND  (Windows MCI MIDI playback, no key sending)
; ============================================================
Func _StartTestSound($sPath)
    ; Close any previously opened MCI alias before reopening
    DllCall("winmm.dll", "DWORD", "mciSendStringW", "wstr", "close testmidi", "wstr", "", "uint", 0, "hwnd", 0)
    DllCall("winmm.dll", "DWORD", "mciSendStringW", "wstr", "open """ & $sPath & """ type sequencer alias testmidi", "wstr", "", "uint", 0, "hwnd", 0)
    DllCall("winmm.dll", "DWORD", "mciSendStringW", "wstr", "play testmidi", "wstr", "", "uint", 0, "hwnd", 0)
EndFunc

Func _StopTestSound()
    DllCall("winmm.dll", "DWORD", "mciSendStringW", "wstr", "stop testmidi",  "wstr", "", "uint", 0, "hwnd", 0)
    DllCall("winmm.dll", "DWORD", "mciSendStringW", "wstr", "close testmidi", "wstr", "", "uint", 0, "hwnd", 0)
EndFunc

; ============================================================
;  UTILITY HELPERS
; ============================================================
Func _T($ms)
    ; Convert milliseconds to M:SS string
    Local $s = Int($ms / 1000)
    Return Int($s / 60) & ":" & StringFormat("%02d", Mod($s, 60))
EndFunc

Func _Status($s)
    ; Update the status bar label
    GUICtrlSetData($hLblStatus, "  " & $s)
EndFunc
    
