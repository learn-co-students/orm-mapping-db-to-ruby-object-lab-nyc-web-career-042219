require 'pry'

class Student
  attr_accessor :id, :name, :grade

  def self.new_from_db(row)
    # create a new Student object given a row from the database
    id, name, grade = row[0], row[1], row[2]
    stu = Student.new
    stu.id  = id
    stu.name = name
    stu.grade = grade
    stu
  end

  def self.all
    # retrieve all the rows from the "Students" database
    # remember each row should be a new instance of the Student class
    sql = <<-SQL
    SELECT
      *
    FROM
      students
    SQL
    DB[:conn].execute(sql).map { |row| new_from_db(row) }
  end

  def self.all_students_in_grade_9
    #* This works because self.all already gives us an array of all students.
    all.select { |student| student.grade == '9' }
    #* Below is the actual SQL query that would otherwise have to be written.
    # sql = <<-SQL
    # SELECT
    #   *
    # FROM
    #   students
    # WHERE
    #   students.grade = '9'
    # SQL
    # DB[:conn].execute(sql).map { |row| new_from_db(row) }
  end

  def self.students_below_12th_grade
    #* Using self.all and Ruby methods
    all.select { |student| student.grade < '12' }
    #* Using SQL
    # sql = <<-SQL
    # SELECT
    #   *
    # FROM
    #   students
    # WHERE
    #   students.grade < '12'
    # SQL
    # DB[:conn].execute(sql).map { |row| new_from_db(row) }
  end

  def self.first_X_students_in_grade_10(x)
    #* Using Ruby
    all.select { |student| student.grade == '10' }.take(x)
    #* Using SQL
    # sql = <<-SQL
    # SELECT
    #   *
    # FROM
    #   students
    # WHERE
    #   students.grade = '10'
    # LIMIT
    #   ?
    # SQL
    # DB[:conn].execute(sql, x).map { |row| new_from_db(row) }
  end

  def self.first_student_in_grade_10
    #* Using Ruby
    all.find { |student| student.grade == '10' }
    #* Using SQL
    # sql = <<-SQL
    # SELECT
    #   *
    # FROM
    #   students
    # WHERE
    #   students.grade = '10'
    # LIMIT
    #   1
    # SQL
    # DB[:conn].execute(sql).map { |row| new_from_db(row) }.first
  end

  def self.all_students_in_grade_X(x)
    #* Using Ruby
    all.select { |student| student.grade == x.to_s }
    #* Using SQL
    # sql = <<-SQL
    # SELECT
    #   *
    # FROM
    #   students
    # WHERE
    #   students.grade = ?
    # SQL
    # DB[:conn].execute(sql, x).map { |row| new_from_db(row) }
  end

  def self.find_by_name(name)
    # find the student in the database given a name
    # return a new instance of the Student class
    sql = <<-SQL
    SELECT
      students.*
    FROM
      students
    WHERE
      students.name = ?
    SQL
    DB[:conn].execute(sql, name).map { |row| new_from_db(row) }.first
  end
  
  def save
    sql = <<-SQL
      INSERT INTO students (name, grade) 
      VALUES (?, ?)
    SQL
    DB[:conn].execute(sql, self.name, self.grade)
    # binding.pry
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

