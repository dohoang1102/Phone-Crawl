
#define LEVEL_DIFF_MULT 2

#import "Skill.h"

#import "Critter.h"
#import "Item.h"

NSMutableArray *abilityList = nil;

BOOL have_set_abilities = FALSE;

@implementation Skill

// getter and setter methods
@synthesize name;
@synthesize abilityId;
@synthesize damageMultiplier;
@synthesize abilityLevel;
@synthesize turnPointCost;

// initializes a skill with the given info
- (id) initWithInfo: (NSString *) abilityName damageMultiplier: (float) abilityDamage abilityLevel: (int) level 
		 abilityId: (int) desiredId abilityFn: (SEL) fn turnPoints:(int) turnPntCost {
	if (self = [super init]) {
		name = abilityName;
		damageMultiplier = abilityDamage;
		abilityLevel = level;
		abilityFn = fn;
		abilityId = desiredId;
		turnPointCost = turnPntCost;
		return self;
	}
	return nil;
}

// initialize is a static function that builds all the basic combat actions.
+ (void) initialize
{
	have_set_abilities = TRUE;
	int id_cnt = 0, abilityLvl = 1;
	abilityList = [[NSMutableArray alloc] init];
	SEL mix = @selector(mixedStrike:target:);
	SEL ele = @selector(elementalStrike:target:);
	SEL def = @selector(defaultStrike:target:);
	
#define ADD_ABILITY(NAME,DMG,FN,TPNTS) [abilityList addObject:[[[Skill alloc] initWithInfo:NAME damageMultiplier:DMG \
abilityLevel:abilityLvl++%3+1 abilityId:id_cnt++ abilityFn:FN turnPoints:TPNTS] autorelease]]
	
	ADD_ABILITY(@"Basic1",2.0,def,50);
	ADD_ABILITY(@"Basic2",2.2,def,50);
	ADD_ABILITY(@"Basic3",2.4,def,50);
	
	ADD_ABILITY(@"Quick1",1.0,def,25);
	ADD_ABILITY(@"Quick2",1.33,def,25);
	ADD_ABILITY(@"Quick3",1.66,def,25);
	
	ADD_ABILITY(@"Power1",4.0,def,100);
	ADD_ABILITY(@"Power2",5.0,def,100);
	ADD_ABILITY(@"Power3",6.0,def,100);
	
	ADD_ABILITY(@"Elem1",2.0,ele,50);
	ADD_ABILITY(@"Elem2",2.2,ele,50);
	ADD_ABILITY(@"Elem3",2.4,ele,50);
	
	ADD_ABILITY(@"Combo1",2.0,mix,50);
	ADD_ABILITY(@"Combo2",2.2,mix,50);
	ADD_ABILITY(@"Combo3",2.4,mix,50);
}

// skillOfType
+ (Skill*) skillOfType:(PC_COMBAT_ABILITY_TYPE)type level: (int)lvl
{
	// find the skill in the ability list that corresponds to the given level and type
	return [abilityList objectAtIndex: 3 * type + lvl];
}

// Main logic function that handles the use of skills by one critter on another
- (NSString *) useAbility: (Critter *) caster target: (Critter *) target 
{
	int abilityResult = 0;
	// make sure that it is a valid ability function
	if([self respondsToSelector:abilityFn])
	{
		// get the method pointer
		IMP f = [self methodForSelector:abilityFn];
		// call the ability function and store the result (how much damage was done)
		abilityResult = (int)(f)(self, abilityFn, caster, target);
	}
	// if damage was done
	if (abilityResult >= 0) {
		[target takeDamage:abilityResult];
		// generate a report string
		return [NSString stringWithFormat:@"%@ was dealt %d damage!!", target.stringName, abilityResult];
	} else {
		// otherwise there was an error. Flag it
		DLog(@"Ability error: %@",self.name);
		// and return nothing
		return @"";
	}

}

// alternate method of using an ability, when only the ID of the ability is known
+ (NSString *) useAbilityWithId: (int) desiredAbilityId caster: (Critter *) caster target: (Critter *) target {
	// find the Skill based on the id given
	Skill *ca = [abilityList objectAtIndex:desiredAbilityId];
	// call the useAbility function from the given skill
	return [ca useAbility:caster target:target];
};

// basicAttack
- (int) basicAttack:(Critter *)attacker def:(Critter *)defender {
	float basedamage = [attacker getPhysDamage];
	basedamage *= damageMultiplier;
	// return damage with the defender's armor factored in
	return basedamage*((120-defender.defense.armor)/54+0.1); 
}

// elementalAttack
- (int) elementalAttack:(Critter *)attacker def:(Critter *)defender {
	// resistance and damage variables
	float resist;
	float elementDamage = [attacker getElemDamage];
	elemType type = attacker.equipment.rhand.element; //Determines which effect to add
	conditionType condtype = NO_CONDITION;
	switch (type) {
		case FIRE:
			resist = defender.defense.fire;
			condtype = BURNED;
			break;
		case COLD:
			resist = defender.defense.frost;
			condtype = CHILLED;
			break;
		case LIGHTNING:
			resist = defender.defense.shock;
			condtype = HASTENED;
			break;
		case POISON:
			resist = defender.defense.poison;
			condtype = POISONED;
			break;
		case DARK:
			resist = defender.defense.dark;
			condtype = CURSED;
			break;
		default:
			resist = 0;
			break;
	}

	int finaldamage = (elementDamage * (100-resist) / 100);
	if ([Rand min:0 max:100] > 20 * abilityLevel) {
		[defender gainCondition:condtype];
	}
	return finaldamage;
}

// action function for MIX_STRIKE
- (int) mixedStrike: (Critter *) attacker target: (Critter *) defender {
	if (attacker == nil || defender == nil) {
		DLog(@"ABILITY_ERR");
	}
	// do both a regular attack and an elemental attack and average the damage
	return 0.5*([self basicAttack: attacker def: defender] + [self elementalAttack:attacker def:defender]);
}

// action function for ELE_STRIKE
- (int) elementalStrike: (Critter *) attacker target: (Critter *) defender {
	if (attacker == nil || defender == nil) {
		DLog(@"ABILITY_ERR");
	}
	// do a basic elemental attack
	return [self elementalAttack: attacker def: defender];
}

// action function for REG_STRIKE
- (int) defaultStrike: (Critter *) attacker target: (Critter *) defender {
	if (attacker == nil || defender == nil) {
		DLog(@"ABILITY_ERR");
	}
	return [self basicAttack: attacker def: defender];
}

@end
