require 'pry'

class Student
  attr_accessor :id, :name, :grade

  def self.new_from_db(row)
    newstudent=Student.new
    newstudent.id = row[0]
    newstudent.name= row[1]
    newstudent.grade=row[2]
    newstudent
    # create a new Student object given a row from the database
  end

  def self.all

    sql=<<-SQL
      SELECT * FROM students
    SQL
    studentrec=DB[:conn].execute(sql).map {|row| self.new_from_db(row)}
    studentrec

    # retrieve all the rows from the "Students" database
    # remember each row should be a new instance of the Student class

  end

  def self.find_by_name(name)

    sql= <<-SQL
      SELECT * FROM students WHERE students.name = ?
      SQL

      studentrow=DB[:conn].execute(sql, name).first
      student_inst=self.new_from_db(studentrow)
      student_inst

    # find the student in the database given a name
    # return a new instance of the Student class
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
      SELECT * FROM students WHERE students.grade = ?
    SQL

    student_inst=DB[:conn].execute(sql,9).map {|row| self.new_from_db(row)}

    student_inst
  end

  def self.students_below_12th_grade
    sql = <<-SQL
      SELECT * FROM students WHERE students.grade < 12
    SQL
  #  binding.pry
    student_inst=DB[:conn].execute(sql).map {|row| self.new_from_db(row)}

    student_inst
  end

  def self.first_X_students_in_grade_10(num)
    sql = <<-SQL
      SELECT * FROM students WHERE students.grade = 10 LIMIT ?
    SQL

    student_inst=DB[:conn].execute(sql, num).map {|row| self.new_from_db(row)}
  #  binding.pry
    student_inst

  end

  def self.first_student_in_grade_10
    self.first_X_students_in_grade_10(1).first
  end

  def self.all_students_in_grade_X(x)
    sql = <<-SQL
      SELECT * FROM students WHERE students.grade = ?
    SQL

    student_inst=DB[:conn].execute(sql, x).map {|row| self.new_from_db(row)}
    #    binding.pry
    student_inst

  end

  def self.create_table
    sql = <<-SQL
    CREATE TABLE IF NOT EXISTS students (
      id INTEGER PRIMARY KEY,
      name TEXT,
      grade TEXT
    )
    SQL

    DB[:conn].execute(sql)
  end

  def self.drop_table
    sql = "DROP TABLE IF EXISTS students"
    DB[:conn].execute(sql)
  end
end
