require_relative 'MainCommand.rb'
class SemesterCommand < MainCommand
  class << self
    def command(message, bot, text, user_action)
      super(message, bot, text)
      user_action = 'start_semester'
    end
    def calculate_dates(user_end_semester)
      result = []
      result.push(user_end_semester.mon - Date.today.mon)
      result.push((user_end_semester.day - Date.today.day).abs)
      result
    end
    def write_semester_to_file(id, user_start_semester, user_end_semester)
      name_of_file = "./users/#{id}"
      File.open(name_of_file, "a+") do |id_file|
        id_file.write("Start of semester:#{user_start_semester}\n")
        id_file.write("End of semester:#{user_end_semester}\n")
      end
    end
    def read_start_semester(id_array)
      result = ""
      id_array.each do |line|
        result = line if line.include?("Start of semester:")
      end
      result = result.delete("Start of semester:")
    end
    def read_end_semester(id_array)
      result = ""
      id_array.each do |line|
        result = line if line.include?("End of semester:")
      end
      result = result.delete("End of semester:")
    end
    def read_semester_from_file(id, user_start_semester, user_end_semester)
      name_of_file = "./users/#{id}"
      File.open(name_of_file) do |id_file|
        user_start_semester = SemesterCommand.read_start_semester(id_file)
        user_end_semester = SemesterCommand.read_end_semester(id_file)
      end
    end
    def check_client(id, user_start_semester, user_end_semester)
      case $new_client
      when true
        SemesterCommand.write_semester_to_file(id, user_start_semester, user_end_semester)
      when false
        SemesterCommand.read_semester_from_file(id, user_start_semester, user_end_semester)
      end
    end
    def semester(message, bot, user, id)
      user.semester_calculate(message.text)
      SemesterCommand.check_client(id, user.start_semester, user.end_semester)
      date = SemesterCommand.calculate_dates(user.end_semester)
      bot.api.send_message(chat_id: message.chat.id, text: "ВОТ БАЛИН, У нас всего #{date[0]}  месяца и #{date[1]}  дня")
    end
  end
end
