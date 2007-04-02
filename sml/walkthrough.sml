datatype item = Item of string
datatype character = Char of string

datatype action =
		Use of item * item|
		Use1 of item |
		Pickup of item|
		TalkTo of character|
		Open of item|
		Close of item|
		Give of item * character|
		Pull of item



(*Items from worldofmi-walkthrough *)
val book = Item "Big Whoop: Unclaimed Bonanza or Myth";
val pins = Item "pins";
val voodoo_doll = Item "voodoo doll";
val bone = Item "bone";
val box = Item "box";
val rat = Item "rat";
val bra = Item "pearly-white bra";
val ticket = Item "laundry claim ticket"; 
val stick = Item "stick";
val spit = Item "spit"; 
val string = Item "string"; 
val bucket_mud = Item "bucket o' mud"; 
val toupee = Item "toupee";
val cheese_squigglies = Item "Cheese Squigglies"; 
val bucket = Item "bucket"; 
val knife = Item "knife";
val paper = Item "piece of paper"; 
val monocle = Item "monocle"; 
val money = Item "money"; (*not used*)
val shovel = Item "shovel"

(*Items added by SS to make this thing fly *)
val swamp = Item "swamp"
val grave = Item "Marco Largo LaGrande's grave"
val vichyssoise  = Item "vichyssoise"
val door  = Item "door"(*in Largos room*)
val rope  = Item "rope"(*for aligator*)
val coffin  = Item "coffin"(*floating in swamp*)
val spit_on_paper  = Item "spit_on_paper"(*Largo's spit on paper*)

(*characters mentioned in walkthrough that are not used, is given _ as name*)
val dread = Char "Captain Dread"; 
val _ = Char "LeChuck"; 
val _ = Char "cook";
val mad_marty = Char "Mad Marty";
val _ = Char "Marco Largo LaGrande's";
val voodoo_lady = Char "voodoo lady";
val _ = Char "innkeeper";
val _ = Char "Pegbiter";
val _ = Char "alligator";
val _ = Char "wood smith";
val men_of = Char "Men of Low Moral Fiber";
val bartender = Char "bartender";
val wally = Char "Wally";
val _ = Char "Guybrush";
val _ = Char "Largo"
		
val walkthrough =
[
(*location: outside Woodtick*)
Pickup shovel,

(*location: Wallys boat*)
TalkTo wally,(*i dont think u need to*)
Pickup monocle,
Pickup paper,

(*location: Bloddy Lip*)
TalkTo bartender(*about Largo*),
Use (paper, spit),
(*side-effect: Get "spit_on_paper"*)

(*location: Bloddy Lip kitchen*)
Pickup knife,

(*location: laundry*)
TalkTo men_of(*ask for money*),
Pickup bucket(*men will interrupt*),
TalkTo men_of(*ask for bucket*),
(*side-effect: Get bucket*)

(*location: hotel*)
Use(knife, rope),
Pickup cheese_squigglies(*strickly speaking we pickup the bowl*),

(*location: Largos room, one has to open the door to enter*)
Pickup toupee,

(*location: swamp*)
Use(bucket,swamp),
(*side-effect: Get "bucket o' mud"*)
Use1(coffin),

(*location: voodoo ladys house*)
Pickup string,
TalkTo voodoo_lady(*about voodoo doll of Largo, this has no side/effect*),
Give(toupee,voodoo_lady),
Give(spit_on_paper,voodoo_lady),

(*location: beach*)
Pickup stick,

(*location: cemetary*)
Use(shovel, grave),
(*side-effect: Get bone*)

(*location: largos room*)
Close door,
Use(bucket_mud, door),

(*location: laundry*)
(*NOTE: this has the side-effect that a laundry ticket appears in Largo's room*)

(*location: largos room*)
Close door,
Pickup ticket,

(*location: laundry*)
Give(ticket,mad_marty),
(*side-effect: Get "pearly-white bra"*)
Open box,
Use (stick,box),
Use (string,stick),(*NOTE: the order of usage is interessting *)
Use (cheese_squigglies,box),
(*Wait for rat in box, how do we model this*)
Pull string,

(*location: Bloddy Lip kitchen*)
Use(rat,vichyssoise),(*put rather than "use"*)

(*location: Bloddy Lip *)
TalkTo bartender,(*ask for stew*)
(*background:bartender discovers rat fires cook, offers job*)
TalkTo bartender,(*take job*)

(*location: voodoo ladys house *)
Give (bra,voodoo_lady),
Give (bone,voodoo_lady),
(*side-effect: Get "voodoo_doll"*)

(*location: Largos room *)
Use (pins, voodoo_doll),
(*location: voodoo ladys house, guybrush goes here automatically*)
(*side-effect: Get "book"*)

(*location: Dreads boat *)
TalkTo dread,(*about chartering his ship*)
Give (monocle, dread),
TalkTo dread(*about chartering his ship*)
]


(*
How do we model that:
Guybrush should talk about specific things
Some talk sessions are not initiated by Guybrush
Is there a difference between in-game items and items in inventory?
 - eg does it make sence to pull something in the inventory
*)

datatype location_def = Location of string
datatype location_actions = LocationActions of  * action list
val Location = (fn(name,list) => Location name)
val woodtick = Location ("Woodtick")
val wallys_boat = Location ("Wallys boat")
val bloddy_lip = Location ("Bloddy lip",[])
val bloddy_lip_kitchen = Location ("Bloddy lip kitchen",[])
val laundry = Location ("Laundry boat",[])
val hotel = Location ("Hotel",[])
val largos_room = Location ("Largos room",[])
val swamp = Location ("Swamp",[])
val voodoo_ladys_house = Location ("Voodoo ladys house",[string])
val beach = Location ("Beach",[stick])
val cemetery = Location ("cemetery",[])
val largos_room = Location ("Largo's room",[toupee])
val dreads_boat = Location ("Dreads boat",[])

val world =
    [
     (woodtick,[shovel]),
     (wallys_boat,[paper,monocle]),
     (bloddy_lip,[]),
     (bloddy_lip_kitchen,[]),
     (laundry,[])
     ]

val walkthrough2 =
[
LocationActions(woodtick,
[Pickup shovel]),

LocationActions(wallys_boat,
[TalkTo wally,(*i dont think u need to*)
Pickup monocle,
Pickup paper]),

LocationActions(bloddy_lip,
[TalkTo bartender(*about Largo*),
Use (paper, spit)]),
(*side-effect: Get "spit_on_paper"*)

LocationActions(bloddy_lip_kitchen,
[Pickup knife]),

LocationActions(laundry,
[TalkTo men_of(*ask for money*),
Pickup bucket(*men will interrupt*),
TalkTo men_of(*ask for bucket*)]),
(*side-effect: Get bucket*)

LocationActions(hotel,
[Use(knife, rope),
Pickup cheese_squigglies(*strickly speaking we pickup the bowl*)]),

LocationActions(largos_room,(*one has to open the door to enter*)
[Pickup toupee]),

LocationActions(swamp,
[Use(bucket,swamp),
(*side-effect: Get "bucket o' mud"*)
Use1(coffin)]),

LocationActions(voodoo_ladys_house,
[Pickup string,
TalkTo voodoo_lady(*about voodoo doll of Largo, this has no side-effect*),
Give(toupee,voodoo_lady),
Give(spit_on_paper,voodoo_lady)]),

LocationActions(beach,
[Pickup stick]),

LocationActions(cemetary,
[Use(shovel, grave)]),
(*side-effect: Get bone*)

LocationActions(largos_room,
[Close door,
Use(bucket_mud, door)]),

LocationActions(laundry,[]),
(*NOTE: this has the side-effect that a laundry ticket appears in Largo's room*)
(*location: largos room*)
LocationActions(largos_room,
[Close door,
Pickup ticket]),

LocationActions(laundry,
[Give(ticket,mad_marty),
(*side-effect: Get "pearly-white bra"*)
Open box,
Use (stick,box),
Use (string,stick),(*NOTE: the order of usage is interessting *)
Use (cheese_squigglies,box),
(*Wait for rat in box, how do we model this*)
Pull string]),

LocationActions(bloddy_lip_kitchen,
[Use(rat,vichyssoise)]),(*put rather than "use"*)

LocationActions(bloddy_lip,
[TalkTo bartender,(*ask for stew*)
(*background:bartender discovers rat fires cook, offers job*)
TalkTo bartender]),(*take job*)

LocationActions(voodoo_ladys_house,
[Give (bra,voodoo_lady),
Give (bone,voodoo_lady)]),
(*side-effect: Get "voodoo_doll"*)

LocationActions(largos_room,
[Use (pins, voodoo_doll)]),
(*location: voodoo ladys house, guybrush goes here automatically*)
(*side-effect: Get "book"*)

LocationActions(dreads_boat,
[TalkTo dread,(*about chartering his ship*)
Give (monocle, dread),
TalkTo dread(*about chartering his ship*)])
]
