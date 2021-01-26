class Student
  attr_accessor :id, :name, :grade

  def self.new_from_db(row)
    # create a new Student object given a row from the database
    student = Student.new
    student.id = row[0]
    student.name = row[1]
    student.grade = row[2]
    return student
  end

  def self.all
    # retrieve all the rows from the "Students" database
    # remember each row should be a new instance of the Student class
    all_rows = DB[:conn].execute("SELECT * FROM students;")
    all_rows.map { |row| Student.new_from_db(row) }
  end

  def self.find_by_name(name)
    # find the student in the database given a name
    # return a new instance of the Student class
    Student.all.find { |student| student.name == name }
  end
  
  def save
    sql = <<-SQL
      INSERT INTO students (name, grade) 
      VALUES (?, ?)
    SQL

    DB[:conn].execute(sql, self.name, self.grade)
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

  def self.all_students_in_grade_X(grade)
    Student.all.select { |student| student.grade.to_i == grade.to_i }
  end

  def self.students_below_12th_grade
    Student.all.select { |student| student.grade.to_i < 12 }
  end

  def self.all_students_in_grade_9
    Student.all_students_in_grade_X("9")
  end

  def self.first_X_students_in_grade_10(num)
    (0...num).map { |i| Student.all_students_in_grade_X("10")[i] }
  end

  def self.first_student_in_grade_10
    Student.first_X_students_in_grade_10(1)[0]
  end

end
