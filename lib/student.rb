class Student

  @@all = []

  attr_reader :name, :id
  attr_accessor :grade

  def initialize(name, grade, id = nil)
    @name = name
    @grade = grade
    @id = id
  end

  def self.create_table
    sql =  <<-SQL
      CREATE TABLE IF NOT EXISTS students (
        id INTEGER PRIMARY KEY,
        name TEXT,
        grade TEXT
      )
      SQL
    DB[:conn].execute(sql)
  end

  def self.drop_table
    sql =  <<-SQL
      DROP TABLE IF EXISTS students
      SQL
    DB[:conn].execute(sql)
  end

  def self.create(name:, grade:)
    student = Student.new(name, grade)
    student.save
    student
  end
  def save
    sql =  <<-SQL
      INSERT INTO students (name, grade)
      VALUES (?, ?)
      SQL
    DB[:conn].execute(sql, @name, @grade)

    @id = DB[:conn].execute("SELECT last_insert_rowid() FROM students")[0][0]
  end
end
