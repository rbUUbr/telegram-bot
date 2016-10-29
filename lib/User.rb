require_relative './lib/MainCommand.rb'
class User
	require 'date'
	attr_accessor :action, :name, :start_semester, :end_semester, :subjects
	def initialize(action = '/start', name = 'Man', start_semester = '2016-09-01', end_semester = '2016-12-25', subjects = {})
		@action = action
		@name = name
		@subjects = subjects
		@start_semester = start_semester
		@end_semester = end_semester
	end
	def calculate_semester_for_first_or_second_course(semester)
		if semester.mon >= 9
			@start_semester = Date.new(2016,9,1)
			@end_semester = Date.new(2016,12,25)
		else
			@start_semester = '2017-02-07'
			@end_semester = '2017-05-31'
		end
	end
	def calculate_semester_for_third_or_greater_course(semester)
		if semester.mon >= 9
			@start_semester = Date.new(2016,9,1)
			@end_semester = Date.new(2016,12,10)
		else
			@start_semester = Date.new(2017, 1, 17)
			@end_semester = Date.new(2017, 5, 10)
		end
end
	def semester_calculate(text)
		semester = Date.today
		case text
		when /1/, /2/
			calculate_semester_for_first_or_second_course(semester)
		else
			calculate_semester_for_third_or_greater_course(semester)
		end
  end
	def load_object(id)
		file_to_upload = IO.readlines("./users/#{id}")
		file_to_upload = MainCommand.delete_special_chars(file_to_upload)
		subject = ""
		file_to_upload.each do |line|
			case line
			when /Start/
				@start_semester = line.delete("Start of semester:")
			when /End/
				@end_semester = line.delete("End of semester:")
			when /Subject:/
				subject = file_to_upload[file_to_upload.index(line) + 1]
			when /Count of labs:/
				@subjects[subject.to_sym] = file_to_upload[file_to_upload.index(line) + 1]
			end
		end
	end
end
