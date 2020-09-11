#Skills kept from mcmmo:
#Iron Fist
#Deflect
#Bleed
#Sharp Claws
#Thick Hide
#Critical Strikes (Taming)
#Critical Strikes (Axes)
#Greater Impact
#Roll
#Treasure Fishing
#Extra Recipes
#Bountiful Harvest
#Arrow Efficiency

fix_me:
    type: task
    script:
        - flag player tree_feller_cooldown:false
        - flag player ignore_count:0
        
list_ignored:
    type: command
    name: list_ignored
    description: List your currently ignored items.
    usage: list_ignored
    script:
        - if <player.flag[ignored_items].size> < 1:
            - narrate "You are not ignoring any items right now!"
        - else:
            - narrate <player.flag[ignored_items].comma_separated>
        
login_listener:
    type: world
    events:
        on player joins:
            - flag tree_feller_cooldown:false
            - flag super_breaker_cooldown:false
            - flag super_digger_cooldown:false
            - flag whirlwind_cooldown:false
            - flag berserk_cooldown:false
            - flag empowered_blade_cooldown:false
            - if <player.has_flag[ignore_count]> == false:
                - flag player ignore_count:0

mana_deposit:
    type: command
    name: manadeposit
    description: Stop looking at this.
    usage: manadeposit
    script:
        - if <player.mcmmo.level[excavation].div_int[2]> >= <util.random.int[1].to[500]>:
            - drop xp quantity:1 <context.location>

pick_up_listener:
    type: world
    events:
        on player picks up item:
            - define target <context.item.material.name>
            - if <player.flag[ignored_items].find[<[target]>]> != -1:
                - if <player.flag[ignored_items].size> > 0:
                    - determine CANCELLED
                
ignore_drops_add_flag:
    type: command
    name: add_ignore
    description: Add an item to your ignored drops list
    usage: add_ignore item_ID
    script:
        - define mining <player.mcmmo.level[mining].div_int[50].round_down>
        - define excavation <player.mcmmo.level[excavation].div_int[50].round_down>
        - if <[mining].add[<[excavation]>]> > <player.flag[ignore_count]>:
            - flag player ignored_items:->:<context.args.get[1]>
            - flag player ignore_count:++
            - narrate "<context.args.get[1]> added to your ignored items."
        - else:
            - narrate "Maximum ignored items reached! Please remove an item before adding a new one."
                
ignore_drops_remove_flag:
    type: command
    name: remove_ignore
    description: Remove an item to your ignored drops list
    usage: remove_ignore item_ID
    script:
        - flag player ignored_items:<-:<context.args.get[1]>
        - flag player ignore_count:--
        - narrate "<context.args.get[1]> removed from your ignored items."

auto_replant:
    type: command
    name: auto_replant
    description: Stop looking at this.
    usage: auto_replant
    script:
        - if <player.mcmmo.level[herbalism]> >= <util.random.int[1].to[1000]>:
            - modifyblock <context.location> <[crop]> delayed source:<player>

double_breed:
    type: world
    events:
        on entity breeds:
        - if <player.mcmmo.level[herbalism]> >= <util.random.int[1].to[1000]>:
                - wait 0.5s
                - spawn <context.child.entity_type> <context.child.location> save:new_baby persistent
                - flag <entry[new_baby].spawned_entity> age:baby
                #Known issues
                #Extra baby is an adult

damage_taken_listener:
    type: world
    events:
        on player damaged by entity:
               #Parry
            - if <player.mcmmo.level[swords].sub_int[500]> >= <util.random.int[1].to[1000]>:
                    - actionbar "Parry!"
                    - determine <context.final_damage.div_int[2]>
            #Smooth Recovery
        on player damaged by fall:
            - if <context.cause> == "FALL":
                - if <player.mcmmo.level[acrobatics]> >= <util.random.int[1].to[1000]>:
                    - cast speed amplifier:0 d:0.75

activate_skill_listener:
    type: world
    events:
        on player right clicks air:
        - choose <context.item.material.name>:
            - case air:
                - inject activate_berserk
            - case wooden_axe:
                - if <player.is_sneaking> == true:
                        - inject activate_whirlwind
                - else:
                        - inject activate_tree_feller
            - case stone_axe:
                - if <player.is_sneaking> == true:
                        - inject activate_whirlwind
                - else:
                        - inject activate_tree_feller
            - case iron_axe:
                - if <player.is_sneaking> == true:
                        - inject activate_whirlwind
                - else:
                        - inject activate_tree_feller
            - case golden_axe:
                - if <player.is_sneaking> == true:
                        - inject activate_whirlwind
                - else:
                        - inject activate_tree_feller
            - case diamond_axe:
                - if <player.is_sneaking> == true:
                        - inject activate_whirlwind
                - else:
                        - inject activate_tree_feller
            - case netherite_axe:
                - if <player.is_sneaking> == true:
                        - inject activate_whirlwind
                - else:
                        - inject activate_tree_feller
            - case wooden_pickaxe:
                - inject activate_super_breaker
            - case stone_pickaxe:
                - inject activate_super_breaker
            - case iron_pickaxe:
                - inject activate_super_breaker
            - case golden_pickaxe:
                - inject activate_super_breaker
            - case diamond_pickaxe:
                - inject activate_super_breaker
            - case netherite_pickaxe:
                - inject activate_super_breaker
            - case wooden_shovel:
                - inject activate_super_digger
            - case stone_shovel:
                - inject activate_super_digger
            - case iron_shovel:
                - inject activate_super_digger
            - case golden_shovel:
                - inject activate_super_digger
            - case diamond_shovel:
                - inject activate_super_digger
            - case netherite_shovel:
                - inject activate_super_digger
            - case wooden_sword:
                - inject activate_empowered_blade
            - case stone_sword:
                - inject activate_empowered_blade
            - case iron_sword:
                - inject activate_empowered_blade
            - case golden_sword:
                - inject activate_empowered_blade
            - case diamond_sword:
                - inject activate_empowered_blade
            - case netherite_sword:
                - inject activate_empowered_blade
            - case potion:
                - inject instant_drink

activate_tree_feller:
    type: command
    name: activate_tree_feller
    description: Activates the tree feller skill.
    usage: activate_tree_feller
    script:
        - if <player.flag[tree_feller_cooldown]> != true:
            #If player has confirmed the activation, activate the skill.
            - if <player.flag[tree_feller_confirm]> == true:
                - actionbar "Tree feller is now active!"
                - flag player tree_feller_cooldown:true
                - flag player tree_feller_active:true
                - choose <player.mcmmo.level[woodcutting].div_int[50].round_down>:
                    - case 0:
                        - wait 1s
                    - case 1:
                        - wait 2s
                    - case 2:
                        - wait 3s
                    - case 3:
                        - wait 4s
                    - case 4:
                        - wait 5s
                    - case 5:
                        - wait 6s
                    - case 6:
                        - wait 7s
                    - case 7:
                        - wait 8s
                    - case 8:
                        - wait 9s
                    - case 9:
                        - wait 10s
                    - case 10:
                        - wait 11s
                    - case 11:
                        - wait 12s
                    - case 12:
                        - wait 13s
                    - case 13:
                        - wait 14s
                    - case 14:
                        - wait 15s
                    - case 15:
                        - wait 16s
                    - case 16:
                        - wait 17s
                    - case 17:
                        - wait 18s
                    - case 18:
                        - wait 19s
                        #level 900+
                    - default:
                        - wait 20s
                - flag player tree_feller_active:false
                - actionbar "Tree feller is no longer active!"
                - wait 300s
                - flag player tree_feller_cooldown:false
                - actionbar "Tree feller is ready to use!"
            #If player has not confirmed the activation yet, set the confirmation flag to true for 5 seconds.
            - else:
                - flag player tree_feller_confirm:true
                - actionbar "Right click again to activate Tree Feller!"
                - wait 5s
                - flag player tree_feller_confirm:false

activate_super_breaker:
    type: command
    name: activate_super_breaker
    description: Activates the super breaker skill.
    usage: activate_super_breaker
    script:
        - if <player.flag[super_breaker_cooldown]> != true:
            #If player has confirmed the activation, activate the skill.
            - if <player.flag[super_breaker_confirm]> == true:
                - actionbar "Super Breaker is now active!"
                - flag player super_breaker_cooldown:true
                - flag player super_breaker_active:true
                - choose <player.mcmmo.level[mining].div_int[50].round_down>:
                    - case 0:
                        - wait 1s
                    - case 1:
                        - wait 2s
                    - case 2:
                        - wait 3s
                    - case 3:
                        - wait 4s
                    - case 4:
                        - wait 5s
                    - case 5:
                        - wait 6s
                    - case 6:
                        - wait 7s
                    - case 7:
                        - wait 8s
                    - case 8:
                        - wait 9s
                    - case 9:
                        - wait 10s
                    - case 10:
                        - wait 11s
                    - case 11:
                        - wait 12s
                    - case 12:
                        - wait 13s
                    - case 13:
                        - wait 14s
                    - case 14:
                        - wait 15s
                    - case 15:
                        - wait 16s
                    - case 16:
                        - wait 17s
                    - case 17:
                        - wait 18s
                    - case 18:
                        - wait 19s
                        #level 900+
                    - default:
                        - wait 20s
                - flag player super_breaker_active:false
                - actionbar "Super Breaker is no longer active!"
                - wait 300s
                - flag player super_breaker_cooldown:false
                - actionbar "Super Breaker is ready to use!"
            #If player has not confirmed the activation yet, set the confirmation flag to true for 5 seconds.
            - else:
                - flag player super_breaker_confirm:true
                - actionbar "Right click again to activate Super Breaker!"
                - wait 5s
                - flag player super_breaker_confirm:false

activate_super_digger:
    type: command
    name: activate_super_digger
    description: Activates the super digger skill.
    usage: activate_super_digger
    script:
        - if <player.flag[super_digger_cooldown]> != true:
            #If player has confirmed the activation, activate the skill.
            - if <player.flag[super_digger_confirm]> == true:
                - actionbar "Super Digger is now active!"
                - flag player super_digger_cooldown:true
                - flag player super_digger_active:true
                - choose <player.mcmmo.level[excavation].div_int[50].round_down>:
                    - case 0:
                        - wait 1s
                    - case 1:
                        - wait 2s
                    - case 2:
                        - wait 3s
                    - case 3:
                        - wait 4s
                    - case 4:
                        - wait 5s
                    - case 5:
                        - wait 6s
                    - case 6:
                        - wait 7s
                    - case 7:
                        - wait 8s
                    - case 8:
                        - wait 9s
                    - case 9:
                        - wait 10s
                    - case 10:
                        - wait 11s
                    - case 11:
                        - wait 12s
                    - case 12:
                        - wait 13s
                    - case 13:
                        - wait 14s
                    - case 14:
                        - wait 15s
                    - case 15:
                        - wait 16s
                    - case 16:
                        - wait 17s
                    - case 17:
                        - wait 18s
                    - case 18:
                        - wait 19s
                        #level 900+
                    - default:
                        - wait 20s
                - flag player super_digger_active:false
                - actionbar "Super Digger is no longer active!"
                - wait 300s
                - flag player super_digger_cooldown:false
                - actionbar "Super Digger is ready to use!"
            #If player has not confirmed the activation yet, set the confirmation flag to true for 5 seconds.
            - else:
                - flag player super_digger_confirm:true
                - actionbar "Right click again to activate Super Digger!"
                - wait 5s
                - flag player super_digger_confirm:false

activate_empowered_blade:
    type: command
    name: activate_empowered_blade
    description: Activates the empowered blade skill.
    usage: activate_empowered_blade
    script:
        - if <player.flag[empowered_blade_cooldown]> != true:
            #If player has confirmed the activation, activate the skill.
            - if <player.flag[empowered_blade_confirm]> == true:
                - actionbar "Empowered Blade is now active!"
                - flag player empowered_blade_cooldown:true
                - flag player empowered_blade_active:true
                - choose <player.mcmmo.level[swords].div_int[100].round_down>:
                    - case 0:
                        - wait 1s
                    - case 1:
                        - wait 2s
                    - case 2:
                        - wait 3s
                    - case 3:
                        - wait 4s
                    - case 4:
                        - wait 5s
                    - case 5:
                        - wait 6s
                    - case 6:
                        - wait 7s
                    - case 7:
                        - wait 8s
                    - case 8:
                        - wait 9s
                        #level 900+
                    - default:
                        - wait 10s
                - flag player empowered_blade_active:false
                - actionbar "Empowered Blade is no longer active!"
                - wait 300s
                - flag player empowered_blade_cooldown:false
                - actionbar "Empowered Blade is ready to use!"
            #If player has not confirmed the activation yet, set the confirmation flag to true for 5 seconds.
            - else:
                - flag player empowered_blade_confirm:true
                - actionbar "Right click again to activate Empowered Blade!"
                - wait 5s
                - flag player empowered_blade_confirm:false


activate_berserk:
    type: command
    name: activate_berserk
    description: Activates the berserk skill.
    usage: activate_berserk
    script:
        - if <player.flag[berserk_cooldown]> != true:
            #If player has confirmed the activation, activate the skill.
            - if <player.flag[berserk_confirm]> == true:
                - actionbar "Berserk is now active!"
                - flag player berserk_cooldown:true
                - flag player berserk_active:true
                - choose <player.mcmmo.level[unarmed].div_int[200].round_down>:
                    - case 0:
                        - wait 1s
                    - case 1:
                        - wait 2s
                    - case 2:
                        - wait 3s
                    - case 3:
                        - wait 4s
                    - case 4:
                        - wait 5s
                        #level 1000+
                    - default:
                        - wait 6s
                - flag player berserk_active:false
                - actionbar "Berserk is no longer active!"
                - wait 300s
                - flag player berserk_cooldown:false
                - actionbar "Berserk is ready to use!"
            #If player has not confirmed the activation yet, set the confirmation flag to true for 5 seconds.
            - else:
                - flag player berserk_confirm:true
                - actionbar "Right click again to activate Berserk!"
                - wait 5s
                - flag player berserk_confirm:false

activate_whirlwind:
    type: command
    name: activate_whirlwind
    description: Activates the whirlwind skill.
    usage: activate_whirlwind
    script:
        - if <player.flag[whirlwind_cooldown]> != true:
            #If player has confirmed the activation, activate the skill.
            - if <player.flag[whirlwind_confirm]> == true:
                - actionbar "Whirlwind used!"
                - run whirlwind
                - flag player whirlwind_cooldown:true
                - choose <player.mcmmo.level[axes].div_int[100].round_down>:
                    - case 0:
                        - wait 300s
                    - case 1:
                        - wait 270s
                    - case 2:
                        - wait 240s
                    - case 3:
                        - wait 210s
                    - case 4:
                        - wait 180s
                    - case 5:
                        - wait 150s
                    - case 6:
                        - wait 120s
                    - case 7:
                        - wait 90s
                    - case 8:
                        - wait 60s
                        #level 1000+
                    - default:
                        - wait 30s
                - flag player whirlwind_cooldown:false
                - actionbar "Whirlwind is ready to use!"
            #If player has not confirmed the activation yet, set the confirmation flag to true for 5 seconds.
            - else:
                - flag player whirlwind_confirm:true
                - wait 5s
                - flag player whirlwind_confirm:false
                
damage_dealt_listener:
    type: world
    events:
        on player damages entity:
            - choose <context.damager.item_in_hand.material>:
                    #Berserk
                - case m@air:
                    - if <context.damager.flag[berserk_active]> == true:
                        - if <player.mcmmo.level[unarmed]> > 1000:
                                - determine <context.damage.add_int[5]>
                        - define damage <player.mcmmo.level[unarmed].div_int[250].round_down.add_int[1]>
                        - determine <context.damage.add_int[<[damage]>]>
                    #Empowered Blade
                - case m@wooden_sword:
                        - if <context.damager.flag[empowered_blade_active]> == true:
                            - if <player.mcmmo.level[swords]> > 1000:
                                    - determine <context.damage.add_int[6]>
                            - define damage <player.mcmmo.level[swords].div_int[200].round_down.add_int[1]>
                            - determine <context.damage.add_int[<[damage]>]>
                - case m@stone_sword:
                        - if <context.damager.flag[empowered_blade_active]> == true:
                            - if <player.mcmmo.level[swords]> > 1000:
                                    - determine <context.damage.add_int[6]>
                            - define damage <player.mcmmo.level[swords].div_int[200].round_down.add_int[1]>
                            - determine <context.damage.add_int[<[damage]>]>
                - case m@iron_sword:
                        - if <context.damager.flag[empowered_blade_active]> == true:
                            - if <player.mcmmo.level[swords]> > 1000:
                                    - determine <context.damage.add_int[6]>
                            - define damage <player.mcmmo.level[swords].div_int[200].round_down.add_int[1]>
                            - determine <context.damage.add_int[<[damage]>]>
                - case m@golden_sword:
                        - if <context.damager.flag[empowered_blade_active]> == true:
                            - if <player.mcmmo.level[swords]> > 1000:
                                    - determine <context.damage.add_int[6]>
                            - define damage <player.mcmmo.level[swords].div_int[200].round_down.add_int[1]>
                            - determine <context.damage.add_int[<[damage]>]>
                - case m@diamond_sword:
                        - if <context.damager.flag[empowered_blade_active]> == true:
                            - if <player.mcmmo.level[swords]> > 1000:
                                    - determine <context.damage.add_int[6]>
                            - define damage <player.mcmmo.level[swords].div_int[200].round_down.add_int[1]>
                            - determine <context.damage.add_int[<[damage]>]>
                - case m@netherite_sword:
                        - if <context.damager.flag[empowered_blade_active]> == true:
                            - if <player.mcmmo.level[swords]> > 1000:
                                    - determine <context.damage.add_int[6]>
                            - define damage <player.mcmmo.level[swords].div_int[200].round_down.add_int[1]>
                            - determine <context.damage.add_int[<[damage]>]>
            
block_break_listener:
    type: world
    events:
        on player breaks block:
        - choose <player.item_in_hand.material>:
            - case m@wooden_axe || m@stone_axe || m@iron_axe || m@gold_axe || m@diamond_axe || m@netherite_axe:
                - choose <context.material>:
                    - case m@oak_log[direction=Y]:
                        - inject tree_feller
                    - case m@birch_log[direction=Y]:
                        - inject tree_feller
                    - case m@spruce_log[direction=Y]:
                        - inject tree_feller
                    - case m@jungle_log[direction=Y]:
                        - inject tree_feller
                    - case m@acacia_log[direction=Y]:
                        - inject tree_feller
                    - case m@dark_oak_log[direction=Y]:
                        - inject tree_feller
                    - case m@crimson_stem[direction=Y]:
                        - inject tree_feller
                    - case m@warped_stem[direction=Y]:
                        - inject tree_feller
            - case m@wooden_hoe || m@stone_hoe || m@iron_hoe || m@gold_hoe || m@diamond_hoe || m@netherite_hoe:
                - choose <context.material.name>:
                    - case wheat: 
                        - if <context.material.age> == 7:
                            - define crop wheat
                            - inject auto_replant
                    - case beetroots:
                        - if <context.material.age> == 3:
                            - define crop beetroots
                            - inject auto_replant
                    - case carrots:
                        - if <context.material.age> == 7:
                            - define crop carrots
                            - inject auto_replant
                    - case potatoes:
                        - if <context.material.age> == 7:
                            - define crop potatoes
                            - inject auto_replant
                    - case nether_wart:
                        - if <context.material.age> == 3:
                            - define crop nether_wart
                            - inject auto_replant
                            #Cocoa removed because I do not know how to get the initial broken block's direction attribute
            - case m@wooden_pickaxe || m@stone_pickaxe || m@iron_pickaxe || m@gold_pickaxe || m@diamond_pickaxe || m@netherite_pickaxe:
                - choose <context.material.name>:
                    - case stone:
                        - inject super_breaker
                    - case andesite:
                        - inject super_breaker
                    - case basalt:
                        - inject super_breaker
                    - case polished_basalt:
                        - inject super_breaker
                    - case blackstone:
                        - inject super_breaker
                    - case cracked_polished_blackstone_bricks:
                        - inject super_breaker
                    - case chiseled_polished_blackstone:
                        - inject super_breaker
                    - case block_of_coal:
                        - inject super_breaker
                    - case block_of_quartz:
                        - inject super_breaker
                    - case bricks:
                        - inject super_breaker
                    - case coal_ore:
                        - inject super_breaker
                    - case cobblestone:
                        - inject super_breaker
                    - case concrete:
                        - inject super_breaker
                    - case dark_prismarine:
                        - inject super_breaker
                    - case diorite:
                        - inject super_breaker
                    - case end_stone:
                        - inject super_breaker
                    - case glazed_terracotta:
                        - inject super_breaker
                    - case granite:
                        - inject super_breaker
                    - case mossy_cobblestone:
                        - inject super_breaker
                    - case nether_bricks:
                        - inject super_breaker
                    - case nether_gold_ore:
                        - inject super_breaker
                    - case nether_quartz_ore:
                        - inject super_breaker
                    - case netherrack:
                        - inject super_breaker
                    - case prismarine:
                        - inject super_breaker
                    - case prismarine_bricks:
                        - inject super_breaker
                    - case polished_andesite:
                        - inject super_breaker
                    - case polished_blackstone:
                        - inject super_breaker
                    - case polished_blackstone_bricks:
                        - inject super_breaker
                    - case polished_diorite:
                        - inject super_breaker
                    - case polished_granite:
                        - inject super_breaker
                    - case red_sandstone:
                        - inject super_breaker
                    - case sandstone:
                        - inject super_breaker
                    - case colored_terracotta:
                        - inject super_breaker
                    - case smooth_stone:
                        - inject super_breaker
                    - case stone_bricks:
                        - inject super_breaker
                    - case cracked_stone_bricks:
                        - inject super_breaker
                    - case mossy_stone_bricks:
                        - inject super_breaker
                    - case chiseled_stone_bricks:
                        - inject super_breaker
                    - case terracotta:
                        - inject super_breaker
                    - case iron_ore:
                        - inject super_breaker
                    - case lapis_lazuli_ore:
                        - inject super_breaker
                    - case diamond_ore:
                        - inject super_breaker
                    - case emerald_ore:
                        - inject super_breaker
                    - case gold_ore:
                        - inject super_breaker
                    - case redstone_ore:
                        - inject super_breaker
                    - case ancient_debris:
                        - inject super_breaker
                    - case crying_obsidian:
                        - inject super_breaker
                    - case obsidian:
                        - inject super_breaker
                    - case ice:
                        - inject super_breaker
                    - case packed_ice:
                        - inject super_breaker
                    - case blue_ice:
                        - inject super_breaker
                    - case frosted_ice:
                        - inject super_breaker
                    - case redstone_block:
                        - inject super_breaker
                    - case iron_block:
                        - inject super_breaker
                    - case lapis_lazuli_block:
                        - inject super_breaker
                    - case diamond_block:
                        - inject super_breaker
                    - case emerald_block:
                        - inject super_breaker
                    - case gold_block:
                        - inject super_breaker
                    - case netherite_block:
                        - inject super_breaker
            - case m@wooden_shovel || m@stone_shovel || m@iron_shovel || m@gold_shovel || m@diamond_shovel || m@netherite_shovel:
                - choose <context.material>:
                    - case m@clay:
                        - inject super_digger
                        - inject mana_deposit
                    - case m@coarse_dirt:
                        - inject super_digger
                        - inject mana_deposit
                    - case m@concrete_powder:
                        - inject super_digger
                        - inject mana_deposit
                    - case m@dirt:
                        - inject super_digger
                        - inject mana_deposit
                    - case m@farmland:
                        - inject super_digger
                        - inject mana_deposit
                    - case m@grass_block[snowy=false]:
                        - inject super_digger
                        - inject mana_deposit
                    - case m@gravel:
                        - inject super_digger
                        - inject mana_deposit
                    - case m@mycelium:
                        - inject super_digger
                        - inject mana_deposit
                    - case m@podzol:
                        - inject super_digger
                        - inject mana_deposit
                    - case m@red_sand:
                        - inject super_digger
                        - inject mana_deposit
                    - case m@sand:
                        - inject super_digger
                        - inject mana_deposit
                    - case m@soul_sand:
                        - inject super_digger
                        - inject mana_deposit
                    - case m@soul_soil:
                        - inject super_digger
                        - inject mana_deposit
                    - case m@snow_block:
                        - inject super_digger
                        - inject mana_deposit

tree_feller:
    type: task
    script:
        - if <player.flag[tree_feller_active]> == true && <context.location> == <player.cursor_on>:
            - define log_location <context.location>
            - while <[log_location].above.material> == <context.material>:
                - define log_location <[log_location].above>
                - modifyblock <[log_location]> air naturally source:<player>
                - mcmmo add xp skill:woodcutting quantity:200
            - define sapling_location <context.location>
            - inject tree_feller_replant
            #Check for 2x2 tree
            - if <context.location.forward[1].material> == <context.material>:
                - define log_location <context.location.forward[1]>
                - modifyblock <[log_location]> air naturally source:<player>
                - mcmmo add xp skill:woodcutting quantity:200
                - while <[log_location].above.material> == <context.material>:
                        - define log_location <[log_location].above>
                        - modifyblock <[log_location]> air naturally source:<player>
                - mcmmo add xp skill:woodcutting quantity:200
                - define sapling_location <context.location.forward[1]>
                - inject tree_feller_replant
            - if <context.location.backward[1].material> == <context.material>:
                - define log_location <context.location.backward[1]>
                - modifyblock <[log_location]> air naturally source:<player>
                - mcmmo add xp skill:woodcutting quantity:200
                - while <[log_location].above.material> == <context.material>:
                        - define log_location <[log_location].above>
                        - modifyblock <[log_location]> air naturally source:<player>
                - mcmmo add xp skill:woodcutting quantity:200
                - define sapling_location <context.location.backward[1]>
                - inject tree_feller_replant
            - if <context.location.left[1].material> == <context.material>:
                - define log_location <context.location.left[1]>
                - modifyblock <[log_location]> air naturally source:<player>
                - mcmmo add xp skill:woodcutting quantity:200
                - while <[log_location].above.material> == <context.material>:
                        - define log_location <[log_location].above>
                        - modifyblock <[log_location]> air naturally source:<player>
                - mcmmo add xp skill:woodcutting quantity:200
                - define sapling_location <context.location.left[1]>
                - inject tree_feller_replant
            - if <context.location.right[1].material> == <context.material>:
                - define log_location <context.location.right[1]>
                - modifyblock <[log_location]> air naturally source:<player>
                - mcmmo add xp skill:woodcutting quantity:200
                - while <[log_location].above.material> == <context.material>:
                        - define log_location <[log_location].above>
                        - modifyblock <[log_location]> air naturally source:<player>
                - mcmmo add xp skill:woodcutting quantity:200
                - define sapling_location <context.location.right[1]>
                - inject tree_feller_replant
            - if <context.location.forward[1].left[1].material> == <context.material>:
                - define log_location <context.location.forward[1].left[1]>
                - modifyblock <[log_location]> air naturally source:<player>
                - mcmmo add xp skill:woodcutting quantity:200
                - while <[log_location].above.material> == <context.material>:
                        - define log_location <[log_location].above>
                        - modifyblock <[log_location]> air naturally source:<player>
                - mcmmo add xp skill:woodcutting quantity:200
                - define sapling_location <context.location.forward[1].left[1]>
                - inject tree_feller_replant
            - if <context.location.forward[1].right[1].material> == <context.material>:
                - define log_location <context.location.forward[1].right[1]>
                - modifyblock <[log_location]> air naturally source:<player>
                - mcmmo add xp skill:woodcutting quantity:200
                - while <[log_location].above.material> == <context.material>:
                        - define log_location <[log_location].above>
                        - modifyblock <[log_location]> air naturally source:<player>
                - mcmmo add xp skill:woodcutting quantity:200
                - define sapling_location <context.location.forward[1].right[1]>
                - inject tree_feller_replant
            - if <context.location.backward[1].left[1].material> == <context.material>:
                - define log_location <context.location.backward[1].left[1]>
                - modifyblock <[log_location]> air naturally source:<player>
                - mcmmo add xp skill:woodcutting quantity:200
                - while <[log_location].above.material> == <context.material>:
                        - define log_location <[log_location].above>
                        - modifyblock <[log_location]> air naturally source:<player>
                - mcmmo add xp skill:woodcutting quantity:200
                - define sapling_location <context.location.backward[1].left[1]>
                - inject tree_feller_replant
            - if <context.location.backward[1].right[1].material> == <context.material>:
                - define log_location <context.location.backward[1].right[1]>
                - modifyblock <[log_location]> air naturally source:<player>
                - mcmmo add xp skill:woodcutting quantity:200
                - while <[log_location].above.material> == <context.material>:
                        - define log_location <[log_location].above>
                        - modifyblock <[log_location]> air naturally source:<player>
                - mcmmo add xp skill:woodcutting quantity:200
                - define sapling_location <context.location.backward[1].right[1]>
                - inject tree_feller_replant
            #Still need to configure leaves being broken
            #Still need to configure branches being broken
            
tree_feller_replant:
    type: task
    script:
        - if <player.mcmmo.level[woodcutting]> >= <util.random.int[1].to[1000]>:
            - if <[sapling_location].below.material.name> == dirt || <[sapling_location].below.material.name> == grass_block:
                - choose <context.material.name>:
                    - case oak_log:
                        - modifyblock <[sapling_location]> oak_sapling delayed source:<player>
                    - case birch_log:
                        - modifyblock <[sapling_location]> birch_sapling delayed source:<player>
                    - case spruce_log:
                        - modifyblock <[sapling_location]> spruce_sapling delayed source:<player>
                    - case jungle_log:
                        - modifyblock <[sapling_location]> jungle_sapling delayed source:<player>
                    - case acacia_log:
                        - modifyblock <[sapling_location]> acacia_sapling delayed source:<player>
                    - case dark_oak_log:
                        - modifyblock <[sapling_location]> dark_oak_sapling delayed source:<player>

super_breaker:
    type: task
    script:
    - if <player.flag[super_breaker_active]> == true && <context.location> == <player.cursor_on>:
        - if <context.location.x.abs.sub_int[<player.location.x.abs.round>]> < 1.5 && <context.location.x.abs.sub_int[<player.location.x.abs.round>]> > -1.5:
            - if <proc[super_breaker_checker].context[<context.location.up>]> == true:
                - modifyblock <context.location.up> air naturally:<player.item_in_hand> source:<player>
                - mcmmo xp add skill:mining quantity:15
                - adjust <context.item_in_hand> durability:<context.item_in_hand.durability.sub_int[1]>
            - if <proc[super_breaker_checker].context[<context.location.up.left>]> == true:
                - modifyblock <context.location.up.left> air naturally:<player.item_in_hand> source:<player>
                - mcmmo xp add skill:mining quantity:15
                - adjust <context.item_in_hand> durability:<context.item_in_hand.durability.sub_int[1]>
            - if <proc[super_breaker_checker].context[<context.location.up.right>]> == true:
                - modifyblock <context.location.up.right> air naturally:<player.item_in_hand> source:<player>
                - mcmmo xp add skill:mining quantity:15
                - adjust <context.item_in_hand> durability:<context.item_in_hand.durability.sub_int[1]>
            - if <proc[super_breaker_checker].context[<context.location.down>]> == true:
                - modifyblock <context.location.down> air naturally:<player.item_in_hand> source:<player>
                - mcmmo xp add skill:mining quantity:15
                - adjust <context.item_in_hand> durability:<context.item_in_hand.durability.sub_int[1]>
            - if <proc[super_breaker_checker].context[<context.location.down.right>]> == true:
                - modifyblock <context.location.down.right> air naturally:<player.item_in_hand> source:<player>
                - mcmmo xp add skill:mining quantity:15
                - adjust <context.item_in_hand> durability:<context.item_in_hand.durability.sub_int[1]>
            - if <proc[super_breaker_checker].context[<context.location.down.left>]> == true:
                - modifyblock <context.location.down.left> air naturally:<player.item_in_hand> source:<player>
                - mcmmo xp add skill:mining quantity:15
                - adjust <context.item_in_hand> durability:<context.item_in_hand.durability.sub_int[1]>
            - if <proc[super_breaker_checker].context[<context.location.left>]> == true:
                - modifyblock <context.location.left> air naturally:<player.item_in_hand> source:<player>
                - mcmmo xp add skill:mining quantity:15
                - adjust <context.item_in_hand> durability:<context.item_in_hand.durability.sub_int[1]>
            - if <proc[super_breaker_checker].context[<context.location.right>]> == true:
                - modifyblock <context.location.right> air naturally:<player.item_in_hand> source:<player>
                - mcmmo xp add skill:mining quantity:15
                - adjust <context.item_in_hand> durability:<context.item_in_hand.durability.sub_int[1]>
        - else:
            - if <proc[super_breaker_checker].context[<context.location.up>]> == true:
                - modifyblock <context.location.up> air naturally:<player.item_in_hand> source:<player>
                - mcmmo xp add skill:mining quantity:15
                - adjust <context.item_in_hand> durability:<context.item_in_hand.durability.sub_int[1]>
            - if <proc[super_breaker_checker].context[<context.location.up.forward[1]>]> == true:
                - modifyblock <context.location.up.forward[1]> air naturally:<player.item_in_hand> source:<player>
                - mcmmo xp add skill:mining quantity:15
                - adjust <context.item_in_hand> durability:<context.item_in_hand.durability.sub_int[1]>
            - if <proc[super_breaker_checker].context[<context.location.up.backward[1]>]> == true:
                - modifyblock <context.location.up.backward[1]> air naturally:<player.item_in_hand> source:<player>
                - mcmmo xp add skill:mining quantity:15
                - adjust <context.item_in_hand> durability:<context.item_in_hand.durability.sub_int[1]>
            - if <proc[super_breaker_checker].context[<context.location.down>]> == true:
                - modifyblock <context.location.down> air naturally:<player.item_in_hand> source:<player>
                - mcmmo xp add skill:mining quantity:15
                - adjust <context.item_in_hand> durability:<context.item_in_hand.durability.sub_int[1]>
            - if <proc[super_breaker_checker].context[<context.location.down.forward[1]>]> == true:
                - modifyblock <context.location.down.forward[1]> air naturally:<player.item_in_hand> source:<player>
                - mcmmo xp add skill:mining quantity:15
                - adjust <context.item_in_hand> durability:<context.item_in_hand.durability.sub_int[1]>
            - if <proc[super_breaker_checker].context[<context.location.down.backward[1]>]> == true:
                - modifyblock <context.location.down.backward[1]> air naturally:<player.item_in_hand> source:<player>
                - mcmmo xp add skill:mining quantity:15
                - adjust <context.item_in_hand> durability:<context.item_in_hand.durability.sub_int[1]>
            - if <proc[super_breaker_checker].context[<context.location.forward[1]>]> == true:
                - modifyblock <context.location.forward[1]> air naturally:<player.item_in_hand> source:<player>
                - mcmmo xp add skill:mining quantity:15
                - adjust <context.item_in_hand> durability:<context.item_in_hand.durability.sub_int[1]>
            - if <proc[super_breaker_checker].context[<context.location.backward[1]>]> == true:
                - modifyblock <context.location.backward[1]> air naturally:<player.item_in_hand> source:<player>
                - mcmmo xp add skill:mining quantity:15
                - adjust <context.item_in_hand> durability:<context.item_in_hand.durability.sub_int[1]>

super_digger:
    type: task
    script:
    - if <player.flag[super_digger_active]> == true && <context.location> == <player.cursor_on>:
        - if <context.location.x.abs.sub_int[<player.location.x.abs.round>]> < 1.5 && <context.location.x.abs.sub_int[<player.location.x.abs.round>]> > -1.5:
            - if <proc[super_digger_checker].context[<context.location.up>]> == true:
                - modifyblock <context.location.up> air naturally:<player.item_in_hand>
                - mcmmo xp add skill:excavation quantity:15
            - if <proc[super_digger_checker].context[<context.location.up.left>]> == true:
                - modifyblock <context.location.up.left> air naturally:<player.item_in_hand>
                - mcmmo xp add skill:excavation quantity:15
            - if <proc[super_digger_checker].context[<context.location.up.right>]> == true:
                - modifyblock <context.location.up.right> air naturally:<player.item_in_hand>
                - mcmmo xp add skill:excavation quantity:15
            - if <proc[super_digger_checker].context[<context.location.down>]> == true:
                - modifyblock <context.location.down> air naturally:<player.item_in_hand>
                - mcmmo xp add skill:excavation quantity:15
            - if <proc[super_digger_checker].context[<context.location.down.right>]> == true:
                - modifyblock <context.location.down.right> air naturally:<player.item_in_hand>
                - mcmmo xp add skill:excavation quantity:15
            - if <proc[super_digger_checker].context[<context.location.down.left>]> == true:
                - modifyblock <context.location.down.left> air naturally:<player.item_in_hand>
                - mcmmo xp add skill:excavation quantity:15
            - if <proc[super_digger_checker].context[<context.location.left>]> == true:
                - modifyblock <context.location.left> air naturally:<player.item_in_hand>
                - mcmmo xp add skill:excavation quantity:15
            - if <proc[super_digger_checker].context[<context.location.right>]> == true:
                - modifyblock <context.location.right> air naturally:<player.item_in_hand>
                - mcmmo xp add skill:excavation quantity:15
        - else:
            - if <proc[super_digger_checker].context[<context.location.up>]> == true:
                - modifyblock <context.location.up> air naturally:<player.item_in_hand>
                - mcmmo xp add skill:excavation quantity:15
            - if <proc[super_digger_checker].context[<context.location.up.forward[1]>]> == true:
                - modifyblock <context.location.up.forward[1]> air naturally:<player.item_in_hand>
                - mcmmo xp add skill:excavation quantity:15
            - if <proc[super_digger_checker].context[<context.location.up.backward[1]>]> == true:
                - modifyblock <context.location.up.backward[1]> air naturally:<player.item_in_hand>
                - mcmmo xp add skill:excavation quantity:15
            - if <proc[super_digger_checker].context[<context.location.down>]> == true:
                - modifyblock <context.location.down> air naturally:<player.item_in_hand>
                - mcmmo xp add skill:excavation quantity:15
            - if <proc[super_digger_checker].context[<context.location.down.forward[1]>]> == true:
                - modifyblock <context.location.down.forward[1]> air naturally:<player.item_in_hand>
                - mcmmo xp add skill:excavation quantity:15
            - if <proc[super_digger_checker].context[<context.location.down.backward[1]>]> == true:
                - modifyblock <context.location.down.backward[1]> air naturally:<player.item_in_hand>
                - mcmmo xp add skill:excavation quantity:15
            - if <proc[super_digger_checker].context[<context.location.forward[1]>]> == true:
                - modifyblock <context.location.forward[1]> air naturally:<player.item_in_hand>
                - mcmmo xp add skill:excavation quantity:15
            - if <proc[super_digger_checker].context[<context.location.backward[1]>]> == true:
                - modifyblock <context.location.backward[1]> air naturally:<player.item_in_hand>
                - mcmmo xp add skill:excavation quantity:15
        
super_breaker_checker:
    type: procedure
    definitions: input
    script:
    - choose <[input].material.name>:
        - case stone:
            - determine true
        - case andesite:
            - determine true
        - case basalt:
            - determine true
        - case polished_basalt:
            - determine true
        - case blackstone:
            - determine true
        - case cracked_polished_blackstone_bricks:
            - determine true
        - case chiseled_polished_blackstone:
            - determine true
        - case block_of_coal:
            - determine true
        - case block_of_quartz:
            - determine true
        - case bricks:
            - determine true
        - case coal_ore:
            - determine true
        - case cobblestone:
            - determine true
        - case concrete:
            - determine true
        - case dark_prismarine:
            - determine true
        - case diorite:
            - determine true
        - case end_stone:
            - determine true
        - case glazed_terracotta:
            - determine true
        - case granite:
            - determine true
        - case mossy_cobblestone:
            - determine true
        - case nether_bricks:
            - determine true
        - case nether_gold_ore:
            - determine true
        - case nether_quartz_ore:
            - determine true
        - case netherrack:
            - determine true
        - case prismarine:
            - determine true
        - case prismarine_bricks:
            - determine true
        - case polished_andesite:
            - determine true
        - case polished_blackstone:
            - determine true
        - case polished_blackstone_bricks:
            - determine true
        - case polished_diorite:
            - determine true
        - case polished_granite:
            - determine true
        - case red_sandstone:
            - determine true
        - case sandstone:
            - determine true
        - case colored_terracotta:
            - determine true
        - case smooth_stone:
            - determine true
        - case stone_bricks:
            - determine true
        - case chiseled_stone_bricks:
            - determine true
        - case cracked_stone_bricks:
            - determine true
        - case polished_stone_bricks:
            - determine true
        - case mossy_stone_bricks:
            - determine true
        - case terracotta:
            - determine true
        - case iron_ore:
            - determine true
        - case lapis_lazuli_ore:
            - determine true
        - case diamond_ore:
            - determine true
        - case emerald_ore:
            - determine true
        - case gold_ore:
            - determine true
        - case redstone_ore:
            - determine true
        - case ancient_debris:
            - determine true
        - case crying_obsidian:
            - determine true
        - case obsidian:
            - determine true
        - case ice:
            - determine true
        - case packed_ice:
            - determine true
        - case blue_ice:
            - determine true
        - case frosted_ice:
            - determine true
        - case redstone_block:
            - determine true
        - case iron_block:
            - determine true
        - case lapis_lazuli_block:
            - determine true
        - case diamond_block:
            - determine true
        - case emerald_block:
            - determine true
        - case gold_block:
            - determine true
        - case netherite_block:
            - determine true
        - default:
            - determine false
        
super_digger_checker:
    type: procedure
    definitions: input
    script:
    - choose <[input].material>:
        - case m@clay:
            - determine true
        - case m@coarse_dirt:
            - determine true
        - case m@concrete_powder:
            - determine true
        - case m@dirt:
            - determine true
        - case m@farmland:
            - determine true
        - case m@grass_block[snowy=false]:
            - determine true
        - case m@gravel:
            - determine true
        - case m@mycelium:
            - determine true
        - case m@podzol:
            - determine true
        - case m@red_sand:
            - determine true
        - case m@sand:
            - determine true
        - case m@soul_sand:
            - determine true
        - case m@soul_soil:
            - determine true
        - case m@snow_block:
            - determine true
        - default:
            - determine false
    

leaf_blower:
    type: world
    events:
        on player left clicks oak_leaves:
            - if <player.mcmmo.level[woodcutting]> > 100:
                - if <context.item> == diamond_axe || <context.item> == netherite_axe || <context.item> == gold_axe || <context.item> == iron_axe || <context.item> == wooden_axe || <context.item> == stone_axe:
                    - modifyblock <context.location> air naturally:<player.item_in_hand> source:<player>
        on player left clicks spruce_leaves:
                - if <context.item> == diamond_axe || <context.item> == netherite_axe || <context.item> == gold_axe || <context.item> == iron_axe || <context.item> == wooden_axe || <context.item> == stone_axe:
                    - modifyblock <context.location> air naturally:<player.item_in_hand> source:<player>
        on player left clicks birch_leaves:
                - if <context.item> == diamond_axe || <context.item> == netherite_axe || <context.item> == gold_axe || <context.item> == iron_axe || <context.item> == wooden_axe || <context.item> == stone_axe:
                    - modifyblock <context.location> air naturally:<player.item_in_hand> source:<player>
        on player left clicks jungle_leaves:
                - if <context.item> == diamond_axe || <context.item> == netherite_axe || <context.item> == gold_axe || <context.item> == iron_axe || <context.item> == wooden_axe || <context.item> == stone_axe:
                    - modifyblock <context.location> air naturally:<player.item_in_hand> source:<player>
        on player left clicks acacia_leaves:
                - if <context.item> == diamond_axe || <context.item> == netherite_axe || <context.item> == gold_axe || <context.item> == iron_axe || <context.item> == wooden_axe || <context.item> == stone_axe:
                    - modifyblock <context.location> air naturally:<player.item_in_hand> source:<player>
        on player left clicks dark_oak_leaves:
                - if <context.item> == diamond_axe || <context.item> == netherite_axe || <context.item> == gold_axe || <context.item> == iron_axe || <context.item> == wooden_axe || <context.item> == stone_axe:
                    - modifyblock <context.location> air naturally:<player.item_in_hand> source:<player>

auto_smelt:
    type: world
    events:
       on player breaks iron_ore:
       - if <player.mcmmo.level[mining]> >= <util.random.int[1].to[1000]> && <player.item_in_hand.enchantments.find[silk_touch]> == -1 && <context.location.mcmmo.is_placed> == false:
            - mcmmo add xp skill:repair quantity:15
            - determine li@iron_ingot|
       on player breaks gold_ore:
       - if <player.mcmmo.level[mining]> >= <util.random.int[1].to[1000]> && <player.item_in_hand.enchantments.find[silk_touch]> == -1 && <context.location.mcmmo.is_placed> == false:
            - mcmmo add xp skill:repair quantity:25
            - determine li@gold_ingot|

#Pushback removed because denizens is dumb and doesn't have a reliable way to push an entity

multishot:
    type: world
    events:
        on player shoots bow:
            - if <player.mcmmo.level[archery].div_int[3]> >= <util.random.int[1].to[1000]>:
                - shoot arrow origin:<context.entity> lead:<player.cursor_on> speed:<context.force.mul_int[8]>
            #Known issues
            #Extra arrow is retreivable

whirlwind:
    type: script
    script:
    - define weapon_damage 1
    - choose <player.item_in_hand.material>:
        - case m@wooden_axe:
            - define weapon_damage 7
        - case m@stone_axe:
            - define weapon_damage 9
        - case m@iron_axe:
            - define weapon_damage 9
        - case m@golden_axe:
            - define weapon_damage 7
        - case m@diamond_axe:
            - define weapon_damage 9
        - case m@netherite_axe:
            - define weapon_damage 10
    - foreach <player.location.find.living_entities.within[2.0]>:
          #Skip the caster.
        - if <[loop_index]> == 1:
            - foreach next
        - hurt <[weapon_damage]> <[value]> source:<player>
    #Known issues
    #Not set up to check for friendly targets (I.E. non-pvp players, Citizen NPCs)

#Changed from increasing repair amount to decreasing the xp requirement of using an anvil because denizen sucks and doesn't let you interact with the anvil's repair function.
empowered_repair:
    type: world
    events:
        on player prepares anvil craft item:
            - if <player.mcmmo.level[repair]> > 1000:
                - define discount 10
            - else:
                - define discount <player.mcmmo.level[repair].div_int[100]>
            - if <context.repair_cost> < <[discount]>:
                - determine 1
            - determine <context.repair_cost.sub_int[<[discount]>]>

empowered_mending:
    type: world
    events:
        on player mends item:
            - if <player.mcmmo.level[repair]> >= <util.random.int[1].to[1000]:
                - determine <context.repair_amount.mul_int[2]>

#Need to add loot table to give command
automatic_reeling:
    type: world
    events:
        on player fishes:
            - if <context.state> == BITE:
                - if <player.mcmmo.level[fishing]> > <util.random.int[1].to[1000]>:
                        - remove <context.hook>
                        - inject treasure_fishing
                        #Run income equation on base_income
                        #baseincome+(baseincome*(joblevel-1)*0.01)-((baseincome+(baseincome*(joblevel-1)*0.01)) * ((numjobs-1)*0.05))
#                        - define new_income <[base_income].add_int[[base_income].mul_int[player.job[fisherman].xp.level.sub_int[1]].mul_int[0.01]].sub_int[[base_income].add_int[[base_income].mul_int[player.job[fisherman].xp.level.sub_int[1]].mul_int[0.01]].mul_int[player.current_jobs.size.sub_int[1]].mul_int[0.05]>
#                        - narrate <[new_income]>
                        #Run xp equation on base_income
                        #baseexperience-(baseexperience*((numjobs-1) *0.01))
                        #Give player calculated income and xp
                        - give <[new_drop]>
                        - mcmmo xp add skill:fishing quantity:100
            - if <context.state> == CAUGHT_FISH:
                - inject treasure_fishing
                - determine CAUGHT:<[new_drop]>
                        
treasure_fishing:
    type: task
    script:
        - define loot_roll <util.random.int[1].to[10000]>
        - choose <player.mcmmo.level[fishing].div_int[50].round_down>:
            - case 0 || 1:
                - inject normal_fish
            - case 2 || 3 || 4:
                - if <[loot_roll]> > 912:
                    - inject normal_fish
                - else if <[loot_roll]> <= 750:
                    - inject common_fish
                - else if <[loot_roll]> <= 875:
                    - inject uncommon_fish
                - else if <[loot_roll]> <= 900:
                    - inject rare_fish
                - else if <[loot_roll]> <= 910:
                    - inject epic_fish
                - else if <[loot_roll]> <= 911:
                    - inject legendary_fish
                - else if <[loot_roll]> <= 912:
                    - inject record_fish
            - case 5 || 6:
                - if <[loot_roll]> > 956:
                    - inject normal_fish
                - else if <[loot_roll]> <= 650:
                    - inject common_fish
                - else if <[loot_roll]> <= 825:
                    - inject uncommon_fish
                - else if <[loot_roll]> <= 900:
                    - inject rare_fish
                - else if <[loot_roll]> <= 950:
                    - inject epic_fish
                - else if <[loot_roll]> <= 955:
                    - inject legendary_fish
                - else if <[loot_roll]> <= 956:
                    - inject record_fish
            - case 7 || 8 || 9:
                - if <[loot_roll]> > 861:
                    - inject normal_fish
                - else if <[loot_roll]> <= 350:
                    - inject common_fish
                - else if <[loot_roll]> <= 625:
                    - inject uncommon_fish
                - else if <[loot_roll]> <= 750:
                    - inject rare_fish
                - else if <[loot_roll]> <= 850:
                    - inject epic_fish
                - else if <[loot_roll]> <= 860:
                    - inject legendary_fish
                - else if <[loot_roll]> <= 861:
                    - inject record_fish
            - case 10 || 11 || 12:
                - if <[loot_roll]> > 1026:
                    - inject normal_fish
                - else if <[loot_roll]> <= 200:
                    - inject common_fish
                - else if <[loot_roll]> <= 550:
                    - inject uncommon_fish
                - else if <[loot_roll]> <= 775:
                    - inject rare_fish
                - else if <[loot_roll]> <= 925:
                    - inject epic_fish
                - else if <[loot_roll]> <= 1025:
                    - inject legendary_fish
                - else if <[loot_roll]> <= 1026:
                    - inject record_fish
            - case 13 || 14:
                - if <[loot_roll]> > 1076:
                    - inject normal_fish
                - else if <[loot_roll]> <= 150:
                    - inject common_fish
                - else if <[loot_roll]> <= 525:
                    - inject uncommon_fish
                - else if <[loot_roll]> <= 775:
                    - inject rare_fish
                - else if <[loot_roll]> <= 975:
                    - inject epic_fish
                - else if <[loot_roll]> <= 1075:
                    - inject legendary_fish
                - else if <[loot_roll]> <= 1076:
                    - inject record_fish
            - case 15 || 16:
                - if <[loot_roll]> > 1205:
                    - inject normal_fish
                - else if <[loot_roll]> <= 100:
                    - inject common_fish
                - else if <[loot_roll]> <= 425:
                    - inject uncommon_fish
                - else if <[loot_roll]> <= 800:
                    - inject rare_fish
                - else if <[loot_roll]> <= 1050:
                    - inject epic_fish
                - else if <[loot_roll]> <= 1200:
                    - inject legendary_fish
                - else if <[loot_roll]> <= 1205:
                    - inject record_fish
            - case 17 || 18 || 19:
                - if <[loot_roll]> > 1460:
                    - inject normal_fish
                - else if <[loot_roll]> <= 25:
                    - inject common_fish
                - else if <[loot_roll]> <= 300:
                    - inject uncommon_fish
                - else if <[loot_roll]> <= 700:
                    - inject rare_fish
                - else if <[loot_roll]> <= 1200:
                    - inject epic_fish
                - else if <[loot_roll]> <= 1450:
                    - inject legendary_fish
                - else if <[loot_roll]> <= 1460:
                    - inject record_fish
            #1000+
            - default:
                - if <[loot_roll]> > 2035:
                    - inject normal_fish
                - else if <[loot_roll]> <= 10:
                    - inject common_fish
                - else if <[loot_roll]> <= 160:
                    - inject uncommon_fish
                - else if <[loot_roll]> <= 760:
                    - inject rare_fish
                - else if <[loot_roll]> <= 1510:
                    - inject epic_fish
                - else if <[loot_roll]> <= 2010:
                    - inject legendary_fish
                - else if <[loot_roll]> <= 2035:
                    - inject record_fish
                
normal_fish:
    type: task
    script:
        - define roll <util.random.int[1].to[100]>
        - if <[roll]> >= 60:
            - define new_drop cod
            - define base_income 5
        - else if <[roll]> >= 85:
            - define new_drop salmon
            - define base_income 7
        - else if <[roll]> >= 87:
            - define new_drop tropical_fish
            - define base_income 12.5
        - else:
            - define new_drop pufferfish
            - define base_income 12.5
                
common_fish:
    type: task
    script:
        - define roll <util.random.int[1].to[10]>
        - define base_income 12.5
        - choose <[roll]>:
            - case 1:
                - define new_drop leather_chestplate
            - case 2:
                - define new_drop leather_helmet
            - case 3:
                - define new_drop leather_leggings
            - case 4:
                - define new_drop leather_boots
            - case 5:
                - define new_drop wooden_shovel
            - case 6:
                - define new_drop wooden_sword
            - case 7:
                - define new_drop wooden_axe
            - case 8:
                - define new_drop wooden_pickaxe
            - case 9:
                - define new_drop wooden_hoe
            - case 10:
                - define new_drop lapis_lazuli
                #Set quantity to 20
                
uncommon_fish:
    type: task
    script:
        - define roll <util.random.int[1].to[16]>
        - define base_income 12.5
        - choose <[roll]>:
            - case 1:
                - define new_drop stone_sword
            - case 2:
                - define new_drop stone_axe
            - case 3:
                - define new_drop stone_pickaxe
            - case 4:
                - define new_drop stone_hoe
            - case 5:
                - define new_drop stone_shovel
            - case 6:
                - define new_drop golden_axe
            - case 7:
                - define new_drop golden_pickaxe
            - case 8:
                - define new_drop golden_shovel
            - case 9:
                - define new_drop golden_sword
            - case 10:
                - define new_drop golden_hoe
            - case 11:
                - define new_drop golden_chestplate
            - case 12:
                - define new_drop golden_helmet
            - case 13:
                - define new_drop golden_leggings
            - case 14:
                - define new_drop golden_boots
            - case 15:
                - define new_drop iron_ingot
                #Set quantity to 5
            - case 16:
                - define new_drop gold_ingot
                #Set quantity to 5
                
rare_fish:
    type: task
    script:
        - define roll <util.random.int[1].to[8]>
        - define base_income 12.5
        - choose <[roll]>:
            - case 1:
                - define new_drop iron_sword
            - case 2:
                - define new_drop iron_pickaxe
            - case 3:
                - define new_drop iron_axe
            - case 4:
                - define new_drop iron_shovel
            - case 5:
                - define new_drop iron_hoe
            - case 6:
                - define new_drop bow
            - case 7:
                - define new_drop ender_pearl
            - case 8:
                - define new_drop blaze_rod
                
epic_fish:
    type: task
    script:
        - define roll <util.random.int[1].to[6]>
        - define base_income 12.5
        - choose <[roll]>:
            - case 1:
                - define new_drop iron_helmet
            - case 2:
                - define new_drop iron_chestplate
            - case 3:
                - define new_drop iron_leggings
            - case 4:
                - define new_drop iron_boots
            - case 5:
                - define new_drop ghast_tear
            - case 6:
                - define new_drop diamond
                #Set quantity to 5
                
legendary_fish:
    type: task
    script:
        - define roll <util.random.int[1].to[9]>
        - define base_income 12.5
        - choose <[roll]>:
            - case 1:
                - define new_drop diamond_helmet
            - case 2:
                - define new_drop diamond_chestplate
            - case 3:
                - define new_drop diamond_leggings
            - case 4:
                - define new_drop diamond_boots
            - case 5:
                - define new_drop diamond_sword
            - case 6:
                - define new_drop diamond_pickaxe
            - case 7:
                - define new_drop diamond_axe
            - case 8:
                - define new_drop diamond_hoe
            - case 9:
                - define new_drop diamond_shovel
                
record_fish:
    type: task
    script:
        - define roll <util.random.int[1].to[13]>
        - define base_income 12.5
        - choose <[roll]>:
            - case 1:
                - define new_drop music_disc_13
            - case 2:
                - define new_drop music_disc_cat
            - case 3:
                - define new_drop music_disc_chirp
            - case 4:
                - define new_drop music_disc_blocks
            - case 5:
                - define new_drop music_disc_far
            - case 6:
                - define new_drop music_disc_mall
            - case 7:
                - define new_drop music_disc_mellohi
            - case 8:
                - define new_drop music_disc_stal
            - case 9:
                - define new_drop music_disc_strad
            - case 10:
                - define new_drop music_disc_ward
            - case 11:
                - define new_drop music_disc_wait
            - case 12:
                - define new_drop music_disc_11
            - case 13:
                - define new_drop music_disc_pigstep

#Waiting until I can find a way to pull the held potion's duration
#instant_drink:
#    type: task
#    script:
#        - define potion_effects <context.item.potion_base.split[,]>
#        - narrate <[potion_effects]>
#        - cast <[potion_effects].get[0]> duration: amplifier:<[potion_effects].get[2].sub_int[1]>

#fuel_efficiency:
#    type: world
#    events:
#        on brewing stand brews:
#            - adjust <context.location> brewing_fuel_level:<context.location.brewing_fuel_level.add_int[1]>
#Turned off until we can determine brewing stand's owner
#Depenizen does not have a bridge with LWC
#There is a bridge for GriefProtection if we decide to use that




#Overrides for mcmmo commands

excavation_override:
    type: command
    name: excavation
    description: Show the overview for the excavation skill.
    usage: /excavation
    script:
        - narrate "§aᚐᚑᚒᚓᚔᚍᚎᚏ §2§lExcavation §aᚏᚎᚍᚔᚓᚒᚑᚐ"
        - narrate "§7Level §8- §6<player.mcmmo.level[excavation]>"
        - narrate "§7Exp §8- §e<player.mcmmo.xp[excavation]>§r / §6<player.mcmmo.xp[excavation].to_next_level>"
        - narrate ""
        - narrate "§aᚐᚐᚐᚑᚒᚓᚔᚍᚎᚏ §2§lSkills §aᚏᚎᚍᚔᚓᚒᚑᚐᚐᚐ"
        - narrate "§a§l» §7Super Digger"
        - narrate "§a§l» §7Mana Deposit"
        - narrate "§a§l» §7Ignore Drops"
        - narrate ""
        - narrate "§2§oUse §a§o/ABILITYNAME §2§oto read about an ability, ex: §a§o/manadeposit§2§o."

fishing_override:
    type: command
    name: fishing
    description: Show the overview for the fishing skill.
    usage: /fishing
    script:
        - narrate "§aᚐᚑᚒᚓᚔᚍᚎᚏ §2§lFishing §aᚏᚎᚍᚔᚓᚒᚑᚐ"
        - narrate "§7Level §8- §6<player.mcmmo.level[fishing]>"
        - narrate "§7Exp §8- §e<player.mcmmo.xp[fishing]>§r / §6<player.mcmmo.xp[fishing].to_next_level>"
        - narrate ""
        - narrate "§aᚐᚐᚐᚑᚒᚓᚔᚍᚎᚏ §2§lSkills §aᚏᚎᚍᚔᚓᚒᚑᚐᚐᚐ"
        - narrate "§a§l» §7Treasure Fishing"
        - narrate "§a§l» §7Automatic Reeling"
        - narrate ""
        - narrate "§2§oUse §a§o/ABILITYNAME §2§oto read about an ability, ex: §a§o/manadeposit§2§o."

herbalism_override:
    type: command
    name: herbalism
    description: Show the overview for the herbalism skill.
    usage: /herbalism
    script:
        - narrate "§aᚐᚑᚒᚓᚔᚍᚎᚏ §2§lHerbalism §aᚏᚎᚍᚔᚓᚒᚑᚐ"
        - narrate "§7Level §8- §6<player.mcmmo.level[herbalism]>"
        - narrate "§7Exp §8- §e<player.mcmmo.xp[herbalism]>§r / §6<player.mcmmo.xp[herbalism].to_next_level>"
        - narrate ""
        - narrate "§aᚐᚐᚐᚑᚒᚓᚔᚍᚎᚏ §2§lSkills §aᚏᚎᚍᚔᚓᚒᚑᚐᚐᚐ"
#       Template for showing ranks
#        - narrate "§a§l» §7Bountiful Harvest §8- §7§oRank §c§o1 §8§o/ §4§o10"
        - narrate "§a§l» §7Bountiful Harvest"
        - narrate "§a§l» §7Auto Replant"
        - narrate "§a§l» §7Double Breed"
        - narrate ""
        - narrate "§2§oUse §a§o/ABILITYNAME §2§oto read about an ability, ex: §a§o/manadeposit§2§o."

mining_override:
    type: command
    name: mining
    description: Show the overview for the mining skill.
    usage: /mining
    script:
        - narrate "§aᚐᚑᚒᚓᚔᚍᚎᚏ §2§lMining §aᚏᚎᚍᚔᚓᚒᚑᚐ"
        - narrate "§7Level §8- §6<player.mcmmo.level[mining]>"
        - narrate "§7Exp §8- §e<player.mcmmo.xp[mining]>§r / §6<player.mcmmo.xp[mining].to_next_level>"
        - narrate ""
        - narrate "§aᚐᚐᚐᚑᚒᚓᚔᚍᚎᚏ §2§lSkills §aᚏᚎᚍᚔᚓᚒᚑᚐᚐᚐ"
        - narrate "§a§l» §7Super Breaker"
        - narrate "§a§l» §7Auto Smelt"
        - narrate "§a§l» §7Ignore Drops"
        - narrate ""
        - narrate "§2§oUse §a§o/ABILITYNAME §2§oto read about an ability, ex: §a§o/manadeposit§2§o."

woodcutting_override:
    type: command
    name: woodcutting
    description: Show the overview for the woodcutting skill.
    usage: /woodcutting
    script:
        - narrate "§aᚐᚑᚒᚓᚔᚍᚎᚏ §2§lWoodcutting §aᚏᚎᚍᚔᚓᚒᚑᚐ"
        - narrate "§7Level §8- §6<player.mcmmo.level[woodcutting]>"
        - narrate "§7Exp §8- §e<player.mcmmo.xp[woodcutting]>§r / §6<player.mcmmo.xp[woodcutting].to_next_level>"
        - narrate ""
        - narrate "§aᚐᚐᚐᚑᚒᚓᚔᚍᚎᚏ §2§lSkills §aᚏᚎᚍᚔᚓᚒᚑᚐᚐᚐ"
        - narrate "§a§l» §7Tree Feller"
        - narrate "§a§l» §7Auto Plant"
        - narrate "§a§l» §7Leaf Blower"
        - narrate ""
        - narrate "§2§oUse §a§o/ABILITYNAME §2§oto read about an ability, ex: §a§o/manadeposit§2§o."

archery_override:
    type: command
    name: archery
    description: Show the overview for the archery skill.
    usage: /archery
    script:
        - narrate "§aᚐᚑᚒᚓᚔᚍᚎᚏ §2§lArchery §aᚏᚎᚍᚔᚓᚒᚑᚐ"
        - narrate "§7Level §8- §6<player.mcmmo.level[archery]>"
        - narrate "§7Exp §8- §e<player.mcmmo.xp[archery]>§r / §6<player.mcmmo.xp[archery].to_next_level>"
        - narrate ""
        - narrate "§aᚐᚐᚐᚑᚒᚓᚔᚍᚎᚏ §2§lSkills §aᚏᚎᚍᚔᚓᚒᚑᚐᚐᚐ"
        - narrate "§a§l» §7Multishot"
        - narrate "§a§l» §7Arrow Efficiency"
        - narrate "§a§l» §7Ignore Drops"
        - narrate ""
        - narrate "§2§oUse §a§o/ABILITYNAME §2§oto read about an ability, ex: §a§o/manadeposit§2§o."

axes_override:
    type: command
    name: axes
    description: Show the overview for the axes skill.
    usage: /axes
    script:
        - narrate "§aᚐᚑᚒᚓᚔᚍᚎᚏ §2§lAxes §aᚏᚎᚍᚔᚓᚒᚑᚐ"
        - narrate "§7Level §8- §6<player.mcmmo.level[axes]>"
        - narrate "§7Exp §8- §e<player.mcmmo.xp[axes]>§r / §6<player.mcmmo.xp[axes].to_next_level>"
        - narrate ""
        - narrate "§aᚐᚐᚐᚑᚒᚓᚔᚍᚎᚏ §2§lSkills §aᚏᚎᚍᚔᚓᚒᚑᚐᚐᚐ"
        - narrate "§a§l» §7Whirlwind"
        - narrate "§a§l» §7Greater Impact"
        - narrate "§a§l» §7Critical Impact"
        - narrate ""
        - narrate "§2§oUse §a§o/ABILITYNAME §2§oto read about an ability, ex: §a§o/manadeposit§2§o."

swords_override:
    type: command
    name: swords
    description: Show the overview for the swords skill.
    usage: /swords
    script:
#        - choose <player.mcmmo.level[swords].div_int[100].round_down>:
#            - case 0:
#                - define empowered_rank 1
#            - case 1:
#                - define empowered_rank 2
#            - case 2:
#                - define empowered_rank 3
#            - case 3:
#                - define empowered_rank 4
#            - case 4:
#                - define empowered_rank 5
#            - case 5:
#                - define empowered_rank 6
#            - case 6:
#                - define empowered_rank 7
#            - case 7:
#                - define empowered_rank 8
#            - case 8:
#                - define empowered_rank 9
#            - default:
#                - define empowered_rank 10
        - narrate "§aᚐᚑᚒᚓᚔᚍᚎᚏ §2§lSwords §aᚏᚎᚍᚔᚓᚒᚑᚐ"
        - narrate "§7Level §8- §6<player.mcmmo.level[swords]>"
        - narrate "§7Exp §8- §e<player.mcmmo.xp[swords]>§r / §6<player.mcmmo.xp[swords].to_next_level>"
        - narrate ""
        - narrate "§aᚐᚐᚐᚑᚒᚓᚔᚍᚎᚏ §2§lSkills §aᚏᚎᚍᚔᚓᚒᚑᚐᚐᚐ"
#        - narrate "§a§l» §7Empowered Blade §8- §7§oRank §c§o<[empowered_rank]> §8§o/ §4§o10"
        - narrate "§a§l» §7Empowered Blade"
        #Add bleed rank
        - narrate "§a§l» §7Bleed"
        - if <player.mcmmo.level[swords]> < 500:
            - narrate "§a§l» §7Parry §8- §c§oLocked"
        - else:
            - narrate "§a§l» §7Parry §8- §c§oUnlocked"
        - narrate ""
        - narrate "§2§oUse §a§o/ABILITYNAME §2§oto read about an ability, ex: §a§o/manadeposit§2§o."

taming_override:
    type: command
    name: taming
    description: Show the overview for the taming skill.
    usage: /taming
    script:
        - narrate "§aᚐᚑᚒᚓᚔᚍᚎᚏ §2§lTaming §aᚏᚎᚍᚔᚓᚒᚑᚐ"
        - narrate "§7Level §8- §6<player.mcmmo.level[taming]>"
        - narrate "§7Exp §8- §e<player.mcmmo.xp[taming]>§r / §6<player.mcmmo.xp[taming].to_next_level>"
        - narrate ""
        - narrate "§aᚐᚐᚐᚑᚒᚓᚔᚍᚎᚏ §2§lSkills §aᚏᚎᚍᚔᚓᚒᚑᚐᚐᚐ"
        - narrate "§a§l» §7Sharp Claws"
        - narrate "§a§l» §7Thick Hide"
        - narrate "§a§l» §7Critical Strikes"
        - narrate ""
        - narrate "§2§oUse §a§o/ABILITYNAME §2§oto read about an ability, ex: §a§o/manadeposit§2§o."

unarmed_override:
    type: command
    name: unarmed
    description: Show the overview for the unarmed skill.
    usage: /unarmed
    script:
        - narrate "§aᚐᚑᚒᚓᚔᚍᚎᚏ §2§lUnarmed §aᚏᚎᚍᚔᚓᚒᚑᚐ"
        - narrate "§7Level §8- §6<player.mcmmo.level[unarmed]>"
        - narrate "§7Exp §8- §e<player.mcmmo.xp[unarmed]>§r / §6<player.mcmmo.xp[unarmed].to_next_level>"
        - narrate ""
        - narrate "§aᚐᚐᚐᚑᚒᚓᚔᚍᚎᚏ §2§lSkills §aᚏᚎᚍᚔᚓᚒᚑᚐᚐᚐ"
        - narrate "§a§l» §7Berserk"
        - narrate "§a§l» §7Iron Fist"
        - narrate "§a§l» §7Deflect"
        - narrate ""
        - narrate "§2§oUse §a§o/ABILITYNAME §2§oto read about an ability, ex: §a§o/manadeposit§2§o."

acrobatics_override:
    type: command
    name: acrobatics
    description: Show the overview for the acrobatics skill.
    usage: /acrobatics
    script:
        - narrate "§aᚐᚑᚒᚓᚔᚍᚎᚏ §2§lAcrobatics §aᚏᚎᚍᚔᚓᚒᚑᚐ"
        - narrate "§7Level §8- §6<player.mcmmo.level[acrobatics]>"
        - narrate "§7Exp §8- §e<player.mcmmo.xp[acrobatics]>§r / §6<player.mcmmo.xp[acrobatics].to_next_level>"
        - narrate ""
        - narrate "§aᚐᚐᚐᚑᚒᚓᚔᚍᚎᚏ §2§lSkills §aᚏᚎᚍᚔᚓᚒᚑᚐᚐᚐ"
        - narrate "§a§l» §7Roll"
        - narrate "§a§l» §7Smooth Recovery"
        - narrate ""
        - narrate "§2§oUse §a§o/ABILITYNAME §2§oto read about an ability, ex: §a§o/manadeposit§2§o."

alchemy_override:
    type: command
    name: alchemy
    description: Show the overview for the alchemy skill.
    usage: /alchemy
    script:
        - narrate "§aᚐᚑᚒᚓᚔᚍᚎᚏ §2§lAlchemy §aᚏᚎᚍᚔᚓᚒᚑᚐ"
        - narrate "§7Level §8- §6<player.mcmmo.level[alchemy]>"
        - narrate "§7Exp §8- §e<player.mcmmo.xp[alchemy]>§r / §6<player.mcmmo.xp[alchemy].to_next_level>"
        - narrate ""
        - narrate "§aᚐᚐᚐᚑᚒᚓᚔᚍᚎᚏ §2§lSkills §aᚏᚎᚍᚔᚓᚒᚑᚐᚐᚐ"
        - narrate "§a§l» §7Extra Recipes"
        - narrate ""
        - narrate "§2§oUse §a§o/ABILITYNAME §2§oto read about an ability, ex: §a§o/manadeposit§2§o."

repair_override:
    type: command
    name: repair
    description: Show the overview for the repair skill.
    usage: /repair
    script:
        - narrate "§aᚐᚑᚒᚓᚔᚍᚎᚏ §2§lRepair §aᚏᚎᚍᚔᚓᚒᚑᚐ"
        - narrate "§7Level §8- §6<player.mcmmo.level[repair]>"
        - narrate "§7Exp §8- §e<player.mcmmo.xp[repair]>§r / §6<player.mcmmo.xp[repair].to_next_level>"
        - narrate ""
        - narrate "You can repair items in Minecraft by Using the McMMO anvil (an iron block) and right-clicking it with the item you would like to repair in your hand. The higher the level, the more durability is restored. Every time you repair an item with the McMMO anvil, it consumes a singular amount of the material the item was made of (For example an iron chestplate would cost one iron ingot per click)."
        - narrate ""
        - narrate "§aᚐᚐᚐᚑᚒᚓᚔᚍᚎᚏ §2§lSkills §aᚏᚎᚍᚔᚓᚒᚑᚐᚐᚐ"
        - narrate "§a§l» §7Empowered Repair"
        - narrate "§a§l» §7Empowered Mending"
        - narrate ""
        - narrate "§2§oUse §a§o/ABILITYNAME §2§oto read about an ability, ex: §a§o/manadeposit§2§o."

salvage_override:
    type: command
    name: salvage
    description: Show the overview for the salvage sub-skill.
    usage: /salvage
    script:
        - narrate "§aᚐᚑᚒᚓᚔᚍᚎᚏ §2§lSalvage §aᚏᚎᚍᚔᚓᚒᚑᚐ"
        - narrate "§7Level §8- §6<player.mcmmo.level[salvage]>"
        - narrate "§7Exp §8- §e<player.mcmmo.xp[salvage]>§r / §6<player.mcmmo.xp[salvage].to_next_level>"
        - narrate ""
        - narrate "§aᚐᚐᚐᚑᚒᚓᚔᚍᚎᚏ §2§lSkills §aᚏᚎᚍᚔᚓᚒᚑᚐᚐᚐ"
        - narrate "§a§l» §7Coming Soon..."
        - narrate ""
        - narrate "§2§oUse §a§o/ABILITYNAME §2§oto read about an ability, ex: §a§o/manadeposit§2§o."

smelting_override:
    type: command
    name: smelting
    description: Show the overview for the smelting sub-skill.
    usage: /smelting
    script:
        - narrate "§aᚐᚑᚒᚓᚔᚍᚎᚏ §2§lSmelting §aᚏᚎᚍᚔᚓᚒᚑᚐ"
        - narrate "§7Level §8- §6<player.mcmmo.level[smelting]>"
        - narrate "§7Exp §8- §e<player.mcmmo.xp[smelting]>§r / §6<player.mcmmo.xp[smelting].to_next_level>"
        - narrate ""
        - narrate "§aᚐᚐᚐᚑᚒᚓᚔᚍᚎᚏ §2§lSkills §aᚏᚎᚍᚔᚓᚒᚑᚐᚐᚐ"
        - narrate "§a§l» §7Coming Soon..."
        - narrate ""
        - narrate "§2§oUse §a§o/ABILITYNAME §2§oto read about an ability, ex: §a§o/manadeposit§2§o."
        
empoweredblade_explanation:
    type: command
    name: empoweredblade
    description: Show the overview for empoweredblade.
    usage: /empoweredblade
    script:
        - choose <player.mcmmo.level[swords].div_int[100].round_down>:
            - case 0:
                - define empowered_rank 1
                - define damage 1
            - case 1:
                - define empowered_rank 2
                - define damage 1
            - case 2:
                - define empowered_rank 3
                - define damage 2
            - case 3:
                - define empowered_rank 4
                - define damage 2
            - case 4:
                - define empowered_rank 5
                - define damage 3
            - case 5:
                - define empowered_rank 6
                - define damage 3
            - case 6:
                - define empowered_rank 7
                - define damage 4
            - case 7:
                - define empowered_rank 8
                - define damage 4
            - case 8:
                - define empowered_rank 9
                - define damage 5
            - case 9:
                - define empowered_rank 9
                - define damage 5
            - default:
                - define empowered_rank 10
                - define damage 6
        - narrate "§aᚐᚑᚒᚓᚔᚍᚎᚏ §2§lEmpowered Blade §aᚏᚎᚍᚔᚓᚒᚑᚐ"
        - narrate "§rRight click with a sword to activate empowered blade, causing your attacks with swords to deal additional damage. The duration and damage increase with your swords level."
        - narrate "Duration: <[empowered_rank]> seconds"
        - narrate "Bonus Damage: <[bonus_damage]>"
        
parry_explanation:
    type: command
    name: parry
    description: Show the overview for parry.
    usage: /parry
    script:
        - narrate "§aᚐᚑᚒᚓᚔᚍᚎᚏ §2§lParry §aᚏᚎᚍᚔᚓᚒᚑᚐ"
        - narrate "§rWhen taking damage while holding a sword, you have a chance to take reduced damage. The chance increases with your swords level."
        - if <player.mcmmo.level[swords]> < 500:
            - narrate "Trigger Chance: 0%"
        - else if <player.mcmmo.level[swords]> > 1000:
            - narrate "Trigger Chance: 50%"
        - else:
            - narrate "Trigger Chance: <player.mcmmo.level[swords].sub_int[500].div_int[10]>%"
        
bleed_explanation:
    type: command
    name: bleed
    description: Show the overview for bleed.
    usage: /bleed
    script:
        - narrate "§aᚐᚑᚒᚓᚔᚍᚎᚏ §2§lBleed §aᚏᚎᚍᚔᚓᚒᚑᚐ"
        - narrate "§rYour sword attacks have a chance to apply a DOT to the enemy hit. The chance and the damage dealt increase with your swords level."
        - narrate "Trigger Chance: TBA"
        - narrate "Bonus Damage: TBA"
        
sharpclaws_explanation:
    type: command
    name: sharpclaws
    description: Show the overview for sharp claws.
    usage: /sharpclaws
    script:
        - narrate "§aᚐᚑᚒᚓᚔᚍᚎᚏ §2§lSharp Claws §aᚏᚎᚍᚔᚓᚒᚑᚐ"
        - narrate "§rYour dogs deal additional damage based on your taming level."
        - narrate "Bonus Damage: TBA"
        
thickhide_explanation:
    type: command
    name: thickhide
    description: Show the overview for thick hide.
    usage: /thickhide
    script:
        - narrate "§aᚐᚑᚒᚓᚔᚍᚎᚏ §2§lThick Hide §aᚏᚎᚍᚔᚓᚒᚑᚐ"
        - narrate "§r Your dogs take reduced damage based on your taming level."
        
criticalstrikes_explanation:
    type: command
    name: criticalstrikes
    description: Show the overview for critical strikes.
    usage: /criticalstrikes
    script:
        - narrate "§aᚐᚑᚒᚓᚔᚍᚎᚏ §2§lCritical Strikes §aᚏᚎᚍᚔᚓᚒᚑᚐ"
        - narrate "§rWhen your dogs deal damage, they have a chance to deal bonus damage. The chance and the bonus damage increase with your taming level."
        - narrate "Trigger Chance: TBA"
        - narrate "Bonus Damage: TBA"
        
roll_explanation:
    type: command
    name: roll
    description: Show the overview for roll.
    usage: /roll
    script:
        - narrate "§aᚐᚑᚒᚓᚔᚍᚎᚏ §2§lRoll §aᚏᚎᚍᚔᚓᚒᚑᚐ"
        - narrate "§rWhen taking fall damage, you have a chance to lower the damage taken. The chance increases with your acrobatics level."
        - if <player.mcmmo.level[acrobatics]> > 1000:
            - narrate "Trigger Chance: 100%"
        - else:
            - narrate "Trigger Chance: <player.mcmmo.level[acrobatics].div_int[10]>%"
        
smoothrecovery_explanation:
    type: command
    name: smoothrecovery
    description: Show the overview for smooth recovery.
    usage: /smoothrecovery
    script:
        - narrate "§aᚐᚑᚒᚓᚔᚍᚎᚏ §2§lSmooth Recovery §aᚏᚎᚍᚔᚓᚒᚑᚐ"
        - narrate "§rWhen taking fall damage, you have a chance to gain a sudden burst of speed. The chance increases with your acrobatics level."
        - if <player.mcmmo.level[acrobatics]> > 1000:
            - narrate "Trigger Chance: 100%"
        - else:
            - narrate "Trigger Chance: <player.mcmmo.level[acrobatics].div_int[10]>%"
        
superdigger_explanation:
    type: command
    name: superdigger
    description: Show the overview for super digger.
    usage: /superdigger
    script:
        - choose <player.mcmmo.level[excavation].div_int[50].round_down>:
            - case 0:
                - define duration 1
            - case 1:
                - define duration 2
            - case 2:
                - define duration 3
            - case 3:
                - define duration 4
            - case 4:
                - define duration 5
            - case 5:
                - define duration 6
            - case 6:
                - define duration 7
            - case 7:
                - define duration 8
            - case 8:
                - define duration 9
            - case 9:
                - define duration 10
            - case 10:
                - define duration 11
            - case 11:
                - define duration 12
            - case 12:
                - define duration 13
            - case 13:
                - define duration 14
            - case 14:
                - define duration 15
            - case 15:
                - define duration 16
            - case 16:
                - define duration 17
            - case 17:
                - define duration 18
            - case 18:
                - define duration 19
            - default:
                - define duration 20
        - narrate "§aᚐᚑᚒᚓᚔᚍᚎᚏ §2§lSuper Digger §aᚏᚎᚍᚔᚓᚒᚑᚐ"
        - narrate "§rRight click with a shovel to activate super digger, allowing you to dig in a 3x3 area for a short time. The duration increases with your excavation level."
        - narrate "Duration: <[duration]>"
        
manadeposit_explanation:
    type: command
    name: manadeposit
    description: Show the overview for mana deposit.
    usage: /manadeposit
    script:
        - narrate "§aᚐᚑᚒᚓᚔᚍᚎᚏ §2§lMana Deposit §aᚏᚎᚍᚔᚓᚒᚑᚐ"
        - narrate "§rWhen digging with a shovel, there is a chance to spawn xp orbs. The chance increases with excavation levels."
        - if <player.mcmmo.level[excavation]> > 1000:
            - narrate "Trigger Chance: 50%"
        - else:
            - narrate "Trigger Chance: <player.mcmmo.level[excavation].div_int[200]>%"
        
ignoredrops_explanation:
    type: command
    name: ignoredrops
    description: Show the overview for ignore drops.
    usage: /ignoredrops
    script:
        - define mining <player.mcmmo.level[mining].sub_int[100].div_int[100].round_down>
        - define excavation <player.mcmmo.level[excavation].sub_int[100].div_int[100].round_down>
        - if <player.mcmmo.level[mining]> > 1000:
            - define mining 9
        - if <player.mcmmo.level[excavation]> > 1000:
            - define excavation 9
        - narrate "§aᚐᚑᚒᚓᚔᚍᚎᚏ §2§lIgnore Drops §aᚏᚎᚍᚔᚓᚒᚑᚐ"
        - narrate "§rBy using the command /igui, open a GUI where you can select items that you do not want to be able to pick up. The amount of items you can ignore increases with your mining and excavation levels."
        - narrate "Max Items Ignored: <[mining].add_int[[excavation]]>"
        
bountifulharvest_explanation:
    type: command
    name: bountifulharvest
    description: Show the overview for bountiful harvest.
    usage: /bountifulharvest
    script:
        - narrate "§aᚐᚑᚒᚓᚔᚍᚎᚏ §2§lBountiful Harvest §aᚏᚎᚍᚔᚓᚒᚑᚐ"
        - narrate "§rWhen harvesting crops, there is a chance to gain additional yields from the crop. The chance increases with level."
        - if <player.mcmmo.level[herbalism]> > 1000:
            - narrate "Trigger Chance: 100%"
        - else:
            - narrate "Trigger Chance: <player.mcmmo.level[herbalism].div_int[10]>%"
        
autoreplant_explanation:
    type: command
    name: autoreplant
    description: Show the overview for auto replant.
    usage: /autoreplant
    script:
        - narrate "§aᚐᚑᚒᚓᚔᚍᚎᚏ §2§lAuto Replant §aᚏᚎᚍᚔᚓᚒᚑᚐ"
        - narrate "§rWhen harvesting crops, there is a chance to automatically plant an appropriate seed. The chance increases with herbalism level."
        - if <player.mcmmo.level[herbalism]> > 1000:
            - narrate "Trigger Chance: 100%"
        - else:
            - narrate "Trigger Chance: <player.mcmmo.level[herbalism].div_int[10]>%"
        
doublebreed_explanation:
    type: command
    name: doublebreed
    description: Show the overview for double breed.
    usage: /doublebreed
    script:
        - narrate "§aᚐᚑᚒᚓᚔᚍᚎᚏ §2§lDouble Breed §aᚏᚎᚍᚔᚓᚒᚑᚐ"
        - narrate "§rWhen breeding animals, there is a chance to spawn an additional copy of the child. The chance increases with herbalism level."
        - if <player.mcmmo.level[herbalism]> > 1000:
            - narrate "Trigger Chance: 100%"
        - else:
            - narrate "Trigger Chance: <player.mcmmo.level[herbalism].div_int[10]>%"
        
berserk_explanation:
    type: command
    name: berserk
    description: Show the overview for berserk.
    usage: /berserk
    script:
        - define damage <player.mcmmo.level[unarmed].div_int[250].round_down.add_int[1]>
        - define duration <player.mcmmo.level[unarmed].div_int[200].round_down.add_int[1]>
        - if <player.mcmmo.level[unarmed]> > 1000:
            - define damage 5
            - define duration 6
        - narrate "§aᚐᚑᚒᚓᚔᚍᚎᚏ §2§lBerserk §aᚏᚎᚍᚔᚓᚒᚑᚐ"
        - narrate "§rRight click with an empty hand to temporarily increase the damage you deal with unarmed attacks. Duration and damage increase with unarmed level."
        - narrate "Duration: <[duration]>s"
        - narrate "Bonus Damage: <[damage]>"
        
ironfist_explanation:
    type: command
    name: ironfist
    description: Show the overview for iron fist.
    usage: /ironfist
    script:
        - narrate "§aᚐᚑᚒᚓᚔᚍᚎᚏ §2§lIron Fist §aᚏᚎᚍᚔᚓᚒᚑᚐ"
        - narrate "§rWhen attacking with an empty hand, deal bonus damage based on your unarmed level."
        - narrate "Bonus Damage: TBA"
        
deflect_explanation:
    type: command
    name: deflect
    description: Show the overview for deflect.
    usage: /deflect
    script:
        - narrate "§aᚐᚑᚒᚓᚔᚍᚎᚏ §2§lDeflect §aᚏᚎᚍᚔᚓᚒᚑᚐ"
        - narrate "§rWhen struck by an arrow, you have a chance to deflect it, knocking it to the ground beside you. The chance increases with your unarmed level."
        - narrate "Trigger Chance: TBA"
        
treefeller_explanation:
    type: command
    name: treefeller
    description: Show the overview for treefeller.
    usage: /treefeller
    script:
        - define duration <player.mcmmo.level[woodcutting].div_int[50].round_down.add_int[1]>
        - if <player.mcmmo.level[woodcutting]> > 1000:
            - define duration 20
        - narrate "§aᚐᚑᚒᚓᚔᚍᚎᚏ §2§lTree Feller §aᚏᚎᚍᚔᚓᚒᚑᚐ"
        - narrate "§rRight click with an axe to activate tree feller, allowing you to chop down entire trees by breaking their base. Does not break leaves, branches, or 2x2 trees."
        - narrate "Duration: <[duration]>s"
        
autoplant_explanation:
    type: command
    name: autoplant
    description: Show the overview for auto plant.
    usage: /autoplant
    script:
        - narrate "§aᚐᚑᚒᚓᚔᚍᚎᚏ §2§lAuto Plant §aᚏᚎᚍᚔᚓᚒᚑᚐ"
        - narrate "§rWhen chopping a tree with tree feller, there is a chance to plant an appropriate sapling at the tree's location. The chance increases wtih woodcutting level."
        - if <player.mcmmo.level[woodcutting]> > 1000:
            - narrate "Trigger Chance: 100%"
        - else:
            - narrate "Trigger Chance: <player.mcmmo.level[woodcutting].div_int[10]>%"
        
leafblower_explanation:
    type: command
    name: leafblower
    description: Show the overview for leaf blower.
    usage: /leafblower
    script:
        - narrate "§aᚐᚑᚒᚓᚔᚍᚎᚏ §2§lLeaf Blower §aᚏᚎᚍᚔᚓᚒᚑᚐ"
        - narrate "§rAfter reaching level 100 in woodcutting, instantly break leaves by left clicking them with an axe."
        
superbreaker_explanation:
    type: command
    name: superbreaker
    description: Show the overview for super breaker.
    usage: /superbreaker
    script:
        - choose <player.mcmmo.level[mining].div_int[50].round_down>:
            - case 0:
                - define duration 1
            - case 1:
                - define duration 2
            - case 2:
                - define duration 3
            - case 3:
                - define duration 4
            - case 4:
                - define duration 5
            - case 5:
                - define duration 6
            - case 6:
                - define duration 7
            - case 7:
                - define duration 8
            - case 8:
                - define duration 9
            - case 9:
                - define duration 10
            - case 10:
                - define duration 11
            - case 11:
                - define duration 12
            - case 12:
                - define duration 13
            - case 13:
                - define duration 14
            - case 14:
                - define duration 15
            - case 15:
                - define duration 16
            - case 16:
                - define duration 17
            - case 17:
                - define duration 18
            - case 18:
                - define duration 19
            - default:
                - define duration 20
        - narrate "§aᚐᚑᚒᚓᚔᚍᚎᚏ §2§lSuper Breaker §aᚏᚎᚍᚔᚓᚒᚑᚐ"
        - narrate "§rRight click with a pickaxe to activate super breaker, allowing you to break blocks in a 3x3 area for a short time. The duration increases with mining level."
        - narrate "Duration: <[duration]>"
        
autosmelt_explanation:
    type: command
    name: autosmelt
    description: Show the overview for auto smelt.
    usage: /autosmelt
    script:
        - narrate "§aᚐᚑᚒᚓᚔᚍᚎᚏ §2§lAuto Smelt §aᚏᚎᚍᚔᚓᚒᚑᚐ"
        - narrate "§rWhen mining iron and gold ore, there is a chance to immediately smelt it into an ingot. The chance increases with your mining level."
        - if <player.mcmmo.level[mining]> > 1000:
            - narrate "Trigger Chance: 100%"
        - else:
            - narrate "Trigger Chance: <player.mcmmo.level[mining].div_int[10]>%"
        
multishot_explanation:
    type: command
    name: multishot
    description: Show the overview for multishot.
    usage: /multishot
    script:
        - narrate "§aᚐᚑᚒᚓᚔᚍᚎᚏ §2§lMultishot §aᚏᚎᚍᚔᚓᚒᚑᚐ"
        - narrate "§rWhen shooting with a bow, you have a chance to fire an additional arrow at the target. The chance increases with your archery level."
        - if <player.mcmmo.level[archery]> > 1000:
            - narrate "Trigger Chance: 33%"
        - else:
            - narrate "Trigger Chance: <player.mcmmo.level[archery].div_int[30]>%"
        
arrowefficiency_explanation:
    type: command
    name: arrowefficiency
    description: Show the overview for arrow efficiency.
    usage: /arrowefficiency
    script:
        - narrate "§aᚐᚑᚒᚓᚔᚍᚎᚏ §2§lArrow Efficiency §aᚏᚎᚍᚔᚓᚒᚑᚐ"
        - narrate "§rWhen shooting a bow, you have a chance to not consume an arrow. The chance increases with your archery level."
        - narrate "Trigger Chance: TBA"
        
whirlwind_explanation:
    type: command
    name: whirlwind
    description: Show the overview for whirlwind.
    usage: /whirlwind
    script:
        - narrate "§aᚐᚑᚒᚓᚔᚍᚎᚏ §2§lWhirlwind §aᚏᚎᚍᚔᚓᚒᚑᚐ"
        - narrate "§rRight click while crouching with an axe to deal damage to enemies around you. The cooldown reduces as you advance in axes levels."
        - narrate "Damage is based off the axe used (not including enchantments)."
        - narrate "Cooldown: TBA"
        
greaterimpact_explanation:
    type: command
    name: greaterimpact
    description: Show the overview for greater impact.
    usage: /greaterimpact
    script:
        - narrate "§aᚐᚑᚒᚓᚔᚍᚎᚏ §2§lGreater Impact §aᚏᚎᚍᚔᚓᚒᚑᚐ"
        - narrate "§rDeal increased damage when attacking with an axe, increasing with axes level."
        - narrate "Bonus Damage: TBA"
        
criticalimpact_explanation:
    type: command
    name: criticalimpact
    description: Show the overview for critical impact.
    usage: /criticalimpact
    script:
        - narrate "§aᚐᚑᚒᚓᚔᚍᚎᚏ §2§lCritical Impact §aᚏᚎᚍᚔᚓᚒᚑᚐ"
        - narrate "§rWhen attacking with an axe, there is a chance to deal bonus damage. Both the chance and the damage increase with axes level."
        - narrate "Critical Strike: TBA"
        - narrate "Bonus Damage: TBA"
        
empoweredrepair_explanation:
    type: command
    name: empoweredrepair
    description: Show the overview for empowered repair.
    usage: /empoweredrepair
    script:
        - narrate "§aᚐᚑᚒᚓᚔᚍᚎᚏ §2§lEmpowered Repair §aᚏᚎᚍᚔᚓᚒᚑᚐ"
        - narrate "§rWhen using an anvil, get a discount on the xp requirement. This discount increases with your repair level."
        - narrate "Current Discount: TBA"
        
empoweredmending_explanation:
    type: command
    name: empoweredmending
    description: Show the overview for empowered mending.
    usage: /empoweredmending
    script:
        - narrate "§aᚐᚑᚒᚓᚔᚍᚎᚏ §2§lEmpowered Mending §aᚏᚎᚍᚔᚓᚒᚑᚐ"
        - narrate "§rWhen your items gain durability from the mending enchantment, there is a chance to gain extra durability."
        - if <player.mcmmo.level[repair]> > 1000:
            - narrate "Currenct Chance: 100%"
        - else:
        - narrate "Current Chance: <player.mcmmo.level[repair].div_int[10]>%"
        
treasurefishing_explanation:
    type: command
    name: treasurefishing
    description: Show the overview for treasure fishing.
    usage: /treasurefishing
    script:
        - narrate "§aᚐᚑᚒᚓᚔᚍᚎᚏ §2§lTreasure Fishing §aᚏᚎᚍᚔᚓᚒᚑᚐ"
        - narrate "§rWhen fishing, there is a chance to get rare items instead of fish. The quality of items increases with your fishing level."
        
autoreeling_explanation:
    type: command
    name: autoreeling
    description: Show the overview for automatic reeling.
    usage: /autoreeling
    script:
        - narrate "§aᚐᚑᚒᚓᚔᚍᚎᚏ §2§lAuto Reeling §aᚏᚎᚍᚔᚓᚒᚑᚐ"
        - narrate "§rWhen fishing, there is a chance to have your hook automatically reel in when a fish is on the line. This chance increases with your fishing level."
        - if <player.mcmmo.level[fishing]> > 1000:
            - narrate "Currenct Chance: 100%"
        - else:
            - narrate "Current Chance: <player.mcmmo.level[fishing].div_int[10]>%"
        
extrarecipes_explanation:
    type: command
    name: extrarecipes
    description: Show the overview for extra recipes.
    usage: /extrarecipes
    script:
        - narrate "§aᚐᚑᚒᚓᚔᚍᚎᚏ §2§lExtra Recipes §aᚏᚎᚍᚔᚓᚒᚑᚐ"
        - narrate "§rAs you gain levels in alchemy unlock new potions."