# autoit-midi-player

The AutoIt script “MIDI PLAYER v4.0” is a MIDI playback application that converts MIDI notes into simulated keyboard key presses. Instead of playing sound directly, the program reads MIDI events and sends mapped keyboard inputs to another active window, making it useful for rhythm games, virtual instruments, or keyboard automation.

The script includes several important systems and functions. It uses AutoIt GUI libraries to create a modern dark-themed interface with buttons, labels, playlists, and playback controls. A multilingual system stores translations in arrays and uses the _L() function to display the correct language dynamically. The MIDI-to-keyboard conversion is handled through the $aNoteMap array, which associates MIDI notes with keyboard keys.

The function _LoadLayout() changes the keyboard mapping depending on the selected layout such as QWERTY, AZERTY, or QWERTZ. Global variables manage playback state, loop mode, shuffle mode, test mode, and playlist data. The application also supports hotkeys like F1 and F2 for quick control.

Overall, the script combines GUI management, multilingual support, playlist handling, keyboard layout adaptation, and MIDI interpretation into a single automated MIDI keyboard player.
