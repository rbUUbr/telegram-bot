class MainCommand
  #require 'telegram/bot'
  attr_accessor   :name_of_the_command
  def initialize( name_of_the_command = '/start')
    @name_of_the_command = name_of_the_command

  end
  class << self
    def command(message, bot, text_of_message)
      bot.api.send_message(chat_id: message.chat.id, text: text_of_message)
    end
    def delete_special_chars(array_of_ids)
      array_of_ids.each do |line|
        line.chomp!("\n")
      end
      array_of_ids
    end
    def open_and_check(id)
      array_of_ids = IO.readlines("./users/ids")
      array_of_ids = delete_special_chars(array_of_ids)
      $new_client = false if array_of_ids.include?(id)
      if !$new_client
        array_of_ids = File.open("./users/ids", "a+")  do |file|
          file.write("#{id}\n")
          $new_client = true
        end
      end
      return $new_client
    end
  end
end
