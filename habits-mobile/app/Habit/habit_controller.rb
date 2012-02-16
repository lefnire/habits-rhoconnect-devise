require 'rho/rhocontroller'
require 'helpers/browser_helper'

class HabitController < Rho::RhoController
  include BrowserHelper

  # GET /Habit
  def index
    @habits = Habit.find(:all)
    render :back => '/app'
  end

  # GET /Habit/{1}
  def show
    @habit = Habit.find(@params['id'])
    if @habit
      render :action => :show, :back => url_for(:action => :index)
    else
      redirect :action => :index
    end
  end

  # GET /Habit/new
  def new
    @habit = Habit.new
    render :action => :new, :back => url_for(:action => :index)
  end

  # GET /Habit/{1}/edit
  def edit
    @habit = Habit.find(@params['id'])
    if @habit
      render :action => :edit, :back => url_for(:action => :index)
    else
      redirect :action => :index
    end
  end

  # POST /Habit/create
  def create
    @habit = Habit.create(@params['habit'])
    redirect :action => :index
  end

  # POST /Habit/{1}/update
  def update
    @habit = Habit.find(@params['id'])
    @habit.update_attributes(@params['habit']) if @habit
    redirect :action => :index
  end

  # POST /Habit/{1}/delete
  def delete
    @habit = Habit.find(@params['id'])
    @habit.destroy if @habit
    redirect :action => :index  
  end
end
