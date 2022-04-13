extends Node

enum GamePlayState { FREEWALK, RELOADING, SHOOTING, CHANGING_WEAPON, PAUSED, OPTIONS, PLAY, IN_DIALOG, DIED}
enum AIState {START, IDLE, AIMING, SEARCHING, APPROACHING, NOT_APPROACHING, TARGET_AQUIRED, HURT, DODGING }
enum ItemTipology { WEAPON, AMMO, LIFE, BOMB, TOOL }
enum TargetTipology {NO_TARGET, SHOOTABLE, CONTROLLABLE,FRIENDLY}
enum ItemStatus { LOCKED, UNLOCKED}
enum MessageTipology { NEW_ITEM, NEW_MISSION }
enum ButtonTipology { PLAY, OPTIONS, BACK, COMAND_LIST, AUDIO_SETTINGS, PLAY_SETTINGS, TOGGLE_FULL_SCREEN, ADVANCE_SLIDE, TITLE_SCREEN, CREDITS, EXIT }
enum PieceTipology {HEAD, WEAPON, LEG}
