require_relative 'MainCommand.rb'
class SubjectsCommand < MainCommand
  class << self
    def command(message, bot, text, user_action)
      super(message, bot, text)
      user_action = 'subject'
    end
    def open_and_check(id, subject)
      new_subject = true
      array_of_lines = IO.readlines("./users/#{id}")
      array_of_lines = SubjectsCommand.delete_special_chars(array_of_lines)
      new_subject = false if array_of_lines.include?(subject)
      new_subject
    end
    def end_command(bot, message, id, subject, count_of_labs, user_subjects)
      case open_and_check(id, subject)
      when true
        write_subject_to_file(id, subject, count_of_labs, user_subjects)
        bot.api.send_message(chat_id: message.chat.id, text: "Давай сдавай")
      when false
        bot.api.send_message(chat_id: message.chat.id, text: "Такие дела. У тебя уже есть этот предмет в списке сдаваемых")
      end
    end
    def write_strings_for_new_subjects(id_file, subject, count_of_labs, user_subjects)
      id_file.write("Subject:\n")
      id_file.write("#{subject}\n")
      id_file.write("Count of labs:\n")
      id_file.write("#{count_of_labs}\n")
      user_subjects[subject.to_sym] = count_of_labs
    end
    def write_subject_to_file(id, subject,count_of_labs, user_subjects)
      id_file = File.open("./users/#{id}", "a+") do |id_file|
        write_strings_for_new_subjects(id_file, subject, count_of_labs, user_subjects)
      end
    end
  end
end
