class DaysController < ApplicationController
  before_action :authenticate_user!

  # GET /days/01-01-2015
  # GET /days/01-01-2015.json
  def show
    @day = Day.new params_date
    @sectors = Sector.load_tree_for(current_user, @day).load
    @subsectors = @sectors.map(&:subsectors).flatten
    @activities = @subsectors.map(&:activities).flatten
    @progress = Fragment.progress_for_days([@day] + @day.previous_days)

    respond_to do |format|
      format.html { render 'show' }
      format.json { render partial: 'day', status: :ok }
    end
  end

  private

  def params_date
    if !params[:date] || params[:date] == '0'
      date = nil
    elsif /(\d{2}-\d{2}-\d{4})/.match(params[:date])
      date = Date.strptime(params[:date], '%d-%m-%Y')
      if date > Date.current.end_of_day
        flash.notice = 'You can not control future, showing today'
        date = nil
      end
    else
      flash.notice = 'Invalid date parameter, showing today'
      date = nil
    end
    date || Date.current
  end
end
