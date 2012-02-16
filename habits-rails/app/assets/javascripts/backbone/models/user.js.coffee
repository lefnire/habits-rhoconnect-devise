# Basically a singleton global variable, not being synced with the server
# Reason is habit.update() will calculate user stats on server
class HabitTracker.Models.User extends Backbone.Model
 