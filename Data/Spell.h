//
//  Spell.h
//  Phone-Crawl
//
//  Created by Benjamin Sangster on 1/23/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Creature.h"
#import "Item.h"
#import "Util.h" 

#define ITEM_NO_SPELL -1

#define NUM_POTION_SPELLS 5
#define NUM_PC_SPELLS 50
#define NUM_DMG_SPELLS 25
#define NUM_WAND_SPELLS NUM_DMG_SPELLS
#define NUM_COND_SPELLS 25

#define ITEM_BOOK_SPELL_ID 0
#define ITEM_HEAL_SPELL_ID ITEM_BOOK_SPELL_ID + 1
#define ITEM_MANA_SPELL_ID ITEM_HEAL_SPELL_ID + NUM_POTION_SPELLS
#define START_PC_SPELLS ITEM_MANA_SPELL_ID + NUM_POTION_SPELLS
#define END_PC_SPELLS START_PC_SPELLS + NUM_PC_SPELLS
#define START_COND_SPELLS START_PC_SPELLS + NUM_DMG_SPELLS
#define END_COND_SPELLS START_COND_SPELLS + NUM_COND_SPELLS
#define START_WAND_SPELLS END_PC_SPELLS + 1
#define END_WANT_SPELLS START_WAND_SPELLS + 25


typedef enum {DAMAGE, CONDITION, ITEM} spellType;
typedef enum {SELF,SINGLE} targetType;

NSMutableArray *spell_list;

@class Creature;
@interface Spell : NSObject {
	NSString *name;
	spellType spell_type; //Hurt or Help
	targetType target_type; //Self, one target, all in range
	elemType elem_type; //Elemental type of damage or buff
	int mana_cost;
	int damage;
	int range;
	int spell_level; //Minor,Lesser, (unnamed regular), Major, Superior
	int spell_id; //Index in spell_list array of the spell
	IMP spell_fn;
}

- (id) initWithInfo: (NSString *) in_name spell_type: (spellType) in_spell_type target_type: (targetType) in_target_type elem_type: (elemType) in_elem_type
		  mana_cost: (int) in_mana_cost damage: (int) in_damage range: (int) in_range spell_level: (int) in_spell_level spell_id: (int) in_spell_id
		   spell_fn: (IMP) in_spell_fn;

- (BOOL) Resist_Check: (Creature *) caster target: (Creature *) target;
- (NSString *) detr_spell: (Creature *) caster target: (Creature *) target;
- (NSString *) cond_spell: (Creature *) caster target: (Creature *) target;

//Specialized item functions

- (NSString *) heal_potion: (Creature *) caster target: (Creature *) target;
- (NSString *) mana_potion: (Creature *) caster target: (Creature *) target;
- (NSString *) wand: (Creature *) caster target: (Creature *) target;
- (NSString *) scroll: (Creature *) caster target: (Creature *) target;
- (NSString *) haste: (Creature *) caster target: (Creature *) target;
- (NSString *) freeze: (Creature *) caster target: (Creature *) target;
- (NSString *) purge: (Creature *) caster target: (Creature *) target;
- (NSString *) taint: (Creature *) caster target: (Creature *) target;
- (NSString *) confusion: (Creature *) caster target: (Creature *) target;

@end
