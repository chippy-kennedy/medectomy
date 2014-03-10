module Faker

  class University < Base
    flexible :name

    class << self
      def domain
        fetch ('eduemail')
      end
    end
  end

  class Course < Base
    flexible :name

    class << self
      def name
        fetch('course.name')
      end
    end
  end
  
end