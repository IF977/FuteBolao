module Winnerable
  def winner
    return :draw   if goals_a == goals_b
    return :team_a if goals_a > goals_b
    :team_b
  end
end