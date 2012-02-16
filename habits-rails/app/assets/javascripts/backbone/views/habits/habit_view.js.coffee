HabitTracker.Views.Habits ||= {}

class HabitTracker.Views.Habits.HabitView extends Backbone.View
  template: JST["backbone/templates/habits/habit"]
  
  tagName: "li"
  
  render: ->
    $(@el).attr('id', "habit_#{@model.get('id')}")
    $(@el).html(@template(@model.toJSON() ))
    
    @$(".comment").qtip content:
      text: (api) ->
        $(this).next().html()
      
    return this
