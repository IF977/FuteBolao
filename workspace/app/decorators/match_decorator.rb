class MatchDecorator < Draper::Decorator
  decorates_association :guesses
  decorates_association :team_a
  decorates_association :team_b
  delegate_all

  def data_hora
    object.datetime.to_time.strftime('%d/%m/%Y %Hh')
  end

  def is_today?
    object.datetime.to_time.strftime('%d/%m/%Y') == Time.now.strftime('%d/%m/%Y')
  end

  def hora
    object.datetime.to_time.strftime('%Hh')
  end

  # select guesses which scored at least 1 point
  def scorers
    guesses.select { |g| g.score > 0 }
  end

  def scorers_limited
    scorers.take(6)
  end

  def my_guess
    Guess.find_by_match_id_and_user_id(self.id, context[:user].id)
  end

  def status_classes
    classes = ['label']
    classes << 'label-success' if is_open_to_guesses?
    classes << 'label-danger'  if !is_open_to_guesses?
    classes
  end

  def open_to_guesses_label
    is_open_to_guesses? ? I18n.t("open") : I18n.t("closed")
  end

  def guesses_max
    User.count
  end

  def guesses_progress
    (object.guesses.size.round(2) / guesses_max.round(2)) * 100.00
  end

  def progress_class
    if guesses_progress < 25
      "progress-bar-danger"
    elsif guesses_progress < 50
      "progress-bar-warning"
    elsif guesses_progress < 75
      "info"
    elsif guesses_progress < 100
      "progress-bar-active"
    else
      "progress-bar-success"
    end
  end
end