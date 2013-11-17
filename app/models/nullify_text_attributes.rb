# converts blank fields to nil
module NullifyTextAttributes
  def self.included(base)
    base.class_eval do
      before_validation :nullify_text_attributes
      private

      def nullify_text_attributes
        self.class.columns.select { |c| [:text, :string].include?(c.type) }.each do |column|
          send("#{column.name}=", nil) if read_attribute(column.name).blank?
        end
      end
    end
  end
end