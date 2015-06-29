module Bolao
  module Rank

    # update the user score acording to the guesses
    def self.update_scores users
      users.each do |u|
        score = u.guesses.collect{ |g| g.score }.reduce(:+) || 0
        u.update_attribute(:score, score)
      end
    end

    # update the user position acording to the score
    # keeps the user position in a column to avoid calculations on each request
    def self.update_rank users
      positions = self.positions users
      users.each_with_index { |user, i| user.update_attribute(:position, positions[i])  }
    end

    # return an array containing the posistions for the ordered users
    # it's useful to put users with the same score in the same position
    # Ex: the scores: 10, 10, 9, 8, 4, 4, 1 would return the positions: 1, 1, 3, 4, 5, 5, 7
    def self.positions users, p = []
      return p if users.size == p.size
      return self.positions(users, p << 1) if p.empty?
      return self.positions(users, p << p[p.size - 1]) if users[p.size - 1].score == users[p.size].score
      return self.positions(users, p << p.size + 1)
    end
  end
end