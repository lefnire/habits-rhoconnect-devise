class HabitTracker.Models.Habit extends Backbone.Model
  paramRoot: 'habit'

  defaults:
    name: null
    notes: null
    position: 0
    
class HabitTracker.Collections.HabitsCollection extends Backbone.Collection
  model: HabitTracker.Models.Habit
  url: '/habits'
  comparator: (habit) ->
    habit.get("position")
    
  nextPosition: ->
    if (!@length) then return 1
    return @max() + 1