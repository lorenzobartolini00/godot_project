extends Node

enum GamePlayState { FREEWALK, RELOADING, SHOOTING, CHANGING_WEAPON, PAUSED, OPTIONS, PLAY, IN_DIALOG, DIED}
enum AIState { IDLE, AIMING, SEARCHING, APPROACHING, TARGET_AQUIRED }
enum ItemTipology { WEAPON, AMMO, LIFE, BOMB, TOOL }
enum TargetTipology {NO_TARGET, SHOOTABLE, FRIENDLY}
enum ItemStatus { LOCKED, UNLOCKED}
enum MessageTipology { NEW_ITEM }
enum ButtonTipology { PLAY, OPTIONS, BACK, COMAND_LIST, AUDIO_SETTINGS, PLAY_SETTINGS, RESUME, ADVANCE_SLIDE, EXIT }
enum OptionTab {MAIN, COMAND_LIST, AUDIO_SETTINGS, PLAY_SETTINGS }
