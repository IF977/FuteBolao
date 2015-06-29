class GuessDecorator < Draper::Decorator
  decorates_association :match
  decorates_association :user

  delegate_all

  def score_classes
    classes = ['label']
    classes << 'label-primary' if score == 3
    classes << 'label-warning' if score == 1
    classes
  end

end