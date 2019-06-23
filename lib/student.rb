require 'pry'

class Student
  attr_accessor :id, :name, :grade

  def self.new_from_db(row)
    # sql =  <<-SQL
    # CREATE TABLE IF NOT EXISTS students (
    # id INTEGER PRIMARY KEY,
    # name TEXT,
    # grade TEXT
    # );
    # SQL
    # DB[:conn].execute(sql)
    newstudent=Student.new
    newstudent.id = row[0]
    newstudent.name = row[1]
    newstudent.grade = row[2]
    newstudent

    # create a new Student object given a row from the database
  end

  def self.all
    sql = <<-SQL
      SELECT * FROM students;
    SQL

    studentarray= DB[:conn].execute(sql)
    # binding.pry
    # self.new_from_db(studentrow)
    students_inst_array=studentarray.map {|studentrow| self.new_from_db (studentrow)}
    students_inst_array
    # retrieve all the rows from the "Students" database
    # remember each row should be a new instance of the Student class

  end

  def self.find_by_name(name)
    # find the student in the database given a name
    # return a new instance of the Student class
    sql = <<-SQL
      SELECT * FROM students WHERE students.name = ?
    SQL
    studentrow= DB[:conn].execute(sql, name).first
    # binding.pry
    self.new_from_db(studentrow)

  end

  def save
    sql = <<-SQL
      INSERT INTO students (name, grade)
      VALUES (?, ?)
    SQL

    DB[:conn].execute(sql, self.name, self.grade)
  end

  def self.all_students_in_grade_9

    sql = <<-SQL
      SELECT * FROM students WHERE students.grade = 9
    SQL
    studentarray= DB[:conn].execute(sql)
    # binding.pry
    # self.new_from_db(studentrow)
    students_inst_array=studentarray.map {|studentrow| self.new_from_db (studentrow)}
    students_inst_array
  end

  def self.students_below_12th_grade
    sql = <<-SQL
      SELECT * FROM students WHERE students.grade < 12
    SQL
    studentarray12= DB[:conn].execute(sql)
    # binding.pry
    # self.new_from_db(studentrow)
    studentarray=studentarray12.map {|studentrow| self.new_from_db (studentrow)}
  #  binding.pry
    studentarray
  end

  def self.first_X_students_in_grade_10(num)
    sql = <<-SQL
      SELECT * FROM students WHERE students.grade = 10 LIMIT ?
    SQL
    studentarrayX= DB[:conn].execute(sql, num)
    # binding.pry
    # self.new_from_db(studentrow)
    studentarray=studentarrayX.map {|studentrow| self.new_from_db (studentrow)}
    # binding.pry
    studentarray

  end

  def self.first_student_in_grade_10
    student=self.first_X_students_in_grade_10(1).first
    # binding.pry
    student
  end

  def self.all_students_in_grade_X(x)
    sql = <<-SQL
      SELECT * FROM students WHERE students.grade = ?
    SQL
    studentarrayX= DB[:conn].execute(sql, x)
    # binding.pry
    # self.new_from_db(studentrow)
    studentarray=studentarrayX.map {|studentrow| self.new_from_db (studentrow)}
    # binding.pry
    studentarray

  end

  def self.create_table
    sql =  <<-SQL
    CREATE TABLE IF NOT EXISTS students (
    id INTEGER PRIMARY KEY,
    name TEXT,
    grade TEXT
    );
    SQL
    DB[:conn].execute(sql)
  end

  def self.drop_table
    sql = <<-SQL
    DROP TABLE IF EXISTS students;
    SQL
    DB[:conn].execute(sql)
  end
end
