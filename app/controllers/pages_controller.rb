class PagesController < ApplicationController
  def about
  end

  def how_to
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
    @sectors_ids = @sectors.map(&:id)
    @fragments_month = Fragment.sum_by_sectors_from @sectors_ids, Day.new(Date.current - 4.weeks).id
    @fragments_epoch = Fragment.sum_by_sectors_from @sectors_ids, Day.new(Date.current - 100.days).id
    @fragments_total = Fragment.sum_by_sectors_from @sectors_ids

    # get sector names with number of users, only for current locale and with some progress
    @popular_sectors = Sector.unscoped.joins(:user)
      .where(users: { locale: I18n.locale })
      .where('(SELECT SUM("fragments"."count") FROM "fragments"
                INNER JOIN "activities" ON "activities"."id" = "fragments"."activity_id"
                INNER JOIN "subsectors" ON "subsectors"."id" = "activities"."subsector_id"
                WHERE "subsectors"."sector_id" = "sectors"."id") > 0')
      .group(:name).order('count_id desc').limit(30).count('id')

    # users activity over time

    @last_month_days = [Day.new(Date.current)] + Day.new(Date.current).previous_days(30)

    @fragmets_by_days = Fragment.where(day_id: @last_month_days.map(&:id))
      .group(:day_id)
      .sum(:count)

    @fragmets_by_days = @last_month_days.map { |d| @fragmets_by_days[d.id] || 0 }

    @users_by_days = User.joins(sectors: { subsectors: { activities: :fragments } })
      .where(fragments: { day_id: @last_month_days.map(&:id) })
      .distinct.group(:day_id).count(:id)

    @users_by_days = @last_month_days.map { |d| @users_by_days[d.id] || 0 }
  end

  # get 'statistics/:id'
  def statistics_sector
    @sector = Sector.find(params[:id])
    @subsectors = Subsector.where(sector_id: @sector.id)
    @activities = Activity.where(subsector_id: @subsectors.map(&:id))
    @activities_ids = @activities.map(&:id)
    @activities_grouped = @activities.each_with_object(Hash.new { |h, k| h[k] = {} }) { |a, h| h[a.subsector_id][a.id] = a }

    @fragments_month = Fragment.sum_by_activities_from @activities_ids, Day.new(Date.current - 4.weeks).id
    @fragments_epoch = Fragment.sum_by_activities_from @activities_ids, Day.new(Date.current - 100.days).id
    @fragments_total = Fragment.sum_by_activities_from @activities_ids
  end

  def hello
    redirect_to root_path if user_signed_in?
  end

  private


end
