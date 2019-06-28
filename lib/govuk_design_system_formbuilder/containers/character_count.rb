module GOVUKDesignSystemFormBuilder
  module Containers
    class CharacterCount < Base
      def initialize(builder, max_words:, max_chars:)
        @builder = builder
        fail ArgumentError, 'limit can be words or chars' if max_words && max_chars
        @max_words = max_words
        @max_chars = max_chars
      end

      def html
        return yield unless limit?

        @builder.content_tag(
          'div',
          class: 'govuk-character-count',
          data: { module: 'character-count' }.merge(limit)
        ) do
          yield
        end
      end

    private

      def limit
        if @max_words
          { maxwords: @max_words }
        elsif @max_chars
          { maxlength: @max_chars }
        end
      end

      def limit?
        @max_words || @max_chars
      end
    end
  end
end