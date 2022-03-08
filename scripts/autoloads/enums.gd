extends Node

enum GamePlayState { FREEWALK, RELOADING, SHOOTING, CHANGING_WEAPON, PAUSED, PLAY, IN_DIALOG}
enum AIState { IDLE, AIMING, SEARCHING, TARGET_AQUIRED }
enum ItemTipology { WEAPON, AMMO, LIFE, BOMB, TOOL }
enum ItemStatus { LOCKED, UNLOCKED}
enum MessageTipology { NEW_ITEM }
enum ButtonTipology { PLAY, OPTIONS, EXIT }
