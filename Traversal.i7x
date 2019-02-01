Traversal by B David Paulsen begins here. 

"Subdivides the room into nodes between which actors may traverse."

[With thanks to Stephen Grant and the good folks over on the Inform7 Discord channel, for their invaluable feedback and testing.]

Volume - Traversal

Book - Defining the landmark kind

A landmark is a kind of thing. A landmark is usually scenery. A landmark is usually privately-named.

The specification of landmark is "Represents a subdivision of its room. An actor can either occupy one landmark
or none. When traversing between landmarks or the absence of a landmark, characters generate report messages
and the opportunity for the author to interrupt their travel using rules."

Part - Implication

A thing can be instantiated-by-proximity. A thing is usually instantiated-by-proximity.

When play begins (this is the ensure things declared near are also locationally present rule): 
	repeat with item running through off-stage things:
		if the item is near a landmark (called the spot):
			if the item is instantiated-by-proximity, now the item is in the holder of the spot.

Book - Traversing

Proximity relates various things to each other in groups. The verb to be near means the proximity relation. 
Definition: a thing is solitary if it is not near something which is not it.
To walk is a verb.

Traversing to is an action applying to one thing.
The traversing to action has an object called the starting-point (matched as "from"). 

Setting action variables for traversing to: 
	if the actor is near a landmark (called origin):
		now the starting-point is the origin. 

Report someone who is near the player traversing to something which is not near the player (this is the report other person going away rule):
	say "[The actor] [walk] away from [us] toward [the noun]." (A).

Report someone traversing to something near the player (this is the report other person approaching rule):
	if the starting-point is a landmark, say "[The actor] [walk] towards [us] from [the starting-point]." (A);
	otherwise say "[The actor] [walk] towards [us]." (B).

Report player traversing to something  (this is the general report player traversing rule):
	say "[We] [walk] over to [the noun]." (A).

Report someone traversing to when the actor is not near the starting-point and the noun is not the player and the noun is not near the player (this is the general report non-player actor traversing rule):
	say "[The actor] [walk] over to [the noun]." (A).

Report an actor traversing to a room when the actor is near a landmark (called the place) (this is the report room-to-room traversal rule):
	say "[The actor] [walk] away from [the place]." (A).

Carry out an actor traversing to something which is near a landmark (called the place) when the actor is not near the place (this is the move closer to thing relocation rule):
	relocate the actor to the place.

Carry out an actor traversing to a landmark when the actor is not near the noun (this is the move closer to landmark relocation rule):
	relocate the actor to the noun.

Carry out an actor traversing to a solitary thing when the actor is near something which is not the actor (this is the leave landmark behind rule):
	relocate the actor to nothing.
	
To decide whether traversal of (actor - a person) with (the item - a thing) didn't succeed:
	if the actor is near nothing and the item is near nothing, decide no;
	let true target be item;
	if the item is near a landmark (called the place), let true target be place;
	if the actor is near the true target, decide no; [To stop the actor from trying to approach what they are already near.]
	if the actor is solitary and the true target is solitary, decide no; [To stop traversal if the actor and the target are both unbound to a landmark.]
	try the actor traversing to the true target;
	if the actor is near the true target, decide no;
	if the true target is near the true target and the true target is not a landmark, decide no; [This occurs when the noun isn't near any landmark at all.]
	yes.

This is the failed to traverse rule:
	[say "Failed traversal; action stops.";]
	stop the action.

Book - Updating the world-state

After actor entering something (called item) which is near a landmark (this is the update actor nearness rule):
	now the actor is near the item;
	continue the action.

When play begins (this is the ensure enclosed items are proximate rule):
	repeat with item running through things that enclose something:
		now everything enclosed by the item is near the item.

To relocate (item - a thing) to (spot - an object):
	now the item is near nothing;
	if the spot is a thing, now the item is near the spot;
	repeat with stuff running through things enclosed by the item:
		relocate the stuff to the spot.

Book - Actions affected by traversal

Going or opening or closing or pulling or eating or pushing or kissing or touching or taking or entering or searching or attacking or putting on or inserting is implicitly moving. 

Before an actor going through a door near a landmark (called the path) when the path is in the location of the actor (this is the block-if-impassable rule):
	if the traversal of the actor with the path didn't succeed, abide by the failed to traverse rule.

Before an actor going when the actor is not solitary (this is the redirect traversal to location rule):
	if the door gone through is a solitary thing or the door gone through is nothing:
		try the actor traversing to the location.

After an actor going through a door near a landmark (called the path) when the path is in the location of the actor (this is the relocate actor after passing through door rule):
	try silently the actor traversing to the path;
	continue the action.

After an actor going when the door gone through is not near a landmark or the door gone through is nothing (this is the uncouple actor post-going rule):
	relocate the actor to nothing;
	continue the action.

Before an actor implicitly moving (this is the general pre-empt actions to perform traversal rule):
	if the noun is not a thing, make no decision;
	if the traversal of the actor with the noun didn't succeed, abide by the failed to traverse rule;
	if the second noun is not nothing:
		if the traversal of the actor with the second noun didn't succeed, abide by the failed to traverse rule.

Last carry out an actor throwing something which is not held by the actor at (this is the place item near target after presumably successful throw rule):
	relocate the noun to the second noun.


Traversal ends here.

---- DOCUMENTATION ----

This extension introduces the idea of traversal (which is implicit actions conveying actors between different spots in the room before doing something. Traversal should still be considered to be in its alpha status (version 0.2).

The central concept here is the existence of a "landmark". Anything that is labeled a landmark becomes a spatial node within the room. The intent is for each landmark to be immobile and present only in a given room, and therefore, the extension strongly discourages things that are portable (such as people) or span multiple rooms (such as backdrops) from being landmarks. Scope hacking may be able to circumvent this, and so should be used with care.

If nothing else is specified, a landmark will be created with no attached Understand tokens. The original concept of landmarks does not imply direct contact or manipulation of landmarks, and a story that relaxes these constraints would need additional rules to gracefully handle physical interaction. 

When the extension is active, persons implicitly use the "traversal" action for moving between points. If the traversal action is suppressed, the traversal itself halts, and the attempted action fails. The "failed to traverse rule" opts to do this silently, but can be easily swapped out for a more descriptive error message. 

Example: *  Only the Penitent Man  - A simple demonstration of a linear partitioned room.

	*: "Only the Penitent Man" 

	Include Traversal by B David Paulsen.

	The Ominous Hallway is a room. "You are standing in an ominous hallway, in the shadow of the [random landmark near the player][if the player is near the entrance]. Dust and cobwebs bar your path to the stairs[end if]." The printed name of the Ominous Hallway is "Ominous Hallway (near [the random landmark near the player])".

	The entrance is a landmark. The entrance is in the Ominous Hallway. The player is near the entrance.
	a thicker section of the cobwebs is a not privately-named scenery landmark in the Ominous Hallway. Understand "dust" as a thicker section of the cobwebs.
	The area by the stairwell is a landmark. It is in the Ominous Hallway.
	The stairs are a scenery enterable supporter in the Ominous Hallway. It is near the area by the stairwell. Before printing the name of the stairs when the player is not near the stairs, say "faraway ".
	A torch is on the stairs. The torch is lit. The printed name of the torch is "single, sputtering torch".

	Check traversing to the area by the stairwell from the entrance:
		try traversing to the thicker section of the cobwebs;
		say "Something is wrong. You hear your father's voice on your own lips. '[italic type]Only the penitent man will pass...'[roman type][line break]" instead.

	Penitence is a scene. Penitence begins when the player is near a thicker section of the cobwebs.

	Every turn during Penitence, say "[one of]The cobwebs before you flutter in an unseen breeze. [or]The cobwebs seem to bend and billow, almost as if they're rippling toward you. [or]The cobwebs part faster and faster, and there is a dreadful swooshing sound...- [stopping] [line break]".

	Instead of traversing to something near the stairs when Penitence is happening:
		say "...but you're pretty sure it's just theatrics, right? What's the worst that could happen? Just press on.[paragraph break]";
		say the end message.

	Penitence ends gorily when the player is standing and time since Penitence began is 3 minutes.
	When penitence ends gorily, say the end message.
	To say the end message:
		say "With a noise not unlike that of a butcher's cleaver, a heavy bronze blade sweeps through the cobwebs and then yourself. You fall to the ground, literally beside yourself.";
		end the story.

	A person can be standing. A person is usually standing.
	Dodging is an action applying to nothing.
	Understand the command "kneel" as "sit".
	Understand "kneel down/--" or "dodge" or "duck" as dodging.

	Check dodging when Penitence is not happening: say "You don't see any immediate threat." instead.
	Carry out dodging: now the player is not standing.
	After player dodging during penitence: say "You throw yourself to the ground in the nick of time!"

	Penitence ends triumphantly when the player is not standing.
	When penitence ends triumphantly:
		say "With a noise not unlike that of a butcher's cleaver, a heavy bronze blade passes through the cobwebs and above your head! Heart pounding, you get to your feet.";
		now the player is standing.

	After traversing to the something near the stairs, say "Shaken, you move toward the stairs."
	After taking the torch, say "You take the torch in a trembling hand."

	Every turn when the player is near the stairs:
		say "As you pause on the stairs, your nerves still tingle. But you must press on, despite your misgivings. You shiver despite yourself. Who knew Bavarian farmers could be so protective of their secrets?";
		end the story saying "You won!".

	The player holds the stone.

	The futile to throw things at inanimate objects rule does nothing.
	The block throwing at rule does nothing.

	Test me with "take torch/examine torch/kneel/take torch".
	Test death with "touch torch/touch torch".
	Test death2 with "touch torch/wait/wait".

In the real world, we would naturally assume that something declared "near" another thing would be in the same room. Inform uses the "ensure things declared near are also locationally present rule" to infer this at beginning of the game. Any facility that moves the actor to another place would require a similar routine. 

The extension also attempts to handle knock-on effects sensibly. Dropped things should be near the person dropping them, going through doors should mean the actor is no longer near things on its opposite side, and when traversal halts, the actor should be locationally near the landmark where that happened. The action of throwing things at other things is insidious in that manner: the "place item near target after presumably successful throw rule" is constructed to only fire if the throwing it at action is at least minimally implemented.
