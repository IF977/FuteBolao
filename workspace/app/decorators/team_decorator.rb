class TeamDecorator < Draper::Decorator
  delegate_all

  # uses uol images for teams flags
  def flag
    "http://e.imguol.com/futebol/brasoes-redondos/100x100-borda-preta/#{slug}.png"
  end

end

