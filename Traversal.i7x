Version 1 of Traversal by B David Paulsen begins here.

"Subdivides the room into nodes that actors are able to traverse."

Volume - Traversal

Book - Defining the landmark kind

A landmark is a kind of scenery privately-named thing.

Part - Implication

A thing can be instantiated-by-proximity. A thing is usually instantiated-by-proximity.

When play begins (this is the ensure things declared near are also locationally present rule): 
	repeat with item running through off-stage things:
		if the item is near a landmark (called the spot):
			if the item is instantiated-by-proximity, now the item is in the holder of the spot.

Book - Traversing

Proximity relates various things to each other in groups. The verb to be near means the proximity relation. 
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

Report player traversing to something (this is the general report player traversing rule):
	say "[We] [walk] over to [the noun]." (A).

Report someone traversing to when the actor is not near the starting-point and the noun is not the player and the noun is not near the player (this is the general report non-player actor traversing rule):
	say "[The actor] [walk] over to [the noun]." (A).

Check an actor traversing to when the noun is near a landmark (called the place) (this is the move away from landmark relocation rule):
	now the noun is near the place.

Carry out an actor traversing to something which is near a landmark (called the place) when the actor is not near the place (this is the move closer to thing relocation rule):
	relocate the actor to the place.

Carry out an actor traversing to a landmark when the actor is not near the noun (this is the move closer to landmark relocation rule):
	relocate the actor to the noun.

Carry out an actor traversing to a thing which is near nothing when the actor is near something (this is the leave landmark behind rule):
	now the actor is near nothing.
	
To decide whether traversal of (actor - a person) with (the item - a thing) didn't succeed:
	if the actor is near nothing and the item is near nothing, decide no;
	let true target be item;
	if the item is near a landmark (called the place), let true target be place;
	if the actor is near the true target, decide no; [To stop the actor from trying to approach what they are already near.]
	try the actor traversing to the true target;
	if the actor is near the true target, decide no;
	if the true target is near the true target and the true target is not a landmark, decide no; [This occurs when the noun isn't near any landmark at all.]
	yes.

This is the failed to traverse rule:
	stop the action.

Book - Updating the world-state

After actor entering something (called item) which is near a landmark (this is the update actor nearness rule):
	now the actor is near the item;
	continue the action.

When play begins (this is the ensure enclosed items are proximate rule):
	repeat with item running through containers:
		now everything in the item is near the item;
	repeat with item running through supporters:
		now everything on the item is near the item;
	repeat with item running through things which incorporate something:
		now everything part of the item is near the item.

To relocate (item - a thing) to (spot - a thing):
	now the item is near nothing;
	now the item is near the spot;
	repeat with stuff running through things enclosed by the item:
		relocate the stuff to the spot.

Book - Actions affected by traversal
	
Going or opening or closing or pulling or eating or pushing or kissing or touching or taking or entering or searching or attacking or putting on or inserting is implicitly moving. 

Before an actor going through something near a landmark (called the path):
	if the traversal of the actor with the path didn't succeed, abide by the failed to traverse rule.

Before an actor implicitly moving (this is the general pre-empt actions to perform traversal rule):
	if the noun is not a thing, make no decision;
	if the traversal of the actor with the noun didn't succeed, abide by the failed to traverse rule;
	if the second noun is not nothing:
		if the traversal of the actor with the second noun didn't succeed, abide by the failed to traverse rule.



Traversal ends here.

---- DOCUMENTATION ----

This extension introduces the idea of traversal (which is implicit actions conveying actors between different spots in the room before doing something. 

The central concept here is the existence of a "landmark". Anything that is labeled a landmark becomes a spatial node within the room. The intent is for each landmark to be immobile and present only in a given room, and therefore, the extension strongly discourages things that are portable (such as people) or span multiple rooms (such as backdrops) from being landmarks. Scope hacking may be able to circumvent this, and so should be used with care.

When the extension is active, persons implicitly use the "traversal" action for moving between points. If the traversal action is suppressed, the traversal itself halts, and the attempted action fails. The "failed to traverse rule" opts to do this silently, but can be easily swapped out for a more descriptive error message. 

Example: *  Only the Penitent Man  - A simple demonstration of a linear partitioned room.

	*: "Only the Penitent Man" 

	Include Traversal by B David Paulsen.
	
	The Ominous Hallway is a room. "You are standing in an ominous hallway, in the shadow of the [random landmark near the player][if the player is near the entrance]. Dust and cobwebs bar your path to the stairs[end if]." The printed name of the Ominous Hallway is "Ominous Hallway (near [the random landmark near the player])".

	The entrance is a landmark. The entrance is in the Ominous Hallway. The player is near the entrance.
	a thicker section of the cobwebs is a scenery landmark in the Ominous Hallway.
	The area by the stairwell is a landmark. It is in the Ominous Hallway.
	The stairs are a scenery enterable supporter in the Ominous Hallway. It is near the area by the stairwell. Before printing the name of the stairs when the player is not near the stairs, say "faraway ".
	A torch is on the stairs. The torch is lit. The printed name of the torch is "single, sputtering torch".

	Check traversing to the area by the stairwell from the entrance:
		try traversing to the thicker section of the cobwebs;
		say "Something is wrong. You hear your father's voice on your own lips. '[italic type]Only the penitent man will pass...'[roman type][line break]" instead.

	Penitence is a scene. Penitence begins when the player is near the thicker section of cobwebs.

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

	Test me with "take torch/examine torch/kneel/take torch".
	Test death with "touch torch/touch torch".
	Test death2 with "touch torch/wait/wait".

