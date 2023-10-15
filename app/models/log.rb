class Log < ApplicationRecord
  validates :log_level, presence: true
  validates :program, presence: true
  validates :log_content, presence: true

  enum log_level: { debug: 0, info: 1, warn: 2, error: 3, fatal: 4, unknown: 5 }

  def self.logger!(log_level = :debug, program = '', log_content = '')
    return unless ENV['SAVE_DB_LOGS'] == 'true'

    log = Log.new(log_level:, program:, log_content:)
    log.save!
  end
end
