class GuessANumberJob < ApplicationJob
  queue_as :default

  class OutOfRange < StandardError; end
  
  discard_on OutOfRange

  class GuessedWrongNumber < StandardError; end

  retry_on GuessedWrongNumber, attempts: 8, wait: 1

  def perform(number)
    unless number.is_a?(Integer) && number.between?(1, 10)
      raise OutOfRange, "#{number} is'nt an integer between 1 and 10"
    end

    guess = rand(1..10)

    if guess == number
      Rails.logger.info "I guessed it! It was #{number}"
    else
      raise GuessedWrongNumber, "It is not #{guess}"
    end
  end
end
