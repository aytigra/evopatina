json.fragments @last_month_days.map { |d| @fragmets_by_days[d.id] || 0 }
json.my_fragments @last_month_days.map { |d| @my_fragmets_by_days[d.id] || 0 }

json.users @last_month_days.map { |d| @users_by_days[d.id] || 0 }

json.labels @last_month_days.map(&:text_short)
