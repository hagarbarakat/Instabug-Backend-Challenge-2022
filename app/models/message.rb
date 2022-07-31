class Message < ApplicationRecord
  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks
  belongs_to :chat

  validates :number,
  presence: true, 
  numericality: {only_integer: true, greater_than_or_equal_to: 1},
  uniqueness:{scope: :chat_id}

  settings do
    mapping dynamic: false do
      indexes :body, type: :text, analyzer: :english
      indexes :chat_id
    end
  end

  def as_indexed_json(options={})
    self.as_json(only: [:body, :number, :chat_id])
  end

  def self.search(term, chat_id)
    response = __elasticsearch__.search(
        query: {
            bool: {
                must: [
                    { match: { chat_id: chat_id } },
                    { query_string: { query: "*#{term}*", fields: [:body] } }
                ]
            }
        }
    )
    response.results.map { |r| {body: r._source.body, number: r._source.number} }
  end
  
end