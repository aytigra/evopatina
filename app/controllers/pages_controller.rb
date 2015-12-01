class PagesController < ApplicationController
  def about
  end

  # GET /patina
  # GET /patina.json
  def patina
    sectors = Sector.where(user: current_user).load
    subsectors = Subsector.where(sector_id: sectors.map(&:id)).group_by(&:sector_id)
    activities = Activity.where(subsector_id: subsectors.values.flatten.map(&:id)).group_by(&:subsector_id)

    @json_locals = { sectors: sectors, subsectors: subsectors, activities: activities }

    respond_to do |format|
      format.html { render 'patina' }
      format.json { render partial: 'patina', locals: @json_locals, status: :ok }
    end
  end

  def statistics
    @sectors = Sector.where(user: current_user).order(:position).load
    @fragments_month = fragments_from Week.new(Date.current - 4.weeks).id
    @fragments_epoch = fragments_from Week.new(Date.current - 14.weeks).id
    @fragments_total = fragments_from

    # get sector names with number of users, only for current locale and with some progress
    @popular_sectors = Sector.joins(:user)
      .where(users: { locale: I18n.locale })
      .where('(SELECT SUM("sector_weeks"."progress") FROM "sector_weeks" WHERE "sector_weeks"."sector_id" = "sectors"."id") > 0')
      .group(:name).order('count_id desc').limit(30).count('id')
  end

  def hello
    redirect_to root_path if user_signed_in?
  end

  private

  def fragments_from(date_id = 0)
    SectorWeek.where(sector_id: @sectors.map(&:id))
              .where('week_id > ?', date_id)
              .group(:sector_id).sum(:progress)
  end
end
