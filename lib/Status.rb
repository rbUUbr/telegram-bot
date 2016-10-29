require_relative 'MainCommand.rb'
class StatusCommand < MainCommand
  def self.command(message, bot, text, user_subjects )
    text_of_labs = ""
    if user_subjects.empty?
      super(message, bot, "Чувак, ты всё сдал уже что ли? Красава.")
    else
      user_subjects.each {|key, value| text_of_labs += "По предмету #{user_subjects.key(value)} у тебя #{value} лаб \n"}
      super(message, bot, text_of_labs)
    end
  end
end
