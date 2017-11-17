class Event < ApplicationRecord
  validates :name, :description, :suggested_budget, :creator_id, presence: true

  belongs_to :creator, class_name: "User", foreign_key: :creator_id
  has_many :participations, dependent: :destroy
  has_many :participants, through: :participations, dependent: :destroy
  accepts_nested_attributes_for :participations

  def create_pairs
    participants = self.participants.shuffle
    nb_participants = participants.length
    temp = participants[0]
    assignees = Array.new(nb_participants, 0)
    participants.each_with_index do |elt, index|
      assignees[index] = participants[index+1]
    end
    assignees[(nb_participants-1)] = temp
    pairs = assignees.zip(participants)
    pairs.each_with_index do |elt, index|
      GiftExchange.create(recipient_id: elt[0].id, sender_id: elt[1].id, event_id: self.id, wishlist_item_id: 1)
    end
  end
end


