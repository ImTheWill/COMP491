extends Node

#Allow other scriots to use this as a named class

class_name AchievementSystem

#Signal to notify when an achievement is unloced
signal achievement_unlocked(name: String)


var achievements := {
	"Defeat boss": {
		
		 "unlocked" : false,
		 "description": "Defeat boss"
	}
}

func unlock_achievement(key: String) -> void:
	if achievements.has(key) and not achievements[key]["unlocked"]:
		
		achievements[key]["unlocked"] = true
		emit_signal("achievement_unlocked", key)
		print("Achievement unlocked: ", achievements[key]["description"])
