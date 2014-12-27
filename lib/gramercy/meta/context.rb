module Gramercy
  module Meta
    class Context

      include Neo4j::ActiveNode

      property :name, index: :exact
      property :created_at
      property :updated_at

      validates :name, :presence => true, :uniqueness => true

      has_many :both, :words, rel_class: Expression

      def add_expression(word, positivity)
        Expression.create(from_node: self, to_node: word, positivity: positivity)
      end

      def words_with_positivity(positivity)
        words.query_as(:w).match('s-[EXPRESSED_AS]->n2').where("EXPRESSED_AS.positivity = #{positivity}").pluck('DISTINCT n2')
      end

      def positive_expressions
        words.query_as(:w).match('s-[EXPRESSED_AS]->n2').where('EXPRESSED_AS.positivity > 0').pluck('DISTINCT n2')
      end

      def negative_expressions
        words.query_as(:w).match('s-[EXPRESSED_AS]->n2').where('EXPRESSED_AS.positivity < 0').pluck('DISTINCT n2')
      end

      def neutral_expressions
        words.query_as(:w).match('s-[EXPRESSED_AS]->n2').where('EXPRESSED_AS.positivity = 0').pluck('DISTINCT n2')
      end

    end
  end
end