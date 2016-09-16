json.fragments @fragmets_by_days.values

json.users @users_by_days.values

json.labels @last_month_days.map(&:text_short)
