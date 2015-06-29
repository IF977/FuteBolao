require 'spec_helper'

describe TeamDecorator do

  it 'should use uol cdn for flag images' do
    team = create(:team).decorate
    team.flag.should == "http://e.imguol.com/futebol/brasoes-redondos/100x100-borda-preta/#{team.slug}.png"
  end

end