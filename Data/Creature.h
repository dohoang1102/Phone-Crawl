#import <Foundation/Foundation.h>
#import "Util.h"

@class Item,Coord;

//#define NUM_EQUIP_SLOTS 4
#define NUM_INV_SLOTS 20
#define MAX_NUM_SPELLS 50
#define MAX_NUM_ABILITIES 100
#define STAT_MAX 100
#define STAT_MIN 0
#define FIRST_AVAIL_INV_SLOT -1

//Conditions
typedef uint32_t condition_bitset;
typedef enum {
	NO_CONDITION  = 0,
	BURNED        = 1,
	CHILLED		  = 2,
	HASTENED	  = 4,
	POISONED	  = 8,
	CURSED		  = 16,
	FIRE_HASTE    = 32, //Fire turn-speed buff
	COLD_SLOW     = 64, //Cold turn-speed debuff
	WEAKENED      = 128, //Max health debuff
	CONFUSION     = 256  //Messes with AI calls
} conditionType;


@interface Points : NSObject {
	int health;
	int shield;
	int mana;
	int turn_speed;
}
@property (nonatomic) int health;
@property (nonatomic) int shield;
@property (nonatomic) int mana;
@property (nonatomic) int turn_speed;
@end

@interface EquipSlots : NSObject {
	Item *head;
	Item *chest;
	Item *r_hand;
	Item *l_hand;
}
- (id) init;
@property (nonatomic, retain) Item* head;
@property (nonatomic, retain) Item* chest;
@property (nonatomic, retain) Item* r_hand;
@property (nonatomic, retain) Item* l_hand;
@end

@interface Creature : NSObject {
	NSString *name;
	Coord *creatureLocation;
	
	int aggro_range;
    int   level;
	int current_turn_points;

	condition_bitset condition;
	Points *current;
	Points *max;

	int   money;
	int   ability_points;

	//Resists
	int fire;
	int cold;
	int lightning;
	int poison;
	int dark;
	int armor;
	
    //currently 4 (Head, Chest, Right Hand, Left Hand)
	EquipSlots *equipment;
	NSMutableArray *inventory;
	
	//Spells stored in an NSArray, and a spellbook will be a list of the spell IDs
	int spellbook[MAX_NUM_SPELLS];
	
	
	//Combat abilities / passive abilities (Dodge, Counter-attack, Bash, etc)
	int abilities[MAX_NUM_ABILITIES];
	
	@private
	Points *real;
}

- (id) initWithLevel: (int) lvl;
- (id) initWithInfo: (NSString *) in_name level: (int) lvl;


//Reset stats modified by conditions during combat
- (void) Reset_Stats;
- (int) statBase;
- (void) Update_Stats_Item: (Item *) item;
- (void) Set_Base_Stats;

- (void) Take_Damage: (int) amount;
- (void) Heal: (int) amount;
- (void) Mana_Heal: (int) amount;

- (void) Add_Condition: (conditionType) new_condition;
- (void) Remove_Condition: (conditionType) rem_condition;
- (void) Clear_Condition;

- (void) Add_Equipment: (Item *) new_item slot: (slotType) dest_slot;
- (void) Remove_Equipment: (slotType) dest_slot;
- (void) Add_Inventory: (Item *) new_item inv_slot: (int) inv_slot;
- (void) Remove_Inventory: (int) inv_slot;

- (int) regular_weapon_damage;
- (int) elemental_weapon_damage;

@property (nonatomic, retain) Coord *creatureLocation;
@property (nonatomic, retain) NSMutableArray *inventory;

@property (nonatomic,retain) EquipSlots *equipment;
@property (nonatomic,retain) Points *current;
@property (nonatomic,retain) Points *max;
@property (nonatomic) int current_turn_points;
@property (readonly) NSString *name;
@property int money;
@property int ability_points;
@property (readonly) int level;
@property (nonatomic) int fire;
@property (nonatomic) int cold;
@property (nonatomic) int lightning;
@property (nonatomic) int poison;
@property (nonatomic) int dark;
@property (nonatomic) int armor;

@end
