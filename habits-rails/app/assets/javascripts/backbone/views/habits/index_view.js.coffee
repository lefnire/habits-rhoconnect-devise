HabitTracker.Views.Habits ||= {}

class HabitTracker.Views.Habits.IndexView extends Backbone.View
  template: JST["backbone/templates/habits/index"]
  
  events: 
    "keypress .new-habit":  "createOnEnter",

  initialize: () ->
    @options.habits.bind('reset', @addAll)
    @options.habits.bind('change', @render, this) #TODO this ruins tabs, revisit
    @options.habits.bind('add', @render, this)
    
  createOnEnter: (e) ->
    input = $(e.target)
    if (!input.val() or e.keyCode != 13) then return
    
    new_habit =
      name: input.val()
      position: @options.habits.nextPosition()
      
    @options.habits.create new_habit,
      success: (habit) ->
        @model = habit
      error: (habit, jqXHR) ->
        @model.set({errors: $.parseJSON(jqXHR.responseText)})
    input.val('')
    
  addAll: () =>
    @options.habits.each(@addOne)

  addOne: (habit) =>
    view = new HabitTracker.Views.Habits.HabitView({model : habit})
    @$("#habits-habits").append(view.render().el)
    
  render: =>
    $(@el).html(@template(habits: @options.habits.toJSON() ))
    @addAll()
    $("#habits").sortable
      axis: "y"
      dropOnEmpty: false
      cursor: "move"
      items: "li"
      opacity: 0.4
      scroll: true
      update: ->
        $.ajax
          type: "post"
          url: "/habits/sort"
          data: $(this).sortable("serialize")
          dataType: "script"
    return this
