# rake db:seed
Group.create(name: 'A')
Group.create(name: 'B')
Group.create(name: 'C')

Team.create(name: 'Vasco da Gama')
Team.create(name: 'Avaí')
Team.create(name: 'Sport')
Team.create(name: 'Internacional')

Match.create(datetime: '2015-06-29 19:30:00', team_a: Team.find_by_name('Vasco da Gama'), team_b: Team.find_by_name('Avaí'), group: Group.find_by_name('A'))
Match.create(datetime: '2015-06-29 19:30:00', team_a: Team.find_by_name('Sport'), team_b: Team.find_by_name('Internacional'), group: Group.find_by_name('A'))