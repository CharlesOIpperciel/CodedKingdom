extends Node

enum CommandError {
	HIT_WALL,
	HIT_CEILING,
	CANCEL_REQUESTED,
	TELEPORT_OUT_OF_BOUNDS,
	TELEPORT_IN_WALL,
	NONE,
}

var errors = {
	CommandError.HIT_WALL: "HitWall",
	CommandError.HIT_CEILING: "HitCeiling",
	CommandError.CANCEL_REQUESTED: "ActionCancelled",
	CommandError.TELEPORT_OUT_OF_BOUNDS: "TeleportOutOfBounds",
	CommandError.TELEPORT_IN_WALL: "TeleportInWall",
	CommandError.NONE: null
}
