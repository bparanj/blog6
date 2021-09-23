class FlashCard
  include Dynamoid::Document

  table(name: "flashcards", key: :user_id)

  range :list_id, :string 

  field :name, :string
  field :created_at, :datetime, default: -> { Time.now } 
end